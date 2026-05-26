class_name CoopTransportSteam
extends RefCounted

# CoopTransportSteam - phase 16c extraction from coop_manager.gd.
#
# Pure helpers for Steam transport. The runtime path (lobby
# creation, `SteamMultiplayerPeer` wiring, rich-presence updates,
# Steam signal subscriptions) is engine-bound (Steamworks autoload
# + Object.call("setLobbyData", ...) + `multiplayer.multiplayer_peer
# = peer`) and stays on `coop_manager.gd` as a forwarder.
#
# What lives here:
#   - `extract_lobby_id_from_connect_string` (coop_manager.gd
#     L1654-1675) - the Steam launch / rich-presence / lobby invite
#     string parser. Handles three input shapes:
#       1. raw lobby-id integer string (e.g. `109775240000000000`);
#       2. anywhere-in-string `+connect_lobby <id>` token (Steam's
#          rich-presence "connect" payload format);
#       3. anywhere-in-string `steam_lobby=<id>` token (our own
#          launch-arg shape used by deep-link handlers).
#     Returns 0 when none of the three shapes parse a positive
#     integer - the call sites all guard with `<= 0`.
#
# This module knows NOTHING about:
#   - `Steamworks` autoload / `_steam_call_alias`.
#   - `Ref.*` / `multiplayer.*`.
#   - `STEAM_CONNECT_LOBBY_PREFIX` constant - threaded in via the
#     forwarder so the wire-shape constant stays on `coop_manager.gd`
#     as the single source of truth (Steam rich-presence regression
#     risk).


# --- Lobby id extraction ---

# extract_lobby_id_from_connect_string: pure form of
# `_extract_lobby_id_from_connect_string` (coop_manager.gd
# L1654-1675).
#
# Returns the first positive lobby id parsed from `raw_text`,
# scanning in this order:
#   1. whole stripped text as an integer;
#   2. text after the first `<connect_prefix>` (e.g.
#      `+connect_lobby `) up to the next space;
#   3. text after the first `steam_lobby=` up to the next space.
# Returns 0 if none of the three shapes yields a valid integer.
#
# The forwarder threads in `STEAM_CONNECT_LOBBY_PREFIX` so the
# wire-shape constant stays on `coop_manager.gd` (Steam regression
# risk - changing the prefix on either side breaks the launch
# flow).
static func extract_lobby_id_from_connect_string(
    raw_text: String,
    connect_prefix: String,
) -> int:
    var text: String = raw_text.strip_edges()
    if text == "":
        return 0
    if text.is_valid_int():
        return int(text)

    if connect_prefix != "":
        var connect_index: int = text.find(connect_prefix)
        if connect_index >= 0:
            var suffix: String = text.substr(connect_index + connect_prefix.length()).strip_edges()
            var lobby_text: String = suffix.get_slice(" ", 0)
            if lobby_text.is_valid_int():
                return int(lobby_text)

    var marker_index: int = text.find("steam_lobby=")
    if marker_index >= 0:
        var marker_suffix: String = text.substr(marker_index + len("steam_lobby=")).strip_edges()
        var marker_lobby_text: String = marker_suffix.get_slice(" ", 0)
        if marker_lobby_text.is_valid_int():
            return int(marker_lobby_text)

    return 0
