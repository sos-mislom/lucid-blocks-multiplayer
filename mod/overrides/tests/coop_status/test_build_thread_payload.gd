extends RefCounted


func run(t: CoopTester) -> void:
    var state: Dictionary = {
        "ready": true,
        "boot_phase": "ready",
        "coop_protocol_name": "lucid-blocks-coop",
        "coop_protocol_version": 5,
        "coop_protocol_min": 3,
        "coop_protocol_features": ["entity-snapshots", "world-patches"],
        "coop_protocol_required_features": ["entity-snapshots"],
        "game_port": 7777,
        "status_port": 7778,
        "transport": "LAN",
        "status_message": "running",
        "max_players": 8,
        "world_title": "Test World",
        "version": "0.1.0",
        "target_tps": 30,
        "tps": 29.7,
        "min_tps": 27.4,
        "last_frame_ms": 33.4,
        "tps_health": "ok",
        "load_radius": 6,
        "buffer_radius": 8,
        "entity_view_radius": 128.0,
        "entity_simulation_radius": 96.0,
    }
    var payload: Dictionary = CoopStatus.build_thread_payload(state)

    t.begin("CoopStatus.build_thread_payload emits the wire-protocol fields")
    t.assert_eq("lucid-blocks-coop-udp", str(payload.get("protocol", "")))
    t.assert_eq("lucid-blocks-coop", str(payload.get("coop_protocol", "")))
    t.assert_eq(5, int(payload.get("coop_protocol_version", -1)))
    t.assert_eq(3, int(payload.get("coop_protocol_min", -1)))

    t.begin("CoopStatus.build_thread_payload mirrors ok/ready and status/boot_phase")
    t.assert_true(bool(payload.get("ok", false)))
    t.assert_true(bool(payload.get("ready", false)))
    t.assert_eq("ready", str(payload.get("status", "")))
    t.assert_eq("ready", str(payload.get("boot_phase", "")))

    t.begin("CoopStatus.build_thread_payload passes through transport, ports, and message")
    t.assert_eq("LAN", str(payload.get("transport", "")))
    t.assert_eq(7777, int(payload.get("game_port", -1)))
    t.assert_eq(7778, int(payload.get("status_port", -1)))
    t.assert_eq("running", str(payload.get("message", "")))

    t.begin("CoopStatus.build_thread_payload always reports players=0 (thread snapshot)")
    t.assert_eq(0, int(payload.get("players", -1)))
    t.assert_eq(8, int(payload.get("max_players", -1)))

    t.begin("CoopStatus.build_thread_payload includes runtime telemetry fields")
    t.assert_eq("Test World", str(payload.get("world_title", "")))
    t.assert_eq("0.1.0", str(payload.get("version", "")))
    t.assert_eq(30, int(payload.get("target_tps", -1)))
    t.assert_eq(29.7, float(payload.get("tps", -1.0)))
    t.assert_eq(27.4, float(payload.get("min_tps", -1.0)))
    t.assert_eq(33.4, float(payload.get("last_frame_ms", -1.0)))
    t.assert_eq("ok", str(payload.get("tps_health", "")))
    t.assert_eq(6, int(payload.get("load_radius", -1)))
    t.assert_eq(8, int(payload.get("buffer_radius", -1)))
    t.assert_eq(128.0, float(payload.get("entity_view_radius", -1.0)))
    t.assert_eq(96.0, float(payload.get("entity_simulation_radius", -1.0)))

    t.begin("CoopStatus.build_thread_payload falls back to 'starting' when boot_phase is missing")
    var starting_payload: Dictionary = CoopStatus.build_thread_payload({})
    t.assert_eq("starting", str(starting_payload.get("status", "")))
    t.assert_eq("starting", str(starting_payload.get("boot_phase", "")))
    t.assert_false(bool(starting_payload.get("ok", true)))
    t.assert_false(bool(starting_payload.get("ready", true)))
