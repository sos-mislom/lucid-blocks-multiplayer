extends RefCounted


func run(t: CoopTester) -> void:
    var inv_a: RefCounted = RefCounted.new()
    var inv_b: RefCounted = RefCounted.new()
    var pending: Dictionary = {
        1: {"action": "place", "inventory": inv_a, "inventory_index": 0},
        2: {"action": "place", "inventory": inv_a, "inventory_index": 0},
        3: {"action": "place", "inventory": inv_a, "inventory_index": 1},
        4: {"action": "break", "inventory": inv_a, "inventory_index": 0},
        5: {"action": "place", "inventory": inv_b, "inventory_index": 0},
    }

    t.begin("CoopWorldPredict.count_pending_place_reservations counts inv_a slot 0 place actions only")
    t.assert_eq(2, CoopWorldPredict.count_pending_place_reservations(pending, inv_a, 0))

    t.begin("CoopWorldPredict.count_pending_place_reservations skips non-place actions")
    t.assert_eq(1, CoopWorldPredict.count_pending_place_reservations(pending, inv_a, 1), "break at slot 0 not counted at slot 1")

    t.begin("CoopWorldPredict.count_pending_place_reservations identity-compares inventory ref")
    t.assert_eq(1, CoopWorldPredict.count_pending_place_reservations(pending, inv_b, 0))

    t.begin("CoopWorldPredict.count_pending_place_reservations null inventory -> 0")
    t.assert_eq(0, CoopWorldPredict.count_pending_place_reservations(pending, null, 0))

    t.begin("CoopWorldPredict.count_pending_place_reservations negative index -> 0")
    t.assert_eq(0, CoopWorldPredict.count_pending_place_reservations(pending, inv_a, -1))

    t.begin("CoopWorldPredict.count_pending_place_reservations skips non-Dictionary entries")
    var with_junk: Dictionary = {1: "garbage", 2: {"action": "place", "inventory": inv_a, "inventory_index": 0}}
    t.assert_eq(1, CoopWorldPredict.count_pending_place_reservations(with_junk, inv_a, 0))

    t.begin("CoopWorldPredict.count_pending_place_reservations empty dict -> 0")
    t.assert_eq(0, CoopWorldPredict.count_pending_place_reservations({}, inv_a, 0))
