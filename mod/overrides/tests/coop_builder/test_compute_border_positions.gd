extends RefCounted

# CoopBuilder.compute_border_positions — pure perimeter walk.


func run(t: CoopTester) -> void:
    t.begin("CoopBuilder.compute_border_positions yields exactly perimeter cells")
    var positions: Array = CoopBuilder.compute_border_positions(Vector3i(0, 0, 0), Vector3i(2, 0, 2), 5, 1)
    var perimeter_set: Dictionary = {}
    for pos in positions:
        perimeter_set[pos] = true
    var expected: Array[Vector3i] = [
        Vector3i(0, 5, 0), Vector3i(1, 5, 0), Vector3i(2, 5, 0),
        Vector3i(0, 5, 2), Vector3i(1, 5, 2), Vector3i(2, 5, 2),
        Vector3i(0, 5, 1), Vector3i(2, 5, 1),
    ]
    t.assert_eq(expected.size(), perimeter_set.size(), "exactly the perimeter cell count")
    for pos in expected:
        t.assert_true(perimeter_set.has(pos), "missing perimeter cell %s" % str(pos))

    t.begin("CoopBuilder.compute_border_positions excludes interior cells")
    var interior_cell: Vector3i = Vector3i(1, 5, 1)
    t.assert_false(perimeter_set.has(interior_cell), "interior must be empty")

    t.begin("CoopBuilder.compute_border_positions emits no duplicate cells")
    t.assert_eq(positions.size(), perimeter_set.size(), "no duplicates")

    t.begin("CoopBuilder.compute_border_positions ordering: z-edges first per row, then x-edges interior")
    var rowwise: Array = CoopBuilder.compute_border_positions(Vector3i(0, 0, 0), Vector3i(2, 0, 2), 0, 1)
    # Per inner loop in the module: for each x in [0..2], emit z=0 then z=2; then for z in (1), emit x=0 then x=2.
    var expected_order: Array[Vector3i] = [
        Vector3i(0, 0, 0), Vector3i(0, 0, 2),
        Vector3i(1, 0, 0), Vector3i(1, 0, 2),
        Vector3i(2, 0, 0), Vector3i(2, 0, 2),
        Vector3i(0, 0, 1), Vector3i(2, 0, 1),
    ]
    t.assert_eq(expected_order.size(), rowwise.size())
    for i in range(expected_order.size()):
        t.assert_eq(expected_order[i], rowwise[i], "step %d" % i)

    t.begin("CoopBuilder.compute_border_positions stacks layers in base_y..base_y+height-1 order")
    var stacked: Array = CoopBuilder.compute_border_positions(Vector3i(0, 0, 0), Vector3i(1, 0, 1), 10, 2)
    # 2x2 footprint -> 4 cells per layer * 2 layers = 8 total
    t.assert_eq(8, stacked.size())
    t.assert_eq(10, (stacked[0] as Vector3i).y, "first layer at base_y")
    t.assert_eq(11, (stacked[stacked.size() - 1] as Vector3i).y, "last layer at base_y+height-1")

    t.begin("CoopBuilder.compute_border_positions returns empty for height=0")
    t.assert_eq(0, CoopBuilder.compute_border_positions(Vector3i(0, 0, 0), Vector3i(5, 0, 5), 0, 0).size())
