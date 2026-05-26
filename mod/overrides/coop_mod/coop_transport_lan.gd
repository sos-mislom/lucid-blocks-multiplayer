class_name CoopTransportLAN
extends RefCounted

# CoopTransportLAN - phase 16b extraction from coop_manager.gd.
#
# Pure helpers for LAN (ENet) transport. The wire/runtime path
# (`_start_lan_host` / `host_session` / `join_session` /
# `disconnect_session` / `leave_session`) is engine-bound
# (`ENetMultiplayerPeer.new()`, `multiplayer.multiplayer_peer = peer`)
# and stays on `coop_manager.gd` as a forwarder.
#
# What lives here:
#   - `parse_address_port` (coop_manager.gd L712-738) - the
#     `--lb-connect` / config-derived target string parser that
#     normalizes `host`, `host:port`, `[v6]`, `[v6]:port` into a
#     `{address, port}` dict with the port clamped to `[1, 65535]`.
#     Used by both the cmdline auto-connect path
#     (`_configure_auto_connect_from_args`) and any UI surfaces that
#     accept a paste-in target string. Pure, no engine deps.
#
# This module knows NOTHING about:
#   - `ENetMultiplayerPeer` / `multiplayer.*`.
#   - `Ref.*` / `class_name Player`.
#   - `config["address"]` / `config["port"]` - the forwarder threads
#     the defaults in so we stay oblivious to engine state.


# --- Address/port parsing ---

# parse_address_port: pure form of `_parse_address_port`
# (coop_manager.gd L712-738).
#
# Accepts a free-form target string and resolves it into a
# `{address, port}` dict. Falls back to the provided defaults when
# the target is empty or omits a port. Port is always clamped to
# `[1, 65535]` (engine ENet requirement).
#
# Supported shapes:
#   - ``                       -> {default_address, default_port}
#   - `host`                   -> {host, default_port}
#   - `host:port`              -> {host, port}
#   - `[ipv6]`                 -> {ipv6, default_port}
#   - `[ipv6]:port`            -> {ipv6, port}
#   - `host:not_an_int`        -> {`host:not_an_int`, default_port}
#     (live behavior: invalid trailing token after the rightmost
#     colon is treated as part of the address; the LAN connect path
#     then surfaces the connect failure to the player rather than
#     silently dropping the port).
#   - `host:port:port` (>=2 colons, no brackets)
#                              -> {target_as_is, default_port}
#     (live behavior: multi-colon hostnames are treated as opaque
#     IPv6-ish strings; users have to wrap them in `[...]`).
static func parse_address_port(
    raw_target: String,
    default_address: String,
    default_port: int,
) -> Dictionary:
    var target: String = raw_target.strip_edges()
    var address: String = default_address
    var port: int = default_port
    if target == "":
        return {"address": address, "port": port}

    if target.begins_with("[") and target.find("]") > 0:
        var close_index: int = target.find("]")
        address = target.substr(1, close_index - 1)
        var suffix: String = target.substr(close_index + 1).strip_edges()
        if suffix.begins_with(":") and suffix.substr(1).is_valid_int():
            port = int(suffix.substr(1))
        return {"address": address, "port": clampi(port, 1, 65535)}

    var colon_index: int = target.rfind(":")
    if colon_index > 0 and target.find(":") == colon_index:
        var maybe_port: String = target.substr(colon_index + 1).strip_edges()
        if maybe_port.is_valid_int():
            address = target.substr(0, colon_index).strip_edges()
            port = int(maybe_port)
        else:
            address = target
    else:
        address = target

    return {"address": address, "port": clampi(port, 1, 65535)}
