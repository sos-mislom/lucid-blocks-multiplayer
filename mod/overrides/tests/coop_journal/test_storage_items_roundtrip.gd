extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJournal.storage_items_to_json converts PackedInt32Array entries to Array")
    var item_a: PackedInt32Array = PackedInt32Array([42, 1, 99])
    var item_b: PackedInt32Array = PackedInt32Array([7])
    var to_json: Array = CoopJournal.storage_items_to_json([item_a, item_b])
    t.assert_eq(2, to_json.size())
    t.assert_true(to_json[0] is Array, "entries must be Array (JSON-friendly)")
    t.assert_eq(3, (to_json[0] as Array).size())
    t.assert_eq(42, (to_json[0] as Array)[0])

    t.begin("CoopJournal.storage_items_from_json reconstructs PackedInt32Array")
    var rebuilt: Array = CoopJournal.storage_items_from_json(to_json)
    t.assert_eq(2, rebuilt.size())
    t.assert_true(rebuilt[0] is PackedInt32Array, "must rebuild PackedInt32Array")
    t.assert_eq_packed_int32_array(item_a, rebuilt[0])
    t.assert_eq_packed_int32_array(item_b, rebuilt[1])

    t.begin("CoopJournal.storage_items_to_json keeps Array entries as Array")
    var mixed: Array = CoopJournal.storage_items_to_json([[1, 2, 3], PackedInt32Array([4, 5])])
    t.assert_eq(2, mixed.size())
    t.assert_true(mixed[0] is Array)
    t.assert_eq(1, (mixed[0] as Array)[0])

    t.begin("CoopJournal.storage_items_to_json falls back to empty Array for unknown entries")
    var with_garbage: Array = CoopJournal.storage_items_to_json([PackedInt32Array([1]), "garbage", null])
    t.assert_eq(3, with_garbage.size())
    t.assert_true((with_garbage[1] as Array).is_empty(), "non-array entry should become empty Array")

    t.begin("CoopJournal.storage_items_from_json returns empty Array on non-Array input")
    t.assert_eq(0, CoopJournal.storage_items_from_json("not-an-array").size())
    t.assert_eq(0, CoopJournal.storage_items_from_json(null).size())
    t.assert_eq(0, CoopJournal.storage_items_from_json(42).size())

    t.begin("CoopJournal.storage_items_from_json passes PackedInt32Array entries through")
    var arr: Array = CoopJournal.storage_items_from_json([PackedInt32Array([1, 2])])
    t.assert_eq(1, arr.size())
    t.assert_eq_packed_int32_array(PackedInt32Array([1, 2]), arr[0])
