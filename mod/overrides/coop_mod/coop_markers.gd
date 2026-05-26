class_name CoopMarkers
extends RefCounted

# CoopMarkers - phase 24 extraction from coop_manager.gd.
#
# Pure decision helpers for the `_refresh_markers` pipeline -
# the per-frame visitor that walks `peer_states` and decides:
#   1. which peers contribute a visible 3D RemotePlayerMarker
#      ("nameplate") above the player's head;
#   2. which peers also contribute a heavier RemotePlayerProxy
#      (full skeletal mesh + ragdoll capsule);
#   3. which existing markers / proxies should be removed
#      because their peer left, became dedicated, or shifted to
#      another dimension instance.
#
# Engine-bound work (instantiating `RemotePlayerMarkerScript`,
# `add_child(...)`, `call_deferred("queue_free")`, reading
# `Ref.world.current_dimension`, walking
# `remote_break_outlines`, etc.) stays on `coop_manager.gd` as
# forwarders.
#
# What lives here:
#   - `is_peer_excluded_from_markers` (the
#     `int_peer_id == local_peer_id` + dedicated-peer skip from
#     L13348-L13355);
#   - `compute_marker_display_name` (the `"<name> [DOWN]"`
#     vs `<name>` formatting at L13362-L13363);
#   - `resolve_marker_display_name_input` (the
#     `str(state.get("name", "Peer <id>"))` default that lives
#     inline at L13362 - lets the test verify both the lookup
#     and the `"Peer %s" % peer_id` fallback in one place);
#   - `compute_marker_crouching` (`crouching OR downed` from
#     L13371);
#   - `compute_marker_active_visible` (`state.active AND
#     same_dimension` from L13367 / L13378);
#   - `compute_stale_marker_ids` (the
#     `markers.keys().duplicate()` walk at L13385-L13388 - any
#     marker not in the `visible_ids` set is stale);
#   - `compute_stale_remote_proxy_ids` (the analogous walk for
#     `remote_player_proxies` at L13391-L13393).
#
# This module knows NOTHING about:
#   - `RemotePlayerMarker` / `RemotePlayerProxy` /
#     `RemotePlayerMarkerScript` Node types.
#   - `Ref.*` / `multiplayer.*` / `Ref.world.current_dimension`
#     / `get_active_dimension_instance_key()`.
#   - `markers` / `remote_player_proxies` /
#     `remote_break_outlines` Dictionary state.
#   - `DEFAULT_AVATAR_ID` / `Color.WHITE` / `Vector3.ZERO`
#     defaults that the caller pulls out of state - the
#     forwarder feeds the unpacked dict directly to the
#     `RemotePlayerMarker.apply_state(...)` API since those
#     defaults are part of the engine-bound contract.


# is_peer_excluded_from_markers: pure form of the
# `int_peer_id == local_peer_id` + dedicated-peer skip from
# `_refresh_markers` (coop_manager.gd L13348-L13355).
#
# Returns true when the peer should NOT be rendered as a
# marker AND its existing marker / proxy must be torn down:
#   - the local player draws their own avatar, so they never
#     get a marker;
#   - dedicated peers are headless servers, never visible to
#     other players.
#
# The "dedicated peer" check stays on `coop_manager.gd`
# (CoopPauseMenuUI.is_dedicated_peer_state needs the
# peer_states dict + multiplayer.get_unique_id()), so this
# helper just consumes the resolved bool.
static func is_peer_excluded_from_markers(
    peer_id: int,
    local_peer_id: int,
    is_dedicated_peer: bool,
) -> bool:
    if peer_id == local_peer_id:
        return true
    if is_dedicated_peer:
        return true
    return false


# resolve_marker_display_name_input: pure form of the
# `str(state.get("name", "Peer %s" % int_peer_id))` lookup
# inlined at coop_manager.gd L13362. Returns the raw display
# name BEFORE the "[DOWN]" decoration is applied.
#
# `peer_id` is plugged into the fallback so peers with no
# advertised name still appear as "Peer <id>" instead of an
# empty label.
static func resolve_marker_display_name_input(
    state: Dictionary,
    peer_id: int,
) -> String:
    var raw_name: Variant = state.get("name", null)
    if raw_name == null:
        return "Peer %s" % peer_id
    return str(raw_name)


# compute_marker_display_name: pure form of the
# `"<name> [DOWN]" if downed else <name>` decoration at L13363
# of `_refresh_markers`.
#
# The "[DOWN]" suffix is what other players see when a peer is
# in the revive-grace state; the marker stays visible (with
# crouching pose, see `compute_marker_crouching`) so reviver
# candidates can find the body.
static func compute_marker_display_name(
    raw_display_name: String,
    downed: bool,
) -> String:
    if downed:
        return "%s [DOWN]" % raw_display_name
    return raw_display_name


# compute_marker_crouching: pure form of the
# `bool(state.crouching) or downed` expression at L13371.
#
# A downed player must visually crouch (the marker's
# `apply_state` interprets `crouching=true` as the prone /
# revive pose). The OR matches the live behavior where a
# crouching player who is then downed stays in the prone pose
# until they revive.
static func compute_marker_crouching(
    state_crouching: bool,
    downed: bool,
) -> bool:
    return state_crouching or downed


# compute_marker_active_visible: pure form of the
# `bool(state.active) and same_dimension` predicate at L13367
# and reused at L13378.
#
# A peer's marker (and proxy) is only "active-visible" when:
#   1. their session is actually live (`state.active == true`,
#      driven by the host's per-tick liveness tracking);
#   2. AND they're in the same dimension / pocket instance as
#      the local player (so cross-dimension peers don't render
#      ghost markers).
#
# Note: the marker NODE is still kept alive when this is false
# (so we don't churn `add_child` / `queue_free` every frame);
# only its visibility / proxy presence flips.
static func compute_marker_active_visible(
    state_active: bool,
    same_dimension: bool,
) -> bool:
    return state_active and same_dimension


# compute_stale_marker_ids: pure form of the cleanup loop at
# L13385-L13388 of `_refresh_markers`.
#
# Returns the subset of `current_marker_peer_ids` (typically
# `markers.keys()`) that are NOT in `visible_ids`. The caller
# uses this to call `markers[id].call_deferred("queue_free")`
# / `markers.erase(id)` / `_remove_remote_break_outline(id)`.
#
# Returning a fresh Array lets the caller iterate it safely
# while mutating the source `markers` dict - mirrors the live
# `.keys().duplicate()` pattern.
static func compute_stale_marker_ids(
    current_marker_peer_ids: Array,
    visible_ids: Dictionary,
) -> Array:
    var stale: Array = []
    for peer_id in current_marker_peer_ids:
        if not visible_ids.has(peer_id):
            stale.append(peer_id)
    return stale


# compute_stale_remote_proxy_ids: pure form of the cleanup
# loop at L13391-L13393.
#
# Same logic as `compute_stale_marker_ids` but for the
# `remote_player_proxies` dict. Kept as a separate helper so
# the call sites read clearly even though the implementation
# is currently identical - the two dicts are independent state
# and proxies can also be torn down for other reasons (e.g.
# `compute_marker_active_visible` flipping false while the
# marker stays).
static func compute_stale_remote_proxy_ids(
    current_proxy_peer_ids: Array,
    visible_ids: Dictionary,
) -> Array:
    return compute_stale_marker_ids(current_proxy_peer_ids, visible_ids)
