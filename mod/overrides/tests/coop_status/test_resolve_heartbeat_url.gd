extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopStatus.resolve_heartbeat_url prefers explicit server_registry_heartbeat_url")
    var explicit: Dictionary = {
        "server_registry_heartbeat_url": "https://master.example.com/v1/heartbeat",
        "server_registry_url": "https://other.example.com/servers.json",
    }
    t.assert_eq("https://master.example.com/v1/heartbeat", CoopStatus.resolve_heartbeat_url(explicit))

    t.begin("CoopStatus.resolve_heartbeat_url trims surrounding whitespace on the explicit URL")
    var whitespaced: Dictionary = {
        "server_registry_heartbeat_url": "  https://m.example.com/heartbeat  ",
    }
    t.assert_eq("https://m.example.com/heartbeat", CoopStatus.resolve_heartbeat_url(whitespaced))

    t.begin("CoopStatus.resolve_heartbeat_url derives /heartbeat from a */servers.json registry URL")
    var derived: Dictionary = {"server_registry_url": "https://master.example.com/v1/servers.json"}
    t.assert_eq("https://master.example.com/v1/heartbeat", CoopStatus.resolve_heartbeat_url(derived))

    t.begin("CoopStatus.resolve_heartbeat_url returns empty string for unrelated registry URL")
    var unrelated: Dictionary = {"server_registry_url": "https://master.example.com/v1/list.json"}
    t.assert_eq("", CoopStatus.resolve_heartbeat_url(unrelated))

    t.begin("CoopStatus.resolve_heartbeat_url returns empty string for empty config")
    t.assert_eq("", CoopStatus.resolve_heartbeat_url({}))
    t.assert_eq("", CoopStatus.resolve_heartbeat_url({"server_registry_heartbeat_url": "", "server_registry_url": ""}))
