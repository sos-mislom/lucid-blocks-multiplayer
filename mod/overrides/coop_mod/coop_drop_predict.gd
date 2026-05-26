class_name CoopDropPredict
extends RefCounted

# CoopDropPredict - phase 14b extraction from coop_manager.gd.
#
# Pure decision helpers for the client-side drop pipeline that:
#   - predicts a temporary local drop when the player breaks a
#     block (so the inventory animation feels instant, even before
#     the host confirmation arrives);
#   - matches a freshly arrived authoritative drop to the
#     predicted one when the host snapshot lands (so the predicted
#     ghost is replaced in-place instead of spawning a duplicate);
#   - corrects the local drop position / velocity from the host
#     snapshot (snap on big divergence, lerp on small divergence,
#     keep predicted motion during the post-merge grace);
#   - auto-picks up drops that land inside the local-player pickup
#     radius (server still owns the actual transfer; this is purely
#     a UX nudge that fires `sync_local_pickup_item`).
#
# Engine-bound bodies stay on coop_manager.gd as thin forwarders:
#   - `_predict_client_break_drops_for_block` instantiates
#     `class_name ItemState`; the pure form
#     (`should_predict_break_drops`) returns the boolean decision
#     gate around the live `ItemState.new()` calls.
#   - `_spawn_client_predicted_drop` calls
#     `load(DROPPED_ITEM_SCENE_PATH).instantiate()` + writes metas;
#     no pure form needed - it is mostly side effects.
#   - `_find_matching_predicted_drop` walks
#     `_get_live_tracked_drops()` and compares signatures + squared
#     distances; the pure form
#     (`predicted_drop_signature_matches` +
#     `is_predicted_drop_within_match_distance`) is the per-child
#     filter the forwarder calls inside the loop.
#   - `_attempt_client_auto_pickup_drop` calls
#     `sync_local_pickup_item.rpc_id(...)` (NodePath-bound, stays
#     on coop_manager.gd); the pure form
#     (`should_attempt_client_auto_pickup`) is the precondition
#     gate.
#   - `_is_client_drop_within_pickup_radius` reads `Ref.player.dead`
#     / `Ref.player.disabled`, dropped_item.global_position; the
#     pure form (`is_drop_within_pickup_radius`) accepts the
#     resolved bools + positions.
#   - `_apply_client_drop_snapshot` orchestrates dropped_item
#     mutations + the post-merge grace window; the pure form
#     (`resolve_client_drop_position_correction`) is the snap /
#     lerp / keep-predicted-motion decision tree and
#     `should_wake_sleeping_drop` is the wake threshold.
#
# Constants pinned in this module (single source of truth):
#   - `PREDICTED_DROP_MATCH_DISTANCE`         = 2.5 m
#   - `AUTO_PICKUP_RADIUS`                    = 2.35 m
#   - `PREDICTED_DROP_SYNC_GRACE_MS`          = 350 ms
#   - `DROP_SYNC_GRACE_SEC`                   = 1.1 s
#   - `DROP_CORRECTION_DISTANCE`              = 1.35 m
#   - `DROP_POSITION_BLEND`                   = 0.45
#   - `DROP_VELOCITY_BLEND`                   = 0.7
#   - `DROP_SLEEP_WAKE_DISTANCE`              = 0.35 m
#   - `DROP_SLEEP_WAKE_VEL_SQ`                = 0.36 (= 0.6 m/s)^2
#   - `DROP_POSITION_LERP_THRESHOLD`          = 0.01 m
# Live `coop_manager.gd` keeps its own copies on lines 68 / 127-135
# and threads them in via the forwarder; pinned-here values are the
# documented defaults for unit tests.


# --- Constants ---

const PREDICTED_DROP_MATCH_DISTANCE: float = 2.5
const AUTO_PICKUP_RADIUS: float = 2.35
const PREDICTED_DROP_SYNC_GRACE_MS: int = 350
const DROP_SYNC_GRACE_SEC: float = 1.1
const DROP_CORRECTION_DISTANCE: float = 1.35
const DROP_POSITION_BLEND: float = 0.45
const DROP_VELOCITY_BLEND: float = 0.7
const DROP_SLEEP_WAKE_DISTANCE: float = 0.35
const DROP_SLEEP_WAKE_VEL_SQ: float = 0.36
const DROP_POSITION_LERP_THRESHOLD: float = 0.01


# --- Break-drop prediction ---

# should_predict_break_drops: pure form of the early-return ladder
# in `_predict_client_break_drops_for_block` (coop_manager.gd
# L9323-9331).
#
# Returns true ONLY when the client is allowed to spawn a local
# predicted drop for the block break, matching the live decision:
#   - pickaxe required but the player has no pickaxe   -> false
#   - axe required but the player has no axe           -> false
#   - block has `drop_loot` (server-only loot table)   -> false
#   - block has `drop_item` (single item to drop)      -> true
#     (the explicit-item branch always proceeds)
#   - otherwise block must be `can_drop` to fall back  -> true
#
# `has_drop_item` collapses the live `block.drop_item == null`
# branch: when an explicit drop item is set we always predict; when
# absent we need `block.can_drop` to fall back to the block itself.
static func should_predict_break_drops(
    pickaxe_required: bool,
    axe_required: bool,
    has_drop_loot: bool,
    has_pickaxe: bool,
    has_axe: bool,
    has_drop_item: bool,
    can_drop: bool,
) -> bool:
    if pickaxe_required and not has_pickaxe:
        return false
    if axe_required and not has_axe:
        return false
    if has_drop_loot:
        return false
    if has_drop_item:
        return true
    return can_drop


# --- Predicted-drop matching ---

# predicted_drop_signature_matches: pure form of the
# `_item_state_signature` compare inside
# `_find_matching_predicted_drop` (coop_manager.gd L9351-9371).
#
# Empty `query_signature` is the live "no item state -> bail out"
# return-null branch; we model that as "never matches" so the
# forwarder loop body stays simple.
static func predicted_drop_signature_matches(stored_signature: String, query_signature: String) -> bool:
    if query_signature == "":
        return false
    return stored_signature == query_signature


# is_predicted_drop_within_match_distance: pure form of the
# squared-distance gate inside `_find_matching_predicted_drop`. The
# live code uses `match_distance` (default
# `CLIENT_PREDICTED_DROP_MATCH_DISTANCE = 2.5`) and runs the
# comparison in squared-space to avoid the sqrt; we keep the same
# signature so the test surface matches.
static func is_predicted_drop_within_match_distance(
    drop_position: Vector3,
    candidate_position: Vector3,
    match_distance: float = PREDICTED_DROP_MATCH_DISTANCE,
) -> bool:
    return drop_position.distance_squared_to(candidate_position) <= match_distance * match_distance


# --- Auto-pickup ---

# is_drop_within_pickup_radius: pure form of
# `_is_client_drop_within_pickup_radius` (coop_manager.gd
# L9374-9379).
#
# Returns true when the player can be sampled (not dead, not
# disabled) and the dropped item is inside the squared pickup
# radius. The forwarder threads in the resolved
# `_can_sample_player()` boolean (which collapses
# `is_instance_valid(Ref.player)` checks).
static func is_drop_within_pickup_radius(
    can_sample_player: bool,
    player_dead: bool,
    player_disabled: bool,
    player_position: Vector3,
    drop_position: Vector3,
    radius: float = AUTO_PICKUP_RADIUS,
) -> bool:
    if not can_sample_player:
        return false
    if player_dead or player_disabled:
        return false
    return drop_position.distance_squared_to(player_position) <= radius * radius


# should_attempt_client_auto_pickup: pure form of the early-return
# ladder inside `_attempt_client_auto_pickup_drop` (coop_manager.gd
# L9382-9392).
#
# Returns true ONLY when ALL of the following hold:
#   - we are not running as the server (the host already owns
#     pickup);
#   - the dropped item is valid (forwarder pre-resolves with
#     `is_instance_valid`);
#   - the drop is `can_collect` (collect-grace expired);
#   - no pickup request is already in flight (the
#     `coop_pickup_pending_request` meta is false);
#   - the drop is inside the auto-pickup radius
#     (`is_drop_within_pickup_radius`).
static func should_attempt_client_auto_pickup(
    is_server: bool,
    drop_valid: bool,
    can_collect: bool,
    pickup_pending_request: bool,
    within_pickup_radius: bool,
) -> bool:
    if is_server or not drop_valid:
        return false
    if not can_collect:
        return false
    if pickup_pending_request:
        return false
    return within_pickup_radius


# --- Sync grace ---

# is_drop_sync_grace_active: pure form of
# `_is_client_drop_sync_grace_active` (coop_manager.gd
# L17058-17061). Returns true when the drop is still inside the
# direct-spawn grace window the host opened on initial sync. The
# forwarder reads `dropped_item.get_meta("coop_direct_spawn_grace_until_ms")`
# and `Time.get_ticks_msec()`.
static func is_drop_sync_grace_active(grace_until_ms: int, now_ms: int) -> bool:
    return now_ms < grace_until_ms


# is_drop_snapshot_grace_active: pure form of
# `_is_client_drop_snapshot_grace_active` (coop_manager.gd
# L17064-17070). Returns true when the last received host snapshot
# was within `grace_ms`. `last_snapshot_msec <= 0` means "never
# sampled" - matches the live `if last_snapshot_msec <= 0: return false`.
static func is_drop_snapshot_grace_active(
    last_snapshot_msec: int,
    now_ms: int,
    grace_sec: float = DROP_SYNC_GRACE_SEC,
) -> bool:
    if last_snapshot_msec <= 0:
        return false
    return (now_ms - last_snapshot_msec) <= int(grace_sec * 1000.0)


# is_predicted_drop_sync_grace_active: pure compare used by the
# `coop_predicted_sync_grace_until_ms` meta set inside
# `_configure_client_synced_drop` (coop_manager.gd L17119-17120)
# and read by `_apply_client_drop_snapshot` (L17878-17879). Same
# shape as `is_drop_sync_grace_active`, named separately so the
# call sites read clearly.
static func is_predicted_drop_sync_grace_active(grace_until_ms: int, now_ms: int) -> bool:
    return now_ms < grace_until_ms


# --- Position correction ---

# resolve_client_drop_position_correction: pure form of the
# snap-vs-lerp-vs-keep decision tree inside
# `_apply_client_drop_snapshot` (coop_manager.gd L17880-17892).
#
# Inputs (resolved at the forwarder boundary):
#   - `snapshot_initialized`     - the
#                                  `coop_drop_snapshot_initialized`
#                                  meta. First snapshot from the
#                                  host -> teleport to drop_position
#                                  and clear distance_error.
#   - `keep_predicted_motion`    - the predicted-drop grace flag
#                                  (`coop_predicted_sync_grace_until_ms
#                                  > now_ms`). When true the
#                                  client keeps its locally
#                                  predicted motion to avoid jitter.
#   - `current_position`         - dropped_item.global_position now.
#   - `target_position`          - host snapshot position.
#   - `correction_distance`      - snap-vs-lerp threshold
#                                  (default 1.35 m).
#   - `position_blend`           - lerp factor (default 0.45).
#   - `position_lerp_threshold`  - minimum drift before lerp fires
#                                  (default 0.01 m); below this we
#                                  keep the current position.
#
# Returns a Dictionary `{
#     "next_position": Vector3,
#     "snapshot_initialized": bool,
#     "distance_error": float,
# }` so the forwarder can apply the position + persist the meta +
# feed the distance back into `should_wake_sleeping_drop`.
static func resolve_client_drop_position_correction(
    snapshot_initialized: bool,
    keep_predicted_motion: bool,
    current_position: Vector3,
    target_position: Vector3,
    correction_distance: float = DROP_CORRECTION_DISTANCE,
    position_blend: float = DROP_POSITION_BLEND,
    position_lerp_threshold: float = DROP_POSITION_LERP_THRESHOLD,
) -> Dictionary:
    if not snapshot_initialized:
        return {
            "next_position": target_position,
            "snapshot_initialized": true,
            "distance_error": 0.0,
        }
    var distance_error: float = current_position.distance_to(target_position)
    if keep_predicted_motion:
        return {
            "next_position": current_position,
            "snapshot_initialized": true,
            "distance_error": distance_error,
        }
    var next_position: Vector3 = current_position
    if distance_error > correction_distance:
        next_position = target_position
    elif distance_error > position_lerp_threshold:
        next_position = current_position.lerp(target_position, position_blend)
    return {
        "next_position": next_position,
        "snapshot_initialized": true,
        "distance_error": next_position.distance_to(target_position),
    }


# should_wake_sleeping_drop: pure form of the wake threshold inside
# `_apply_client_drop_snapshot` (coop_manager.gd L17895). The
# sleeping DroppedItem state pauses physics to save CPU; we wake it
# when the host says the drop has moved (distance_error > 0.35 m)
# or when the new velocity is non-trivial (squared length > 0.36).
static func should_wake_sleeping_drop(
    distance_error: float,
    velocity_length_squared: float,
    wake_distance: float = DROP_SLEEP_WAKE_DISTANCE,
    wake_velocity_sq: float = DROP_SLEEP_WAKE_VEL_SQ,
) -> bool:
    return distance_error > wake_distance or velocity_length_squared > wake_velocity_sq
