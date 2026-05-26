extends RefCounted


func _make_states() -> Dictionary:
    return {
        1: {"name": "Host", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(1, 1, 1)},
        5: {"name": "Alice", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(5, 5, 5)},
        9: {"name": "Bob", "active": true, "dimension_instance_key": "pocket:bob", "position": Vector3(9, 9, 9)},
    }


func run(t: CoopTester) -> void:
    var states: Dictionary = _make_states()
    var own_peer_id: int = 5  # Alice is the local peer.

    t.begin("CoopDimensionTravel.select_active_peer_in_instance finds host in dimension:0 (excludes Alice = self)")
    var found_host: Dictionary = CoopDimensionTravel.select_active_peer_in_instance(states, "dimension:0", own_peer_id)
    t.assert_true(bool(found_host.get("found", false)))
    t.assert_eq(1, int(found_host.get("peer_id", -1)))
    t.assert_eq(Vector3(1, 1, 1), found_host.get("position", Vector3.ZERO))

    t.begin("CoopDimensionTravel.select_active_peer_in_instance no peer in target instance -> found:false")
    var no_match: Dictionary = CoopDimensionTravel.select_active_peer_in_instance(states, "dimension:999", own_peer_id)
    t.assert_false(bool(no_match.get("found", true)))

    t.begin("CoopDimensionTravel.select_active_peer_in_instance inactive peer skipped")
    var with_inactive: Dictionary = states.duplicate(true)
    with_inactive[1]["active"] = false
    var miss: Dictionary = CoopDimensionTravel.select_active_peer_in_instance(with_inactive, "dimension:0", own_peer_id)
    t.assert_false(bool(miss.get("found", true)), "host inactive, Alice self -> nobody in dimension:0")

    t.begin("CoopDimensionTravel.select_active_peer_in_instance peer in wrong instance skipped")
    var bob_only: Dictionary = CoopDimensionTravel.select_active_peer_in_instance(states, "pocket:bob", own_peer_id)
    t.assert_true(bool(bob_only.get("found", false)))
    t.assert_eq(9, int(bob_only.get("peer_id", -1)))

    t.begin("CoopDimensionTravel.select_active_peer_in_instance own_peer_id always excluded")
    var alice_query: Dictionary = CoopDimensionTravel.select_active_peer_in_instance(states, "dimension:0", own_peer_id)
    t.assert_eq(1, int(alice_query.get("peer_id", -1)), "Alice (peer 5) is self; result must be host (peer 1)")

    t.begin("CoopDimensionTravel.select_active_peer_in_instance missing position defaults to Vector3.ZERO")
    var no_pos_states: Dictionary = {7: {"active": true, "dimension_instance_key": "dimension:0"}}
    var no_pos: Dictionary = CoopDimensionTravel.select_active_peer_in_instance(no_pos_states, "dimension:0", own_peer_id)
    t.assert_true(bool(no_pos.get("found", false)))
    t.assert_eq(Vector3.ZERO, no_pos.get("position", Vector3.ONE))

    t.begin("CoopDimensionTravel.select_active_peer_in_instance first-hit semantics preserved (no sort)")
    # Two matching peers; the iteration is dict-order so the first match wins. We can't guarantee
    # specific peer_id here in GDScript dicts (insertion order), but we can confirm exactly one match
    # returns and it's one of the two valid ones.
    var two_match: Dictionary = {
        3: {"active": true, "dimension_instance_key": "dimension:0", "position": Vector3(3, 0, 0)},
        4: {"active": true, "dimension_instance_key": "dimension:0", "position": Vector3(4, 0, 0)},
    }
    var first: Dictionary = CoopDimensionTravel.select_active_peer_in_instance(two_match, "dimension:0", own_peer_id)
    t.assert_true(bool(first.get("found", false)))
    var matched_id: int = int(first.get("peer_id", -1))
    t.assert_true(matched_id == 3 or matched_id == 4)
