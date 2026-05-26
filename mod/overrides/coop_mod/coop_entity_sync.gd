class_name CoopEntitySync
extends RefCounted

# CoopEntitySync - phase 13a extraction from coop_manager.gd.
#
# Pure helpers for the host -> peer entity-sync pipeline that runs
# every frame on the dedicated host: scene-path resolution,
# snapshot / visual cache keys, snapshot-interval LOD, yaw-delta
# math, build / change-detection for snapshot state, per-peer
# interest predicate, client-side block-position resolution, and
# the full-render gate.
#
# Engine-bound bodies stay on coop_manager.gd as thin forwarders:
#   - `_is_syncable_entity_node` reaches for `class_name Entity` /
#     `class_name Player` and `is_remote_player_proxy(node)`. The
#     pure form below (`is_syncable_entity`) accepts the three
#     resolved booleans so the predicate can be unit-tested without
#     the base-game classes registered in the test harness.
#   - `_get_sync_scene_path` reads `node.scene_file_path` and
#     `node.get_meta("coop_source_scene_path", "")`. The pure form
#     below (`resolve_sync_scene_path`) takes the two resolved
#     strings.
#   - `_should_full_render_client_entity` calls
#     `Ref.world.is_position_loaded(_client_entity_block_position(...))`.
#     The pure form below (`should_full_render_client_entity`) takes
#     a `Callable is_position_loaded` so the forwarder threads
#     `Ref.world` in only when valid.
#   - `_is_peer_interested_in_position` looks up
#     `peer_states[peer_id]` (with `int` / `String` key fallback),
#     calls `get_active_dimension_instance_key()` for the default
#     instance, and `_is_peer_state_same_instance(...)`. The pure
#     form (`is_peer_interested_in_position`) is invoked from the
#     forwarder after resolving the peer state and the
#     same-instance flag.
#
# This module knows NOTHING about:
#   - `class_name Entity` / `class_name Player` /
#     `class_name Block`.
#   - `Ref.world` / `Ref.player` / `multiplayer.*`.
#   - `peer_states` lookups or `get_active_dimension_instance_key()`
#     resolution.
#   - `Time.get_ticks_msec()` or `host_server_time` bookkeeping.
#   - `@rpc` handlers (`server_world_state`,
#     `server_snapshot_reliable`) - NodePath-bound, stay on
#     coop_manager.gd.
#
# Constants pinned in this module (single source of truth):
#   - `ENTITY_DR_POS_ERR_SQ`         = 0.0225 (15 cm squared)
#   - `ENTITY_DR_KB_ERR_SQ`          = 0.25   (50 cm/s squared)
#   - `ENTITY_DR_YAW_ERR_DEG`        = 5.0    (degrees)
#   - `ENTITY_VISUAL_NEAR_RADIUS`    = 48.0
#   - `ENTITY_VISUAL_MID_RADIUS`     = 88.0
#   - `ENTITY_SNAPSHOT_INTERVAL_NEAR`= 0.05 s (20 Hz at near range)
#   - `ENTITY_SNAPSHOT_INTERVAL_MID` = 0.12 s (~8 Hz at mid range)
#   - `ENTITY_SNAPSHOT_INTERVAL_FAR` = 0.35 s (~3 Hz at far range)
# Live `coop_manager.gd` keeps its own copies on lines 58-60 / 150-151
# and threads them in via `_get_host_entity_snapshot_interval`; the
# pinned-here copies are only consulted when the forwarder omits
# the override (and by the unit tests).


# --- Constants ---

const ENTITY_DR_POS_ERR_SQ: float = 0.0225
const ENTITY_DR_KB_ERR_SQ: float = 0.25
const ENTITY_DR_YAW_ERR_DEG: float = 5.0
const ENTITY_VISUAL_NEAR_RADIUS: float = 48.0
const ENTITY_VISUAL_MID_RADIUS: float = 88.0
const ENTITY_SNAPSHOT_INTERVAL_NEAR: float = 0.05
const ENTITY_SNAPSHOT_INTERVAL_MID: float = 0.12
const ENTITY_SNAPSHOT_INTERVAL_FAR: float = 0.35


# --- Scene-path / sync-node predicate (pure tails) ---

# resolve_sync_scene_path: pure form of `_get_sync_scene_path`
# (coop_manager.gd L4864-4870). The forwarder reads
# `node.scene_file_path` and `node.get_meta("coop_source_scene_path",
# "")` and threads them in. Empty `scene_file_path` falls back to
# the meta value; both empty returns "".
static func resolve_sync_scene_path(scene_file_path: String, fallback_meta_path: String) -> String:
    if scene_file_path != "":
        return scene_file_path
    return fallback_meta_path


# is_syncable_entity: pure tail of `_is_syncable_entity_node`
# (coop_manager.gd L5079-5080). The forwarder evaluates the three
# class predicates against the node and threads the booleans in.
# Returns true when the node is an Entity that is neither a Player
# instance nor a remote-player proxy.
static func is_syncable_entity(is_entity: bool, is_player: bool, is_remote_player_proxy: bool) -> bool:
    return is_entity and not is_player and not is_remote_player_proxy


# --- Cache keys ---

# host_entity_snapshot_key / host_entity_visual_key: pure forms of
# `_host_entity_snapshot_key` / `_host_entity_visual_key`
# (coop_manager.gd L16380-16385). Two functions even though they
# return the same string today, so the call sites stay
# semantically distinct (`host_entity_snapshot_last_sent` vs.
# `host_entity_last_sent` are different dicts).
static func host_entity_snapshot_key(peer_id: int, uuid: String) -> String:
    return "%s:%s" % [peer_id, uuid]


static func host_entity_visual_key(peer_id: int, uuid: String) -> String:
    return "%s:%s" % [peer_id, uuid]


# host_drop_snapshot_key: same shape, surfaced here so the four
# `*_snapshot_last_sent` / `*_snapshot_last_state` dicts can share
# a single key formatter when CoopDropSync is extracted in Phase
# 14a.
static func host_drop_snapshot_key(peer_id: int, uuid: String) -> String:
    return "%s:%s" % [peer_id, uuid]


# peer_cache_key_prefix: returns the "<peer_id>:" prefix used by
# `_clear_host_interest_cache_for_peer` (coop_manager.gd
# L16388-16404) and the planned CoopDropSync purge pass. Centralising
# the prefix here means the entity / drop / visual caches stay in
# sync if the key shape ever changes.
static func peer_cache_key_prefix(peer_id: int) -> String:
    return "%s:" % peer_id


# --- LOD / interval ---

# get_host_entity_snapshot_interval: pure form of
# `_get_host_entity_snapshot_interval` (coop_manager.gd
# L16452-16457). Three-tier LOD: near / mid / far, with the radii
# pinned at ENTITY_VISUAL_NEAR_RADIUS / ENTITY_VISUAL_MID_RADIUS
# (the forwarder threads in coop_manager.gd's own values).
#
# Inputs are squared distances and squared radii so call sites can
# avoid a `sqrt`. Output is the snapshot interval (seconds).
static func get_host_entity_snapshot_interval(
    distance_squared: float,
    near_radius_sq: float = ENTITY_VISUAL_NEAR_RADIUS * ENTITY_VISUAL_NEAR_RADIUS,
    mid_radius_sq: float = ENTITY_VISUAL_MID_RADIUS * ENTITY_VISUAL_MID_RADIUS,
    near_interval: float = ENTITY_SNAPSHOT_INTERVAL_NEAR,
    mid_interval: float = ENTITY_SNAPSHOT_INTERVAL_MID,
    far_interval: float = ENTITY_SNAPSHOT_INTERVAL_FAR,
) -> float:
    if distance_squared <= near_radius_sq:
        return near_interval
    if distance_squared <= mid_radius_sq:
        return mid_interval
    return far_interval


# --- Yaw delta ---

# host_entity_yaw_delta_abs: pure form of
# `_host_entity_yaw_delta_abs` (coop_manager.gd L16460-16461).
# Returns the absolute yaw delta wrapped to [0, PI]. Handles
# wraparound across `0`/`TAU` without producing spurious
# `~ TAU` deltas.
static func host_entity_yaw_delta_abs(previous_yaw: float, next_yaw: float) -> float:
    return absf(wrapf(next_yaw - previous_yaw + PI, 0.0, TAU) - PI)


# --- Snapshot state build / change detection ---

# build_host_entity_snapshot_state: pure form of
# `_build_host_entity_snapshot_state` (coop_manager.gd L16464-16477).
# The live function reads `scene_file_path` via `_get_sync_scene_path`;
# the forwarder threads the resolved scene path in so this module
# stays oblivious to `class_name Entity`.
static func build_host_entity_snapshot_state(
    scene_path: String,
    entity_position: Vector3,
    entity_yaw: float,
    movement_velocity: Vector3,
    gravity_velocity: Vector3,
    knockback_velocity: Vector3,
    rope_velocity: Vector3,
    dead: bool,
    disabled: bool,
    held_item_id: int,
    held_item_index: int,
) -> Dictionary:
    return {
        "position": entity_position,
        "yaw": entity_yaw,
        "movement_velocity": movement_velocity,
        "gravity_velocity": gravity_velocity,
        "knockback_velocity": knockback_velocity,
        "rope_velocity": rope_velocity,
        "dead": dead,
        "disabled": disabled,
        "held_item_id": held_item_id,
        "held_item_index": held_item_index,
        "scene": scene_path,
    }


# is_host_entity_snapshot_state_changed: pure form of
# `_is_host_entity_snapshot_state_changed` (coop_manager.gd
# L16480-16510). Returns true ONLY when the snapshot diverges from
# the previously-sent snapshot by more than the dead-reckoning
# tolerances:
#   - scene path changed (entity respawn / morph),
#   - dead / disabled flag flipped,
#   - held item id / index changed,
#   - position drifted by more than `pos_err_sq` (default
#     `ENTITY_DR_POS_ERR_SQ`),
#   - yaw drifted by more than `yaw_err_deg` (default
#     `ENTITY_DR_YAW_ERR_DEG`),
#   - any of the four velocity channels drifted by more than
#     `kb_err_sq` (default `ENTITY_DR_KB_ERR_SQ`).
#
# `previous_state.is_empty()` returns true so a never-sent entity
# is always treated as "changed".
static func is_host_entity_snapshot_state_changed(
    previous_state: Dictionary,
    next_state: Dictionary,
    pos_err_sq: float = ENTITY_DR_POS_ERR_SQ,
    yaw_err_deg: float = ENTITY_DR_YAW_ERR_DEG,
    kb_err_sq: float = ENTITY_DR_KB_ERR_SQ,
) -> bool:
    if previous_state.is_empty():
        return true
    if str(previous_state.get("scene", "")) != str(next_state.get("scene", "")):
        return true
    if bool(previous_state.get("dead", false)) != bool(next_state.get("dead", false)):
        return true
    if bool(previous_state.get("disabled", false)) != bool(next_state.get("disabled", false)):
        return true
    if int(previous_state.get("held_item_id", -1)) != int(next_state.get("held_item_id", -1)):
        return true
    if int(previous_state.get("held_item_index", 0)) != int(next_state.get("held_item_index", 0)):
        return true

    var previous_position: Vector3 = previous_state.get("position", Vector3.ZERO)
    var next_position: Vector3 = next_state.get("position", Vector3.ZERO)
    if previous_position.distance_squared_to(next_position) > pos_err_sq:
        return true

    var previous_yaw: float = float(previous_state.get("yaw", 0.0))
    var next_yaw: float = float(next_state.get("yaw", 0.0))
    if host_entity_yaw_delta_abs(previous_yaw, next_yaw) > deg_to_rad(yaw_err_deg):
        return true

    for velocity_key in ["movement_velocity", "gravity_velocity", "knockback_velocity", "rope_velocity"]:
        var previous_velocity: Vector3 = previous_state.get(velocity_key, Vector3.ZERO)
        var next_velocity: Vector3 = next_state.get(velocity_key, Vector3.ZERO)
        if previous_velocity.distance_squared_to(next_velocity) > kb_err_sq:
            return true

    return false


# --- Interest predicate ---

# is_peer_interested_in_position: pure form of the radius / instance
# check inside `_is_peer_interested_in_position` (coop_manager.gd
# L16407-16417).
#
# The forwarder resolves the peer state, the active instance key,
# and `_is_peer_state_same_instance(...)` first; this helper only
# decides whether the peer is "active in the same instance and
# within `radius` of `world_position`".
#
# Inputs (resolved at the forwarder boundary):
#   - `peer_state_active`        - `bool(state.get("active", false))`.
#   - `peer_state_same_instance` - `_is_peer_state_same_instance(state,
#                                  instance_key)`.
#   - `peer_position`            - `state.get("position", world_position)`
#                                  (note the live code falls back to
#                                  the focus position so a missing
#                                  state-position counts as "co-located").
#   - `world_position`           - the focus point (drop / entity).
#   - `radius`                   - the interest radius (e.g.
#                                  `DROP_SYNC_RADIUS = 96.0`).
#
# Squared-radius comparison matches the live code.
static func is_peer_interested_in_position(
    peer_state_active: bool,
    peer_state_same_instance: bool,
    peer_position: Vector3,
    world_position: Vector3,
    radius: float,
) -> bool:
    if not peer_state_active:
        return false
    if not peer_state_same_instance:
        return false
    return peer_position.distance_squared_to(world_position) <= radius * radius


# --- Client-side block / render gate ---

# client_entity_block_position: pure form of
# `_client_entity_block_position` (coop_manager.gd L16924-16925).
# Floors a world-position into the integer block coordinate the
# remote-entity proxy uses to ask `Ref.world.is_position_loaded`.
static func client_entity_block_position(world_position: Vector3) -> Vector3i:
    return Vector3i(world_position.floor())


# should_full_render_client_entity: pure form of
# `_should_full_render_client_entity` (coop_manager.gd L16928-16931).
# The forwarder threads in:
#   - `world_valid`        - `is_instance_valid(Ref.world)`.
#   - `is_position_loaded` - `Callable(Ref.world, "is_position_loaded")`.
# Returns true ONLY when `world_valid` AND the block at
# `client_entity_block_position(world_position)` is reported as
# loaded by the engine.
#
# Invalid callable is treated as "not loaded" (do NOT full-render).
# This is intentionally stricter than the live code on the
# unreachable test-harness path, where `Ref.world` would not exist;
# `world_valid=false` already covers that path on coop_manager.gd.
static func should_full_render_client_entity(
    world_valid: bool,
    world_position: Vector3,
    is_position_loaded: Callable,
) -> bool:
    if not world_valid:
        return false
    if not is_position_loaded.is_valid():
        return false
    return bool(is_position_loaded.call(client_entity_block_position(world_position)))
