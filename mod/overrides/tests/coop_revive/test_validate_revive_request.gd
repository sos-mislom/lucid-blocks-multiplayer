extends RefCounted


func _ok_sender() -> Dictionary:
    return {"name": "Alice", "dimension_instance_key": "dimension:0", "downed": false}


func _ok_target() -> Dictionary:
    return {"name": "Bob", "dimension_instance_key": "dimension:0", "downed": true}


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.validate_revive_request accepts valid request")
    var decision: Dictionary = CoopRevive.validate_revive_request(
        _ok_sender(),
        _ok_target(),
        7,
        Vector3.ZERO,
        Vector3(1.0, 0.0, 0.0),
        3.2,
    )
    t.assert_true(bool(decision.get("ok", false)))
    t.assert_eq("Alice", str(decision.get("reviver_name", "")))
    t.assert_eq("Bob", str(decision.get("target_name", "")))

    t.begin("CoopRevive.validate_revive_request rejects target_peer_id <= 0")
    var bad_id: Dictionary = CoopRevive.validate_revive_request(_ok_sender(), _ok_target(), 0, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_false(bool(bad_id.get("ok", true)))
    t.assert_eq(CoopRevive.FEEDBACK_GENERIC_FAILURE, str(bad_id.get("feedback", "")))

    t.begin("CoopRevive.validate_revive_request rejects negative target_peer_id")
    var neg_id: Dictionary = CoopRevive.validate_revive_request(_ok_sender(), _ok_target(), -3, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_false(bool(neg_id.get("ok", true)))

    t.begin("CoopRevive.validate_revive_request rejects empty sender_state")
    var no_sender: Dictionary = CoopRevive.validate_revive_request({}, _ok_target(), 7, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_false(bool(no_sender.get("ok", true)))
    t.assert_eq(CoopRevive.FEEDBACK_GENERIC_FAILURE, str(no_sender.get("feedback", "")))

    t.begin("CoopRevive.validate_revive_request rejects empty target_state")
    var no_target: Dictionary = CoopRevive.validate_revive_request(_ok_sender(), {}, 7, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_false(bool(no_target.get("ok", true)))

    t.begin("CoopRevive.validate_revive_request rejects when sender has empty instance key")
    var no_key_sender: Dictionary = {"name": "Alice", "dimension_instance_key": "", "downed": false}
    var empty_key: Dictionary = CoopRevive.validate_revive_request(no_key_sender, _ok_target(), 7, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_false(bool(empty_key.get("ok", true)))
    t.assert_eq(CoopRevive.FEEDBACK_NOT_SAME_AREA, str(empty_key.get("feedback", "")))

    t.begin("CoopRevive.validate_revive_request rejects when instance keys differ")
    var other_inst: Dictionary = {"name": "Bob", "dimension_instance_key": "pocket:bob", "downed": true}
    var diff_inst: Dictionary = CoopRevive.validate_revive_request(_ok_sender(), other_inst, 7, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_false(bool(diff_inst.get("ok", true)))
    t.assert_eq(CoopRevive.FEEDBACK_NOT_SAME_AREA, str(diff_inst.get("feedback", "")))

    t.begin("CoopRevive.validate_revive_request rejects when sender is downed")
    var downed_sender: Dictionary = {"name": "Alice", "dimension_instance_key": "dimension:0", "downed": true}
    var sender_down: Dictionary = CoopRevive.validate_revive_request(downed_sender, _ok_target(), 7, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_false(bool(sender_down.get("ok", true)))
    t.assert_eq(CoopRevive.FEEDBACK_SENDER_DOWNED, str(sender_down.get("feedback", "")))

    t.begin("CoopRevive.validate_revive_request rejects when target is not downed")
    var not_downed: Dictionary = {"name": "Bob", "dimension_instance_key": "dimension:0", "downed": false}
    var target_up: Dictionary = CoopRevive.validate_revive_request(_ok_sender(), not_downed, 7, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_false(bool(target_up.get("ok", true)))
    t.assert_eq(CoopRevive.FEEDBACK_TARGET_NOT_DOWNED, str(target_up.get("feedback", "")))

    t.begin("CoopRevive.validate_revive_request rejects when out of range")
    var far_away: Dictionary = CoopRevive.validate_revive_request(
        _ok_sender(),
        _ok_target(),
        7,
        Vector3.ZERO,
        Vector3(100.0, 0.0, 0.0),
        3.2,
    )
    t.assert_false(bool(far_away.get("ok", true)))
    t.assert_eq(CoopRevive.FEEDBACK_OUT_OF_RANGE, str(far_away.get("feedback", "")))

    t.begin("CoopRevive.validate_revive_request accepts at safe distance inside radius")
    var inside: Dictionary = CoopRevive.validate_revive_request(
        _ok_sender(),
        _ok_target(),
        7,
        Vector3.ZERO,
        Vector3(2.0, 0.0, 0.0),
        3.2,
    )
    t.assert_true(bool(inside.get("ok", false)), "distance=2.0 < radius=3.2 must accept")

    t.begin("CoopRevive.validate_revive_request defaults reviver_name to 'Partner' when sender has no name")
    var nameless_sender: Dictionary = {"dimension_instance_key": "dimension:0", "downed": false}
    var default_name: Dictionary = CoopRevive.validate_revive_request(nameless_sender, _ok_target(), 7, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_true(bool(default_name.get("ok", false)))
    t.assert_eq("Partner", str(default_name.get("reviver_name", "")))

    t.begin("CoopRevive.validate_revive_request defaults target_name to 'partner' when target has no name")
    var nameless_target: Dictionary = {"dimension_instance_key": "dimension:0", "downed": true}
    var default_target: Dictionary = CoopRevive.validate_revive_request(_ok_sender(), nameless_target, 7, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_eq("partner", str(default_target.get("target_name", "")))

    t.begin("CoopRevive.validate_revive_request rejection order: bad id beats every state issue")
    var bad_id_priority: Dictionary = CoopRevive.validate_revive_request({}, {}, 0, Vector3.ZERO, Vector3.ZERO, 3.2)
    t.assert_eq(CoopRevive.FEEDBACK_GENERIC_FAILURE, str(bad_id_priority.get("feedback", "")),
        "target_peer_id <= 0 short-circuits before state checks")
