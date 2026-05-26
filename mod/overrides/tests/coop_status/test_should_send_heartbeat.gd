extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopStatus.should_send_heartbeat short-circuits while a request is in flight")
    t.assert_false(CoopStatus.should_send_heartbeat(60.0, 30.0, true, true))
    t.assert_false(CoopStatus.should_send_heartbeat(60.0, 30.0, true, false), "in_flight wins over cold-start fast path")

    t.begin("CoopStatus.should_send_heartbeat forces a first send on cold start regardless of timer")
    t.assert_true(CoopStatus.should_send_heartbeat(0.0, 30.0, false, false))
    t.assert_true(CoopStatus.should_send_heartbeat(0.5, 30.0, false, false))

    t.begin("CoopStatus.should_send_heartbeat waits for the timer once the request node exists")
    t.assert_false(CoopStatus.should_send_heartbeat(0.0, 30.0, false, true))
    t.assert_false(CoopStatus.should_send_heartbeat(29.99, 30.0, false, true))

    t.begin("CoopStatus.should_send_heartbeat triggers when timer >= interval and not in flight")
    t.assert_true(CoopStatus.should_send_heartbeat(30.0, 30.0, false, true))
    t.assert_true(CoopStatus.should_send_heartbeat(45.0, 30.0, false, true))
