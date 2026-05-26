extends RefCounted


func _ticket(chunk: Vector3i, center: Vector3, priority: int, expires: int, simulation: bool = true, instance: String = "dimension:0") -> Dictionary:
    return {
        "dimension_instance_key": instance,
        "chunk": chunk,
        "center": center,
        "priority": priority,
        "expires_at_msec": expires,
        "simulation_enabled": simulation,
    }


func run(t: CoopTester) -> void:
    t.begin("CoopChunkTickets.select_active_chunk_ticket_positions returns centers sorted by priority desc")
    var tickets: Dictionary = {
        "a": _ticket(Vector3i(0, 0, 0), Vector3(0, 0, 0), 1, 100),
        "b": _ticket(Vector3i(1, 0, 0), Vector3(16, 0, 0), 10, 100),
        "c": _ticket(Vector3i(2, 0, 0), Vector3(32, 0, 0), 5, 100),
    }
    var positions: Array = CoopChunkTickets.select_active_chunk_ticket_positions(tickets, "dimension:0", 10, false)
    t.assert_eq(3, positions.size())
    t.assert_eq(Vector3(16, 0, 0), positions[0], "priority=10 highest -> first")
    t.assert_eq(Vector3(32, 0, 0), positions[1], "priority=5 next")
    t.assert_eq(Vector3(0, 0, 0), positions[2], "priority=1 last")

    t.begin("CoopChunkTickets.select_active_chunk_ticket_positions ties broken by descending expiration")
    var tied: Dictionary = {
        "early": _ticket(Vector3i(0, 0, 0), Vector3(0, 0, 0), 5, 100),
        "late": _ticket(Vector3i(1, 0, 0), Vector3(16, 0, 0), 5, 500),
    }
    var sorted_pos: Array = CoopChunkTickets.select_active_chunk_ticket_positions(tied, "dimension:0", 10, false)
    t.assert_eq(Vector3(16, 0, 0), sorted_pos[0], "later expiration wins on priority tie")

    t.begin("CoopChunkTickets.select_active_chunk_ticket_positions caps at max_count")
    var many: Dictionary = {
        "a": _ticket(Vector3i(0, 0, 0), Vector3(0, 0, 0), 1, 100),
        "b": _ticket(Vector3i(1, 0, 0), Vector3(16, 0, 0), 2, 100),
        "c": _ticket(Vector3i(2, 0, 0), Vector3(32, 0, 0), 3, 100),
    }
    var capped: Array = CoopChunkTickets.select_active_chunk_ticket_positions(many, "dimension:0", 2, false)
    t.assert_eq(2, capped.size())

    t.begin("CoopChunkTickets.select_active_chunk_ticket_positions deduplicates by chunk position")
    var dup: Dictionary = {
        "first": _ticket(Vector3i(0, 0, 0), Vector3(0, 0, 0), 5, 100),
        "second": _ticket(Vector3i(0, 0, 0), Vector3(7, 7, 7), 3, 100),
        "third": _ticket(Vector3i(1, 0, 0), Vector3(16, 0, 0), 1, 100),
    }
    var deduped: Array = CoopChunkTickets.select_active_chunk_ticket_positions(dup, "dimension:0", 10, false)
    t.assert_eq(2, deduped.size(), "same chunk_position deduped: highest-priority entry retained")
    t.assert_eq(Vector3(0, 0, 0), deduped[0])

    t.begin("CoopChunkTickets.select_active_chunk_ticket_positions filters wrong-instance tickets")
    var mixed: Dictionary = {
        "ok": _ticket(Vector3i(0, 0, 0), Vector3(0, 0, 0), 1, 100),
        "other": _ticket(Vector3i(1, 0, 0), Vector3(16, 0, 0), 99, 100, true, "pocket:abc"),
    }
    var filtered: Array = CoopChunkTickets.select_active_chunk_ticket_positions(mixed, "dimension:0", 10, false)
    t.assert_eq(1, filtered.size())
    t.assert_eq(Vector3(0, 0, 0), filtered[0])

    t.begin("CoopChunkTickets.select_active_chunk_ticket_positions require_simulation=true filters non-sim tickets")
    var sim_mix: Dictionary = {
        "sim_off": _ticket(Vector3i(0, 0, 0), Vector3(0, 0, 0), 10, 100, false),
        "sim_on": _ticket(Vector3i(1, 0, 0), Vector3(16, 0, 0), 1, 100, true),
    }
    var sim_only: Array = CoopChunkTickets.select_active_chunk_ticket_positions(sim_mix, "dimension:0", 10, true)
    t.assert_eq(1, sim_only.size())
    t.assert_eq(Vector3(16, 0, 0), sim_only[0])

    t.begin("CoopChunkTickets.select_active_chunk_ticket_positions skips tickets without Vector3 center")
    var no_center: Dictionary = {
        "ok": _ticket(Vector3i(0, 0, 0), Vector3(0, 0, 0), 1, 100),
        "broken": {"dimension_instance_key": "dimension:0", "chunk": Vector3i(1, 0, 0), "center": null, "priority": 5, "expires_at_msec": 100},
    }
    var safe: Array = CoopChunkTickets.select_active_chunk_ticket_positions(no_center, "dimension:0", 10, false)
    t.assert_eq(1, safe.size())

    t.begin("CoopChunkTickets.select_active_chunk_ticket_positions max_count <= 0 returns []")
    var nothing: Array = CoopChunkTickets.select_active_chunk_ticket_positions(_ticket_dict(), "dimension:0", 0, false)
    t.assert_eq(0, nothing.size())
    var negative: Array = CoopChunkTickets.select_active_chunk_ticket_positions(_ticket_dict(), "dimension:0", -5, false)
    t.assert_eq(0, negative.size())


func _ticket_dict() -> Dictionary:
    return {"x": _ticket(Vector3i.ZERO, Vector3.ZERO, 1, 100)}
