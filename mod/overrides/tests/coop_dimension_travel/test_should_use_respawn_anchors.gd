extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDimensionTravel.should_use_respawn_anchors not wandering + anchors present -> true")
    t.assert_true(CoopDimensionTravel.should_use_respawn_anchors(false, false))

    t.begin("CoopDimensionTravel.should_use_respawn_anchors not wandering + no anchors -> false")
    t.assert_false(CoopDimensionTravel.should_use_respawn_anchors(false, true))

    t.begin("CoopDimensionTravel.should_use_respawn_anchors wandering spirit + anchors present -> false")
    t.assert_false(CoopDimensionTravel.should_use_respawn_anchors(true, false))

    t.begin("CoopDimensionTravel.should_use_respawn_anchors wandering spirit + no anchors -> false")
    t.assert_false(CoopDimensionTravel.should_use_respawn_anchors(true, true))
