extends RefCounted


func run(t: CoopTester) -> void:
    var tolerance: float = 1e-5

    t.begin("CoopEntityVisuals.quantize_vector3 snaps every axis independently")
    var snapped: Vector3 = CoopEntityVisuals.quantize_vector3(Vector3(1.04, 2.06, -0.11), 0.1)
    t.assert_true(absf(1.0 - snapped.x) < tolerance, "x: 1.04 -> 1.0")
    t.assert_true(absf(2.1 - snapped.y) < tolerance, "y: 2.06 -> 2.1")
    t.assert_true(absf(-0.1 - snapped.z) < tolerance, "z: -0.11 -> -0.1")

    t.begin("CoopEntityVisuals.quantize_vector3 step <= 0 returns vector unchanged")
    var unchanged: Vector3 = CoopEntityVisuals.quantize_vector3(Vector3(1.234, 5.678, 9.012), 0.0)
    t.assert_eq(Vector3(1.234, 5.678, 9.012), unchanged)
    t.assert_eq(Vector3(1.234, 5.678, 9.012), CoopEntityVisuals.quantize_vector3(Vector3(1.234, 5.678, 9.012), -1.0))

    t.begin("CoopEntityVisuals.quantize_vector3 default step = 0.1")
    var default_snap: Vector3 = CoopEntityVisuals.quantize_vector3(Vector3(1.04, 1.06, 1.05))
    t.assert_true(absf(1.0 - default_snap.x) < tolerance, "x: 1.04 -> 1.0")
    t.assert_true(absf(1.1 - default_snap.y) < tolerance, "y: 1.06 -> 1.1")
    # 1.05 with step 0.1 -> snappedf rounds half to nearest even/away depending on rounding mode
    t.assert_true(absf(1.0 - default_snap.z) < tolerance or absf(1.1 - default_snap.z) < tolerance,
        "z: 1.05 -> 1.0 or 1.1 (half rounding)")
