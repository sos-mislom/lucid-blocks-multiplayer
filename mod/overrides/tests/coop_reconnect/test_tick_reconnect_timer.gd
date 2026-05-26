extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopReconnect.tick_reconnect_timer decrements timer by delta")
    var result: Dictionary = CoopReconnect.tick_reconnect_timer(0.25, 2.0)
    t.assert_eq(true, abs(float(result.get("timer", 0.0)) - 1.75) < 0.0001)
    t.assert_eq(false, bool(result.get("should_attempt", false)))

    t.begin("CoopReconnect.tick_reconnect_timer hits zero on exact match")
    result = CoopReconnect.tick_reconnect_timer(2.0, 2.0)
    t.assert_eq(0.0, float(result.get("timer", 0.0)))
    t.assert_eq(true, bool(result.get("should_attempt", false)))

    t.begin("CoopReconnect.tick_reconnect_timer clamps at zero on overshoot")
    result = CoopReconnect.tick_reconnect_timer(5.0, 1.0)
    t.assert_eq(0.0, float(result.get("timer", 0.0)))
    t.assert_eq(true, bool(result.get("should_attempt", false)))

    t.begin("CoopReconnect.tick_reconnect_timer already-zero timer immediately attempts")
    result = CoopReconnect.tick_reconnect_timer(0.0, 0.0)
    t.assert_eq(0.0, float(result.get("timer", 0.0)))
    t.assert_eq(true, bool(result.get("should_attempt", false)))

    t.begin("CoopReconnect.tick_reconnect_timer negative existing timer is clamped at zero")
    result = CoopReconnect.tick_reconnect_timer(0.1, -1.0)
    t.assert_eq(0.0, float(result.get("timer", 0.0)))
    t.assert_eq(true, bool(result.get("should_attempt", false)))
