extends RefCounted


func _approx_eq(t: CoopTester, expected: float, actual: float, tolerance: float, label: String) -> void:
    if absf(expected - actual) > tolerance:
        t.assert_eq(expected, actual, label)
    else:
        t.assert_true(true, label)


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.host_entity_yaw_delta_abs identical yaw -> 0")
    _approx_eq(t, 0.0, CoopEntitySync.host_entity_yaw_delta_abs(1.5, 1.5), 1e-6, "delta=0")

    t.begin("CoopEntitySync.host_entity_yaw_delta_abs small forward delta")
    _approx_eq(t, 0.5, CoopEntitySync.host_entity_yaw_delta_abs(1.0, 1.5), 1e-6, "+0.5 rad")

    t.begin("CoopEntitySync.host_entity_yaw_delta_abs small backward delta is absolute")
    _approx_eq(t, 0.5, CoopEntitySync.host_entity_yaw_delta_abs(1.5, 1.0), 1e-6, "abs(-0.5) = 0.5")

    t.begin("CoopEntitySync.host_entity_yaw_delta_abs wraps across 0/TAU boundary correctly")
    # Previous near +PI, next near -PI (wrapped to +PI on the wrap side):
    # naive subtraction would yield ~ 2*PI, but the wrapped delta should be near 0.
    _approx_eq(t, 0.0, CoopEntitySync.host_entity_yaw_delta_abs(-PI + 0.01, PI - 0.01), 0.05,
        "wraparound across 0/TAU is normalised")

    t.begin("CoopEntitySync.host_entity_yaw_delta_abs ~PI delta returns ~PI (max)")
    _approx_eq(t, PI, CoopEntitySync.host_entity_yaw_delta_abs(0.0, PI), 1e-6, "max delta is PI")

    t.begin("CoopEntitySync.host_entity_yaw_delta_abs symmetric across sign")
    _approx_eq(t,
        CoopEntitySync.host_entity_yaw_delta_abs(0.0, 1.2),
        CoopEntitySync.host_entity_yaw_delta_abs(0.0, -1.2),
        1e-6,
        "abs(+1.2) == abs(-1.2)",
    )
