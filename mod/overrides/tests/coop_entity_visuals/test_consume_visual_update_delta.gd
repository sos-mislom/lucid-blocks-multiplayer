extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntityVisuals.consume_visual_update_delta interval=0 -> per-frame emit, accumulator reset")
    var per_frame: Dictionary = CoopEntityVisuals.consume_visual_update_delta(0.0, 0.016, 999.0)
    t.assert_eq(0.016, float(per_frame.get("visual_delta", -1.0)))
    t.assert_eq(0.0, float(per_frame.get("next_accumulator", -1.0)))
    t.assert_true(bool(per_frame.get("should_emit", false)))

    t.begin("CoopEntityVisuals.consume_visual_update_delta interval=0 delta=0 -> no emit (no work to do)")
    var idle: Dictionary = CoopEntityVisuals.consume_visual_update_delta(0.0, 0.0, 0.0)
    t.assert_eq(0.0, float(idle.get("visual_delta", -1.0)))
    t.assert_false(bool(idle.get("should_emit", true)))

    t.begin("CoopEntityVisuals.consume_visual_update_delta below threshold -> accumulator grows, no emit")
    var below: Dictionary = CoopEntityVisuals.consume_visual_update_delta(0.1, 0.03, 0.04)
    t.assert_eq(0.0, float(below.get("visual_delta", -1.0)))
    t.assert_eq(0.07, float(below.get("next_accumulator", -1.0)), "0.04 + 0.03 = 0.07")
    t.assert_false(bool(below.get("should_emit", true)))

    t.begin("CoopEntityVisuals.consume_visual_update_delta at threshold -> emit, wrap with fmod")
    var at_threshold: Dictionary = CoopEntityVisuals.consume_visual_update_delta(0.1, 0.06, 0.04)
    t.assert_eq(0.1, float(at_threshold.get("visual_delta", -1.0)))
    t.assert_true(bool(at_threshold.get("should_emit", false)))

    t.begin("CoopEntityVisuals.consume_visual_update_delta above threshold -> emit excess, fmod keeps remainder")
    var above: Dictionary = CoopEntityVisuals.consume_visual_update_delta(0.1, 0.08, 0.05)
    t.assert_eq(0.13, float(above.get("visual_delta", -1.0)), "0.05 + 0.08 = 0.13")
    t.assert_true(bool(above.get("should_emit", false)))
    var remainder: float = float(above.get("next_accumulator", -1.0))
    t.assert_true(absf(remainder - 0.03) < 0.001, "fmod(0.13, 0.1) = 0.03 (within float tolerance)")

    t.begin("CoopEntityVisuals.consume_visual_update_delta epsilon avoids early skip exactly at threshold")
    # The live code uses `accumulated + 0.0001 < interval` so an
    # accumulator of exactly `interval - 0.00005` should emit (within epsilon).
    var on_epsilon: Dictionary = CoopEntityVisuals.consume_visual_update_delta(0.1, 0.0, 0.099999, 0.0001)
    t.assert_true(bool(on_epsilon.get("should_emit", false)),
        "0.099999 + 0.0001 >= 0.1 -> emit (epsilon boundary)")
