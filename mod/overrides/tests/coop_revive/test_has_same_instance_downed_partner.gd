extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.has_same_instance_downed_partner finds downed peer in instance")
    var with_downed: Dictionary = {
        1: {"name": "Host", "active": true, "downed": false, "dimension_instance_key": "dimension:0"},
        9: {"name": "Bob", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
    }
    t.assert_true(CoopRevive.has_same_instance_downed_partner(with_downed, "dimension:0"))

    t.begin("CoopRevive.has_same_instance_downed_partner returns false when no peer is downed")
    var none_downed: Dictionary = {
        1: {"name": "Host", "active": true, "downed": false, "dimension_instance_key": "dimension:0"},
        5: {"name": "Alice", "active": true, "downed": false, "dimension_instance_key": "dimension:0"},
    }
    t.assert_false(CoopRevive.has_same_instance_downed_partner(none_downed, "dimension:0"))

    t.begin("CoopRevive.has_same_instance_downed_partner skips inactive downed peer")
    var inactive_downed: Dictionary = {
        9: {"name": "Bob", "active": false, "downed": true, "dimension_instance_key": "dimension:0"},
    }
    t.assert_false(CoopRevive.has_same_instance_downed_partner(inactive_downed, "dimension:0"),
        "inactive peer is not considered (dead/disconnected players are not partners)")

    t.begin("CoopRevive.has_same_instance_downed_partner skips downed peer in different instance")
    var wrong_inst_downed: Dictionary = {
        9: {"name": "Bob", "active": true, "downed": true, "dimension_instance_key": "pocket:bob"},
    }
    t.assert_false(CoopRevive.has_same_instance_downed_partner(wrong_inst_downed, "dimension:0"))

    t.begin("CoopRevive.has_same_instance_downed_partner excludes ignore_peer_id")
    var only_self_downed: Dictionary = {
        5: {"name": "Alice", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
    }
    t.assert_false(CoopRevive.has_same_instance_downed_partner(only_self_downed, "dimension:0", 5),
        "own downed state should never be counted as a partner downed")

    t.begin("CoopRevive.has_same_instance_downed_partner empty peer_states returns false")
    t.assert_false(CoopRevive.has_same_instance_downed_partner({}, "dimension:0"))
