extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPredict.next_action_id increments by 1")
    t.assert_eq(1, CoopWorldPredict.next_action_id(0))
    t.assert_eq(42, CoopWorldPredict.next_action_id(41))

    t.begin("CoopWorldPredict.next_action_id wraps to 1 at max")
    t.assert_eq(1, CoopWorldPredict.next_action_id(CoopWorldPredict.CLIENT_ACTION_SEQUENCE_MAX - 1),
        "next would be == max -> wrap to 1 (live `>=` comparison)")
    t.assert_eq(1, CoopWorldPredict.next_action_id(CoopWorldPredict.CLIENT_ACTION_SEQUENCE_MAX))

    t.begin("CoopWorldPredict.next_action_id wraps to 1 (never 0)")
    var wrapped: int = CoopWorldPredict.next_action_id(2147479999)
    t.assert_eq(1, wrapped, "0 is reserved for 'no action'")

    t.begin("CoopWorldPredict.next_action_id custom max_sequence honored")
    t.assert_eq(1, CoopWorldPredict.next_action_id(9, 10))
    t.assert_eq(3, CoopWorldPredict.next_action_id(2, 100))
