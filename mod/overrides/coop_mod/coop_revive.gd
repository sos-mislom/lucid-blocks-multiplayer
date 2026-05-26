class_name CoopRevive
extends RefCounted

# CoopRevive - phase 11 extraction from coop_manager.gd.
#
# Pure decision logic for the downed / revive / respawn cluster.
# The forwarders on coop_manager.gd thread engine state
# (`peer_states`, `Ref.player.global_position`, `multiplayer.*`,
# `Ref.world.respawn_positions`, etc.) through these helpers and dispatch
# the side-effecting branches (player mutation, RPC sends, status_message,
# overlay updates) themselves.
#
# Five families:
#
#   1. Same-instance peer scans - reviver-available / downed-partner /
#      all-partners-downed predicates that iterate `peer_states` in dict
#      order, gated by an `instance_key`. Counterparts to the live
#      `_has_same_instance_reviver_available`,
#      `_has_same_instance_downed_partner`, and
#      `_all_same_instance_partners_downed` helpers in coop_manager.gd
#      L5877-5934.
#
#   2. Revive target selection - nearest downed-partner search within
#      `REVIVE_RADIUS`, returning the matched peer-state Dictionary plus
#      `peer_id`. Mirrors the live `_get_revivable_peer_state`
#      (L6149-6178).
#
#   3. Revive request validation - the if/elif tree from
#      `_host_attempt_revive` (L6240-6275) that produces a
#      `{ok, feedback, reviver_name?, target_name?}` decision the
#      forwarder uses to either fire `force_peer_revive.rpc_id` or send
#      a `_send_revive_feedback` reject.
#
#   4. Remote respawn anchor selection - combines the live
#      `_has_remote_respawn_anchor` and `_get_remote_respawn_anchor`
#      (L12665-12718) into one `{found, position}` result. The
#      `prefer_host_peer && peer_id == 1` short-circuit and the
#      "client-with-remote-host-respawning" gate are both preserved.
#
#   5. Pure scalar predicates / math - downed-grace window
#      (`is_in_downed_grace`), fake-death union (`is_fake_dead_or_respawning`),
#      void-Y gate + block centering for the local downed position
#      (`compute_safe_downed_position`).
#
# This module knows NOTHING about:
#   - `@rpc` decorators - `request_revive_peer`, `force_peer_revive`,
#     `receive_revive_feedback`, `sync_host_respawn_state` stay on
#     coop_manager.gd (wire protocol is bound to the script's NodePath
#     on the multiplayer authority).
#   - `Ref.player.*` mutation - `Ref.player.revive()`, `dead`,
#     `health`, `disabled`, `invincible*`, `collision_layer/mask` toggle,
#     `_teleport_local_player_exact` all stay on coop_manager.gd inside
#     `_enter_local_downed_state`, `_finish_local_revive`,
#     `_commit_local_real_death`, `_set_local_player_combat_targetable`.
#   - `Ref.world.is_position_loaded` / `is_block_solid_at` /
#     `get_water_level_at` - the `_is_safe_respawn_position` engine
#     predicate stays on coop_manager.gd. Forwarders pass it as a
#     `Callable` to `compute_safe_downed_position`.
#   - `Ref.world.respawn_positions` access -
#     `_resolve_default_respawn_fallback_position` already routes through
#     `CoopDimensionTravel.find_closest_respawn_position` /
#     `should_use_respawn_anchors` (Phase 10).
#   - `Ref.world.spawn_tester.find_spawn_position(...)` -
#     `_resolve_respawn_position` is async + engine, stays on
#     coop_manager.gd.
#   - The UI overlay (`death_overlay*`, `revive_prompt_label`) and the
#     `status_message` + `_update_status_text()` pipeline.
#   - `multiplayer.is_server()` / `.get_unique_id()` /
#     `_has_live_peer()` / `_can_sample_player()` - resolved at the
#     forwarder boundary and passed in as plain booleans / ints.
#
# Same-instance check semantics:
#   The pure scans here use a strict `state.get("dimension_instance_key", "")`
#   string compare (matching the L5877-5934 source and Phase 10's
#   `CoopDimensionTravel.select_active_peer_in_instance`). The live
#   `_does_peer_state_match_instance` has an engine-side fallback when
#   the state has no `dimension_instance_key` (it reconstructs from
#   `state.dimension` + `pocket_owner_key`). That fallback applies to
#   stale snapshots only - peer_states populated via the canonical
#   `_capture_local_state()` always include the key, so the strict
#   compare matches the live behaviour for all in-flight code paths.


# --- Constants ---

# Tunable knobs preserved from coop_manager.gd L211-214. The live
# forwarders read these via `CoopRevive.REVIVE_RADIUS`, etc.; the
# constants live here so a rename surfaces in CI immediately (matches
# the Phase 8/9/10 pattern).
const REVIVE_RADIUS: float = 3.2
const REVIVE_HOLD_TIME: float = 1.6
const DOWNED_VOID_Y: float = -96.0
const DOWNED_REVIVER_GRACE_SEC: float = 2.0

# RESPAWN_BLOCK_CENTER_OFFSET: half-block X/Z centering applied to the
# local downed position before the safety predicate runs. Matches the
# `Vector3(0.5, 0.0, 0.5)` literal at coop_manager.gd L5871/12730 and
# also the same constant in `CoopDimensionTravel.RESPAWN_ANCHOR_CENTER_OFFSET`
# (kept consistent across both helpers so a teleport target always
# lands on a block centre).
const RESPAWN_BLOCK_CENTER_OFFSET: Vector3 = Vector3(0.5, 0.0, 0.5)

# Feedback message templates emitted by `validate_revive_request`.
# Pinned so a rename surfaces in CI immediately (matches the Phase 8
# `REJECTION_MESSAGE_TEMPLATE` pattern). The forwarder writes the
# returned `feedback` string into `status_message` (local sender) or
# pipes it through `receive_revive_feedback.rpc_id(...)` (remote sender).
const FEEDBACK_GENERIC_FAILURE: String = "Revive failed"
const FEEDBACK_NOT_SAME_AREA: String = "Revive failed: not in the same area"
const FEEDBACK_SENDER_DOWNED: String = "Revive failed: you are downed"
const FEEDBACK_TARGET_NOT_DOWNED: String = "Revive failed: target is already up"
const FEEDBACK_OUT_OF_RANGE: String = "Revive failed: get closer"


# --- Same-instance peer scans ---

# has_same_instance_reviver_available: pure form of
# `_has_same_instance_reviver_available` (coop_manager.gd L5877-5894).
#
# Returns true when at least one ACTIVE, NOT-DOWNED peer in
# `peer_states` shares `instance_key` with the caller. Excludes
# `ignore_peer_id` (the forwarder passes `multiplayer.get_unique_id()`
# so the local player is never counted as their own reviver).
#
# The live-peer / sample-player short-circuit (returns false when no
# peer is connected) stays in the forwarder - the pure module assumes
# the caller already gated on that.
static func has_same_instance_reviver_available(
    peer_states: Dictionary,
    instance_key: String,
    ignore_peer_id: int = -1,
) -> bool:
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == ignore_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if bool(state.get("downed", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != instance_key:
            continue
        return true
    return false


# has_same_instance_downed_partner: pure form of
# `_has_same_instance_downed_partner` (coop_manager.gd L5897-5913).
#
# Returns true when at least one ACTIVE, DOWNED peer in `peer_states`
# shares `instance_key` with the caller. The dual of
# `has_same_instance_reviver_available` - same iteration shape, opposite
# `downed` polarity.
static func has_same_instance_downed_partner(
    peer_states: Dictionary,
    instance_key: String,
    ignore_peer_id: int = -1,
) -> bool:
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == ignore_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != instance_key:
            continue
        if bool(state.get("downed", false)):
            return true
    return false


# all_same_instance_partners_downed: pure form of
# `_all_same_instance_partners_downed` (coop_manager.gd L5916-5934).
#
# Returns true when:
#   1. At least one ACTIVE same-instance partner exists, AND
#   2. EVERY such partner is downed.
#
# The "at least one" guard mirrors the live `found_partner` flag - the
# function returns false when there is no partner to be downed (a solo
# downed player cannot trigger double-down recovery).
#
# Returns false on first non-downed partner encountered (early-exit
# preserves the live `return false` at L5933).
static func all_same_instance_partners_downed(
    peer_states: Dictionary,
    instance_key: String,
    ignore_peer_id: int = -1,
) -> bool:
    var found_partner: bool = false
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == ignore_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != instance_key:
            continue
        found_partner = true
        if not bool(state.get("downed", false)):
            return false
    return found_partner


# --- Manual respawn gating ---

# can_offer_manual_partner_respawn: pure AND-gate from
# `_can_offer_manual_partner_respawn` (coop_manager.gd L5972-5977).
#
# The forwarder resolves the three engine inputs:
#   - `local_downed`           - the live `local_downed` member var.
#   - `has_reviver`            - result of
#     `has_same_instance_reviver_available(...)` with the local peer
#     excluded.
#   - `has_remote_anchor`      - result of
#     `select_remote_respawn_anchor(..., prefer_host_peer=false, ...).found`.
#
# The pure body is a one-line AND chain - extracted purely so that any
# future tightening of the gate (e.g. an extra "not already requesting
# revive" guard) lands in a single tested place.
static func can_offer_manual_partner_respawn(
    local_downed: bool,
    has_reviver: bool,
    has_remote_anchor: bool,
) -> bool:
    return local_downed and has_reviver and has_remote_anchor


# --- Revive target selection ---

# find_revivable_peer: pure form of `_get_revivable_peer_state`
# (coop_manager.gd L6149-6178).
#
# Iterates `peer_states.keys()` in dict order (preserves live for-loop
# ordering; no sort applied) and returns the NEAREST active+downed peer
# in `instance_key` whose distance from `local_position` is within
# `revive_radius`. Distance comparison is `<=` (the live `>` continue
# leaves `==` as a match).
#
# Returns:
#   - `{}` when no candidate fits (no live partner, all up, all out of
#     range, or all in a different instance).
#   - the matched peer-state Dictionary (deep-copied via `state.duplicate(true)`)
#     with an extra `peer_id: int` field on hit. The deep-copy preserves
#     the live behaviour at L6173 so the forwarder can mutate the result
#     without poisoning the live `peer_states` snapshot.
static func find_revivable_peer(
    peer_states: Dictionary,
    local_position: Vector3,
    own_peer_id: int,
    revive_radius: float,
    instance_key: String,
) -> Dictionary:
    var nearest_state: Dictionary = {}
    var nearest_peer_id: int = -1
    var nearest_distance_squared: float = revive_radius * revive_radius

    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == own_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if not bool(state.get("downed", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != instance_key:
            continue

        var peer_position: Vector3 = state.get("position", local_position)
        var distance_squared: float = local_position.distance_squared_to(peer_position)
        if distance_squared > nearest_distance_squared:
            continue
        nearest_distance_squared = distance_squared
        nearest_state = state.duplicate(true)
        nearest_peer_id = int_peer_id

    if nearest_peer_id == -1:
        return {}
    nearest_state["peer_id"] = nearest_peer_id
    return nearest_state


# --- Revive request validation ---

# validate_revive_request: pure form of the validation branches inside
# `_host_attempt_revive` (coop_manager.gd L6240-6275).
#
# Inputs:
#   - `sender_state`, `target_state`: dicts the forwarder fetches via
#     `_get_peer_state_for_revive(peer_id)` (host uses
#     `_capture_local_state()` for peer 1, otherwise `peer_states[id]`).
#   - `target_peer_id`: target's high-level multiplayer id; the host
#     branches on `== 1` for the host-locally-revives-themself case.
#   - `sender_position`, `target_position`: the positions the forwarder
#     resolves via `_get_peer_revive_position(...)` - host-as-target
#     uses the frozen `local_downed_position` when valid; otherwise
#     `state.position`.
#   - `revive_radius`: caller-supplied (forwarder uses `REVIVE_RADIUS`).
#
# Output:
#   - `{ok: true, reviver_name: String, target_name: String}` on
#     accept. The forwarder uses `reviver_name` to fill the
#     `force_peer_revive.rpc_id(target, position, reviver_name)`
#     payload, and `target_name` to format the success feedback.
#   - `{ok: false, feedback: String}` on reject. The forwarder passes
#     `feedback` to `_send_revive_feedback(sender_id, feedback)`.
#
# Validation order matches the live code (target_peer_id sanity ->
# state empty -> instance match -> sender not downed -> target downed
# -> within range). Reordering would change which feedback message a
# borderline failure produces.
static func validate_revive_request(
    sender_state: Dictionary,
    target_state: Dictionary,
    target_peer_id: int,
    sender_position: Vector3,
    target_position: Vector3,
    revive_radius: float,
) -> Dictionary:
    if target_peer_id <= 0:
        return {"ok": false, "feedback": FEEDBACK_GENERIC_FAILURE}
    if sender_state.is_empty() or target_state.is_empty():
        return {"ok": false, "feedback": FEEDBACK_GENERIC_FAILURE}

    var sender_instance_key: String = str(sender_state.get("dimension_instance_key", ""))
    if sender_instance_key == "" or sender_instance_key != str(target_state.get("dimension_instance_key", "")):
        return {"ok": false, "feedback": FEEDBACK_NOT_SAME_AREA}

    if bool(sender_state.get("downed", false)):
        return {"ok": false, "feedback": FEEDBACK_SENDER_DOWNED}
    if not bool(target_state.get("downed", false)):
        return {"ok": false, "feedback": FEEDBACK_TARGET_NOT_DOWNED}

    if sender_position.distance_squared_to(target_position) > revive_radius * revive_radius:
        return {"ok": false, "feedback": FEEDBACK_OUT_OF_RANGE}

    return {
        "ok": true,
        "reviver_name": str(sender_state.get("name", "Partner")),
        "target_name": str(target_state.get("name", "partner")),
    }


# --- Remote respawn anchor selection ---

# select_remote_respawn_anchor: combined pure form of
# `_has_remote_respawn_anchor` + `_get_remote_respawn_anchor`
# (coop_manager.gd L12665-12718).
#
# Returns `{found: bool, position: Vector3}`:
#   - On miss (no eligible peer in instance, or client-side guard
#     trips), `found = false` and `position = fallback_position`.
#   - On hit with `prefer_host_peer = true` AND a host peer (peer id 1)
#     is in `instance_key`, returns that host position immediately
#     (matches the live `return peer_position` short-circuit at L12710).
#   - Otherwise returns the NEAREST eligible peer's position by
#     squared-distance to `fallback_position` (preserves live `<`
#     comparison; ties go to the first-seen peer).
#
# Filter rules (preserve live L12674-12678):
#   - `is_server = true`: skip peer 1 (server is peer 1 - excluding it
#     prevents "self as remote anchor").
#   - `is_server = false`, `prefer_host_peer = true`: ONLY consider
#     peer 1 (host).
#   - `is_server = false`, `prefer_host_peer = false`: consider all peers.
#
# Early-out: client-side, when `prefer_host_peer = true` AND
# `remote_host_respawning = true`, the host is in the middle of a
# respawn and is not a valid anchor; returns the miss form
# immediately (matches L12668 / L12689).
static func select_remote_respawn_anchor(
    peer_states: Dictionary,
    instance_key: String,
    is_server: bool,
    prefer_host_peer: bool,
    remote_host_respawning: bool,
    fallback_position: Vector3,
) -> Dictionary:
    if not is_server and prefer_host_peer and remote_host_respawning:
        return {"found": false, "position": fallback_position}

    var nearest_position: Vector3 = fallback_position
    var nearest_distance_squared: float = INF
    var found: bool = false

    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if is_server:
            if int_peer_id == 1:
                continue
        elif prefer_host_peer and int_peer_id != 1:
            continue

        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != instance_key:
            continue

        var peer_position: Vector3 = state.get("position", fallback_position)
        if prefer_host_peer and int_peer_id == 1:
            return {"found": true, "position": peer_position}

        found = true
        var distance_squared: float = fallback_position.distance_squared_to(peer_position)
        if distance_squared >= nearest_distance_squared:
            continue
        nearest_distance_squared = distance_squared
        nearest_position = peer_position

    return {"found": found, "position": nearest_position}


# --- Pure scalar predicates / math ---

# compute_safe_downed_position: pure form of the void-check + centering
# branches from `_resolve_local_downed_position` (coop_manager.gd
# L5858-5874).
#
# Inputs:
#   - `current_position`: the live `Ref.player.global_position`.
#   - `fallback_position`: the engine-resolved fallback. The forwarder
#     builds this via `_resolve_default_respawn_fallback_position(...)`
#     and, if `_has_live_peer()`, refines it through
#     `_find_safe_respawn_position_near(_get_remote_respawn_anchor(...))`.
#   - `void_y`: caller-supplied (forwarder uses `DOWNED_VOID_Y`).
#   - `is_safe_position`: Callable `(Vector3) -> bool` - the live
#     `_is_safe_respawn_position` predicate that reads `Ref.world`
#     state. Invalid callable is treated as "always safe" (matches the
#     `is_instance_valid(Ref.world)` early-return at L12638).
#   - `find_safe_near`: Callable `(Vector3, Vector3) -> Vector3` - the
#     live `_find_safe_respawn_position_near(anchor, fallback)`. Invalid
#     callable falls back to `fallback_position`.
#   - `center_offset`: defaults to `RESPAWN_BLOCK_CENTER_OFFSET`. Lets
#     tests pin the offset.
#
# Decision tree:
#   1. Below `void_y`: return `fallback_position` (the player has fallen
#      out of the world and the centered position would be useless).
#   2. Centered current position passes `is_safe_position`: return it.
#   3. Otherwise refine to `find_safe_near(centered_current, fallback_position)`.
#
# Note: pure callers can pass `Callable()` for both callables to test
# the "no engine" path - the function then returns either
# `fallback_position` (below void / unsafe + no find_safe_near) or the
# centered position (no is_safe_position -> treated as safe).
static func compute_safe_downed_position(
    current_position: Vector3,
    fallback_position: Vector3,
    void_y: float,
    is_safe_position: Callable,
    find_safe_near: Callable,
    center_offset: Vector3 = RESPAWN_BLOCK_CENTER_OFFSET,
) -> Vector3:
    if current_position.y <= void_y:
        return fallback_position

    var centered_current: Vector3 = current_position.floor() + center_offset
    var safe: bool = true
    if is_safe_position.is_valid():
        safe = bool(is_safe_position.call(centered_current))
    if safe:
        return centered_current

    if find_safe_near.is_valid():
        return find_safe_near.call(centered_current, fallback_position)
    return fallback_position


# is_in_downed_grace: pure form of the grace-window check inside
# `_tick_local_downed_state` (coop_manager.gd L6104).
#
# Returns true when the local player has been downed for less than
# `grace_sec` seconds. The grace window exists so the "no reviver
# available" branch does not fire instantly at the moment of going
# downed - the local UI gets a chance to settle, partners get a chance
# to be marked active, etc.
#
# `downed_started_msec` is the live `local_downed_started_msec`
# (`Time.get_ticks_msec()` snapshot at downed entry). A non-positive
# value (zero or negative) is treated as "not currently downed" -> the
# grace window is inactive.
static func is_in_downed_grace(downed_started_msec: int, now_msec: int, grace_sec: float) -> bool:
    if downed_started_msec <= 0:
        return false
    return (now_msec - downed_started_msec) < int(grace_sec * 1000.0)


# is_fake_dead_or_respawning: pure form of `is_local_player_fake_dead`
# (coop_manager.gd L12500-12501).
#
# Boolean union over the four legacy fake-death / host-respawn flags.
# Preserves the live OR-chain (order does not matter for `or`, but
# keeping the same order makes a regression on any one of them easy
# to spot in tests).
#
# Note: Phase 21 of the decomposition plan audits these flags. As of
# Phase 11 the live behaviour is preserved verbatim; the cleanup
# happens later so this phase stays purely mechanical.
static func is_fake_dead_or_respawning(
    local_fake_death_pending: bool,
    handling_host_respawn: bool,
    handling_client_respawn: bool,
    host_respawning: bool,
) -> bool:
    return local_fake_death_pending or handling_host_respawn or handling_client_respawn or host_respawning
