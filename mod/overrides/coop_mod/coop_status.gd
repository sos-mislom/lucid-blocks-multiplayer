class_name CoopStatus
extends RefCounted

# CoopStatus — phase 4 extraction from coop_manager.gd.
#
# Pure, static helpers for the dedicated-server status subsystem:
#   - UDP status request parsing
#   - thread-safe + full status payload assembly
#   - master-registry heartbeat URL/headers/enrichment/throttle
#
# This module knows NOTHING about:
#   - Thread / Mutex / PacketPeerUDP / HTTPRequest (engine-bound state
#     stays on coop_manager.gd as the owning node)
#   - Ref.* singletons (callers resolve save-register info first)
#   - multiplayer.* (callers resolve the connected peer count first)
#
# Coop_manager.gd keeps the existing private function names as
# forwarders. The payload contract is enumerated by the test suite so
# accidental key drift surfaces in CI before it reaches the master
# server (`scripts/linux/lucid_blocks_master_server.py`) and the JSON
# CLI tooling.


# --- UDP request parsing ---

# parse_status_request: extract the request type from a raw UDP packet
# payload (already utf-8 decoded). Strips whitespace, lowercases, and
# accepts both plain-text ("ping" / "status" / "health" / "") and JSON
# wrappers ({"type":"ping"} or {"request":"status"}).
static func parse_status_request(raw_text: String) -> String:
    var request: String = raw_text.strip_edges().to_lower()
    if request.begins_with("{"):
        var parsed_request: Variant = JSON.parse_string(request)
        if parsed_request is Dictionary:
            var dict: Dictionary = parsed_request
            request = str(dict.get("type", dict.get("request", ""))).strip_edges().to_lower()
    return request


# is_known_status_request: true for the known no-arg status pings.
# Mirrors the coop_manager._poll_dedicated_status_udp gate exactly.
static func is_known_status_request(request_type: String) -> bool:
    return request_type == "" or request_type == "ping" or request_type == "status" or request_type == "health"


# encode_status_payload: canonical JSON-over-UTF8 encoding used for
# every UDP status reply and HTTP heartbeat body. Kept as a helper so
# tests can verify the byte-level shape without re-implementing it.
static func encode_status_payload(payload: Dictionary) -> PackedByteArray:
    return JSON.stringify(payload).to_utf8_buffer()


# --- Payload assembly ---

# build_thread_payload: assemble the snapshot served by the UDP worker
# thread. Pure form of coop_manager._get_dedicated_status_thread_payload
# (lines 1349-1380). `state` is the caller-built snapshot Dictionary;
# all values are read directly without further validation so the caller
# is responsible for `snappedf(...)`, `boot_phase` fallback, etc.
static func build_thread_payload(state: Dictionary) -> Dictionary:
    var ready: bool = bool(state.get("ready", false))
    var boot_phase: String = str(state.get("boot_phase", "starting"))
    return {
        "protocol": "lucid-blocks-coop-udp",
        "coop_protocol": str(state.get("coop_protocol_name", "")),
        "coop_protocol_version": state.get("coop_protocol_version", 0),
        "coop_protocol_min": state.get("coop_protocol_min", 0),
        "coop_protocol_features": state.get("coop_protocol_features", []),
        "coop_protocol_required_features": state.get("coop_protocol_required_features", []),
        "ok": ready,
        "status": boot_phase,
        "ready": ready,
        "boot_phase": boot_phase,
        "game_port": state.get("game_port", 0),
        "status_port": state.get("status_port", 0),
        "transport": state.get("transport", ""),
        "message": str(state.get("status_message", "")),
        "players": 0,
        "max_players": state.get("max_players", 0),
        "world_title": str(state.get("world_title", "")),
        "version": str(state.get("version", "")),
        "target_tps": state.get("target_tps", 0),
        "tps": state.get("tps", 0.0),
        "min_tps": state.get("min_tps", 0.0),
        "last_frame_ms": state.get("last_frame_ms", 0.0),
        "tps_health": str(state.get("tps_health", "")),
        "load_radius": state.get("load_radius", 0),
        "buffer_radius": state.get("buffer_radius", 0),
        "entity_view_radius": state.get("entity_view_radius", 0.0),
        "entity_simulation_radius": state.get("entity_simulation_radius", 0.0),
    }


# build_full_payload: assemble the full main-thread status payload used
# by the per-frame HTTP heartbeat and direct UDP polls. Pure form of
# coop_manager._get_dedicated_status_payload (lines 1383-1444).
#
# Arguments:
#   - state: same snapshot as build_thread_payload, plus `net_backoff`,
#     `send_hz`, `world_hz`.
#   - runtime_metrics: output of coop_manager._get_server_runtime_metrics.
#   - save_register_info: { "title": String, "uuid": String } resolved by
#     the caller from Ref.save_file_manager (empty Dictionary skips the
#     overrides).
#   - connected_count: number of non-server peers (the caller iterates
#     peer_states because multiplayer state lives on the manager).
static func build_full_payload(
    state: Dictionary,
    runtime_metrics: Dictionary,
    save_register_info: Dictionary,
    connected_count: int,
) -> Dictionary:
    var ready: bool = bool(state.get("ready", false))
    var boot_phase: String = str(state.get("boot_phase", "starting"))
    var payload: Dictionary = {
        "protocol": "lucid-blocks-coop-udp",
        "coop_protocol": str(state.get("coop_protocol_name", "")),
        "coop_protocol_version": state.get("coop_protocol_version", 0),
        "coop_protocol_min": state.get("coop_protocol_min", 0),
        "coop_protocol_features": state.get("coop_protocol_features", []),
        "coop_protocol_required_features": state.get("coop_protocol_required_features", []),
        "ok": ready,
        "status": boot_phase,
        "ready": ready,
        "boot_phase": boot_phase,
        "game_port": state.get("game_port", 0),
        "status_port": state.get("status_port", 0),
        "transport": state.get("transport", ""),
        "message": str(state.get("status_message", "")),
        "players": 0,
        "max_players": state.get("max_players", 0),
        "world_title": str(state.get("world_title", "")),
        "version": str(state.get("version", "")),
        "target_tps": state.get("target_tps", 0),
        "tps": state.get("tps", 0.0),
        "min_tps": state.get("min_tps", 0.0),
        "last_frame_ms": state.get("last_frame_ms", 0.0),
        "tps_health": str(state.get("tps_health", "")),
        "net_backoff": state.get("net_backoff", 0.0),
        "send_hz": state.get("send_hz", 0.0),
        "world_hz": state.get("world_hz", 0.0),
        "load_radius": state.get("load_radius", 0),
        "buffer_radius": state.get("buffer_radius", 0),
        "entity_view_radius": state.get("entity_view_radius", 0.0),
        "entity_simulation_radius": state.get("entity_simulation_radius", 0.0),
        "runtime": runtime_metrics,
        "memory_static_mb": runtime_metrics.get("memory_static_mb", 0.0),
        "memory_static_peak_mb": runtime_metrics.get("memory_static_peak_mb", 0.0),
        "ram_mb": runtime_metrics.get("memory_static_mb", 0.0),
        "ram_peak_mb": runtime_metrics.get("memory_static_peak_mb", 0.0),
        "entity_count": runtime_metrics.get("entity_count", 0),
        "drop_count": runtime_metrics.get("drop_count", 0),
        "dirty_chunk_count": runtime_metrics.get("dirty_chunk_count", 0),
        "dirty_journal_backlog": runtime_metrics.get("dirty_journal_backlog", 0),
        "chunk_journal_sequence": runtime_metrics.get("chunk_journal_sequence", 0),
        "chunk_ticket_count": runtime_metrics.get("chunk_ticket_count", 0),
        "loaded_region_count": runtime_metrics.get("loaded_region_count", 0),
        "native_active_region_centers": runtime_metrics.get("native_active_region_centers", 0),
        "packet_backlog": runtime_metrics.get("packet_backlog", 0),
        "pending_world_patches": runtime_metrics.get("pending_world_patches", 0),
        "pending_remote_changes": runtime_metrics.get("pending_remote_changes", 0),
    }
    if save_register_info.has("title"):
        payload["world_title"] = str(save_register_info.get("title", payload.get("world_title", "")))
    if save_register_info.has("uuid"):
        payload["world_uuid"] = str(save_register_info.get("uuid", ""))
    payload["players"] = connected_count
    return payload


# --- Master-registry heartbeat helpers ---

# resolve_heartbeat_url: honour the explicit
# `server_registry_heartbeat_url` config first, then derive a heartbeat
# endpoint from a `*/servers.json` registry URL. Returns "" when
# neither path yields a usable URL.
static func resolve_heartbeat_url(config: Dictionary) -> String:
    var heartbeat_url: String = str(config.get("server_registry_heartbeat_url", "")).strip_edges()
    if heartbeat_url != "":
        return heartbeat_url
    var registry_url: String = str(config.get("server_registry_url", "")).strip_edges()
    if registry_url.ends_with("/servers.json"):
        return registry_url.substr(0, registry_url.length() - "/servers.json".length()) + "/heartbeat"
    return ""


# enrich_heartbeat_payload: returns a NEW Dictionary with the public-
# facing fields (name/address/region) layered on top of the status
# payload. `protocol` is always rewritten to "lucid-blocks-coop-master"
# so the registry can tell heartbeats apart from raw status pings.
# Empty-string config values are treated as "leave the payload alone".
static func enrich_heartbeat_payload(payload: Dictionary, config: Dictionary) -> Dictionary:
    var enriched: Dictionary = payload.duplicate(true)
    var public_name: String = str(config.get("server_public_name", "")).strip_edges()
    if public_name != "":
        enriched["name"] = public_name
        enriched["world_title"] = public_name
    var public_address: String = str(config.get("server_public_address", "")).strip_edges()
    if public_address != "":
        enriched["address"] = public_address
    enriched["region"] = str(config.get("server_public_region", "public")).strip_edges()
    enriched["protocol"] = "lucid-blocks-coop-master"
    return enriched


# build_heartbeat_headers: always sets Content-Type; adds a Bearer
# Authorization header when a non-empty token is provided. Whitespace-
# only tokens are treated as absent (matches the existing
# `.strip_edges() != ""` check in coop_manager).
static func build_heartbeat_headers(token: String) -> PackedStringArray:
    var headers: PackedStringArray = PackedStringArray(["Content-Type: application/json"])
    var trimmed: String = token.strip_edges()
    if trimmed != "":
        headers.append("Authorization: Bearer %s" % trimmed)
    return headers


# should_send_heartbeat: throttle decision for the per-frame ticker.
# Mirrors coop_manager._tick_dedicated_registry_heartbeat (lines
# 1465-1473):
#   - in_flight short-circuits: never overlap requests
#   - if the request node has never been created, force a first send
#     regardless of the timer (so cold-start heartbeat goes out fast)
#   - otherwise wait until timer >= interval
static func should_send_heartbeat(timer_sec: float, interval_sec: float, in_flight: bool, request_node_exists: bool) -> bool:
    if in_flight:
        return false
    if not request_node_exists:
        return true
    return timer_sec >= interval_sec
