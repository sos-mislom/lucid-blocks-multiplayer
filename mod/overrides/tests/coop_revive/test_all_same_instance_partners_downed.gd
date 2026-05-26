extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.all_same_instance_partners_downed returns true when all partners in instance are downed")
    var all_downed: Dictionary = {
        1: {"name": "Host", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
        9: {"name": "Bob", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
    }
    t.assert_true(CoopRevive.all_same_instance_partners_downed(all_downed, "dimension:0", 5))

    t.begin("CoopRevive.all_same_instance_partners_downed returns false on first non-downed partner")
    var one_alive: Dictionary = {
        1: {"name": "Host", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
        9: {"name": "Bob", "active": true, "downed": false, "dimension_instance_key": "dimension:0"},
    }
    t.assert_false(CoopRevive.all_same_instance_partners_downed(one_alive, "dimension:0", 5))

    t.begin("CoopRevive.all_same_instance_partners_downed returns false when no partner exists")
    t.assert_false(CoopRevive.all_same_instance_partners_downed({}, "dimension:0", 5),
        "solo downed player cannot trigger double-down recovery")

    t.begin("CoopRevive.all_same_instance_partners_downed returns false when only own state present")
    var only_self: Dictionary = {
        5: {"name": "Alice", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
    }
    t.assert_false(CoopRevive.all_same_instance_partners_downed(only_self, "dimension:0", 5),
        "self is excluded; no partner found means false")

    t.begin("CoopRevive.all_same_instance_partners_downed skips inactive peers (not counted as partners)")
    var inactive_alive: Dictionary = {
        1: {"name": "Host", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
        9: {"name": "Bob", "active": false, "downed": false, "dimension_instance_key": "dimension:0"},
    }
    t.assert_true(CoopRevive.all_same_instance_partners_downed(inactive_alive, "dimension:0", 5),
        "Bob is disconnected/inactive so he is not a partner")

    t.begin("CoopRevive.all_same_instance_partners_downed skips peers in different instance")
    var split_inst: Dictionary = {
        1: {"name": "Host", "active": true, "downed": true, "dimension_instance_key": "dimension:0"},
        9: {"name": "Bob", "active": true, "downed": false, "dimension_instance_key": "pocket:bob"},
    }
    t.assert_true(CoopRevive.all_same_instance_partners_downed(split_inst, "dimension:0", 5),
        "Bob is in another instance so his alive state does not block recovery")
