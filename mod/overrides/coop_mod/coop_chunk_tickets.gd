class_name CoopChunkTickets
extends RefCounted

# CoopChunkTickets - phase 12b extraction from coop_manager.gd.
#
# Pure helpers for the dedicated-server chunk-ticket and load-focus
# subsystems. The live forwarders thread the engine state
# (`server_chunk_tickets`, `dedicated_load_focus_*`, `peer_states`,
# `Time.get_ticks_msec()`, `get_active_dimension_instance_key()`)
# around these decisions.
#
# Four families:
#
#   1. `cleanup_active_chunk_tickets` - removes expired or
#      wrong-instance tickets from the live tickets dict. Counterpart
#      to `_cleanup_server_chunk_tickets` (coop_manager.gd L10800-10811).
#
#   2. `select_active_chunk_ticket_positions` - filters the tickets
#      dict to the active instance, sorts by priority then expiration
#      time, deduplicates by chunk position, and returns up to
#      `max_count` ticket centers. Pure form of
#      `_get_active_server_chunk_ticket_positions` (L10814-10853).
#
#   3. `tick_dedicated_load_focus` - per-frame load-focus state
#      transition. Returns the new state plus a `side_effect` token
#      (`"reset_all"`, `"none"`, `"expire"`) the forwarder uses to
#      apply the world-load side effects (clear `server_chunk_tickets`,
#      zero the cleanup timer, clear focus peer). Pure form of
#      `_tick_dedicated_world_load_focus` (L5196-5212).
#
#   4. `select_dedicated_world_load_center` - chooses the world
#      coordinate the dedicated server streams chunks around. Pure form
#      of `_get_dedicated_world_load_center` (L10643-10670).
#
# Plus a tiny pure helper:
#
#   - `snap_world_stream_position(position)` - chunk-grid (16-block)
#     centering helper from `_snap_world_stream_position` (L11311-11316).
#
# This module knows NOTHING about:
#   - `Ref.world.*` - the only engine-bound state the live functions
#     touch (besides member vars) is `Ref.world.snap_to_chunk(...)`
#     which is the SOURCE of the `chunk` field on each ticket and is
#     therefore already populated before tickets reach the pure helpers.
#   - `dedicated_server_enabled` / `multiplayer.is_server()` gates -
#     the live forwarders gate before calling the pure helpers.
#   - `Time.get_ticks_msec()` - `now_msec` is passed in as a plain int
#     so tests stay deterministic.
#   - `get_active_dimension_instance_key()` - the forwarder resolves
#     the active instance and passes the string in.


# --- Helper: chunk-grid centering ---

# snap_world_stream_position: pure form of `_snap_world_stream_position`
# (coop_manager.gd L11311-11316).
#
# Snaps `position` to the centre of its 16-block chunk on every axis.
# Used as the world-load focus position when the live focus point is
# not aligned with the chunk grid. The +0.5 / +8.0 offset
# (`floor(...) * 16.0 + 8.0`) lands the result in the centre of the
# block in the centre of the chunk.
static func snap_world_stream_position(position: Vector3) -> Vector3:
    return Vector3(
        floor(position.x / 16.0) * 16.0 + 8.0,
        floor(position.y / 16.0) * 16.0 + 8.0,
        floor(position.z / 16.0) * 16.0 + 8.0,
    )


# --- Cleanup ---

# cleanup_active_chunk_tickets: pure form of `_cleanup_server_chunk_tickets`
# (coop_manager.gd L10800-10811).
#
# Iterates `tickets.keys()` (mutated via `.erase(...)` mid-iteration -
# this is safe in GDScript when erasing the current key) and removes:
#   - empty ticket entries
#   - tickets whose `expires_at_msec` is <= `now_msec` (expired)
#   - tickets whose `dimension_instance_key` differs from
#     `active_instance_key`
#
# Returns the count of removed entries (useful for diagnostics; live
# function returns void but a count is cheap to expose and makes the
# helper testable without inspecting the dict directly).
#
# `tickets` is mutated in place. Empty input is a no-op.
static func cleanup_active_chunk_tickets(tickets: Dictionary, now_msec: int, active_instance_key: String) -> int:
    if tickets.is_empty():
        return 0
    var removed: int = 0
    for key in tickets.keys():
        var ticket: Dictionary = tickets.get(key, {})
        if ticket.is_empty() \
            or int(ticket.get("expires_at_msec", 0)) <= now_msec \
            or str(ticket.get("dimension_instance_key", "")) != active_instance_key:
            tickets.erase(key)
            removed += 1
    return removed


# --- Active ticket position selection ---

# select_active_chunk_ticket_positions: pure form of the filter/sort/
# dedupe steps inside `_get_active_server_chunk_ticket_positions`
# (coop_manager.gd L10822-10853).
#
# Inputs:
#   - `tickets`               - the live `server_chunk_tickets` dict
#     (already cleaned via `cleanup_active_chunk_tickets`).
#   - `active_instance_key`   - the active instance key; tickets in
#     other instances are skipped (defensive - cleanup already removed
#     them, but this filter belongs here too in case the cleanup gate
#     is skipped by tests or by future call sites).
#   - `max_count`             - the upper bound on returned positions.
#   - `require_simulation`    - if true, only tickets with
#     `simulation_enabled = true` are considered.
#
# Output:
#   - `Array` of `Vector3` ticket centers, sorted by descending
#     priority (ties broken by descending expiration time), deduplicated
#     by ticket `chunk` position (Vector3i), capped at `max_count`.
#
# A ticket without a Vector3 `center` field is skipped (matches live
# L10832 type-guard).
#
# `max_count <= 0` returns `[]` immediately as a safety hatch (the
# live forwarder always passes a positive value; the guard helps tests
# pin the no-op case).
static func select_active_chunk_ticket_positions(
    tickets: Dictionary,
    active_instance_key: String,
    max_count: int,
    require_simulation: bool,
) -> Array:
    if max_count <= 0:
        return []
    var records: Array = []
    for ticket in tickets.values():
        if not (ticket is Dictionary):
            continue
        if str(ticket.get("dimension_instance_key", "")) != active_instance_key:
            continue
        if require_simulation and not bool(ticket.get("simulation_enabled", false)):
            continue
        var center: Variant = ticket.get("center", null)
        if center is Vector3:
            records.append(ticket)

    records.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
        var priority_a: int = int(a.get("priority", 0))
        var priority_b: int = int(b.get("priority", 0))
        if priority_a != priority_b:
            return priority_a > priority_b
        return int(a.get("expires_at_msec", 0)) > int(b.get("expires_at_msec", 0))
    )

    var positions: Array = []
    var seen_chunks: Dictionary = {}
    for ticket in records:
        if positions.size() >= max_count:
            break
        var chunk_position: Vector3i = ticket.get("chunk", Vector3i.ZERO)
        if seen_chunks.has(chunk_position):
            continue
        seen_chunks[chunk_position] = true
        positions.append(ticket.get("center", Vector3.ZERO))
    return positions


# --- Load-focus tick ---

# tick_dedicated_load_focus: pure state-transition form of
# `_tick_dedicated_world_load_focus` (coop_manager.gd L5196-5212).
#
# Inputs:
#   - `valid`, `peer_id`, `timer` - current focus state values
#     (`dedicated_load_focus_valid`, `dedicated_load_focus_peer_id`,
#     `dedicated_load_focus_timer`).
#   - `delta`                     - per-frame delta seconds.
#   - `active`                    - the live
#     `dedicated_server_enabled and multiplayer.is_server()` predicate.
#
# Output (Dictionary):
#   - `valid: bool`       - new value for `dedicated_load_focus_valid`.
#   - `peer_id: int`      - new value for `dedicated_load_focus_peer_id`.
#   - `timer: float`      - new value for `dedicated_load_focus_timer`.
#   - `side_effect: String`:
#       - `"reset_all"`   - dedicated server disabled / no longer host;
#         the forwarder must ALSO clear `server_chunk_tickets` and
#         zero `server_chunk_ticket_cleanup_timer`.
#       - `"expire"`      - the focus timer ran out; only the focus
#         state needs updating (tickets keep running).
#       - `"none"`        - no change beyond the returned focus state
#         fields (either focus is invalid and we just idle, or focus
#         is valid and the timer is still positive).
#
# Branch table (matches the live tree):
#   - `not active`:                            -> reset_all
#   - `active and not valid`:                  -> none (peer/timer unchanged)
#   - `active and valid and new_timer > 0`:    -> none (timer ticks down)
#   - `active and valid and new_timer <= 0`:   -> expire (clear valid/peer/timer)
static func tick_dedicated_load_focus(
    valid: bool,
    peer_id: int,
    timer: float,
    delta: float,
    active: bool,
) -> Dictionary:
    if not active:
        return {
            "valid": false,
            "peer_id": 0,
            "timer": 0.0,
            "side_effect": "reset_all",
        }

    if not valid:
        return {
            "valid": false,
            "peer_id": peer_id,
            "timer": timer,
            "side_effect": "none",
        }

    var new_timer: float = timer - delta
    if new_timer <= 0.0:
        return {
            "valid": false,
            "peer_id": 0,
            "timer": 0.0,
            "side_effect": "expire",
        }

    return {
        "valid": true,
        "peer_id": peer_id,
        "timer": new_timer,
        "side_effect": "none",
    }


# --- World-load center selection ---

# select_dedicated_world_load_center: pure form of
# `_get_dedicated_world_load_center` (coop_manager.gd L10643-10670).
#
# Selection priority:
#   1. If the local load focus is `valid`, return `focus_position`.
#   2. Otherwise, if `ticket_positions` (already filtered + sorted by
#      `select_active_chunk_ticket_positions(..., 1, false)`) has at
#      least one Vector3, return the first element.
#   3. Otherwise iterate `peer_states` (excluding `own_peer_id`):
#      a. If a same-instance peer is currently `breaking`, IMMEDIATELY
#         return `Vector3(break_position) + (0.5, 0.5, 0.5)` (the
#         block-centred break point - block actions take focus
#         priority over idle positions).
#      b. Otherwise remember the FIRST same-instance peer's `position`
#         as the fallback.
#   4. If step 3 found a fallback Vector3, return it.
#   5. Return `default_center`.
#
# The same-instance match here is the strict
# `state.dimension_instance_key == active_instance_key` form (matching
# Phase 10 / Phase 11 convention). The forwarder may have additional
# engine-side fallbacks (e.g. `_does_peer_state_match_instance`'s
# dimension+pocket-owner fallback) but that path applies only to
# stale snapshots and the live `_get_dedicated_world_load_center`
# routes through `_is_peer_state_same_instance` which already requires
# `active=true` - so peers with non-default `active` flag values are
# filtered before reaching the strict compare here.
static func select_dedicated_world_load_center(
    load_focus_valid: bool,
    load_focus_position: Vector3,
    ticket_positions: Array,
    peer_states: Dictionary,
    active_instance_key: String,
    own_peer_id: int,
    default_center: Vector3,
) -> Vector3:
    if load_focus_valid:
        return load_focus_position

    if not ticket_positions.is_empty() and ticket_positions[0] is Vector3:
        return ticket_positions[0]

    var first_active_position: Variant = null
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == own_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != active_instance_key:
            continue
        if bool(state.get("breaking", false)):
            var break_position: Vector3i = state.get("break_position", Vector3i.ZERO)
            return Vector3(break_position) + Vector3(0.5, 0.5, 0.5)
        if first_active_position == null:
            first_active_position = state.get("position", default_center)

    if first_active_position is Vector3:
        return first_active_position
    return default_center
