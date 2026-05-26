extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopReconnect.resolve_lan_reconnect_target normal address/port pass through")
    var target: Dictionary = CoopReconnect.resolve_lan_reconnect_target("10.0.0.5", 27015, 7777)
    t.assert_eq("10.0.0.5", target.get("address"))
    t.assert_eq(27015, target.get("port"))

    t.begin("CoopReconnect.resolve_lan_reconnect_target strips whitespace from address")
    target = CoopReconnect.resolve_lan_reconnect_target("  example.org  ", 7777, 7777)
    t.assert_eq("example.org", target.get("address"))
    t.assert_eq(7777, target.get("port"))

    t.begin("CoopReconnect.resolve_lan_reconnect_target empty address falls back to 127.0.0.1")
    target = CoopReconnect.resolve_lan_reconnect_target("", 7777, 7777)
    t.assert_eq("127.0.0.1", target.get("address"))
    t.assert_eq(7777, target.get("port"))

    t.begin("CoopReconnect.resolve_lan_reconnect_target whitespace-only address falls back to 127.0.0.1")
    target = CoopReconnect.resolve_lan_reconnect_target("   ", 7777, 7777)
    t.assert_eq("127.0.0.1", target.get("address"))

    t.begin("CoopReconnect.resolve_lan_reconnect_target null port uses default")
    target = CoopReconnect.resolve_lan_reconnect_target("127.0.0.1", null, 12345)
    t.assert_eq(12345, target.get("port"))

    t.begin("CoopReconnect.resolve_lan_reconnect_target port above range clamped to 65535")
    target = CoopReconnect.resolve_lan_reconnect_target("127.0.0.1", 999999, 7777)
    t.assert_eq(65535, target.get("port"))

    t.begin("CoopReconnect.resolve_lan_reconnect_target port at zero clamped to 1")
    target = CoopReconnect.resolve_lan_reconnect_target("127.0.0.1", 0, 7777)
    t.assert_eq(1, target.get("port"))

    t.begin("CoopReconnect.resolve_lan_reconnect_target stringy port works")
    target = CoopReconnect.resolve_lan_reconnect_target("127.0.0.1", "8080", 7777)
    t.assert_eq(8080, target.get("port"))
