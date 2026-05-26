extends RefCounted


func _approx_vector3(t: CoopTester, expected: Vector3, actual: Vector3, tolerance: float = 0.001) -> void:
    t.assert_true(absf(expected.x - actual.x) < tolerance, "x: expected %f, got %f" % [expected.x, actual.x])
    t.assert_true(absf(expected.y - actual.y) < tolerance, "y: expected %f, got %f" % [expected.y, actual.y])
    t.assert_true(absf(expected.z - actual.z) < tolerance, "z: expected %f, got %f" % [expected.z, actual.z])


func run(t: CoopTester) -> void:
    t.begin("CoopDropPredict.resolve_client_drop_position_correction first snapshot -> snap to target")
    var result: Dictionary = CoopDropPredict.resolve_client_drop_position_correction(
        false,
        false,
        Vector3(0.0, 0.0, 0.0),
        Vector3(10.0, 5.0, 3.0),
    )
    _approx_vector3(t, Vector3(10.0, 5.0, 3.0), result.get("next_position"))
    t.assert_eq(true, result.get("snapshot_initialized"))
    t.assert_eq(0.0, result.get("distance_error"))

    t.begin("CoopDropPredict.resolve_client_drop_position_correction predicted-motion grace keeps current position")
    result = CoopDropPredict.resolve_client_drop_position_correction(
        true,
        true,
        Vector3(1.0, 0.0, 0.0),
        Vector3(5.0, 0.0, 0.0),
    )
    _approx_vector3(t, Vector3(1.0, 0.0, 0.0), result.get("next_position"))
    t.assert_eq(true, result.get("snapshot_initialized"))
    t.assert_true(absf(float(result.get("distance_error")) - 4.0) < 0.001)

    t.begin("CoopDropPredict.resolve_client_drop_position_correction distance < threshold -> keep current position")
    result = CoopDropPredict.resolve_client_drop_position_correction(
        true,
        false,
        Vector3(0.0, 0.0, 0.0),
        Vector3(0.005, 0.0, 0.0),
    )
    _approx_vector3(t, Vector3(0.0, 0.0, 0.0), result.get("next_position"))

    t.begin("CoopDropPredict.resolve_client_drop_position_correction distance > correction -> snap")
    result = CoopDropPredict.resolve_client_drop_position_correction(
        true,
        false,
        Vector3(0.0, 0.0, 0.0),
        Vector3(2.0, 0.0, 0.0),
    )
    _approx_vector3(t, Vector3(2.0, 0.0, 0.0), result.get("next_position"))

    t.begin("CoopDropPredict.resolve_client_drop_position_correction distance in lerp band -> blend")
    result = CoopDropPredict.resolve_client_drop_position_correction(
        true,
        false,
        Vector3(0.0, 0.0, 0.0),
        Vector3(1.0, 0.0, 0.0),
        1.35,
        0.45,
    )
    _approx_vector3(t, Vector3(0.45, 0.0, 0.0), result.get("next_position"))
    t.assert_true(absf(float(result.get("distance_error")) - 0.55) < 0.001)
