class_name CoopCombatSync
extends RefCounted

# CoopCombatSync - phase 13c extraction from coop_manager.gd.
#
# Pure helpers for the host-side attack-validation + knockback /
# impulse math used by the two @rpc handlers `request_entity_attack`
# (coop_manager.gd L19834-19889) and `request_player_attack`
# (L19892-19939):
#
#   1. `clamp_attack_damage` / `clamp_attack_knockback_strength` /
#     `clamp_attack_fly_strength` - the three "incoming float / int
#     -> server cap" clamps applied to every attack RPC. Pinned as
#     pure helpers so the three call sites share one source of
#     truth and so the caps can be unit-tested.
#
#   2. `is_attack_within_reach` - the
#     `attacker_position.distance_squared_to(target.global_position)
#     > (max_distance + slack) * (max_distance + slack)` reach
#     gate used by both attack RPCs (L19859, L19918). Default slack
#     `1.25` matches the live "client latency tolerance" margin.
#
#   3. `compute_attack_knockback_velocity` - pure form of
#     `calculate_attack_knockback_velocity` (coop_manager.gd
#     L13563-13580). The forwarder resolves the target-side
#     `jump_modifier` / `on_floor` flags and threads them in so
#     the pure module does not need to know about
#     `_object_has_property` / `Player` / `RemotePlayerProxy`.
#
#   4. `clamp_attacker_horizontal_velocity` - pure tail of the
#     remote-vs-local attacker horizontal-velocity clamp used
#     inside `get_attack_impulse_velocity` (coop_manager.gd
#     L13596-L13616). Captures the two clamp modes (remote-proxy:
#     cap at `reported_move_speed` then scale by 0.35; local:
#     cap at `reported_move_speed + 1.25`) plus the Y-clamp
#     `[-8.0, 8.0]`.
#
# This module knows NOTHING about:
#   - `class_name Entity` / `class_name Player`.
#   - `Ref.player` / `Ref.world` / `multiplayer.*`.
#   - `_object_has_property` / `is_remote_player_proxy` /
#     `_get_entity_total_velocity` - resolved at the forwarder
#     boundary.
#   - The `@rpc` handlers (`request_entity_attack`,
#     `request_player_attack`, `confirm_entity_attack`,
#     `receive_remote_player_attack`,
#     `receive_remote_player_direct_hit`,
#     `request_ignite_entity`, `sync_host_attack_on_remote_player`)
#     - NodePath-bound, stay on coop_manager.gd.
#
# Constants pinned in this module (single source of truth):
#   - `MAX_PLAYER_DAMAGE`          = 200
#   - `MAX_KNOCKBACK_STRENGTH`     = 60.0
#   - `MAX_FLY_STRENGTH`           = 60.0
#   - `ATTACK_REACH_DISTANCE`      = 6.0
#   - `ATTACK_REACH_SLACK`         = 1.25
#   - `IMPULSE_Y_CLAMP`            = 8.0
#   - `REMOTE_PROXY_HORIZONTAL_DAMP` = 0.35
#   - `BASE_ATTACKER_VELOCITY_FACTOR` = 0.45
#   - `GROUND_FLY_DAMP_FACTOR`     = 0.5
# The forwarder threads in the live coop_manager.gd values
# (`CLIENT_SAFE_MAX_PLAYER_DAMAGE` = 200, `SERVER_MAX_PLAYER_KNOCKBACK`
# = 60.0, `SERVER_MAX_PLAYER_FLY` = 60.0,
# `ENTITY_ATTACK_REQUEST_MAX_DISTANCE` = 6.0) so the source of
# truth for those caps stays in coop_manager.gd; the pinned-here
# copies are only used by the unit tests.


# --- Constants ---

const MAX_PLAYER_DAMAGE: int = 200
const MAX_KNOCKBACK_STRENGTH: float = 60.0
const MAX_FLY_STRENGTH: float = 60.0
const ATTACK_REACH_DISTANCE: float = 6.0
const ATTACK_REACH_SLACK: float = 1.25
const IMPULSE_Y_CLAMP: float = 8.0
const REMOTE_PROXY_HORIZONTAL_DAMP: float = 0.35
const BASE_ATTACKER_VELOCITY_FACTOR: float = 0.45
const GROUND_FLY_DAMP_FACTOR: float = 0.5


# --- Server-side ingress clamps ---

# clamp_attack_damage: pure form of `clampi(damage, 1, max_damage)`
# (coop_manager.gd L19862, L19921). Damage floor is 1 (a 0-damage
# attack is rejected upstream, but the clamp guarantees at least
# 1 point of damage if it ever passes through).
static func clamp_attack_damage(damage: int, max_damage: int = MAX_PLAYER_DAMAGE) -> int:
    return clampi(damage, 1, max_damage)


# clamp_attack_knockback_strength: pure form of `clampf(knockback,
# 0.0, max)` (coop_manager.gd L19863, L19922). Negative knockback
# is clamped to 0 so a buggy / malicious client cannot pull the
# target toward the attacker.
static func clamp_attack_knockback_strength(strength: float, max_strength: float = MAX_KNOCKBACK_STRENGTH) -> float:
    return clampf(strength, 0.0, max_strength)


# clamp_attack_fly_strength: pure form of `clampf(fly, 0.0, max)`
# (coop_manager.gd L19864, L19923). Same shape as the knockback
# clamp; negative fly is clamped to 0 so the upward impulse
# cannot flip into a downward yank.
static func clamp_attack_fly_strength(strength: float, max_strength: float = MAX_FLY_STRENGTH) -> float:
    return clampf(strength, 0.0, max_strength)


# --- Reach gate ---

# is_attack_within_reach: pure form of the reach check shared by
# `request_entity_attack` (coop_manager.gd L19859) and
# `request_player_attack` (L19918).
#
# Returns true when
# `attacker_position.distance_squared_to(target_position) <=
# (max_distance + slack) * (max_distance + slack)`. Squared-radius
# math matches the live code (no `sqrt`).
#
# `slack` (default `ATTACK_REACH_SLACK = 1.25`) is the client-side
# latency tolerance the live code uses everywhere combat reach is
# enforced; bake into one source of truth here.
static func is_attack_within_reach(
    attacker_position: Vector3,
    target_position: Vector3,
    max_distance: float = ATTACK_REACH_DISTANCE,
    slack: float = ATTACK_REACH_SLACK,
) -> bool:
    var allowed: float = max_distance + slack
    return attacker_position.distance_squared_to(target_position) <= allowed * allowed


# --- Knockback math ---

# compute_attack_knockback_velocity: pure form of
# `calculate_attack_knockback_velocity` (coop_manager.gd
# L13563-13580).
#
# Inputs (resolved at the forwarder boundary):
#   - `target_position`          - `target.global_position`.
#   - `attacker_position`        - the sender state's last
#                                  reported position (or
#                                  `attacker.global_position` as
#                                  fallback).
#   - `attacker_velocity`        - the result of
#                                  `get_attack_impulse_velocity(...)`.
#   - `knockback_strength`       - already clamped.
#   - `fly_strength`             - already clamped.
#   - `target_jump_modifier`     - `float(target.get("jump_modifier"))`
#                                  if present, else 1.0.
#   - `target_on_floor`          - `bool(target.get("grounded"))`
#                                  if remote-proxy, else
#                                  `target.is_on_floor()`.
#
# Returns the knockback velocity to add to the target's
# `knockback_velocity`. Horizontal component points away from the
# attacker; vertical component scales with jump_modifier *
# fly_strength * (0.5 when airborne, 1.0 on ground).
#
# Coefficient `0.45` (`BASE_ATTACKER_VELOCITY_FACTOR`) is the live
# attacker-velocity weight - the attack inherits 45% of the
# attacker's impulse, then adds the directional knockback.
static func compute_attack_knockback_velocity(
    target_position: Vector3,
    attacker_position: Vector3,
    attacker_velocity: Vector3,
    knockback_strength: float,
    fly_strength: float,
    target_jump_modifier: float = 1.0,
    target_on_floor: bool = false,
) -> Vector3:
    var horizontal_kb: Vector3 = target_position - attacker_position
    horizontal_kb.y = 0.0
    if not horizontal_kb.is_zero_approx():
        horizontal_kb = horizontal_kb.normalized()
    var knockback_velocity: Vector3 = BASE_ATTACKER_VELOCITY_FACTOR * attacker_velocity + horizontal_kb * knockback_strength
    var ground_factor: float = 1.0 if target_on_floor else GROUND_FLY_DAMP_FACTOR
    knockback_velocity.y += knockback_strength * target_jump_modifier * fly_strength * ground_factor
    return knockback_velocity


# --- Impulse-velocity horizontal clamp ---

# clamp_attacker_horizontal_velocity: pure form of the
# remote-proxy vs. local horizontal-velocity clamp inside
# `get_attack_impulse_velocity` (coop_manager.gd L13596-L13616).
#
# Mode `is_remote_proxy = true`:
#   - cap horizontal magnitude at `reported_move_speed` (clamp to
#     0 if `reported_move_speed <= 0`),
#   - scale resulting horizontal velocity by 0.35,
#   - return zero Y component (we do not trust remote vertical).
#
# Mode `is_remote_proxy = false`:
#   - cap horizontal magnitude at `reported_move_speed + 1.25`
#     (only if `reported_move_speed >= 0`; otherwise pass through),
#   - preserve Y component clamped to `[-IMPULSE_Y_CLAMP, IMPULSE_Y_CLAMP]`
#     (= [-8.0, 8.0]).
#
# Inputs (resolved at the forwarder boundary):
#   - `current_velocity`         - the un-clamped attack velocity
#                                  (`_get_entity_total_velocity(...)`).
#   - `movement_velocity_or_null`- the entity's `movement_velocity`
#                                  if `_object_has_property(entity,
#                                  "movement_velocity")`; the
#                                  forwarder passes `null` to fall
#                                  back to the horizontal slice of
#                                  `current_velocity`.
#   - `reported_move_speed`      - the sender state's
#                                  `move_speed` (default -1.0 when
#                                  missing -> "no cap" for local
#                                  attacker).
#   - `is_remote_proxy`          - `is_remote_player_proxy(attacker)`.
#
# Live code calls this only when `has_connected_remote_peers()`;
# otherwise the raw `_get_entity_total_velocity(attacker)` is
# returned. The forwarder keeps that early-exit on
# coop_manager.gd.
static func clamp_attacker_horizontal_velocity(
    current_velocity: Vector3,
    movement_velocity_or_null,
    reported_move_speed: float,
    is_remote_proxy: bool,
) -> Vector3:
    var horizontal_velocity: Vector3 = Vector3(current_velocity.x, 0.0, current_velocity.z)
    if movement_velocity_or_null is Vector3:
        horizontal_velocity = movement_velocity_or_null
        horizontal_velocity.y = 0.0

    if is_remote_proxy:
        var remote_speed_cap: float = maxf(reported_move_speed, 0.0)
        if remote_speed_cap > 0.0 and horizontal_velocity.length() > remote_speed_cap:
            horizontal_velocity = horizontal_velocity.normalized() * remote_speed_cap
        elif remote_speed_cap <= 0.0:
            horizontal_velocity = Vector3.ZERO
        return Vector3(
            horizontal_velocity.x * REMOTE_PROXY_HORIZONTAL_DAMP,
            0.0,
            horizontal_velocity.z * REMOTE_PROXY_HORIZONTAL_DAMP,
        )

    if reported_move_speed >= 0.0 and horizontal_velocity.length() > reported_move_speed + ATTACK_REACH_SLACK:
        if not horizontal_velocity.is_zero_approx():
            horizontal_velocity = horizontal_velocity.normalized() * (reported_move_speed + ATTACK_REACH_SLACK)
        else:
            horizontal_velocity = Vector3.ZERO

    var clamped: Vector3 = current_velocity
    clamped.x = horizontal_velocity.x
    clamped.z = horizontal_velocity.z
    clamped.y = clampf(current_velocity.y, -IMPULSE_Y_CLAMP, IMPULSE_Y_CLAMP)
    return clamped
