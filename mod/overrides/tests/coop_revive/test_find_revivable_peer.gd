extends RefCounted


func _make_states() -> Dictionary:
    return {
        1: {"name": "Host", "active": true, "downed": true, "dimension_instance_key": "dimension:0", "position": Vector3(0, 0, 0)},
        7: {"name": "Carla", "active": true, "downed": true, "dimension_instance_key": "dimension:0", "position": Vector3(2, 0, 0)},
        9: {"name": "Bob", "active": true, "downed": false, "dimension_instance_key": "dimension:0", "position": Vector3(1, 0, 0)},
    }


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.find_revivable_peer picks nearest downed peer within radius")
    var near_carla: Dictionary = CoopRevive.find_revivable_peer(_make_states(), Vector3(2.5, 0, 0), 5, 3.2, "dimension:0")
    t.assert_eq(7, int(near_carla.get("peer_id", -1)), "Carla at (2,0,0) is nearer than Host at (0,0,0)")
    t.assert_eq("Carla", str(near_carla.get("name", "")))

    t.begin("CoopRevive.find_revivable_peer ignores non-downed peer (Bob is alive)")
    var picked: Dictionary = CoopRevive.find_revivable_peer(_make_states(), Vector3(1, 0, 0), 5, 3.2, "dimension:0")
    t.assert_ne(9, int(picked.get("peer_id", -1)), "Bob is alive, must not be returned")

    t.begin("CoopRevive.find_revivable_peer returns {} when no downed peer is in radius")
    var states_far: Dictionary = {
        7: {"name": "Carla", "active": true, "downed": true, "dimension_instance_key": "dimension:0", "position": Vector3(100, 0, 0)},
    }
    var empty: Dictionary = CoopRevive.find_revivable_peer(states_far, Vector3.ZERO, 5, 3.2, "dimension:0")
    t.assert_true(empty.is_empty())

    t.begin("CoopRevive.find_revivable_peer excludes own_peer_id")
    var only_self: Dictionary = {
        5: {"name": "Alice", "active": true, "downed": true, "dimension_instance_key": "dimension:0", "position": Vector3.ZERO},
    }
    var none: Dictionary = CoopRevive.find_revivable_peer(only_self, Vector3.ZERO, 5, 3.2, "dimension:0")
    t.assert_true(none.is_empty(), "self may be downed but cannot revive self")

    t.begin("CoopRevive.find_revivable_peer skips wrong-instance peer")
    var wrong_inst: Dictionary = {
        7: {"name": "Carla", "active": true, "downed": true, "dimension_instance_key": "pocket:carla", "position": Vector3(0, 0, 0)},
    }
    var miss: Dictionary = CoopRevive.find_revivable_peer(wrong_inst, Vector3.ZERO, 5, 3.2, "dimension:0")
    t.assert_true(miss.is_empty())

    t.begin("CoopRevive.find_revivable_peer skips inactive peer")
    var inactive: Dictionary = {
        7: {"name": "Carla", "active": false, "downed": true, "dimension_instance_key": "dimension:0", "position": Vector3.ZERO},
    }
    var skip: Dictionary = CoopRevive.find_revivable_peer(inactive, Vector3.ZERO, 5, 3.2, "dimension:0")
    t.assert_true(skip.is_empty())

    t.begin("CoopRevive.find_revivable_peer result is deep-copied (mutating result does not poison source)")
    var states_for_copy: Dictionary = _make_states()
    var picked_copy: Dictionary = CoopRevive.find_revivable_peer(states_for_copy, Vector3(0, 0, 0), 5, 3.2, "dimension:0")
    picked_copy["name"] = "MUTATED"
    t.assert_eq("Host", str(states_for_copy[1].get("name", "")), "original peer_states unchanged")

    t.begin("CoopRevive.find_revivable_peer result Dictionary has peer_id key added")
    var picked2: Dictionary = CoopRevive.find_revivable_peer(_make_states(), Vector3.ZERO, 5, 3.2, "dimension:0")
    t.assert_true(picked2.has("peer_id"))
    t.assert_eq(1, int(picked2.get("peer_id", -1)), "Host at (0,0,0) is nearest to origin")

    t.begin("CoopRevive.find_revivable_peer rejects peer outside radius")
    var beyond: Dictionary = {
        7: {"name": "Carla", "active": true, "downed": true, "dimension_instance_key": "dimension:0", "position": Vector3(4.0, 0, 0)},
    }
    var rejected: Dictionary = CoopRevive.find_revivable_peer(beyond, Vector3.ZERO, 5, 3.2, "dimension:0")
    t.assert_true(rejected.is_empty(), "Carla at distance=4.0 > radius=3.2 must miss")

    t.begin("CoopRevive.find_revivable_peer accepts peer comfortably inside radius")
    var inside: Dictionary = {
        7: {"name": "Carla", "active": true, "downed": true, "dimension_instance_key": "dimension:0", "position": Vector3(2.0, 0, 0)},
    }
    var accepted: Dictionary = CoopRevive.find_revivable_peer(inside, Vector3.ZERO, 5, 3.2, "dimension:0")
    t.assert_eq(7, int(accepted.get("peer_id", -1)), "Carla at distance=2.0 < radius=3.2 must match")
