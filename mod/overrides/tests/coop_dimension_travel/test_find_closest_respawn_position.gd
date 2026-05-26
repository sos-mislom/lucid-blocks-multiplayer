extends RefCounted


func run(t: CoopTester) -> void:
    var origin: Vector3 = Vector3(10, 0, 10)

    t.begin("CoopDimensionTravel.find_closest_respawn_position empty list -> origin unchanged")
    t.assert_eq(origin, CoopDimensionTravel.find_closest_respawn_position([], origin))

    t.begin("CoopDimensionTravel.find_closest_respawn_position single anchor returns that anchor centered")
    var single: Vector3 = CoopDimensionTravel.find_closest_respawn_position([Vector3i(5, 0, 5)], origin)
    t.assert_eq(Vector3(5, 0, 5) + Vector3(0.5, 0.0, 0.5), single, "anchor + half-block center offset")

    t.begin("CoopDimensionTravel.find_closest_respawn_position picks closest by Euclidean distance")
    var anchors: Array = [Vector3i(100, 0, 100), Vector3i(9, 0, 11), Vector3i(50, 0, 50)]
    var closest: Vector3 = CoopDimensionTravel.find_closest_respawn_position(anchors, origin)
    t.assert_eq(Vector3(9, 0, 11) + Vector3(0.5, 0.0, 0.5), closest)

    t.begin("CoopDimensionTravel.find_closest_respawn_position equidistant -> first-seen wins (< comparison)")
    # Two anchors equidistant from origin (sqrt(2) each). First in list must win.
    var equi: Array = [Vector3i(11, 0, 11), Vector3i(9, 0, 9)]
    var equi_result: Vector3 = CoopDimensionTravel.find_closest_respawn_position(equi, origin)
    t.assert_eq(Vector3(11, 0, 11) + Vector3(0.5, 0.0, 0.5), equi_result, "first-seen wins on tie")

    t.begin("CoopDimensionTravel.find_closest_respawn_position uses RESPAWN_ANCHOR_CENTER_OFFSET constant")
    var via_const: Vector3 = CoopDimensionTravel.find_closest_respawn_position([Vector3i(0, 0, 0)], Vector3.ZERO)
    t.assert_eq(Vector3.ZERO + CoopDimensionTravel.RESPAWN_ANCHOR_CENTER_OFFSET, via_const)

    t.begin("CoopDimensionTravel.find_closest_respawn_position handles negative coordinates")
    var neg: Array = [Vector3i(-3, 0, -3), Vector3i(-1, 0, -1)]
    var neg_origin: Vector3 = Vector3(-2, 0, -2)
    var neg_result: Vector3 = CoopDimensionTravel.find_closest_respawn_position(neg, neg_origin)
    # Both anchors equidistant (sqrt(2)); first wins.
    t.assert_eq(Vector3(-3, 0, -3) + Vector3(0.5, 0.0, 0.5), neg_result)

    t.begin("CoopDimensionTravel.find_closest_respawn_position scan finds anchor late in list")
    var late: Array = [Vector3i(100, 0, 100), Vector3i(99, 0, 99), Vector3i(10, 0, 10)]
    var late_result: Vector3 = CoopDimensionTravel.find_closest_respawn_position(late, origin)
    t.assert_eq(Vector3(10, 0, 10) + Vector3(0.5, 0.0, 0.5), late_result)
