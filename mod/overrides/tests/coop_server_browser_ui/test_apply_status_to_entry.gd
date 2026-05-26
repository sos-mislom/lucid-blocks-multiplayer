extends RefCounted


class _ProtocolStubs:
    extends RefCounted

    var info_to_return: Dictionary = {}
    var compatible_result: bool = true

    func get_info(_data: Dictionary) -> Dictionary:
        return info_to_return.duplicate(true)

    func is_compatible(_info: Dictionary) -> bool:
        return compatible_result


func run(t: CoopTester) -> void:
    var stubs := _ProtocolStubs.new()
    var get_info := Callable(stubs, "get_info")
    var is_compatible := Callable(stubs, "is_compatible")

    var base_entry: Dictionary = {
        "address": "1.2.3.4",
        "name": "S",
        "players": 0,
        "max_players": 4,
        "status": "unknown",
        "allow_status_endpoint_update": false,
    }

    t.begin("CoopServerBrowserUI.apply_status_to_entry ok+no protocol info -> online")
    var data: Dictionary = {"ok": true, "message": "hi"}
    var entry: Dictionary = CoopServerBrowserUI.apply_status_to_entry(base_entry, data, get_info, is_compatible, 4)
    t.assert_eq("online", entry.get("status"))
    t.assert_eq("hi", entry.get("message"))

    t.begin("CoopServerBrowserUI.apply_status_to_entry ok+incompatible protocol -> incompatible")
    stubs.info_to_return = {"protocol": "lucid-blocks-coop", "version": 1, "min": 1}
    stubs.compatible_result = false
    entry = CoopServerBrowserUI.apply_status_to_entry(base_entry, {"ok": true}, get_info, is_compatible, 4)
    t.assert_eq("incompatible", entry.get("status"))
    t.assert_eq("Server protocol is incompatible", entry.get("message"))
    t.assert_eq("lucid-blocks-coop", entry.get("coop_protocol"))
    t.assert_eq(1, entry.get("coop_protocol_version"))

    t.begin("CoopServerBrowserUI.apply_status_to_entry starting -> checking")
    stubs.info_to_return = {}
    stubs.compatible_result = true
    entry = CoopServerBrowserUI.apply_status_to_entry(base_entry, {"ok": false, "status": "starting"}, get_info, is_compatible, 4)
    t.assert_eq("checking", entry.get("status"))
    t.assert_eq("Server is starting", entry.get("message"))

    t.begin("CoopServerBrowserUI.apply_status_to_entry waiting_world -> checking")
    entry = CoopServerBrowserUI.apply_status_to_entry(base_entry, {"ok": false, "status": "waiting_world"}, get_info, is_compatible, 4)
    t.assert_eq("checking", entry.get("status"))

    t.begin("CoopServerBrowserUI.apply_status_to_entry backend_connected=false -> relay")
    entry = CoopServerBrowserUI.apply_status_to_entry(base_entry, {"ok": false, "backend_connected": false}, get_info, is_compatible, 4)
    t.assert_eq("relay", entry.get("status"))
    t.assert_eq("Relay online, host is not connected", entry.get("message"))

    t.begin("CoopServerBrowserUI.apply_status_to_entry otherwise -> offline")
    entry = CoopServerBrowserUI.apply_status_to_entry(base_entry, {"ok": false}, get_info, is_compatible, 4)
    t.assert_eq("offline", entry.get("status"))

    t.begin("CoopServerBrowserUI.apply_status_to_entry pulls player counts and tps")
    entry = CoopServerBrowserUI.apply_status_to_entry(base_entry, {
        "ok": true,
        "players": 3,
        "max_players": 8,
        "world_title": "WorldA",
        "tps": 45.0,
        "tps_health": "ok",
    }, get_info, is_compatible, 4)
    t.assert_eq(3, entry.get("players"))
    t.assert_eq(8, entry.get("max_players"))
    t.assert_eq("WorldA", entry.get("world_title"))
    t.assert_eq(45.0, entry.get("tps"))
    t.assert_eq("ok", entry.get("tps_health"))

    t.begin("CoopServerBrowserUI.apply_status_to_entry endpoint_update gates game_port/status_port rewrites")
    var endpoint_entry: Dictionary = base_entry.duplicate(true)
    endpoint_entry["allow_status_endpoint_update"] = true
    entry = CoopServerBrowserUI.apply_status_to_entry(endpoint_entry, {"ok": true, "game_port": 24999, "status_port": 24555}, get_info, is_compatible, 4, 24667, 1)
    t.assert_eq(24999, entry.get("port"))
    t.assert_eq(24555, entry.get("status_port"))

    t.begin("CoopServerBrowserUI.apply_status_to_entry endpoint_update=false ignores game_port")
    entry = CoopServerBrowserUI.apply_status_to_entry(base_entry, {"ok": true, "game_port": 24999, "status_port": 24555}, get_info, is_compatible, 4, 24667, 1)
    t.assert_false(entry.has("port") and int(entry.get("port", -1)) == 24999)
