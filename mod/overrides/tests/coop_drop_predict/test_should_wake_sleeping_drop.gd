extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropPredict.should_wake_sleeping_drop default thresholds")
    t.assert_false(CoopDropPredict.should_wake_sleeping_drop(0.0, 0.0))
    t.assert_false(CoopDropPredict.should_wake_sleeping_drop(0.1, 0.05))
    t.assert_false(CoopDropPredict.should_wake_sleeping_drop(0.35, 0.36))

    t.begin("CoopDropPredict.should_wake_sleeping_drop distance over threshold wakes")
    t.assert_true(CoopDropPredict.should_wake_sleeping_drop(0.36, 0.0))
    t.assert_true(CoopDropPredict.should_wake_sleeping_drop(1.0, 0.0))

    t.begin("CoopDropPredict.should_wake_sleeping_drop velocity over threshold wakes")
    t.assert_true(CoopDropPredict.should_wake_sleeping_drop(0.0, 0.37))
    t.assert_true(CoopDropPredict.should_wake_sleeping_drop(0.0, 5.0))

    t.begin("CoopDropPredict.should_wake_sleeping_drop honours override thresholds")
    t.assert_false(CoopDropPredict.should_wake_sleeping_drop(0.5, 0.5, 1.0, 1.0))
    t.assert_true(CoopDropPredict.should_wake_sleeping_drop(0.5, 0.5, 0.1, 0.1))
