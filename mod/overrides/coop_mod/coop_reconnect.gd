class_name CoopReconnect
extends RefCounted

# CoopReconnect - phase 16d extraction from coop_manager.gd.
#
# Pure helpers for the client-side reconnect loop. The runtime path
# (creating the multiplayer peer, mutating `Ref.player.disabled`,
# toggling the reconnect overlay, calling `disconnect_session` and
# `_steam_call_alias`) is engine-bound and stays on
# `coop_manager.gd` as a forwarder.
#
# What lives here:
#   - `tick_reconnect_timer` - the pure timer-decrement + "should
#     attempt now?" decision from `_tick_reconnect`
#     (coop_manager.gd L15047-15061). Decrements the retry timer
#     by delta (clamped at 0.0) and reports whether the timer hit
#     zero this tick. The forwarder still owns the live-peer /
#     receiving-host-world early returns and the side effects
#     (UI subtitle update, `_attempt_reconnect()` call).
#   - `format_reconnect_subtitle` / `format_attempting_now_subtitle`
#     - the two subtitle text shapes the overlay shows. Pure
#     string-format; matches the live behavior including the
#     `attempt_count + 1` display offset (the running attempt is
#     1-indexed in the UI even though the counter is 0-indexed
#     until the attempt fires).
#   - `compute_next_attempt_kind` - the pure form of the
#     Steam-vs-LAN branch in `_attempt_reconnect`
#     (coop_manager.gd L15064-15137). Returns one of:
#       "steam_create_client"   (Steam host id known + peer
#                                 supports `create_client`);
#       "steam_connect_to_lobby" (Steam lobby id known + peer
#                                 supports `connect_to_lobby`);
#       "steam_join_lobby"      (Steam lobby id known but the
#                                 peer needs the legacy
#                                 `joinLobby` callback path);
#       "lan"                   (no Steam IDs).
#     The forwarder threads in the actual capability bits via the
#     `can_create_client` / `can_connect_to_lobby` arguments
#     (those come from `MultiplayerPeer.has_method` on the
#     instance, which is engine-bound).
#   - `resolve_lan_reconnect_target` - the pure form of the
#     `config["address"]` / `config["port"]` resolution at
#     L15122-15123. Strips whitespace, falls back to `127.0.0.1`
#     when the address is empty, and clamps the port to
#     `[1, 65535]` (matches how `_parse_address_port` clamps).
#
# This module knows NOTHING about:
#   - `multiplayer.*` / `ENetMultiplayerPeer` / `SteamMultiplayerPeer`.
#   - `Ref.*` / `class_name Player`.
#   - `config["address"]` / `config["port"]` - threaded in via the
#     forwarder.
#   - `AUTO_RECONNECT_INTERVAL` / `DEFAULT_PORT` - threaded in.


# --- Timer tick ---

# tick_reconnect_timer: pure form of the timer-decrement +
# "should attempt now?" decision in `_tick_reconnect`
# (coop_manager.gd L15047-15061).
#
# Returns:
#   {
#     "timer": float,           # new retry timer, clamped at 0.0
#     "should_attempt": bool,   # true iff the timer hit zero this tick
#   }
#
# The forwarder still owns:
#   - the multiplayer / receiving_host_world early returns;
#   - the subtitle update (`format_reconnect_subtitle`);
#   - calling `_attempt_reconnect()` when `should_attempt == true`.
static func tick_reconnect_timer(delta: float, current_timer: float) -> Dictionary:
    var next_timer: float = maxf(0.0, current_timer - delta)
    return {
        "timer": next_timer,
        "should_attempt": next_timer <= 0.0,
    }


# --- Subtitle text ---

# format_reconnect_subtitle: pure form of the "retrying in Xs" text
# (coop_manager.gd L15053-15057).
#
# The attempt is displayed 1-indexed (`attempt_count + 1`) - the
# counter increments inside `_attempt_reconnect` *after* the
# subtitle is rendered, so the visible "attempt N" matches the
# attempt about to fire next.
static func format_reconnect_subtitle(reason: String, retry_timer: float, attempt_count: int) -> String:
    return "%s\nRetrying in %.1fs (attempt %d)" % [reason, retry_timer, attempt_count + 1]


# format_attempting_now_subtitle: pure form of the "attempting
# reconnect now..." text (coop_manager.gd L15081). Used the moment
# the retry timer hits zero and we hand off to `_attempt_reconnect`.
static func format_attempting_now_subtitle(reason: String) -> String:
    return "%s\nAttempting reconnect now..." % reason


# --- Attempt kind decision ---

# compute_next_attempt_kind: pure form of the Steam-vs-LAN branch
# in `_attempt_reconnect` (coop_manager.gd L15083-15137).
#
# Inputs:
#   steam_host_id           - last known Steam host id; > 0 means
#                             "use Steam host route".
#   steam_lobby_id          - last known Steam lobby id; > 0 means
#                             "use Steam lobby route".
#   can_create_client       - does the Steam peer instance expose
#                             `create_client(host_id, channel)`?
#                             (engine-bound `MultiplayerPeer.has_method`
#                             check; threaded in by the forwarder).
#   can_connect_to_lobby    - does the Steam peer instance expose
#                             `connect_to_lobby(lobby_id)`? (same
#                             engine-bound check).
#
# Returns one of:
#   "steam_create_client"     - peer can create directly to host id.
#   "steam_connect_to_lobby"  - peer can connect to lobby id.
#   "steam_join_lobby"        - legacy joinLobby alias path
#                               (lobby id known, no direct method).
#   "lan"                     - no Steam IDs at all; use LAN target.
#
# Order matches `_attempt_reconnect`:
#   1. `steam_host_id > 0 and peer.has_method("create_client")`
#   2. `else if steam_lobby_id > 0 and peer.has_method("connect_to_lobby")`
#   3. `else if steam_lobby_id > 0` -> joinLobby alias
#   4. fall through to LAN.
# Live note: when `steam_host_id > 0` but the peer does NOT support
# `create_client`, the engine code falls through to the lobby-based
# branches; we mirror that here (steam_host_id with lobby_id falls
# back to the lobby branches, host-only with no `create_client`
# falls through to "lan").
static func compute_next_attempt_kind(
    steam_host_id: int,
    steam_lobby_id: int,
    can_create_client: bool,
    can_connect_to_lobby: bool,
) -> String:
    if steam_host_id > 0 and can_create_client:
        return "steam_create_client"
    if steam_lobby_id > 0 and can_connect_to_lobby:
        return "steam_connect_to_lobby"
    if steam_lobby_id > 0:
        return "steam_join_lobby"
    return "lan"


# --- LAN target resolution ---

# resolve_lan_reconnect_target: pure form of the LAN target
# extraction at coop_manager.gd L15122-15123.
#
# Strips whitespace from the address, falls back to `127.0.0.1`
# when empty, and clamps the port to `[1, 65535]` (the ENet hard
# limit). The forwarder threads in the live `config["address"]` /
# `config["port"]` values and the `DEFAULT_PORT` constant.
static func resolve_lan_reconnect_target(
    raw_address: Variant,
    raw_port: Variant,
    default_port: int,
) -> Dictionary:
    var address: String = str(raw_address).strip_edges()
    if address == "":
        address = "127.0.0.1"
    var port: int = default_port
    if raw_port != null:
        port = int(raw_port)
    return {
        "address": address,
        "port": clampi(port, 1, 65535),
    }
