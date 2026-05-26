class_name CoopDropSync
extends RefCounted

# CoopDropSync - phase 14a extraction from coop_manager.gd.
#
# Pure helpers for the host -> peer drop-sync pipeline that runs
# every frame on the dedicated host: snapshot-cache keys (shared
# shape with `CoopEntitySync`), LOD update intervals tuned to drop
# physics, snapshot-state build / change detection over
# DroppedItem state, the "recently visible to this peer" cache
# decision (so a freshly spawned drop survives the first interest
# pass while the peer is still loading the chunk around it), and
# the two `item_data_signature` / `item_state_signature` hashers
# shared by the predicted-drop merge pass and the
# host-snapshot-state comparator.
#
# Engine-bound bodies stay on coop_manager.gd as thin forwarders:
#   - `_build_host_drop_snapshot_state` reads
#     `dropped_item.global_position`, `.velocity`, `.item`,
#     `.can_collect`, `.state`. The pure form
#     (`build_host_drop_snapshot_state`) takes the resolved
#     primitives + the precomputed `item_signature`.
#   - `_remember_host_recent_drop_visibility` /
#     `_cleanup_host_recent_drop_visibility` mutate
#     `host_recent_drop_visibility` directly; the pure module
#     ships the per-entry record builder and the expiry / interest
#     predicate so the dict-mutation orchestration is small.
#   - `_is_host_recent_drop_visible_to_peer` looks up
#     `peer_states[peer_id]` (with int / String key fallback)
#     and calls `_is_peer_state_same_instance`. The pure form
#     accepts the resolved booleans.
#
# This module knows NOTHING about:
#   - `class_name DroppedItem` / `class_name InventoryItem`.
#   - `Ref.player` / `Ref.world` / `multiplayer.*`.
#   - `host_drop_snapshot_last_sent` /
#     `host_drop_snapshot_last_state` /
#     `host_recent_drop_visibility` dicts - the forwarder
#     mutates them.
#   - `Time.get_ticks_msec()` clock / `host_server_time` -
#     resolved at the forwarder boundary.
#   - `@rpc` handlers (`request_drop_item`,
#     `request_pickup_drop`, `sync_spawn_drop`,
#     `sync_remove_drop`, `receive_picked_item`,
#     `receive_item_action_result`, `server_world_state`) -
#     NodePath-bound, stay on coop_manager.gd.
#
# Constants pinned in this module (single source of truth):
#   - `DROP_INTEREST_NEAR_RADIUS`   = 24.0
#   - `DROP_INTEREST_MID_RADIUS`    = 64.0
#   - `DROP_INTERVAL_NEAR`          = 0.08 s (12.5 Hz)
#   - `DROP_INTERVAL_MID`           = 0.18 s (~5.5 Hz)
#   - `DROP_INTERVAL_FAR`           = 0.35 s (~3 Hz)
#   - `DROP_DR_POS_ERR_SQ`          = 0.01  (10 cm squared)
#   - `DROP_DR_VEL_ERR_SQ`          = 0.04  (20 cm/s squared)
#   - `RECENT_VISIBILITY_TTL_SEC`   = 8.0
# Live `coop_manager.gd` keeps its own copies on lines 55 / 65-67
# / 16252-16255 and threads them in via the forwarder; pinned-here
# values are the documented defaults for unit tests.


# --- Constants ---

const DROP_INTEREST_NEAR_RADIUS: float = 24.0
const DROP_INTEREST_MID_RADIUS: float = 64.0
const DROP_INTERVAL_NEAR: float = 0.08
const DROP_INTERVAL_MID: float = 0.18
const DROP_INTERVAL_FAR: float = 0.35
const DROP_DR_POS_ERR_SQ: float = 0.01
const DROP_DR_VEL_ERR_SQ: float = 0.04
const RECENT_VISIBILITY_TTL_SEC: float = 8.0


# --- Cache keys ---

# host_drop_snapshot_key: pure form of `_host_drop_snapshot_key`
# (coop_manager.gd L16247-16248). Same shape as
# `CoopEntitySync.host_entity_snapshot_key` so the four host
# `*_snapshot_last_sent` / `*_snapshot_last_state` caches share a
# single key formatter and the `peer_cache_key_prefix(peer_id) ->
# "<peer_id>:"` purge pass walks every dict consistently.
static func host_drop_snapshot_key(peer_id: int, uuid: String) -> String:
    return "%s:%s" % [peer_id, uuid]


# --- Item signature ---

# item_data_signature: pure form of `_item_data_signature`
# (coop_manager.gd L9197-9206). Returns a `":"`-joined string of
# the PackedInt32Array. Empty array returns `""` so the comparator
# inside `_is_host_drop_snapshot_state_changed` can treat
# "no item" and "item with empty data" as the same hash.
#
# Tracking: this is used as a fingerprint to detect inventory /
# durability / item-data changes on the host snapshot; if any
# int in the array differs the signature differs.
static func item_data_signature(item_data: PackedInt32Array) -> String:
    if item_data.is_empty():
        return ""
    var signature: String = ""
    for index in range(item_data.size()):
        if index > 0:
            signature += ":"
        signature += str(int(item_data[index]))
    return signature


# --- LOD / interval ---

# get_host_drop_snapshot_interval: pure form of
# `_get_host_drop_snapshot_interval` (coop_manager.gd L16251-16256).
# Drop snapshots use a slightly slower base rate than entity
# snapshots (drops don't animate) and a tighter near-band threshold
# (drops are small + collected by close proximity).
#
# Three-tier LOD over squared distance:
#   - inside near band (<= 24m^2 = 576) -> 0.08 s
#   - inside mid band  (<= 64m^2 = 4096) -> 0.18 s
#   - past mid                            -> 0.35 s
#
# Override-friendly so the forwarder can thread in the live
# coop_manager constants.
static func get_host_drop_snapshot_interval(
    distance_squared: float,
    near_radius: float = DROP_INTEREST_NEAR_RADIUS,
    mid_radius: float = DROP_INTEREST_MID_RADIUS,
    near_interval: float = DROP_INTERVAL_NEAR,
    mid_interval: float = DROP_INTERVAL_MID,
    far_interval: float = DROP_INTERVAL_FAR,
) -> float:
    if distance_squared <= near_radius * near_radius:
        return near_interval
    if distance_squared <= mid_radius * mid_radius:
        return mid_interval
    return far_interval


# --- Snapshot state build / change detection ---

# build_host_drop_snapshot_state: pure form of
# `_build_host_drop_snapshot_state` (coop_manager.gd L16259-16266).
# The forwarder pre-resolves the item signature via
# `item_state_signature(dropped_item.item)` (engine-bound through
# `_serialize_item_state`) so this module stays oblivious to
# `class_name DroppedItem` / `class_name InventoryItem`.
static func build_host_drop_snapshot_state(
    drop_position: Vector3,
    drop_velocity: Vector3,
    item_signature: String,
    can_collect: bool,
    drop_state: int,
) -> Dictionary:
    return {
        "position": drop_position,
        "velocity": drop_velocity,
        "item": item_signature,
        "can_collect": can_collect,
        "state": drop_state,
    }


# is_host_drop_snapshot_state_changed: pure form of
# `_is_host_drop_snapshot_state_changed` (coop_manager.gd
# L16269-16284). Returns true ONLY when the snapshot diverges from
# the previously-sent snapshot by more than the dead-reckoning
# tolerances:
#   - item signature changed (durability, item ID, sub-item swap),
#   - can_collect flag flipped (drop now collectible, or held
#     in-place by the pickup grace),
#   - state changed (DroppedItem.state enum: idle / falling / etc),
#   - position drifted by more than `pos_err_sq` (default
#     `DROP_DR_POS_ERR_SQ = 0.01`),
#   - velocity drifted by more than `vel_err_sq` (default
#     `DROP_DR_VEL_ERR_SQ = 0.04`).
#
# `previous_state.is_empty()` returns true so a never-sent drop
# is always treated as "changed".
static func is_host_drop_snapshot_state_changed(
    previous_state: Dictionary,
    next_state: Dictionary,
    pos_err_sq: float = DROP_DR_POS_ERR_SQ,
    vel_err_sq: float = DROP_DR_VEL_ERR_SQ,
) -> bool:
    if previous_state.is_empty():
        return true
    if str(previous_state.get("item", "")) != str(next_state.get("item", "")):
        return true
    if bool(previous_state.get("can_collect", true)) != bool(next_state.get("can_collect", true)):
        return true
    if int(previous_state.get("state", -1)) != int(next_state.get("state", -1)):
        return true
    var previous_position: Vector3 = previous_state.get("position", Vector3.ZERO)
    var next_position: Vector3 = next_state.get("position", Vector3.ZERO)
    if previous_position.distance_squared_to(next_position) > pos_err_sq:
        return true
    var previous_velocity: Vector3 = previous_state.get("velocity", Vector3.ZERO)
    var next_velocity: Vector3 = next_state.get("velocity", Vector3.ZERO)
    return previous_velocity.distance_squared_to(next_velocity) > vel_err_sq


# --- Recent-visibility cache helpers ---

# make_recent_drop_visibility_record: pure form of the record
# builder inside `_remember_host_recent_drop_visibility`
# (coop_manager.gd L16207-16212). Returns the Dictionary the
# forwarder writes into `host_recent_drop_visibility[drop_uuid]`.
#
# `now_msec + ttl_msec` is computed by the forwarder so the live
# code can stay deterministic relative to `Time.get_ticks_msec()`.
static func make_recent_drop_visibility_record(
    dimension_instance_key: String,
    source_peer_id: int,
    force_same_instance_peers: bool,
    expires_at_msec: int,
) -> Dictionary:
    return {
        "dimension_instance_key": dimension_instance_key,
        "source_peer_id": source_peer_id,
        "force_same_instance_peers": force_same_instance_peers,
        "expires_at_msec": expires_at_msec,
    }


# is_recent_drop_visibility_expired: pure form of the expiry
# branch inside both `_cleanup_host_recent_drop_visibility`
# (L16215-16222) and `_is_host_recent_drop_visible_to_peer`
# (L16231). Centralised so the comparison stays consistent across
# the two call sites.
#
# Returns true when the record is empty OR
# `expires_at_msec <= now_msec`.
static func is_recent_drop_visibility_expired(record: Dictionary, now_msec: int) -> bool:
    if record.is_empty():
        return true
    return int(record.get("expires_at_msec", 0)) <= now_msec


# is_recent_drop_visible_to_peer: pure form of the predicate
# inside `_is_host_recent_drop_visible_to_peer` (coop_manager.gd
# L16225-16244).
#
# Inputs (resolved at the forwarder boundary):
#   - `record`                       - the entry from
#                                      `host_recent_drop_visibility[drop_uuid]`.
#                                      Empty record / mismatched
#                                      instance / source peer -
#                                      see decision tree below.
#   - `peer_id`                      - the receiver under test.
#   - `active_instance_key`          - the active dimension
#                                      instance key.
#   - `peer_state_same_instance`     - the resolved
#                                      `_is_peer_state_same_instance(...)` -
#                                      result. Only consulted when
#                                      `force_same_instance_peers`
#                                      is set on the record.
#
# Decision tree:
#   - record empty / expired                       -> false (caller
#                                                    will erase).
#   - record_instance_key != ""                    -> matches
#                                                    active_instance_key
#                                                    or fail.
#   - source_peer_id == peer_id                    -> true (always
#                                                    deliver to the
#                                                    originator).
#   - force_same_instance_peers + same instance    -> true.
#   - otherwise                                    -> false.
#
# Note: this function does NOT consult `now_msec` - the caller
# uses `is_recent_drop_visibility_expired(record, now_msec)` first
# and skips the predicate (and erases the entry) on a hit.
static func is_recent_drop_visible_to_peer(
    record: Dictionary,
    peer_id: int,
    active_instance_key: String,
    peer_state_same_instance: bool,
) -> bool:
    if record.is_empty() or peer_id <= 0:
        return false
    var record_instance_key: String = str(record.get("dimension_instance_key", ""))
    if record_instance_key != "" and record_instance_key != active_instance_key:
        return false
    if int(record.get("source_peer_id", 0)) == peer_id:
        return true
    if bool(record.get("force_same_instance_peers", false)) and peer_state_same_instance:
        return true
    return false
