extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropPredict.is_drop_within_pickup_radius cannot sample player -> false")
    t.assert_false(CoopDropPredict.is_drop_within_pickup_radius(false, false, false, Vector3.ZERO, Vector3.ZERO))

    t.begin("CoopDropPredict.is_drop_within_pickup_radius player dead -> false")
    t.assert_false(CoopDropPredict.is_drop_within_pickup_radius(true, true, false, Vector3.ZERO, Vector3.ZERO))

    t.begin("CoopDropPredict.is_drop_within_pickup_radius player disabled -> false")
    t.assert_false(CoopDropPredict.is_drop_within_pickup_radius(true, false, true, Vector3.ZERO, Vector3.ZERO))

    t.begin("CoopDropPredict.is_drop_within_pickup_radius within default radius (2.35m) -> true")
    t.assert_true(CoopDropPredict.is_drop_within_pickup_radius(true, false, false, Vector3.ZERO, Vector3(2.0, 0.0, 0.0)))
    t.assert_true(CoopDropPredict.is_drop_within_pickup_radius(true, false, false, Vector3.ZERO, Vector3(2.35, 0.0, 0.0)))

    t.begin("CoopDropPredict.is_drop_within_pickup_radius past default radius -> false")
    t.assert_false(CoopDropPredict.is_drop_within_pickup_radius(true, false, false, Vector3.ZERO, Vector3(2.5, 0.0, 0.0)))
    t.assert_false(CoopDropPredict.is_drop_within_pickup_radius(true, false, false, Vector3.ZERO, Vector3(10.0, 0.0, 0.0)))

    t.begin("CoopDropPredict.is_drop_within_pickup_radius honours override radius")
    t.assert_true(CoopDropPredict.is_drop_within_pickup_radius(true, false, false, Vector3.ZERO, Vector3(4.0, 0.0, 0.0), 5.0))
    t.assert_false(CoopDropPredict.is_drop_within_pickup_radius(true, false, false, Vector3.ZERO, Vector3(4.0, 0.0, 0.0), 1.0))

    t.begin("CoopDropPredict.should_attempt_client_auto_pickup server runs -> false")
    t.assert_false(CoopDropPredict.should_attempt_client_auto_pickup(true, true, true, false, true))

    t.begin("CoopDropPredict.should_attempt_client_auto_pickup invalid drop -> false")
    t.assert_false(CoopDropPredict.should_attempt_client_auto_pickup(false, false, true, false, true))

    t.begin("CoopDropPredict.should_attempt_client_auto_pickup not can_collect -> false")
    t.assert_false(CoopDropPredict.should_attempt_client_auto_pickup(false, true, false, false, true))

    t.begin("CoopDropPredict.should_attempt_client_auto_pickup pickup pending -> false")
    t.assert_false(CoopDropPredict.should_attempt_client_auto_pickup(false, true, true, true, true))

    t.begin("CoopDropPredict.should_attempt_client_auto_pickup not within radius -> false")
    t.assert_false(CoopDropPredict.should_attempt_client_auto_pickup(false, true, true, false, false))

    t.begin("CoopDropPredict.should_attempt_client_auto_pickup all conditions met -> true")
    t.assert_true(CoopDropPredict.should_attempt_client_auto_pickup(false, true, true, false, true))
