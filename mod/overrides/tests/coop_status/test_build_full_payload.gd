extends RefCounted


func run(t: CoopTester) -> void:
    var state: Dictionary = {
        "ready": true,
        "boot_phase": "ready",
        "coop_protocol_name": "lucid-blocks-coop",
        "coop_protocol_version": 5,
        "coop_protocol_min": 3,
        "coop_protocol_features": ["a", "b"],
        "coop_protocol_required_features": ["a"],
        "game_port": 7777,
        "status_port": 7778,
        "transport": "LAN",
        "status_message": "ready",
        "max_players": 4,
        "world_title": "Fallback Title",
        "version": "0.2.0",
        "target_tps": 30,
        "tps": 29.0,
        "min_tps": 25.5,
        "last_frame_ms": 35.0,
        "tps_health": "ok",
        "net_backoff": 1.0,
        "send_hz": 20.0,
        "world_hz": 10.0,
        "load_radius": 4,
        "buffer_radius": 6,
        "entity_view_radius": 96.0,
        "entity_simulation_radius": 64.0,
    }
    var runtime_metrics: Dictionary = {
        "memory_static_mb": 256.0,
        "memory_static_peak_mb": 312.5,
        "entity_count": 42,
        "drop_count": 5,
        "dirty_chunk_count": 7,
        "dirty_journal_backlog": 7,
        "chunk_journal_sequence": 999,
        "chunk_ticket_count": 3,
        "loaded_region_count": 2,
        "native_active_region_centers": 1,
        "packet_backlog": 12,
        "pending_world_patches": 4,
        "pending_remote_changes": 8,
    }
    var save_register_info: Dictionary = {"title": "Saved World", "uuid": "abc-123"}
    var payload: Dictionary = CoopStatus.build_full_payload(state, runtime_metrics, save_register_info, 2)

    t.begin("CoopStatus.build_full_payload mirrors ok/ready/status from state")
    t.assert_true(bool(payload.get("ok", false)))
    t.assert_true(bool(payload.get("ready", false)))
    t.assert_eq("ready", str(payload.get("status", "")))
    t.assert_eq("ready", str(payload.get("boot_phase", "")))

    t.begin("CoopStatus.build_full_payload includes ratesink fields net_backoff/send_hz/world_hz")
    t.assert_eq(1.0, float(payload.get("net_backoff", -1.0)))
    t.assert_eq(20.0, float(payload.get("send_hz", -1.0)))
    t.assert_eq(10.0, float(payload.get("world_hz", -1.0)))

    t.begin("CoopStatus.build_full_payload embeds runtime metrics under 'runtime' and mirrors common keys")
    t.assert_true(payload.has("runtime"))
    t.assert_eq(42, int(payload.get("entity_count", -1)))
    t.assert_eq(5, int(payload.get("drop_count", -1)))
    t.assert_eq(7, int(payload.get("dirty_chunk_count", -1)))
    t.assert_eq(7, int(payload.get("dirty_journal_backlog", -1)))
    t.assert_eq(999, int(payload.get("chunk_journal_sequence", -1)))
    t.assert_eq(12, int(payload.get("packet_backlog", -1)))

    t.begin("CoopStatus.build_full_payload mirrors memory_static_mb to ram_mb / ram_peak_mb")
    t.assert_eq(256.0, float(payload.get("memory_static_mb", -1.0)))
    t.assert_eq(312.5, float(payload.get("memory_static_peak_mb", -1.0)))
    t.assert_eq(256.0, float(payload.get("ram_mb", -1.0)))
    t.assert_eq(312.5, float(payload.get("ram_peak_mb", -1.0)))

    t.begin("CoopStatus.build_full_payload overrides world_title and sets world_uuid from save_register_info")
    t.assert_eq("Saved World", str(payload.get("world_title", "")))
    t.assert_eq("abc-123", str(payload.get("world_uuid", "")))

    t.begin("CoopStatus.build_full_payload sets players from connected_count")
    t.assert_eq(2, int(payload.get("players", -1)))

    t.begin("CoopStatus.build_full_payload leaves world_title fallback when save_register_info is empty")
    var no_save_payload: Dictionary = CoopStatus.build_full_payload(state, runtime_metrics, {}, 0)
    t.assert_eq("Fallback Title", str(no_save_payload.get("world_title", "")))
    t.assert_false(no_save_payload.has("world_uuid"), "uuid is only added when save_register_info supplies it")
    t.assert_eq(0, int(no_save_payload.get("players", -1)))
