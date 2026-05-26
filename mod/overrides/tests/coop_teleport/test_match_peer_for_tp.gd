extends RefCounted


func _make_peer_states() -> Dictionary:
    return {
        1: {"name": "Host", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3.ZERO},
        5: {"name": "Alice", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(5, 0, 0)},
        9: {"name": "Bob", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(9, 0, 0)},
    }


func run(t: CoopTester) -> void:
    var peer_states: Dictionary = _make_peer_states()
    var own_peer_id: int = 9  # Bob is the local peer; we tp from Bob.

    t.begin("CoopTeleport.match_peer_for_tp 'host' matches peer_id 1")
    var matched_host: Dictionary = CoopTeleport.match_peer_for_tp("host", peer_states, own_peer_id)
    t.assert_true(bool(matched_host.get("ok", false)))
    t.assert_eq(1, int(matched_host.get("peer_id", -1)))

    t.begin("CoopTeleport.match_peer_for_tp 'HOST' (uppercase) matches peer 1 case-insensitive")
    var matched_caps: Dictionary = CoopTeleport.match_peer_for_tp("HOST", peer_states, own_peer_id)
    t.assert_true(bool(matched_caps.get("ok", false)))
    t.assert_eq(1, int(matched_caps.get("peer_id", -1)))

    t.begin("CoopTeleport.match_peer_for_tp 'p1' matches literal peer_id 1 (not index)")
    var matched_p1: Dictionary = CoopTeleport.match_peer_for_tp("p1", peer_states, own_peer_id)
    t.assert_true(bool(matched_p1.get("ok", false)))
    t.assert_eq(1, int(matched_p1.get("peer_id", -1)))

    t.begin("CoopTeleport.match_peer_for_tp 'p5' matches literal peer_id 5 (not index)")
    var matched_p5: Dictionary = CoopTeleport.match_peer_for_tp("p5", peer_states, own_peer_id)
    t.assert_true(bool(matched_p5.get("ok", false)))
    t.assert_eq(5, int(matched_p5.get("peer_id", -1)))

    t.begin("CoopTeleport.match_peer_for_tp numeric id '5' matches peer 5")
    var matched_id: Dictionary = CoopTeleport.match_peer_for_tp("5", peer_states, own_peer_id)
    t.assert_true(bool(matched_id.get("ok", false)))
    t.assert_eq(5, int(matched_id.get("peer_id", -1)))

    t.begin("CoopTeleport.match_peer_for_tp exact name match (case-insensitive)")
    var matched_exact: Dictionary = CoopTeleport.match_peer_for_tp("alice", peer_states, own_peer_id)
    t.assert_true(bool(matched_exact.get("ok", false)))
    t.assert_eq(5, int(matched_exact.get("peer_id", -1)))

    t.begin("CoopTeleport.match_peer_for_tp partial name match (contains)")
    var matched_contains: Dictionary = CoopTeleport.match_peer_for_tp("ali", peer_states, own_peer_id)
    t.assert_true(bool(matched_contains.get("ok", false)))
    t.assert_eq(5, int(matched_contains.get("peer_id", -1)))

    t.begin("CoopTeleport.match_peer_for_tp no match returns error_message with query")
    var miss: Dictionary = CoopTeleport.match_peer_for_tp("nope", peer_states, own_peer_id)
    t.assert_false(bool(miss.get("ok", true)))
    t.assert_eq("Peer not found: nope", str(miss.get("error_message", "")))

    t.begin("CoopTeleport.match_peer_for_tp excludes own peer (own name does NOT match self)")
    var self_miss: Dictionary = CoopTeleport.match_peer_for_tp("bob", peer_states, own_peer_id)
    t.assert_false(bool(self_miss.get("ok", true)), "matching own name returns no-match - self excluded")

    t.begin("CoopTeleport.match_peer_for_tp 'host' with no peer 1 -> no match (host alias is peer-1-only)")
    var no_host: Dictionary = CoopTeleport.match_peer_for_tp("host", {5: {"name": "Alice", "active": true}}, own_peer_id)
    t.assert_false(bool(no_host.get("ok", true)))

    t.begin("CoopTeleport.match_peer_for_tp returns the peer_state dictionary on hit")
    var with_state: Dictionary = CoopTeleport.match_peer_for_tp("alice", peer_states, own_peer_id)
    var returned_state: Dictionary = with_state.get("peer_state", {})
    t.assert_eq("Alice", str(returned_state.get("name", "")))
    t.assert_eq(Vector3(5, 0, 0), returned_state.get("position", Vector3.ZERO))
