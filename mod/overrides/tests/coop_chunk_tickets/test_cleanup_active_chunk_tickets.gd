extends RefCounted


func _ticket(instance_key: String, expires: int) -> Dictionary:
    return {
        "dimension_instance_key": instance_key,
        "expires_at_msec": expires,
        "chunk": Vector3i.ZERO,
        "center": Vector3(8, 8, 8),
        "priority": 0,
        "simulation_enabled": true,
    }


func run(t: CoopTester) -> void:
    t.begin("CoopChunkTickets.cleanup_active_chunk_tickets removes expired tickets")
    var tickets: Dictionary = {
        "k1": _ticket("dimension:0", 1000),
        "k2": _ticket("dimension:0", 5000),
    }
    var removed: int = CoopChunkTickets.cleanup_active_chunk_tickets(tickets, 2000, "dimension:0")
    t.assert_eq(1, removed)
    t.assert_false(tickets.has("k1"), "k1 expired at 1000, now=2000 -> removed")
    t.assert_true(tickets.has("k2"), "k2 expires at 5000 -> kept")

    t.begin("CoopChunkTickets.cleanup_active_chunk_tickets boundary expiry (expires == now -> removed)")
    var on_edge: Dictionary = {"k": _ticket("dimension:0", 2000)}
    CoopChunkTickets.cleanup_active_chunk_tickets(on_edge, 2000, "dimension:0")
    t.assert_false(on_edge.has("k"), "expires_at_msec <= now_msec -> removed (live `<=` comparison)")

    t.begin("CoopChunkTickets.cleanup_active_chunk_tickets removes wrong-instance tickets")
    var inst_mix: Dictionary = {
        "ok": _ticket("dimension:0", 9000),
        "stale": _ticket("pocket:abc", 9000),
    }
    var removed2: int = CoopChunkTickets.cleanup_active_chunk_tickets(inst_mix, 100, "dimension:0")
    t.assert_eq(1, removed2)
    t.assert_true(inst_mix.has("ok"))
    t.assert_false(inst_mix.has("stale"))

    t.begin("CoopChunkTickets.cleanup_active_chunk_tickets removes empty ticket entries")
    var with_empty: Dictionary = {
        "empty": {},
        "ok": _ticket("dimension:0", 9000),
    }
    CoopChunkTickets.cleanup_active_chunk_tickets(with_empty, 100, "dimension:0")
    t.assert_false(with_empty.has("empty"))
    t.assert_true(with_empty.has("ok"))

    t.begin("CoopChunkTickets.cleanup_active_chunk_tickets empty dict no-op")
    var empty: Dictionary = {}
    var removed3: int = CoopChunkTickets.cleanup_active_chunk_tickets(empty, 100, "dimension:0")
    t.assert_eq(0, removed3)
    t.assert_eq(0, empty.size())
