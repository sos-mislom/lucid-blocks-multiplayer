extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPredict.CLIENT_ACTION_SEQUENCE_MAX pinned to 2_147_480_000 (just under INT32_MAX)")
    t.assert_eq(2147480000, CoopWorldPredict.CLIENT_ACTION_SEQUENCE_MAX)
    t.assert_true(CoopWorldPredict.CLIENT_ACTION_SEQUENCE_MAX < 2147483647, "must stay below INT32_MAX")
