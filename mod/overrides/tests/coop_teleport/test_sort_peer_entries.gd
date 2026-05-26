extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopTeleport.sort_peer_entries ascending by peer_id")
    t.assert_true(CoopTeleport.sort_peer_entries({"peer_id": 5}, {"peer_id": 9}))
    t.assert_false(CoopTeleport.sort_peer_entries({"peer_id": 9}, {"peer_id": 5}))

    t.begin("CoopTeleport.sort_peer_entries equal peer_ids -> false (strict less)")
    t.assert_false(CoopTeleport.sort_peer_entries({"peer_id": 5}, {"peer_id": 5}))

    t.begin("CoopTeleport.sort_peer_entries missing peer_id defaults to 0")
    t.assert_true(CoopTeleport.sort_peer_entries({}, {"peer_id": 1}), "missing key on left -> 0 < 1")
    t.assert_false(CoopTeleport.sort_peer_entries({"peer_id": 1}, {}), "missing key on right -> 1 < 0 false")

    t.begin("CoopTeleport.sort_peer_entries coerces peer_id strings via int()")
    t.assert_true(CoopTeleport.sort_peer_entries({"peer_id": "5"}, {"peer_id": "9"}))

    t.begin("CoopTeleport.sort_peer_entries sort_custom integration produces ascending peer_id order")
    var entries: Array = [{"peer_id": 9}, {"peer_id": 1}, {"peer_id": 5}]
    entries.sort_custom(Callable(CoopTeleport, "sort_peer_entries"))
    t.assert_eq(1, int(entries[0].get("peer_id", -1)))
    t.assert_eq(5, int(entries[1].get("peer_id", -1)))
    t.assert_eq(9, int(entries[2].get("peer_id", -1)))
