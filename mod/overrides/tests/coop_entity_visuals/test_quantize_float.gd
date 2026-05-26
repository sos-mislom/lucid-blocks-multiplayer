extends RefCounted


func run(t: CoopTester) -> void:
    var tolerance: float = 1e-5

    t.begin("CoopEntityVisuals.quantize_float snaps to step (rounds toward nearest)")
    t.assert_true(absf(1.0 - CoopEntityVisuals.quantize_float(1.02, 0.05)) < tolerance, "1.02 -> 1.0")
    t.assert_true(absf(0.0 - CoopEntityVisuals.quantize_float(0.024, 0.05)) < tolerance, "0.024 -> 0.0")

    t.begin("CoopEntityVisuals.quantize_float rounds to nearest")
    t.assert_true(absf(1.0 - CoopEntityVisuals.quantize_float(1.024, 0.05)) < tolerance, "1.024 -> 1.0")
    t.assert_true(absf(1.05 - CoopEntityVisuals.quantize_float(1.026, 0.05)) < tolerance, "1.026 -> 1.05")

    t.begin("CoopEntityVisuals.quantize_float step <= 0 returns value unchanged")
    t.assert_eq(1.234, CoopEntityVisuals.quantize_float(1.234, 0.0))
    t.assert_eq(1.234, CoopEntityVisuals.quantize_float(1.234, -1.0))

    t.begin("CoopEntityVisuals.quantize_float default step = 0.05")
    t.assert_true(absf(0.0 - CoopEntityVisuals.quantize_float(0.02)) < tolerance, "0.02 -> 0.0")
    t.assert_true(absf(0.05 - CoopEntityVisuals.quantize_float(0.03)) < tolerance, "0.03 -> 0.05")

    t.begin("CoopEntityVisuals.quantize_float handles negative values")
    t.assert_true(absf(-1.0 - CoopEntityVisuals.quantize_float(-1.02, 0.05)) < tolerance, "-1.02 -> -1.0")
    t.assert_true(absf(-0.05 - CoopEntityVisuals.quantize_float(-0.03, 0.05)) < tolerance, "-0.03 -> -0.05")
