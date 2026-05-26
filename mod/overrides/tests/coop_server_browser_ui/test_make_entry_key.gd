extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerBrowserUI.make_entry_key endpoint_key wins over address")
    t.assert_eq("key:abc123", CoopServerBrowserUI.make_entry_key({"endpoint_key": "abc123", "address": "10.0.0.5"}))
    t.assert_eq("key:hidden-xyz", CoopServerBrowserUI.make_entry_key({"hidden_endpoint_key": "hidden-xyz"}))

    t.begin("CoopServerBrowserUI.make_entry_key address+status_port -> udp:...")
    t.assert_eq("udp:10.0.0.5:24668", CoopServerBrowserUI.make_entry_key({"address": "10.0.0.5", "status_port": 24668}))
    t.assert_eq("udp:10.0.0.5:24668", CoopServerBrowserUI.make_entry_key({"address": "10.0.0.5", "port": 24667}, 24667, 1))

    t.begin("CoopServerBrowserUI.make_entry_key no address -> name fallback (lowercased)")
    t.assert_eq("name:my server", CoopServerBrowserUI.make_entry_key({"name": "My Server"}))
    t.assert_eq("name:server", CoopServerBrowserUI.make_entry_key({}))
    t.assert_eq("name:fallback", CoopServerBrowserUI.make_entry_key({"world_title": "Fallback"}))

    t.begin("CoopServerBrowserUI.make_entry_key trims whitespace on endpoint_key")
    t.assert_eq("key:abc", CoopServerBrowserUI.make_entry_key({"endpoint_key": "  abc  "}))
