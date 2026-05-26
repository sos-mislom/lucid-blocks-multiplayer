extends RefCounted


func _baseline() -> Dictionary:
    return CoopEntitySync.build_host_entity_snapshot_state(
        "res://entities/chicken.tscn",
        Vector3(0.0, 0.0, 0.0),
        0.0,
        Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO,
        false, false, -1, 0,
    )


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed empty previous -> changed")
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed({}, _baseline()))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed identical -> NOT changed")
    t.assert_false(CoopEntitySync.is_host_entity_snapshot_state_changed(_baseline(), _baseline()))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed scene swap -> changed")
    var prev_scene: Dictionary = _baseline()
    var next_scene: Dictionary = _baseline()
    next_scene["scene"] = "res://entities/sheep.tscn"
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(prev_scene, next_scene))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed dead flag flip -> changed")
    var dead_prev: Dictionary = _baseline()
    var dead_next: Dictionary = _baseline()
    dead_next["dead"] = true
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(dead_prev, dead_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed disabled flag flip -> changed")
    var dis_prev: Dictionary = _baseline()
    var dis_next: Dictionary = _baseline()
    dis_next["disabled"] = true
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(dis_prev, dis_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed held_item_id swap -> changed")
    var hid_prev: Dictionary = _baseline()
    var hid_next: Dictionary = _baseline()
    hid_next["held_item_id"] = 7
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(hid_prev, hid_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed held_item_index swap -> changed")
    var hii_prev: Dictionary = _baseline()
    var hii_next: Dictionary = _baseline()
    hii_next["held_item_index"] = 4
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(hii_prev, hii_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed small position drift inside threshold -> NOT changed")
    var pos_small_prev: Dictionary = _baseline()
    var pos_small_next: Dictionary = _baseline()
    # ENTITY_DR_POS_ERR_SQ = 0.0225 (15 cm). 5 cm move -> sq=0.0025, under threshold.
    pos_small_next["position"] = Vector3(0.05, 0.0, 0.0)
    t.assert_false(CoopEntitySync.is_host_entity_snapshot_state_changed(pos_small_prev, pos_small_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed large position drift -> changed")
    var pos_big_prev: Dictionary = _baseline()
    var pos_big_next: Dictionary = _baseline()
    # 30 cm move -> sq=0.09, well above 0.0225.
    pos_big_next["position"] = Vector3(0.3, 0.0, 0.0)
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(pos_big_prev, pos_big_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed yaw drift past threshold (5 deg) -> changed")
    var yaw_prev: Dictionary = _baseline()
    var yaw_next: Dictionary = _baseline()
    yaw_next["yaw"] = deg_to_rad(10.0)
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(yaw_prev, yaw_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed yaw drift inside threshold -> NOT changed")
    var yaw_small_prev: Dictionary = _baseline()
    var yaw_small_next: Dictionary = _baseline()
    yaw_small_next["yaw"] = deg_to_rad(2.0)
    t.assert_false(CoopEntitySync.is_host_entity_snapshot_state_changed(yaw_small_prev, yaw_small_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed knockback above ENTITY_DR_KB_ERR_SQ -> changed")
    var kb_prev: Dictionary = _baseline()
    var kb_next: Dictionary = _baseline()
    # ENTITY_DR_KB_ERR_SQ = 0.25 (0.5 m/s squared). Use 1.0 m/s.
    kb_next["knockback_velocity"] = Vector3(1.0, 0.0, 0.0)
    t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(kb_prev, kb_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed small knockback inside threshold -> NOT changed")
    var kb_small_prev: Dictionary = _baseline()
    var kb_small_next: Dictionary = _baseline()
    kb_small_next["knockback_velocity"] = Vector3(0.1, 0.0, 0.0)
    t.assert_false(CoopEntitySync.is_host_entity_snapshot_state_changed(kb_small_prev, kb_small_next))

    t.begin("CoopEntitySync.is_host_entity_snapshot_state_changed every velocity channel is checked")
    for vel_key in ["movement_velocity", "gravity_velocity", "knockback_velocity", "rope_velocity"]:
        var v_prev: Dictionary = _baseline()
        var v_next: Dictionary = _baseline()
        v_next[vel_key] = Vector3(0.0, 2.0, 0.0)
        t.assert_true(CoopEntitySync.is_host_entity_snapshot_state_changed(v_prev, v_next),
            "%s channel change above kb_err_sq detected" % vel_key)
