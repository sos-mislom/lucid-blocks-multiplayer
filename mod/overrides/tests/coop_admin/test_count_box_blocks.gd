extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.count_box_blocks returns 1 for a single-block AABB")
    t.assert_eq(1, CoopAdmin.count_box_blocks(Vector3i(0, 0, 0), Vector3i(0, 0, 0)))
    t.assert_eq(1, CoopAdmin.count_box_blocks(Vector3i(-5, -5, -5), Vector3i(-5, -5, -5)))

    t.begin("CoopAdmin.count_box_blocks computes inclusive volume for cube selections")
    t.assert_eq(8, CoopAdmin.count_box_blocks(Vector3i(0, 0, 0), Vector3i(1, 1, 1)))
    t.assert_eq(27, CoopAdmin.count_box_blocks(Vector3i(0, 0, 0), Vector3i(2, 2, 2)))

    t.begin("CoopAdmin.count_box_blocks handles asymmetric AABBs")
    t.assert_eq(2 * 3 * 4, CoopAdmin.count_box_blocks(Vector3i(0, 0, 0), Vector3i(1, 2, 3)))

    t.begin("CoopAdmin.count_box_blocks handles negative-to-positive ranges")
    t.assert_eq(3 * 3 * 3, CoopAdmin.count_box_blocks(Vector3i(-1, -1, -1), Vector3i(1, 1, 1)))

    t.begin("CoopAdmin.count_box_blocks clamps inverted ranges to 0")
    t.assert_eq(0, CoopAdmin.count_box_blocks(Vector3i(5, 5, 5), Vector3i(0, 0, 0)))
    t.assert_eq(0, CoopAdmin.count_box_blocks(Vector3i(0, 10, 0), Vector3i(5, 5, 5)), "inverted on a single axis still yields zero")
