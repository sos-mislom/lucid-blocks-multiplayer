extends RefCounted


func _make_state(extra: Dictionary = {}) -> Dictionary:
    var state: Dictionary = {
        "active": true,
        "downed": false,
        "dimension": 0,
        "dimension_instance_key": "overworld",
        "position": Vector3(1.0, 2.0, 3.0),
        "yaw": 0.5,
        "pitch": 0.25,
        "crouching": false,
        "grounded": true,
        "move_speed": 2.5,
        "held_item_id": 7,
        "action_state": 1,
        "breaking": false,
        "break_position": Vector3i(0, 0, 0),
        "break_block_id": 0,
        "break_progress": 0.0,
    }
    for key in extra.keys():
        state[key] = extra[key]
    return state


func run(t: CoopTester) -> void:
    t.begin("CoopPlayerSync.hash_client_state deterministic for identical states")
    var hash_a: int = CoopPlayerSync.hash_client_state(_make_state())
    var hash_b: int = CoopPlayerSync.hash_client_state(_make_state())
    t.assert_eq(hash_a, hash_b)

    t.begin("CoopPlayerSync.hash_client_state position quantizes at 1/20 block")
    # Sub-quantization changes don't move the hash (both round to 20).
    var hash_below: int = CoopPlayerSync.hash_client_state(_make_state({"position": Vector3(1.0, 2.0, 3.0)}))
    var hash_below_tiny: int = CoopPlayerSync.hash_client_state(_make_state({"position": Vector3(1.001, 2.0, 3.0)}))
    t.assert_eq(hash_below, hash_below_tiny)

    var hash_above: int = CoopPlayerSync.hash_client_state(_make_state({"position": Vector3(1.06, 2.0, 3.0)}))
    t.assert_eq(true, hash_below != hash_above)

    t.begin("CoopPlayerSync.hash_client_state yaw quantizes at 1/100")
    var hash_yaw_a: int = CoopPlayerSync.hash_client_state(_make_state({"yaw": 0.50}))
    var hash_yaw_b: int = CoopPlayerSync.hash_client_state(_make_state({"yaw": 0.504}))
    t.assert_eq(hash_yaw_a, hash_yaw_b)
    var hash_yaw_c: int = CoopPlayerSync.hash_client_state(_make_state({"yaw": 0.52}))
    t.assert_eq(true, hash_yaw_a != hash_yaw_c)

    t.begin("CoopPlayerSync.hash_client_state move_speed quantizes at 1/20")
    var hash_speed_a: int = CoopPlayerSync.hash_client_state(_make_state({"move_speed": 2.5}))
    var hash_speed_b: int = CoopPlayerSync.hash_client_state(_make_state({"move_speed": 2.51}))
    t.assert_eq(hash_speed_a, hash_speed_b)
    var hash_speed_c: int = CoopPlayerSync.hash_client_state(_make_state({"move_speed": 2.6}))
    t.assert_eq(true, hash_speed_a != hash_speed_c)

    t.begin("CoopPlayerSync.hash_client_state break_progress quantizes at 1/50")
    var hash_break_a: int = CoopPlayerSync.hash_client_state(_make_state({"break_progress": 0.50}))
    var hash_break_b: int = CoopPlayerSync.hash_client_state(_make_state({"break_progress": 0.501}))
    t.assert_eq(hash_break_a, hash_break_b)
    var hash_break_c: int = CoopPlayerSync.hash_client_state(_make_state({"break_progress": 0.54}))
    t.assert_eq(true, hash_break_a != hash_break_c)

    t.begin("CoopPlayerSync.hash_client_state booleans flip the hash")
    var hash_active: int = CoopPlayerSync.hash_client_state(_make_state({"active": true}))
    var hash_inactive: int = CoopPlayerSync.hash_client_state(_make_state({"active": false}))
    t.assert_eq(true, hash_active != hash_inactive)

    t.begin("CoopPlayerSync.hash_client_state held_item_id flips the hash")
    var hash_item_a: int = CoopPlayerSync.hash_client_state(_make_state({"held_item_id": 1}))
    var hash_item_b: int = CoopPlayerSync.hash_client_state(_make_state({"held_item_id": 2}))
    t.assert_eq(true, hash_item_a != hash_item_b)

    t.begin("CoopPlayerSync.hash_client_state dimension_instance_key flips the hash")
    var hash_dim_a: int = CoopPlayerSync.hash_client_state(_make_state({"dimension_instance_key": "overworld"}))
    var hash_dim_b: int = CoopPlayerSync.hash_client_state(_make_state({"dimension_instance_key": "void"}))
    t.assert_eq(true, hash_dim_a != hash_dim_b)

    t.begin("CoopPlayerSync.hash_client_state missing keys use safe defaults")
    var hash_partial_a: int = CoopPlayerSync.hash_client_state({})
    var hash_partial_b: int = CoopPlayerSync.hash_client_state({})
    t.assert_eq(hash_partial_a, hash_partial_b)
