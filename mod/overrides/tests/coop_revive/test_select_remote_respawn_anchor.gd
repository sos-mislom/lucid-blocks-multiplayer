extends RefCounted


func _states_with_host_and_guests() -> Dictionary:
    return {
        1: {"name": "Host", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(10, 0, 0)},
        5: {"name": "Alice", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(2, 0, 0)},
        9: {"name": "Bob", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(5, 0, 0)},
    }


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.select_remote_respawn_anchor host short-circuits when prefer_host_peer + peer 1 in instance")
    var pick_host: Dictionary = CoopRevive.select_remote_respawn_anchor(
        _states_with_host_and_guests(),
        "dimension:0",
        false,  # is_server (client side)
        true,   # prefer_host_peer
        false,  # remote_host_respawning
        Vector3.ZERO,
    )
    t.assert_true(bool(pick_host.get("found", false)))
    t.assert_eq(Vector3(10, 0, 0), pick_host.get("position", Vector3.ZERO),
        "prefer_host short-circuit returns host position immediately, not the nearest")

    t.begin("CoopRevive.select_remote_respawn_anchor client without prefer_host picks nearest active peer")
    var nearest: Dictionary = CoopRevive.select_remote_respawn_anchor(
        _states_with_host_and_guests(),
        "dimension:0",
        false,
        false,
        false,
        Vector3(2.1, 0, 0),  # nearest is Alice at (2,0,0)
    )
    t.assert_true(bool(nearest.get("found", false)))
    t.assert_eq(Vector3(2, 0, 0), nearest.get("position", Vector3.ZERO))

    t.begin("CoopRevive.select_remote_respawn_anchor server excludes peer 1 (self)")
    var server_pick: Dictionary = CoopRevive.select_remote_respawn_anchor(
        _states_with_host_and_guests(),
        "dimension:0",
        true,
        false,
        false,
        Vector3(10, 0, 0),  # closest to host(10,0,0), but host is excluded; nearest other is Bob (5,0,0)
    )
    t.assert_true(bool(server_pick.get("found", false)))
    t.assert_eq(Vector3(5, 0, 0), server_pick.get("position", Vector3.ZERO),
        "host excluded on server; Bob at (5,0,0) is nearer to origin(10,0,0) than Alice(2,0,0)")

    t.begin("CoopRevive.select_remote_respawn_anchor client prefer_host but host not in instance -> miss")
    var split_states: Dictionary = {
        1: {"name": "Host", "active": true, "dimension_instance_key": "pocket:host", "position": Vector3(10, 0, 0)},
        9: {"name": "Bob", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(5, 0, 0)},
    }
    var no_host: Dictionary = CoopRevive.select_remote_respawn_anchor(split_states, "dimension:0", false, true, false, Vector3.ZERO)
    t.assert_false(bool(no_host.get("found", true)),
        "prefer_host_peer=true ONLY considers peer 1; Bob is filtered out")

    t.begin("CoopRevive.select_remote_respawn_anchor client+prefer_host+remote_host_respawning -> early miss")
    var respawn_block: Dictionary = CoopRevive.select_remote_respawn_anchor(
        _states_with_host_and_guests(),
        "dimension:0",
        false,
        true,
        true,
        Vector3(42.0, 0, 0),
    )
    t.assert_false(bool(respawn_block.get("found", true)))
    t.assert_eq(Vector3(42.0, 0, 0), respawn_block.get("position", Vector3.ZERO),
        "early-miss returns the fallback verbatim")

    t.begin("CoopRevive.select_remote_respawn_anchor server ignores remote_host_respawning (only clients gate on it)")
    var server_ignore: Dictionary = CoopRevive.select_remote_respawn_anchor(
        _states_with_host_and_guests(),
        "dimension:0",
        true,
        true,  # prefer_host_peer ignored when is_server (server excludes peer 1)
        true,  # remote_host_respawning irrelevant for server
        Vector3(0, 0, 0),
    )
    t.assert_true(bool(server_ignore.get("found", false)))

    t.begin("CoopRevive.select_remote_respawn_anchor empty peer_states returns miss with fallback")
    var nothing: Dictionary = CoopRevive.select_remote_respawn_anchor({}, "dimension:0", false, false, false, Vector3(7.0, 0, 0))
    t.assert_false(bool(nothing.get("found", true)))
    t.assert_eq(Vector3(7.0, 0, 0), nothing.get("position", Vector3.ZERO))

    t.begin("CoopRevive.select_remote_respawn_anchor skips inactive peers")
    var inactive: Dictionary = {
        5: {"name": "Alice", "active": false, "dimension_instance_key": "dimension:0", "position": Vector3.ZERO},
    }
    var none: Dictionary = CoopRevive.select_remote_respawn_anchor(inactive, "dimension:0", false, false, false, Vector3.ONE)
    t.assert_false(bool(none.get("found", true)))
    t.assert_eq(Vector3.ONE, none.get("position", Vector3.ZERO))

    t.begin("CoopRevive.select_remote_respawn_anchor skips wrong-instance peers")
    var wrong_inst: Dictionary = {
        5: {"name": "Alice", "active": true, "dimension_instance_key": "pocket:alice", "position": Vector3.ZERO},
    }
    var skip: Dictionary = CoopRevive.select_remote_respawn_anchor(wrong_inst, "dimension:0", false, false, false, Vector3.ONE)
    t.assert_false(bool(skip.get("found", true)))

    t.begin("CoopRevive.select_remote_respawn_anchor returns first peer when prefer_host_peer + host found, even if closer guest exists")
    var states_close_alice: Dictionary = {
        1: {"name": "Host", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(50, 0, 0)},
        5: {"name": "Alice", "active": true, "dimension_instance_key": "dimension:0", "position": Vector3(0.1, 0, 0)},
    }
    var prefer: Dictionary = CoopRevive.select_remote_respawn_anchor(states_close_alice, "dimension:0", false, true, false, Vector3.ZERO)
    t.assert_eq(Vector3(50, 0, 0), prefer.get("position", Vector3.ZERO),
        "prefer_host_peer=true ignores Alice; returns host even if Alice is nearer")
