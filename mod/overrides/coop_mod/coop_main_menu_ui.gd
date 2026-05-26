class_name CoopMainMenuUI
extends RefCounted

# CoopMainMenuUI - phase 15c extraction from coop_manager.gd.
#
# Pure helpers for the main-menu coop panel - the rest of the
# main-menu code is engine-bound (Control / Button instancing,
# theming, button-group reparenting, NodePath lookups) and stays
# on `coop_manager.gd` as forwarders.
#
# Captures the two pure-decision spots that read JSON-shaped
# state and return display text:
#   - `summarize_server_browser_status` walks
#     `server_browser_entries` (the live registry array) and
#     returns the `{online, checking}` count so the main-menu
#     server detail label can pick the right hint without
#     re-running the loop on each frame.
#   - `format_main_menu_server_detail_text` picks one of the
#     three documented hint strings based on those counts (no
#     entries -> "No public ... registered", any online ->
#     "Click a QUALIA card ...", any checking -> "Checking ...",
#     else -> "No public ... reachable right now").
#   - `format_main_menu_player_detail_text` is the pure form of
#     the `_refresh_main_menu_player_actions` text ladder:
#     `no_live_peer` -> "No active multiplayer session.";
#     `peer_id <= 0` (no selection) -> "Select a player to inspect
#     them."; otherwise the detail lines (pre-built by
#     `CoopPauseMenuUI.build_player_detail_lines` and threaded in
#     by the forwarder) joined by `\n`.
#
# Engine-bound bodies stay on coop_manager.gd as thin forwarders:
#   - `_get_selected_main_menu_peer_id` reads the `ItemList`
#     selection metadata; it cannot move out without dragging the
#     Control node with it.
#   - `_refresh_main_menu_player_list` / `_refresh_main_menu_player_actions`
#     orchestrate the ItemList repopulate + label assignment;
#     they use the pure helpers under the hood (the player-list
#     label / signature / detail-lines all live in
#     `CoopPauseMenuUI`).
#   - `_refresh_main_menu_coop_status` is a single-line
#     `main_menu_coop_status_label.text = status_message` forwarder;
#     no pure logic to extract.


# --- Server browser status summary ---

# summarize_server_browser_status: pure form of the
# online/checking loop inside `_refresh_main_menu_server_detail`
# (coop_manager.gd L4019-4025).
#
# Returns:
#   {
#     "online": int,
#     "checking": int,   # counts both "checking" and "unknown"
#   }
# - matches the live `status == "checking" or status == "unknown"`
# branch so a never-probed entry still counts as "checking".
static func summarize_server_browser_status(entries: Array) -> Dictionary:
    var online_count: int = 0
    var checking_count: int = 0
    for entry in entries:
        if not (entry is Dictionary):
            continue
        var status: String = str(entry.get("status", "unknown"))
        if status == "online":
            online_count += 1
        elif status == "checking" or status == "unknown":
            checking_count += 1
    return {"online": online_count, "checking": checking_count}


# format_main_menu_server_detail_text: pure form of the text
# ladder inside `_refresh_main_menu_server_detail` (coop_manager.gd
# L4011-4032).
#
# Decision tree:
#   - entries.is_empty()              -> "No public QUALIA servers
#                                        registered."
#   - online > 0                      -> "Click a QUALIA card to
#                                        enter that server world."
#   - checking > 0                    -> "Checking public QUALIA
#                                        servers..."
#   - else                            -> "No public QUALIA servers
#                                        are reachable right now."
static func format_main_menu_server_detail_text(entries: Array) -> String:
    if entries.is_empty():
        return "No public QUALIA servers registered."
    var counts: Dictionary = summarize_server_browser_status(entries)
    if int(counts.get("online", 0)) > 0:
        return "Click a QUALIA card to enter that server world."
    if int(counts.get("checking", 0)) > 0:
        return "Checking public QUALIA servers..."
    return "No public QUALIA servers are reachable right now."


# --- Player detail panel text ---

# format_main_menu_player_detail_text: pure form of the text
# ladder inside `_refresh_main_menu_player_actions` (coop_manager.gd
# L3105-3118).
#
# Decision tree:
#   - not has_live_peer                          -> "No active
#                                                  multiplayer
#                                                  session."
#   - peer_id <= 0 (nothing selected)            -> "Select a
#                                                  player to inspect
#                                                  them."
#   - otherwise                                  -> detail_lines
#                                                  joined by "\n"
#                                                  (the forwarder
#                                                  builds the
#                                                  PackedStringArray
#                                                  via
#                                                  `CoopPauseMenuUI.build_player_detail_lines`).
static func format_main_menu_player_detail_text(
    has_live_peer: bool,
    selected_peer_id: int,
    detail_lines: PackedStringArray,
) -> String:
    if not has_live_peer:
        return "No active multiplayer session."
    if selected_peer_id <= 0:
        return "Select a player to inspect them."
    return "\n".join(detail_lines)
