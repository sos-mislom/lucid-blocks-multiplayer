extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPredict.make_pending_action_record builds the canonical schema")
    var fake_inv: RefCounted = RefCounted.new()
    var rec: Dictionary = CoopWorldPredict.make_pending_action_record(
        "place",
        Vector3i(1, 2, 3),
        42,
        fake_inv,
        7,
        {"saved": "snapshot"},
        1234,
    )
    t.assert_eq("place", str(rec.get("action", "")))
    t.assert_eq(Vector3i(1, 2, 3), rec.get("position", Vector3i.ZERO))
    t.assert_eq(42, int(rec.get("block_id", -1)))
    t.assert_eq(fake_inv, rec.get("inventory", null))
    t.assert_eq(7, int(rec.get("inventory_index", -1)))
    t.assert_eq("snapshot", str(rec.get("inventory_snapshot", {}).get("saved", "")))
    t.assert_eq(1234, int(rec.get("created_ms", -1)))

    t.begin("CoopWorldPredict.make_pending_action_record null inventory + empty snapshot accepted")
    var rec2: Dictionary = CoopWorldPredict.make_pending_action_record("break", Vector3i.ZERO, 0, null, -1, {}, 5000)
    t.assert_eq(null, rec2.get("inventory", "non-null"))
    t.assert_eq(-1, int(rec2.get("inventory_index", 99)))
    t.assert_eq(0, rec2.get("inventory_snapshot", {}).size())
