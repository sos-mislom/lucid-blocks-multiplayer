class_name CoopBuilderRuntime
extends RefCounted

# CoopBuilderRuntime - phase 7 extraction from coop_manager.gd.
#
# Pure helpers for the admin builder runtime: tick gating + the
# per-frame day-lock / peaceful-sweep decisions, plus the filter that
# picks which scene-tree nodes the peaceful pass should despawn.
#
# This module knows NOTHING about:
#   - multiplayer / scene tree / Ref.* - every engine call is passed
#     in as a Callable (deps for the tick) or a pre-resolved value
#     (nodes Array + player_node for the despawn filter).
#   - The Entity class - the `is Entity` guard lives on coop_manager.gd
#     as _is_entity_value() and is injected via the is_entity_value
#     Callable so the test runner can instantiate this module without
#     the base game's class_names being registered. Same isolation
#     pattern as Phase 6's CoopBuilder.is_block_value.
#   - queue_free / find_children / Ref.entity_spawner mutation - the
#     forwarder in coop_manager.gd owns all engine-mutating calls.


# --- Constants (canonical values referenced from coop_manager.gd) ---

# DAY_TIME_OF_DAY: value the /daylock command writes to Ref.world.time_of_day.
const DAY_TIME_OF_DAY: float = 0.25

# PEACEFUL_SWEEP_INTERVAL_SEC: timer reset value after each peaceful
# sweep fires; one sweep per second matches the pre-refactor cadence.
const PEACEFUL_SWEEP_INTERVAL_SEC: float = 1.0

# DAY_LOCK_RESPONSE: chat-feedback string when /daylock toggles on
# with report=true. Kept here so renames go through the constant.
const DAY_LOCK_RESPONSE: String = "Time locked to day"


# --- Tick decision ---

# compute_tick: pure form of _tick_builder_admin_runtime (coop_manager.gd
# 7328-7337). Decides whether the day-lock and peaceful-sweep actions
# should fire this frame and returns the updated timer value the
# forwarder writes back.
#
# state (in):
#   peaceful_enabled:        bool   - is /peaceful currently on
#   day_lock_enabled:        bool   - is /daylock currently on
#   peaceful_sweep_timer:    float  - remaining seconds before next sweep
#   peaceful_sweep_interval: float  - reset value after a sweep fires
#                                     (defaults to PEACEFUL_SWEEP_INTERVAL_SEC)
#
# deps:
#   has_live_peer: Callable() -> bool - true when a live coop session
#       exists. Invalid callable defaults to false (singleplayer).
#   is_server:     Callable() -> bool - true when this peer is the
#       multiplayer authority. Invalid callable defaults to true
#       (singleplayer fallback - there is no peer to consult, so the
#       local instance is implicitly the authority).
#
# Returns:
#   {
#     state:   { peaceful_sweep_timer: float },  # forwarder writes back
#     actions: {
#       apply_day_lock: bool,                    # call _set_builder_day_time(false)
#       apply_peaceful: bool,                    # call _apply_builder_peaceful_runtime()
#     },
#   }
static func compute_tick(delta: float, state: Dictionary, deps: Dictionary) -> Dictionary:
    var has_live_peer: Callable = deps.get("has_live_peer", Callable())
    var is_server: Callable = deps.get("is_server", Callable())
    var live_peer: bool = has_live_peer.is_valid() and bool(has_live_peer.call())
    var server: bool = (not is_server.is_valid()) or bool(is_server.call())
    var current_timer: float = float(state.get("peaceful_sweep_timer", 0.0))
    if live_peer and not server:
        return {
            "state": {"peaceful_sweep_timer": current_timer},
            "actions": {"apply_day_lock": false, "apply_peaceful": false},
        }
    var apply_day_lock: bool = bool(state.get("day_lock_enabled", false))
    var apply_peaceful: bool = false
    if bool(state.get("peaceful_enabled", false)):
        current_timer -= delta
        if current_timer <= 0.0:
            current_timer = float(state.get("peaceful_sweep_interval", PEACEFUL_SWEEP_INTERVAL_SEC))
            apply_peaceful = true
    return {
        "state": {"peaceful_sweep_timer": current_timer},
        "actions": {"apply_day_lock": apply_day_lock, "apply_peaceful": apply_peaceful},
    }


# --- Entity-despawn filter ---

# select_entities_to_despawn: pure form of the inner loop body in
# _apply_builder_peaceful_runtime (coop_manager.gd 7349-7353). Returns
# the subset of `nodes` that the forwarder should `queue_free()`.
#
# Rules:
#   - exclude the player node (compared by identity / `==`).
#   - include nodes for which is_entity_value.call(node) returns true.
#   - skip everything else (interior chunks, lights, UI nodes, etc.).
#   - invalid is_entity_value callable -> empty result (defensive; the
#     forwarder should always pass _is_entity_value, but we guard
#     anyway so a refactor that drops the bag does not despawn the
#     entire scene by accident).
#
# is_instance_valid(...) is NOT checked here - the forwarder runs it
# right before queue_free so this module stays free of engine state.
static func select_entities_to_despawn(nodes: Array, player_node, is_entity_value: Callable) -> Array:
    var result: Array = []
    if not is_entity_value.is_valid():
        return result
    for node in nodes:
        if node == player_node:
            continue
        if bool(is_entity_value.call(node)):
            result.append(node)
    return result
