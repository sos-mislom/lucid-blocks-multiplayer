extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDimensionTravel.STATUS_REQUESTING_WORLD_SYNC pinned")
    t.assert_eq("Requesting world sync", CoopDimensionTravel.STATUS_REQUESTING_WORLD_SYNC)

    t.begin("CoopDimensionTravel.STATUS_WAITING_FOR_HOST_TELEPORT pinned")
    t.assert_eq("Waiting for host teleport", CoopDimensionTravel.STATUS_WAITING_FOR_HOST_TELEPORT)

    t.begin("CoopDimensionTravel.STATUS_OPENING_DIMENSION_TEMPLATE pinned (with %s placeholder)")
    t.assert_eq("Opening dimension %s", CoopDimensionTravel.STATUS_OPENING_DIMENSION_TEMPLATE)
    t.assert_eq("Opening dimension 5", CoopDimensionTravel.STATUS_OPENING_DIMENSION_TEMPLATE % 5, "template formats with int")

    t.begin("CoopDimensionTravel.STATUS_DIMENSION_SYNCED pinned")
    t.assert_eq("Dimension synced", CoopDimensionTravel.STATUS_DIMENSION_SYNCED)

    t.begin("CoopDimensionTravel.STATUS_RETURNED_TO_SPAWN pinned")
    t.assert_eq("Returned to spawn", CoopDimensionTravel.STATUS_RETURNED_TO_SPAWN)

    t.begin("CoopDimensionTravel.RESPAWN_ANCHOR_CENTER_OFFSET pinned to half-block X/Z")
    t.assert_eq(Vector3(0.5, 0.0, 0.5), CoopDimensionTravel.RESPAWN_ANCHOR_CENTER_OFFSET)
