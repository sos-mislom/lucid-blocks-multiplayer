extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntityVisuals.worm_segment_target_count floors at 1")
    t.assert_eq(1, CoopEntityVisuals.worm_segment_target_count(0))
    t.assert_eq(1, CoopEntityVisuals.worm_segment_target_count(-5))
    t.assert_eq(1, CoopEntityVisuals.worm_segment_target_count(1))

    t.begin("CoopEntityVisuals.worm_segment_target_count passes through positive values")
    t.assert_eq(2, CoopEntityVisuals.worm_segment_target_count(2))
    t.assert_eq(99, CoopEntityVisuals.worm_segment_target_count(99))
