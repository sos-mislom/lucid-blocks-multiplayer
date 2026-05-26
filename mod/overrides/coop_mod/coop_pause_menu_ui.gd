class_name CoopPauseMenuUI
extends RefCounted

# CoopPauseMenuUI - phase 15b extraction from coop_manager.gd.
#
# Pure helpers for the pause-menu coop player list panel + the
# in-game player-list overlay (the small top-right HUD label):
#   - `format_session_player_label` returns the
#     "<display_name> [(You|Host|Connecting)] [Downed]" label
#     used by both the pause-menu ItemList and the HUD overlay.
#   - `is_dedicated_peer_state` is the predicate that hides
#     dedicated-server "headless host" entries from the player
#     list (peer_id 1 with `dedicated_server: true`).
#   - `compute_session_player_signature` builds the deterministic
#     "<peer_id>|<label>|<instance_key>|<active>" fingerprint per
#     entry, joined by `\n` so the pause-menu refresh tick can
#     short-circuit when nothing has changed.
#   - `build_player_detail_lines` returns the PackedStringArray of
#     lines for the per-peer detail box ("<name>", "Peer <id>  |
#     Same area|Different area", optional "This is you." / "Host
#     player." / "Connecting to world...", optional "Status:
#     Downed").
#   - `resolve_peer_display_name` resolves the four-fallback
#     display name (local-player override -> state.name -> "Peer
#     <id>").
#   - `should_show_kick_button` / `is_kick_button_disabled` /
#     `is_tp_button_disabled` are the three button-gate decisions
#     used by `_refresh_pause_menu_player_actions`.
#
# Engine-bound bodies stay on coop_manager.gd as thin forwarders:
#   - `_get_peer_display_name` resolves
#     `multiplayer.get_unique_id()` + `_get_local_player_name()`;
#     the pure form takes the resolved local-name override.
#   - `_get_session_player_entries` calls `_has_live_peer()`,
#     `_capture_local_state`, `multiplayer.get_unique_id()`,
#     iterates `peer_states`; the forwarder collects the entries
#     and passes them in.
#   - `_set_player_list_overlay_visible` /
#     `_refresh_player_list_overlay` /
#     `_refresh_pause_menu_player_list` /
#     `_refresh_pause_menu_player_actions` mutate
#     `Control` / `ItemList` / `Label` nodes; they stay engine-bound
#     and use the pure helpers under the hood.
#
# This module knows NOTHING about:
#   - `class_name SaveFile` / `class_name Player`.
#   - `multiplayer.*` / `Ref.*` / engine clocks.
#   - `pause_menu_coop_player_list` / `player_list_overlay` Control
#     nodes - the forwarder reads/writes them.
#   - `SESSION_TRANSPORT_STEAM` constant - threaded in via the
#     forwarder.


# --- Display name resolution ---

# resolve_peer_display_name: pure form of
# `_get_peer_display_name` (coop_manager.gd L2915-2922).
#
# Inputs (resolved at the forwarder boundary):
#   - `peer_id`              - the peer the label is for.
#   - `state`                - the peer's snapshot from
#                              `peer_states`; or the resolved
#                              local state when `is_local`.
#   - `local_peer_id`        - `multiplayer.get_unique_id()`.
#   - `local_player_name`    - `_get_local_player_name()` for the
#                              local-player branch.
#
# Returns the local player's display name when `peer_id ==
# local_peer_id`; otherwise the trimmed `state.name`, falling back
# to `"Peer <peer_id>"`.
static func resolve_peer_display_name(
    peer_id: int,
    state: Dictionary,
    local_peer_id: int,
    local_player_name: String,
) -> String:
    if peer_id == local_peer_id:
        return local_player_name
    var display_name: String = str(state.get("name", "")).strip_edges()
    if display_name != "":
        return display_name
    return "Peer %s" % peer_id


# --- Dedicated-server predicate ---

# is_dedicated_peer_state: pure form of `_is_dedicated_peer_state`
# (coop_manager.gd L2970-2972). A peer is the dedicated headless
# host iff its peer_id is 1 AND `state.dedicated_server` is true.
# The dedicated peer is hidden from the player list (it has no
# avatar in-world).
static func is_dedicated_peer_state(peer_id: int, state: Dictionary) -> bool:
    return peer_id == 1 and bool(state.get("dedicated_server", false))


# --- Player label / signature ---

# format_session_player_label: pure form of
# `_format_session_player_label` (coop_manager.gd L2956-2967).
#
# Produces the per-row label:
#   "<display_name>[ (You|Host|Connecting)][ [Downed]]"
#
# Decision tree:
#   - `entry.is_local`            -> append " (You)"
#   - else `peer_id == 1`         -> append " (Host)"
#   - else not `entry.active`     -> append " (Connecting)"
#   - if `entry.downed`           -> append " [Downed]"
#
# `local_peer_id` + `local_player_name` are threaded through
# `resolve_peer_display_name`.
static func format_session_player_label(
    entry: Dictionary,
    local_peer_id: int,
    local_player_name: String,
) -> String:
    var peer_id: int = int(entry.get("peer_id", -1))
    var label: String = resolve_peer_display_name(peer_id, entry, local_peer_id, local_player_name)
    if bool(entry.get("is_local", false)):
        label += " (You)"
    elif peer_id == 1:
        label += " (Host)"
    elif not bool(entry.get("active", false)):
        label += " (Connecting)"
    if bool(entry.get("downed", false)):
        label += " [Downed]"
    return label


# compute_session_player_signature: pure form of
# `_get_session_player_signature` (coop_manager.gd L2975-2986).
#
# Returns a deterministic "<peer_id>|<label>|<instance_key>|<active>"
# string per entry, joined by `\n`. The pause-menu refresh tick
# diff-compares the result against `pause_menu_coop_player_signature`
# so the ItemList only repopulates when something changed
# (selection-preserving).
static func compute_session_player_signature(
    entries: Array,
    local_peer_id: int,
    local_player_name: String,
) -> String:
    var parts: PackedStringArray = PackedStringArray()
    for entry in entries:
        if not (entry is Dictionary):
            continue
        parts.append("%s|%s|%s|%s" % [
            int(entry.get("peer_id", -1)),
            format_session_player_label(entry, local_peer_id, local_player_name),
            str(entry.get("dimension_instance_key", "")),
            bool(entry.get("active", false)),
        ])
    return "\n".join(parts)


# --- Detail lines ---

# build_player_detail_lines: pure form of
# `_build_player_detail_lines` (coop_manager.gd L3058-3073).
#
# Inputs (resolved at the forwarder boundary):
#   - `peer_id`               - the selected pause-menu peer.
#   - `state`                 - the peer's snapshot (or
#                               `_capture_local_state()` for local).
#   - `local_peer_id`         - `multiplayer.get_unique_id()`.
#   - `local_player_name`     - `_get_local_player_name()`.
#   - `active_instance_key`   - `get_active_dimension_instance_key()`.
#
# Returns:
#   ["<name>", "Peer <id>  |  Same area|Different area",
#    optional "This is you." / "Host player." / "Connecting to world...",
#    optional "Status: Downed"]
static func build_player_detail_lines(
    peer_id: int,
    state: Dictionary,
    local_peer_id: int,
    local_player_name: String,
    active_instance_key: String,
) -> PackedStringArray:
    var is_local: bool = peer_id == local_peer_id
    var same_dimension: bool = str(state.get("dimension_instance_key", "")) == active_instance_key
    var detail_lines: PackedStringArray = PackedStringArray([
        resolve_peer_display_name(peer_id, state, local_peer_id, local_player_name),
        "Peer %s  |  %s" % [peer_id, "Same area" if same_dimension else "Different area"],
    ])
    if is_local:
        detail_lines.append("This is you.")
    elif peer_id == 1:
        detail_lines.append("Host player.")
    elif not bool(state.get("active", false)):
        detail_lines.append("Connecting to world...")
    if bool(state.get("downed", false)):
        detail_lines.append("Status: Downed")
    return detail_lines


# --- Button-gate decisions ---

# should_show_kick_button: pure form of the visibility decision
# inside `_refresh_pause_menu_player_actions` (coop_manager.gd
# L3043 / L3054). The kick button only makes sense when the local
# peer is the server AND the active transport is Steam (LAN kicks
# go through ENet; the kick button only exposes the lobby-kick
# RPC).
static func should_show_kick_button(is_server: bool, transport_is_steam: bool) -> bool:
    return is_server and transport_is_steam


# is_kick_button_disabled: pure form of the
# `pause_menu_coop_kick_button.disabled = ...` branch (coop_manager.gd
# L3055).
#
# Kick is disabled when:
#   - the button itself is hidden (not visible), or
#   - the selected peer is local (no self-kick), or
#   - we have no `state` for the peer (state.is_empty).
static func is_kick_button_disabled(
    button_visible: bool,
    is_local_peer: bool,
    state_empty: bool,
) -> bool:
    if not button_visible:
        return true
    if is_local_peer:
        return true
    return state_empty


# is_tp_button_disabled: pure form of the
# `pause_menu_coop_tp_button.disabled = ...` branch (coop_manager.gd
# L3051). TP is disabled when:
#   - the selected peer is local (no self-TP), or
#   - we cannot sample our own player (dead/disabled/unloaded), or
#   - the state is empty, or
#   - the peer is not active.
static func is_tp_button_disabled(
    is_local_peer: bool,
    can_sample_player: bool,
    state_empty: bool,
    peer_active: bool,
) -> bool:
    if is_local_peer:
        return true
    if not can_sample_player:
        return true
    if state_empty:
        return true
    return not peer_active
