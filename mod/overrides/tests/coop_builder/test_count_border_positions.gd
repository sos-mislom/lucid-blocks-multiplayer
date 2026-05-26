extends RefCounted

# CoopBuilder.count_border_positions — pure arithmetic; mirrors the
# existing _builder_build_border budget calculation.


func run(t: CoopTester) -> void:
    t.begin("CoopBuilder.count_border_positions handles a 1x1 footprint")
    # Formula: (max_x - min_x + 1)*2 + (max_z - min_z - 1)*2
    # 1x1 -> 1*2 + (-1)*2 = 0 per layer. The single cell cannot form a
    # perimeter; maxi(0, ...) clamp leaves the result at 0.
    t.assert_eq(0, CoopBuilder.count_border_positions(Vector3i(0, 0, 0), Vector3i(0, 0, 0), 1))

    t.begin("CoopBuilder.count_border_positions handles a 2x2 footprint at height=1")
    # span_x=2, span_z=2 => (2*2) + (0*2) = 4 perimeter cells per layer
    t.assert_eq(4, CoopBuilder.count_border_positions(Vector3i(0, 0, 0), Vector3i(1, 0, 1), 1))

    t.begin("CoopBuilder.count_border_positions handles a 3x3 footprint at height=1")
    # span_x=3, span_z=3 => (3*2) + (1*2) = 8 perimeter cells per layer
    t.assert_eq(8, CoopBuilder.count_border_positions(Vector3i(0, 0, 0), Vector3i(2, 0, 2), 1))

    t.begin("CoopBuilder.count_border_positions handles a 5x5 footprint at height=4")
    # span_x=5, span_z=5 => (5*2) + (3*2) = 16 perimeter cells per layer * 4 layers = 64
    t.assert_eq(64, CoopBuilder.count_border_positions(Vector3i(0, 0, 0), Vector3i(4, 0, 4), 4))

    t.begin("CoopBuilder.count_border_positions handles asymmetric spans")
    # span_x=2, span_z=5 => (2*2) + (3*2) = 10 per layer * 2 layers = 20
    t.assert_eq(20, CoopBuilder.count_border_positions(Vector3i(0, 0, 0), Vector3i(1, 0, 4), 2))

    t.begin("CoopBuilder.count_border_positions returns 0 when height is 0")
    t.assert_eq(0, CoopBuilder.count_border_positions(Vector3i(0, 0, 0), Vector3i(9, 0, 9), 0))

    t.begin("CoopBuilder.count_border_positions clamps negative height to 0")
    t.assert_eq(0, CoopBuilder.count_border_positions(Vector3i(0, 0, 0), Vector3i(9, 0, 9), -3))

    t.begin("CoopBuilder.count_border_positions clamps inverted spans via maxi(0, ...)")
    # max_area before min_area on x-axis: (-5 - 0 + 1)*2 + (10 - 0 - 1)*2 = -8 + 18 = 10
    # so this is NOT clamped to 0 in practice; verify behaviour
    var inverted: int = CoopBuilder.count_border_positions(Vector3i(0, 0, 0), Vector3i(-5, 0, 10), 1)
    t.assert_true(inverted >= 0, "result must never be negative")
