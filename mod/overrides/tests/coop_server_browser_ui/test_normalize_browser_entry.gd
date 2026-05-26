extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerBrowserUI.normalize_browser_entry empty address -> empty dict")
    t.assert_true(CoopServerBrowserUI.normalize_browser_entry({}).is_empty())
    t.assert_true(CoopServerBrowserUI.normalize_browser_entry({"address": ""}).is_empty())

    t.begin("CoopServerBrowserUI.normalize_browser_entry pins defaults")
    var entry: Dictionary = CoopServerBrowserUI.normalize_browser_entry({"address": "10.0.0.5"}, 24667, 1, 4)
    t.assert_eq("10.0.0.5", entry.get("address"))
    t.assert_eq(24667, entry.get("port"))
    t.assert_eq(24668, entry.get("status_port"))
    t.assert_eq("Server", entry.get("name"))
    t.assert_eq("Server", entry.get("world_title"))
    t.assert_eq("public", entry.get("region"))
    t.assert_eq("unknown", entry.get("status"))
    t.assert_eq(0, entry.get("players"))
    t.assert_eq(4, entry.get("max_players"))
    t.assert_eq("", entry.get("message"))
    t.assert_eq(false, entry.get("allow_status_endpoint_update"))

    t.begin("CoopServerBrowserUI.normalize_browser_entry honours host alias / explicit name")
    entry = CoopServerBrowserUI.normalize_browser_entry({"host": "1.2.3.4", "name": "QUALIA-EU", "region": "europe"}, 24667, 1, 4)
    t.assert_eq("1.2.3.4", entry.get("address"))
    t.assert_eq("QUALIA-EU", entry.get("name"))
    t.assert_eq("europe", entry.get("region"))

    t.begin("CoopServerBrowserUI.normalize_browser_entry clamps port to 1..65535")
    entry = CoopServerBrowserUI.normalize_browser_entry({"address": "1.2.3.4", "port": 0, "status_port": -1}, 24667, 1, 4)
    t.assert_eq(1, entry.get("port"))
    t.assert_eq(1, entry.get("status_port"))
    entry = CoopServerBrowserUI.normalize_browser_entry({"address": "1.2.3.4", "port": 99999, "status_port": 99999}, 24667, 1, 4)
    t.assert_eq(65535, entry.get("port"))
    t.assert_eq(65535, entry.get("status_port"))

    t.begin("CoopServerBrowserUI.normalize_browser_entry allow_status_endpoint_update derived from endpoint_key/status_port/game_port")
    entry = CoopServerBrowserUI.normalize_browser_entry({"address": "1.2.3.4", "endpoint_key": "abc"}, 24667, 1, 4)
    t.assert_eq(true, entry.get("allow_status_endpoint_update"))
    entry = CoopServerBrowserUI.normalize_browser_entry({"address": "1.2.3.4", "status_port": 24700}, 24667, 1, 4)
    t.assert_eq(true, entry.get("allow_status_endpoint_update"))
    entry = CoopServerBrowserUI.normalize_browser_entry({"address": "1.2.3.4", "game_port": 24700}, 24667, 1, 4)
    t.assert_eq(true, entry.get("allow_status_endpoint_update"))

    t.begin("CoopServerBrowserUI.normalize_browser_entry preserves explicit allow_status_endpoint_update")
    entry = CoopServerBrowserUI.normalize_browser_entry({"address": "1.2.3.4", "allow_status_endpoint_update": false, "endpoint_key": "abc"}, 24667, 1, 4)
    t.assert_eq(false, entry.get("allow_status_endpoint_update"))
