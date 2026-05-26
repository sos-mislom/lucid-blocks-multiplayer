class_name CoopHud
extends RefCounted

# CoopHud - phase 23 extraction from coop_manager.gd.
#
# Pure decision helpers for in-game HUD / panel toggling and the
# read-only label/overlay formatters. Engine-bound Control writes
# (`panel.visible = ...`, `local_ip_label.text = ...`, etc.) and
# Ref.* / multiplayer.* accesses stay on `coop_manager.gd` as
# thin forwarders.
#
# What lives here:
#   - `compute_next_panel_visible` (the
#     `not panel_visible if force_visible == null else bool(force_visible)`
#     decision shared by `toggle_panel`);
#   - `should_skip_panel_toggle` (the
#     `if next_visible == panel_visible: return` early-out used
#     by `toggle_panel` to avoid redundant focus / capture
#     thrash);
#   - `should_close_pause_coop_panel_for_sync` (the predicate
#     used by `_sync_pause_menu_coop_panel_visibility` to decide
#     whether the pause-menu coop panel should close itself when
#     its owner / parent game-menu state diverges from the
#     "pause" state);
#   - `should_close_main_coop_panel_for_sync` (the predicate
#     used by `_sync_main_menu_coop_panel_visibility` to decide
#     whether the main-menu coop panel should close itself when
#     its owner is destroyed or hidden);
#   - `score_ipv4` (the RFC1918 / CGNAT category scoring used by
#     `_get_best_local_ipv4` to pick the most-likely "LAN" IPv4
#     address out of the OS's list);
#   - `format_steam_status_text` (the `"ready" | "unavailable" |
#     "lobby <id>"` label fragment used by
#     `_refresh_local_ip_label` and the pause-menu status
#     formatter);
#   - `format_local_ip_label_text` (the `"LAN: <ip>\nSteam:
#     <status>"` line written into the HUD's `local_ip_label`);
#   - `build_player_list_overlay_lines` (the `"Players"` header +
#     `"No players"` empty-marker pattern used by
#     `_refresh_player_list_overlay`);
#   - `compute_player_list_overlay_min_size` (the
#     `Vector2(180.0, 18.0 + line_count * 10.0)` size used by
#     `_refresh_player_list_overlay`).
#
# This module knows NOTHING about:
#   - Control / Panel / Label / ItemList / Button nodes.
#   - `Ref.*` / `multiplayer.*` / `MouseHandler.*` /
#     `get_viewport()` / `IP.get_local_addresses()`.
#   - `panel_visible` / `panel_open` Boolean state.
#   - `Ref.game_menu.state` int value 4 (the "pause" state) -
#     threaded in via the forwarder as `coop_pause_state_value`.


# compute_next_panel_visible: pure form of the
# `not panel_visible if force_visible == null else bool(force_visible)`
# pattern at the top of `toggle_panel` (coop_manager.gd L5232).
#
# `null` flips the current visibility (the "no argument" path),
# any non-null value runs through `bool()` so callers can pass
# `true` / `false` / `0` / `1` / etc.
static func compute_next_panel_visible(force_visible: Variant, current_visible: bool) -> bool:
    if force_visible == null:
        return not current_visible
    return bool(force_visible)


# should_skip_panel_toggle: pure form of the
# `if next_visible == panel_visible: return` early-out at L5233
# of `toggle_panel`.
#
# Skipping the toggle preserves the live behavior where calling
# `toggle_panel(true)` on an already-visible panel does NOT
# re-grab focus / re-capture the mouse / re-fire
# `_refresh_overlay_layout` - which matters because those side
# effects can race with input handlers that triggered the call.
static func should_skip_panel_toggle(next_visible: bool, current_visible: bool) -> bool:
    return next_visible == current_visible


# should_close_pause_coop_panel_for_sync: pure form of the
# decision in `_sync_pause_menu_coop_panel_visibility`
# (coop_manager.gd L2849-2856).
#
# Returns true when the coop pause-menu panel is currently open
# AND something has changed that should close it:
#   - the pause-menu owner has been freed or hidden, OR
#   - the parent game menu is no longer in the "pause" state
#     (`coop_pause_state_value` is threaded in to keep the
#     state-int constant on `coop_manager.gd`; the live code
#     hardcodes `int(Ref.game_menu.state) != 4`).
#
# When the panel is already closed (`panel_open == false`),
# returns false - the sync function early-exits and nothing
# needs doing.
static func should_close_pause_coop_panel_for_sync(
    panel_open: bool,
    pause_owner_present: bool,
    pause_owner_visible: bool,
    game_menu_present: bool,
    game_menu_state: int,
    coop_pause_state_value: int,
) -> bool:
    if not panel_open:
        return false
    if not pause_owner_present:
        return true
    if not pause_owner_visible:
        return true
    if game_menu_present and game_menu_state != coop_pause_state_value:
        return true
    return false


# should_close_main_coop_panel_for_sync: pure form of the
# decision in `_sync_main_menu_coop_panel_visibility`
# (coop_manager.gd L4070-4073).
#
# Returns true when the coop main-menu panel is open AND its
# owner is gone or hidden. Unlike the pause variant there's no
# state-int check because the main menu doesn't surface a
# multi-state pause/inventory/coop selector - the panel is
# either there or not.
static func should_close_main_coop_panel_for_sync(
    panel_open: bool,
    main_owner_present: bool,
    main_owner_visible: bool,
) -> bool:
    if not panel_open:
        return false
    if not main_owner_present:
        return true
    if not main_owner_visible:
        return true
    return false


# score_ipv4: pure form of `_score_ipv4` (coop_manager.gd
# L14314-L14328). Lower is "more likely the right LAN IP" so
# `_get_best_local_ipv4` can `argmin` across the OS-provided
# list.
#
# The buckets match real-world RFC1918 / CGNAT / Docker
# heuristics:
#   0 - 192.168/16 (the canonical home-LAN block);
#   1 - 10/8 (large RFC1918, common in office / VPN);
#   2 - 172.16/12 .. 172.31/12 except 172.17 / 172.18
#       (which are 4 because Docker famously uses 172.17.0.0/16
#       and Compose 172.18.0.0/16 for bridge networks);
#   3 - 100.64/10 (CGNAT - carrier shared);
#   4 - 172.17 / 172.18 (Docker bridges, penalized so they
#       don't beat a real LAN address);
#   5 - everything else.
#
# Inputs from `IP.get_local_addresses()` are pre-filtered to
# strip IPv6 and 127.* so we don't need to repeat that here.
static func score_ipv4(address: String) -> int:
    if address.begins_with("192.168."):
        return 0
    if address.begins_with("10."):
        return 1
    if address.begins_with("172."):
        var second_octet_text: String = address.get_slice(".", 1)
        var second_octet: int = int(second_octet_text)
        if second_octet >= 16 and second_octet <= 31:
            if second_octet == 17 or second_octet == 18:
                return 4
            return 2
    if address.begins_with("100."):
        return 3
    return 5


# format_steam_status_text: pure form of the
# `"ready" | "unavailable" | "lobby <id>"` fragment used by
# `_refresh_local_ip_label` (coop_manager.gd L14290-L14292) and
# the pause-menu status formatter (L2836-L2838).
#
# `lobby_id > 0` overrides everything - we're actively in a
# Steam lobby, surface the id even when Steamworks itself
# reports "unavailable" (some Steamworks builds return false
# after a temporary hiccup).
static func format_steam_status_text(steam_ready: bool, steam_lobby_id: int) -> String:
    if steam_lobby_id > 0:
        return "lobby %s" % steam_lobby_id
    return "ready" if steam_ready else "unavailable"


# format_local_ip_label_text: pure form of the HUD label fed
# into `local_ip_label.text` (coop_manager.gd L14293).
#
# Two-line format matters - the HUD reserves vertical space
# for both lines, so we always emit the newline.
static func format_local_ip_label_text(best_lan_ip: String, steam_status_text: String) -> String:
    return "LAN: %s\nSteam: %s" % [best_lan_ip, steam_status_text]


# build_player_list_overlay_lines: pure form of the list-of-
# lines built by `_refresh_player_list_overlay` (coop_manager.gd
# L2922-L2929).
#
# Pattern is:
#   - always a "Players" header on top;
#   - one line per formatted entry label;
#   - if `formatted_labels` is empty, append a single "No
#     players" marker so the overlay isn't visually empty.
#
# `formatted_labels` is expected to already have non-Dictionary
# entries filtered out by the caller (live code does the
# `if not (entry is Dictionary): continue` skip inline).
static func build_player_list_overlay_lines(formatted_labels: Array) -> PackedStringArray:
    var lines: PackedStringArray = PackedStringArray()
    lines.append("Players")
    for label in formatted_labels:
        lines.append(str(label))
    if formatted_labels.is_empty():
        lines.append("No players")
    return lines


# compute_player_list_overlay_min_size: pure form of the
# `Vector2(180.0, 18.0 + line_count * 10.0)` sizing used by
# `_refresh_player_list_overlay` (coop_manager.gd L2931).
#
# Width is fixed; height grows with line count to keep the
# overlay from clipping its content. The 18.0 / 10.0 magic
# numbers come from the live default font metrics.
static func compute_player_list_overlay_min_size(line_count: int) -> Vector2:
    return Vector2(180.0, 18.0 + float(line_count) * 10.0)
