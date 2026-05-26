extends RefCounted


func _make_states() -> Dictionary:
    return {
        1: {"name": "Host", "active": true, "downed": false, "dimension_instance_key": "dimension:0"},
        5: {"name": "Alice", "active": true, "downed": false, "dimension_instance_key": "dimension:0"},
        9: {"name": "Bob", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
    }


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.has_same_instance_reviver_available finds active+non-downed peer in instance")
    t.assert_true(CoopRevive.has_same_instance_reviver_available(_make_states(), "dimension:0"))

    t.begin("CoopRevive.has_same_instance_reviver_available skips downed peer")
    var only_downed: Dictionary = {
        9: {"name": "Bob", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
    }
    t.assert_false(CoopRevive.has_same_instance_reviver_available(only_downed, "dimension:0"))

    t.begin("CoopRevive.has_same_instance_reviver_available skips inactive peer")
    var inactive: Dictionary = {
        1: {"name": "Host", "active": false, "downed": false, "dimension_instance_key": "dimension:0"},
    }
    t.assert_false(CoopRevive.has_same_instance_reviver_available(inactive, "dimension:0"))

    t.begin("CoopRevive.has_same_instance_reviver_available skips wrong-instance peer")
    var wrong_inst: Dictionary = {
        1: {"name": "Host", "active": true, "downed": false, "dimension_instance_key": "pocket:other"},
    }
    t.assert_false(CoopRevive.has_same_instance_reviver_available(wrong_inst, "dimension:0"))

    t.begin("CoopRevive.has_same_instance_reviver_available excludes ignore_peer_id (self)")
    var self_only: Dictionary = {
        5: {"name": "Alice", "active": true, "downed": false, "dimension_instance_key": "dimension:0"},
    }
    t.assert_false(CoopRevive.has_same_instance_reviver_available(self_only, "dimension:0", 5),
        "self should never count as own reviver")
    t.assert_true(CoopRevive.has_same_instance_reviver_available(self_only, "dimension:0", -1),
        "default ignore_peer_id=-1 counts everyone")

    t.begin("CoopRevive.has_same_instance_reviver_available empty peer_states returns false")
    t.assert_false(CoopRevive.has_same_instance_reviver_available({}, "dimension:0"))

    t.begin("CoopRevive.has_same_instance_reviver_available missing dimension_instance_key treated as empty string")
    var no_key: Dictionary = {
        1: {"name": "Host", "active": true, "downed": false},
    }
    t.assert_false(CoopRevive.has_same_instance_reviver_available(no_key, "dimension:0"),
        "missing key never matches a non-empty instance_key")
    t.assert_true(CoopRevive.has_same_instance_reviver_available(no_key, ""),
        "missing key matches empty instance_key (defensive edge case)")
