extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.REVIVE_RADIUS pinned to 3.2m")
    t.assert_eq(3.2, CoopRevive.REVIVE_RADIUS)

    t.begin("CoopRevive.REVIVE_HOLD_TIME pinned to 1.6s")
    t.assert_eq(1.6, CoopRevive.REVIVE_HOLD_TIME)

    t.begin("CoopRevive.DOWNED_VOID_Y pinned to -96.0")
    t.assert_eq(-96.0, CoopRevive.DOWNED_VOID_Y)

    t.begin("CoopRevive.DOWNED_REVIVER_GRACE_SEC pinned to 2.0s")
    t.assert_eq(2.0, CoopRevive.DOWNED_REVIVER_GRACE_SEC)

    t.begin("CoopRevive.RESPAWN_BLOCK_CENTER_OFFSET pinned to half-block X/Z")
    t.assert_eq(Vector3(0.5, 0.0, 0.5), CoopRevive.RESPAWN_BLOCK_CENTER_OFFSET)

    t.begin("CoopRevive.FEEDBACK_GENERIC_FAILURE pinned")
    t.assert_eq("Revive failed", CoopRevive.FEEDBACK_GENERIC_FAILURE)

    t.begin("CoopRevive.FEEDBACK_NOT_SAME_AREA pinned")
    t.assert_eq("Revive failed: not in the same area", CoopRevive.FEEDBACK_NOT_SAME_AREA)

    t.begin("CoopRevive.FEEDBACK_SENDER_DOWNED pinned")
    t.assert_eq("Revive failed: you are downed", CoopRevive.FEEDBACK_SENDER_DOWNED)

    t.begin("CoopRevive.FEEDBACK_TARGET_NOT_DOWNED pinned")
    t.assert_eq("Revive failed: target is already up", CoopRevive.FEEDBACK_TARGET_NOT_DOWNED)

    t.begin("CoopRevive.FEEDBACK_OUT_OF_RANGE pinned")
    t.assert_eq("Revive failed: get closer", CoopRevive.FEEDBACK_OUT_OF_RANGE)
