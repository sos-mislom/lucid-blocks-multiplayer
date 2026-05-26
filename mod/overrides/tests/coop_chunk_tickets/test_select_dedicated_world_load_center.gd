extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopChunkTickets.select_dedicated_world_load_center load_focus_valid wins over everything")
    var pos: Vector3 = CoopChunkTickets.select_dedicated_world_load_center(
        true,
        Vector3(100, 0, 0),
        [Vector3(50, 0, 0)],
        {5: {"active": true, "dimension_instance_key": "dimension:0", "position": Vector3(0, 0, 0)}},
        "dimension:0",
        1,
        Vector3.ZERO,
    )
    t.assert_eq(Vector3(100, 0, 0), pos)

    t.begin("CoopChunkTickets.select_dedicated_world_load_center first ticket position wins when focus invalid")
    var via_ticket: Vector3 = CoopChunkTickets.select_dedicated_world_load_center(
        false,
        Vector3.ZERO,
        [Vector3(50, 0, 0)],
        {5: {"active": true, "dimension_instance_key": "dimension:0", "position": Vector3(0, 0, 0)}},
        "dimension:0",
        1,
        Vector3(999, 0, 0),
    )
    t.assert_eq(Vector3(50, 0, 0), via_ticket)

    t.begin("CoopChunkTickets.select_dedicated_world_load_center breaking peer takes priority over idle peer")
    var states: Dictionary = {
        5: {"active": true, "dimension_instance_key": "dimension:0", "position": Vector3(10, 0, 0), "breaking": false},
        7: {"active": true, "dimension_instance_key": "dimension:0", "position": Vector3(20, 0, 0), "breaking": true, "break_position": Vector3i(15, 8, 25)},
    }
    var breaking: Vector3 = CoopChunkTickets.select_dedicated_world_load_center(
        false,
        Vector3.ZERO,
        [],
        states,
        "dimension:0",
        1,
        Vector3(999, 0, 0),
    )
    t.assert_eq(Vector3(15.5, 8.5, 25.5), breaking, "break_position + (0.5, 0.5, 0.5) wins")

    t.begin("CoopChunkTickets.select_dedicated_world_load_center first active peer position when nobody is breaking")
    var idle: Dictionary = {
        5: {"active": true, "dimension_instance_key": "dimension:0", "position": Vector3(10, 0, 0)},
    }
    var pick: Vector3 = CoopChunkTickets.select_dedicated_world_load_center(
        false,
        Vector3.ZERO,
        [],
        idle,
        "dimension:0",
        1,
        Vector3(999, 0, 0),
    )
    t.assert_eq(Vector3(10, 0, 0), pick)

    t.begin("CoopChunkTickets.select_dedicated_world_load_center excludes own_peer_id")
    var self_only: Dictionary = {
        1: {"active": true, "dimension_instance_key": "dimension:0", "position": Vector3(10, 0, 0)},
    }
    var fallback: Vector3 = CoopChunkTickets.select_dedicated_world_load_center(
        false,
        Vector3.ZERO,
        [],
        self_only,
        "dimension:0",
        1,
        Vector3(999, 0, 0),
    )
    t.assert_eq(Vector3(999, 0, 0), fallback)

    t.begin("CoopChunkTickets.select_dedicated_world_load_center returns default_center when nothing matches")
    var empty: Vector3 = CoopChunkTickets.select_dedicated_world_load_center(
        false,
        Vector3.ZERO,
        [],
        {},
        "dimension:0",
        1,
        Vector3(42, 42, 42),
    )
    t.assert_eq(Vector3(42, 42, 42), empty)

    t.begin("CoopChunkTickets.select_dedicated_world_load_center filters wrong-instance peers")
    var other_inst: Dictionary = {
        5: {"active": true, "dimension_instance_key": "pocket:abc", "position": Vector3(10, 0, 0)},
    }
    var skip: Vector3 = CoopChunkTickets.select_dedicated_world_load_center(
        false,
        Vector3.ZERO,
        [],
        other_inst,
        "dimension:0",
        1,
        Vector3(99, 99, 99),
    )
    t.assert_eq(Vector3(99, 99, 99), skip)
