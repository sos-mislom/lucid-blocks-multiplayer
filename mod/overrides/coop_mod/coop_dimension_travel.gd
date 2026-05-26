class_name CoopDimensionTravel
extends RefCounted

# CoopDimensionTravel - phase 10 extraction from coop_manager.gd.
#
# Pure decision logic that sits inside the engine-bound orchestration
# of `_open_dimension_instance_async`, `_travel_group_to_dimension_async`,
# and the respawn-anchor selection in `_resolve_default_respawn_fallback_position`.
#
# Three families:
#
#   1. Dimension-class predicate - which dimension ids are private
#      (instanced per-owner). Centralises the `[POCKET, FIRMAMENT]`
#      list that Phase 9 already threads into CoopTeleport.
#
#   2. Open / group-travel path decisions - the if/elif trees that
#      decide whether a dimension transition is a snapshot-request,
#      a guest-flush-then-local-load, or a plain local-load. Encoding
#      those as data (a Dictionary `{path, ...}`) lets the engine-side
#      orchestration `match` on the result and tests pin every branch.
#
#   3. Respawn-anchor selection - the closest-anchor scan and the
#      "use anchors vs fall back to safe-search" gate. Both consumed
#      by `_resolve_default_respawn_fallback_position` and (gate only)
#      by `_resolve_respawn_position`.
#
# This module knows NOTHING about:
#   - `await Ref.main.teleport_to_dimension(...)` - the actual
#     scene-tree level reload stays on coop_manager.gd.
#   - `@rpc` handlers (`request_group_dimension_travel`,
#     `request_dimension_world_snapshot`, `_send_world_snapshot_to_peer`)
#     - NodePath-bound, stay on coop_manager.gd.
#   - `Ref.save_file_manager.loaded_file_register.set_data(...)` -
#     engine save-state mutation, stays on coop_manager.gd inside
#     `_set_loaded_dimension_instance`.
#   - `Ref.world.spawn_tester.find_spawn_position(...)` -
#     `_resolve_respawn_position` and `_position_local_player_after_dimension_open`
#     stay on coop_manager.gd (async + engine).
#   - `_flush_pending_local_world_patch_to_host`,
#     `_persist_current_owned_pocket_variants_if_needed`,
#     `_send_persistent_state_to_host`, `_broadcast_local_state_now` -
#     side-effecting engine helpers, called by the forwarder around
#     the pure decision.
#   - The `status_message` / `_update_status_text()` UI pipeline -
#     constants below carry the message strings; the forwarder writes
#     them in.
#
# Explicit NON-extractions (stay on coop_manager.gd):
#   - `_resolve_target_pocket_owner_key` - mixes pure decision with
#     `_get_local_player_key()` + `_migrate_legacy_pocket_save_to_owner_if_needed`
#     engine calls; the pure bit is one `if`, not worth a helper.
#   - `_set_loaded_dimension_instance` - pure `Ref.save_file_manager`
#     mutations.
#   - `_position_local_player_after_dimension_open` - NARAKA-specific
#     async + `spawn_tester` flow; deferred to a future phase.
#   - `_resolve_respawn_position` / `_resolve_double_downed_host_respawn_position`
#     - cross-cut with revive cluster, deferred to Phase 11 (CoopRevive).


# --- Constants ---

# Status-message strings written into `status_message` by the
# forwarder around each decision branch. Pinned so a rename surfaces
# in CI immediately (matches the Phase 8 pattern for command-policy
# rejection messages).
const STATUS_REQUESTING_WORLD_SYNC: String = "Requesting world sync"
const STATUS_WAITING_FOR_HOST_TELEPORT: String = "Waiting for host teleport"
const STATUS_OPENING_DIMENSION_TEMPLATE: String = "Opening dimension %s"
const STATUS_DIMENSION_SYNCED: String = "Dimension synced"
const STATUS_RETURNED_TO_SPAWN: String = "Returned to spawn"

# RESPAWN_ANCHOR_CENTER_OFFSET: half-block X/Z centering applied to
# the closest-respawn-anchor result before it is returned. Mirrors
# the `Vector3(0.5, 0.0, 0.5)` literal at coop_manager.gd L12740 and
# also the centering used inside `_find_safe_respawn_position_near`
# (kept consistent across both helpers so a teleport target always
# lands on a block centre).
const RESPAWN_ANCHOR_CENTER_OFFSET: Vector3 = Vector3(0.5, 0.0, 0.5)


# --- Dimension-class predicate ---

# is_private_instance_dimension: pure form of _is_private_instance_dimension
# (coop_manager.gd L6325).
#
# Returns true when `dimension` is in the caller-supplied
# `private_dimension_ids` list. The live forwarder threads
# `[POCKET, FIRMAMENT]`; tests can use any ids.
#
# Defensive: empty list returns false (no private dimensions
# configured -> nothing is private).
static func is_private_instance_dimension(dimension: int, private_dimension_ids: Array) -> bool:
    return private_dimension_ids.has(dimension)


# --- Open / group-travel path decisions ---

# decide_open_path: pure form of the if/elif tree inside
# `_open_dimension_instance_async` (coop_manager.gd L6392-6410).
#
# Inputs:
#   - target_instance_key  - the canonical dimension-instance key the
#                            caller wants to open (from
#                            `get_dimension_instance_key(target_dim, owner_key)`).
#   - active_instance_key  - the key the local player is currently in
#                            (from `get_active_dimension_instance_key()`).
#   - host_state           - `peer_states.get(1, {})` on the client
#                            side; `{}` on the host or in singleplayer.
#                            Read for `dimension_instance_key`.
#   - is_server            - `multiplayer.is_server()`.
#   - has_live_peer        - `_has_live_peer()`.
#   - visiting_remote_private - true when the target is a private
#                            dimension owned by a non-local player
#                            (i.e. a remote pocket / firmament).
#
# Output (Dictionary; pure data; engine-side caller dispatches via `match`):
#   - `{path: "request_world_snapshot"}` when the local peer is a
#     client AND (the host is already in the target instance OR we
#     are visiting a remote private instance). The engine-side branch
#     issues `request_dimension_world_snapshot.rpc_id(1, ...)` and
#     writes STATUS_REQUESTING_WORLD_SYNC.
#   - `{path: "local_load", await_guest_flush: bool}` otherwise. The
#     engine-side branch optionally awaits
#     `_await_guest_world_patch_flush_for_instance(target_instance_key)`
#     (when `await_guest_flush` is true) before invoking the
#     `Ref.main.teleport_to_dimension(...)` reload.
#
# Branch semantics preserved from the live tree:
#   - The snapshot-request branch is ONLY taken on the client side
#     (`not is_server AND has_live_peer`), matching the live guard at
#     L6393.
#   - `await_guest_flush` is true ONLY when the host is processing a
#     cross-instance transition for a live coop session, matching the
#     live guard at L6406.
static func decide_open_path(
    target_instance_key: String,
    active_instance_key: String,
    host_state: Dictionary,
    is_server: bool,
    has_live_peer: bool,
    visiting_remote_private: bool,
) -> Dictionary:
    if has_live_peer and not is_server:
        var host_in_target: bool = str(host_state.get("dimension_instance_key", "")) == target_instance_key
        if host_in_target or visiting_remote_private:
            return {"path": "request_world_snapshot"}

    var await_guest_flush: bool = is_server and has_live_peer and target_instance_key != active_instance_key
    return {
        "path": "local_load",
        "await_guest_flush": await_guest_flush,
    }


# decide_group_travel_path: pure form of the if/elif tree inside
# `_travel_group_to_dimension_async` (coop_manager.gd L6344-6358).
#
# Inputs: `is_server` (`multiplayer.is_server()`), `has_live_peer`
# (`_has_live_peer()`).
#
# Output (Dictionary; pure data):
#   - `{path: "singleplayer"}` when there is no live peer. The
#     engine-side branch just runs the local teleport.
#   - `{path: "client_request"}` when we are a client (live peer +
#     not server). The engine-side branch sends
#     `request_group_dimension_travel.rpc_id(1, ...)` and writes
#     STATUS_WAITING_FOR_HOST_TELEPORT.
#   - `{path: "server_orchestrate"}` when we are the host with a live
#     peer. The engine-side branch sets the group-transfer flag,
#     writes STATUS_OPENING_DIMENSION_TEMPLATE, runs the teleport,
#     then broadcasts world snapshots.
static func decide_group_travel_path(is_server: bool, has_live_peer: bool) -> Dictionary:
    if not has_live_peer:
        return {"path": "singleplayer"}
    if not is_server:
        return {"path": "client_request"}
    return {"path": "server_orchestrate"}


# --- Peer-state iteration ---

# select_active_peer_in_instance: pure form of
# `_find_active_peer_position_in_instance` (coop_manager.gd L6433-6451).
#
# Iterates `peer_states.keys()` in dict order (matches the existing
# for-loop semantics; no sort applied). Excludes `own_peer_id`,
# inactive peers, and peers in a different `dimension_instance_key`.
# Returns the FIRST matching peer (first-hit semantics preserved).
#
# Returns:
#   - `{found: true, peer_id: int, position: Vector3}` on hit.
#   - `{found: false}` on miss.
#
# Mirror of Phase 9's `CoopTeleport.match_peer_for_tp` shape so the
# two peer-lookup helpers feel consistent to forwarder callers.
static func select_active_peer_in_instance(peer_states: Dictionary, instance_key: String, own_peer_id: int) -> Dictionary:
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == own_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != instance_key:
            continue
        return {
            "found": true,
            "peer_id": int_peer_id,
            "position": state.get("position", Vector3.ZERO),
        }
    return {"found": false}


# --- Respawn-anchor selection ---

# find_closest_respawn_position: pure form of the closest-anchor loop
# inside `_resolve_default_respawn_fallback_position` (coop_manager.gd
# L12735-12740).
#
# Iterates `respawn_positions` (a list of `Vector3i` block-coords - the
# forwarder passes `Ref.world.respawn_positions.keys()` in), picks the
# anchor closest to `origin_position` by Euclidean distance, and
# returns `Vector3(anchor) + RESPAWN_ANCHOR_CENTER_OFFSET`. Ties go to
# the first-seen anchor (preserves the live `<` comparison at L12738).
#
# Defensive: empty list returns `origin_position` unchanged. The live
# forwarder gates on `respawn_positions.is_empty()` BEFORE calling
# this helper, so the empty-list branch is belt-and-suspenders for
# tests / future callers that forget the gate.
static func find_closest_respawn_position(respawn_positions: Array, origin_position: Vector3) -> Vector3:
    if respawn_positions.is_empty():
        return origin_position

    var closest_position: Vector3i = respawn_positions[0]
    var closest_distance: float = Vector3(closest_position).distance_to(origin_position)
    for i in range(1, respawn_positions.size()):
        var candidate: Vector3i = respawn_positions[i]
        var candidate_distance: float = Vector3(candidate).distance_to(origin_position)
        if candidate_distance < closest_distance:
            closest_position = candidate
            closest_distance = candidate_distance
    return Vector3(closest_position) + RESPAWN_ANCHOR_CENTER_OFFSET


# should_use_respawn_anchors: pure form of the gating predicate used
# by `_resolve_default_respawn_fallback_position` (L12735) and
# `_resolve_respawn_position` (L12750).
#
# Returns true when the player is NOT in wandering-spirit mode AND
# the world has at least one respawn anchor configured. The two
# callers diverge after this check: the fallback helper picks the
# closest anchor; the resolver returns the player's current position
# (which is treated as "snap to nearest known anchor by caller").
static func should_use_respawn_anchors(wandering_spirit: bool, respawn_positions_empty: bool) -> bool:
    return not wandering_spirit and not respawn_positions_empty
