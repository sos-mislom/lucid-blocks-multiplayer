class_name CoopEntityVisuals
extends RefCounted

# CoopEntityVisuals - phase 13b extraction from coop_manager.gd.
#
# Pure helpers for the client-side synced-entity visual pipeline:
# update-interval LOD math, walk-blend computation, scalar / Vector3
# quantisation used by the procedural-visual capture step, the
# segmented-worm predicate (pure tail), and the
# procedural-visual override gate.
#
# The big surface of base-game-touching code stays on coop_manager.gd:
#   - AnimationTree look-up / parameter writes
#     (`_find_first_animation_tree`,
#     `_animation_tree_has_parameter`,
#     `_apply_compact_animation_state`,
#     `_advance_client_animation_tree`).
#   - Worm segment instantiation / Node3D tree mutation
#     (`_sync_worm_segment_structure`,
#     `_refresh_worm_segment_cache`,
#     `_apply_worm_segment_visual_state`).
#   - `_quantize_vector3` / `_quantize_float` forwarders (now
#     thin wrappers around the pure helpers below).
#   - `Ref.player.global_position` distance sampling, `Object.get_meta` /
#     `set_meta` accumulator bookkeeping, `_object_has_property`
#     dispatch.
#   - The `@rpc` handlers (`receive_remote_player_attack`,
#     `receive_remote_player_direct_hit`) - NodePath-bound, stay on
#     coop_manager.gd.
#
# Constants pinned here mirror the live coop_manager.gd copies
# (lines 150-153) so the forwarder can keep using its own names
# without churn; the pinned-here values are the documented
# defaults for unit tests.


# --- Constants ---

# Pinned copies of the live coop_manager.gd constants (lines 150-153).
# The forwarder passes its own values in to keep one source of truth
# in coop_manager.gd; these defaults are used by the unit tests.
const VISUAL_NEAR_RADIUS: float = 48.0
const VISUAL_MID_RADIUS: float = 88.0
const VISUAL_MID_INTERVAL: float = 1.0 / 30.0
const VISUAL_FAR_INTERVAL: float = 1.0 / 15.0


# --- Quantisation (pure form of the live `_quantize_float` / `_quantize_vector3`) ---

# quantize_float: pure form of `_quantize_float` (coop_manager.gd
# L12934-12937). Snaps `value` to the nearest multiple of `step`.
# `step <= 0.0` returns `value` unchanged (matches the live guard).
static func quantize_float(value: float, step: float = 0.05) -> float:
    if step <= 0.0:
        return value
    return snappedf(value, step)


# quantize_vector3: pure form of `_quantize_vector3` (coop_manager.gd
# L12940-12947). Snaps every axis independently via
# `quantize_float`. `step <= 0.0` returns `value` unchanged.
static func quantize_vector3(value: Vector3, step: float = 0.1) -> Vector3:
    if step <= 0.0:
        return value
    return Vector3(
        snappedf(value.x, step),
        snappedf(value.y, step),
        snappedf(value.z, step),
    )


# --- LOD update-interval ---

# resolve_client_visual_update_interval: pure form of the LOD
# decision inside `_consume_client_entity_visual_update_delta`
# (coop_manager.gd L17509-17516).
#
# Three-tier interval over squared distances:
#   - inside near band  -> 0.0 (per-frame update, no accumulator)
#   - mid band          -> mid_interval (default ~33 ms = 30 Hz)
#   - past mid band     -> far_interval (default ~67 ms = 15 Hz)
#
# `can_sample_player=false` forces a per-frame update (the live
# code falls through to `update_interval = 0.0` when the player is
# unsampled). This matches the "always-on visuals when the player
# is missing / loading" intent.
static func resolve_client_visual_update_interval(
    can_sample_player: bool,
    distance_squared: float,
    near_radius_sq: float = VISUAL_NEAR_RADIUS * VISUAL_NEAR_RADIUS,
    mid_radius_sq: float = VISUAL_MID_RADIUS * VISUAL_MID_RADIUS,
    mid_interval: float = VISUAL_MID_INTERVAL,
    far_interval: float = VISUAL_FAR_INTERVAL,
) -> float:
    if not can_sample_player:
        return 0.0
    if distance_squared > mid_radius_sq:
        return far_interval
    if distance_squared > near_radius_sq:
        return mid_interval
    return 0.0


# --- Delta accumulator ---

# consume_visual_update_delta: pure form of the delta-accumulator
# decision inside `_consume_client_entity_visual_update_delta`
# (coop_manager.gd L17517-17527).
#
# Inputs (resolved at the forwarder boundary):
#   - `update_interval`           - the LOD interval (use
#                                   `resolve_client_visual_update_interval`).
#                                   `<= 0.0` means "every frame".
#   - `delta`                     - the engine delta this tick.
#   - `previous_accumulator`      - the entity's
#                                   `coop_client_visual_delta_accum`
#                                   meta value.
#
# Returns a Dictionary:
#   - `visual_delta`              - the delta to feed into the
#                                   visual update (0.0 if not
#                                   ready yet).
#   - `next_accumulator`          - the value the forwarder should
#                                   write back into
#                                   `coop_client_visual_delta_accum`.
#   - `should_emit`               - true ONLY when the caller
#                                   should run the visual update
#                                   step this tick (equivalent to
#                                   `visual_delta > 0.0`).
#
# Behaviour:
#   - `update_interval <= 0.0` -> emit `{visual_delta: delta,
#     next_accumulator: 0.0, should_emit: delta > 0.0}` (the live
#     code resets the accumulator and returns `delta`).
#   - `previous_accumulator + delta + epsilon < interval` -> hold
#     onto the accumulator, no emit.
#   - otherwise -> emit `{visual_delta: previous_accumulator + delta,
#     next_accumulator: fmod(previous_accumulator + delta, interval),
#     should_emit: true}`.
#
# `epsilon = 0.0001` matches the live `accumulated_delta + 0.0001 <
# update_interval` guard.
static func consume_visual_update_delta(
    update_interval: float,
    delta: float,
    previous_accumulator: float,
    epsilon: float = 0.0001,
) -> Dictionary:
    if update_interval <= 0.0:
        return {
            "visual_delta": delta,
            "next_accumulator": 0.0,
            "should_emit": delta > 0.0,
        }

    var accumulated: float = previous_accumulator + delta
    if accumulated + epsilon < update_interval:
        return {
            "visual_delta": 0.0,
            "next_accumulator": accumulated,
            "should_emit": false,
        }

    return {
        "visual_delta": accumulated,
        "next_accumulator": fmod(accumulated, update_interval),
        "should_emit": true,
    }


# --- Walk-blend math ---

# compute_walk_blend: pure form of the walk-blend calculation
# inside `_update_client_entity_visuals` (coop_manager.gd L17548).
#
# Returns the normalised XZ-plane velocity magnitude clamped to
# [0, 1] given the entity's `base_speed * speed_modifier`. Y
# component is intentionally dropped (vertical movement does not
# influence the walk / run blend tree).
#
# Divisor floor `maxf(scale, 0.001)` matches the live guard so a
# zero base_speed or modifier does NOT blow up the division.
static func compute_walk_blend(
    velocity: Vector3,
    base_speed: float,
    speed_modifier: float,
) -> float:
    var planar_speed: float = Vector3(velocity.x, 0.0, velocity.z).length()
    var divisor: float = maxf(base_speed * speed_modifier, 0.001)
    return clampf(planar_speed / divisor, 0.0, 1.0)


# --- Worm predicate (pure tail) ---

# is_segmented_worm_entity: pure tail of `_is_segmented_worm_entity`
# (coop_manager.gd L12985-12988). Returns true when the entity
# script path ends in `/worm.gd` AND the `%Segments` node3d is
# present.
#
# Inputs (resolved at the forwarder boundary):
#   - `entity_script_path`     - `_get_object_script_path(entity)`.
#                                The forwarder passes "" if the
#                                entity is null / invalid.
#   - `has_segments_node3d`    - `entity.get_node_or_null("%Segments")
#                                is Node3D`. The forwarder passes
#                                false if the entity is null /
#                                invalid.
static func is_segmented_worm_entity(
    entity_script_path: String,
    has_segments_node3d: bool,
) -> bool:
    if not has_segments_node3d:
        return false
    return entity_script_path.ends_with("/worm.gd")


# --- Worm segment counts ---

# worm_segment_target_count: pure form of the
# `maxi(required_count, 1)` floor inside
# `_sync_worm_segment_structure` (coop_manager.gd L13024). Pinned
# here so the segment-count clamp lives in one place.
static func worm_segment_target_count(required_count: int) -> int:
    return maxi(required_count, 1)
