extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopChunkTickets.tick_dedicated_load_focus inactive -> reset_all")
    var reset: Dictionary = CoopChunkTickets.tick_dedicated_load_focus(true, 5, 3.0, 0.016, false)
    t.assert_false(bool(reset.get("valid", true)))
    t.assert_eq(0, int(reset.get("peer_id", -1)))
    t.assert_eq(0.0, float(reset.get("timer", -1.0)))
    t.assert_eq("reset_all", str(reset.get("side_effect", "")))

    t.begin("CoopChunkTickets.tick_dedicated_load_focus active+not valid -> none, idle")
    var idle: Dictionary = CoopChunkTickets.tick_dedicated_load_focus(false, 7, 2.5, 0.016, true)
    t.assert_false(bool(idle.get("valid", true)))
    t.assert_eq(7, int(idle.get("peer_id", -1)), "peer_id preserved when invalid")
    t.assert_eq(2.5, float(idle.get("timer", -1.0)), "timer preserved when invalid")
    t.assert_eq("none", str(idle.get("side_effect", "")))

    t.begin("CoopChunkTickets.tick_dedicated_load_focus active+valid+timer>0 -> none, timer decremented")
    var tick: Dictionary = CoopChunkTickets.tick_dedicated_load_focus(true, 7, 2.5, 0.5, true)
    t.assert_true(bool(tick.get("valid", false)))
    t.assert_eq(7, int(tick.get("peer_id", -1)))
    t.assert_eq(2.0, float(tick.get("timer", -1.0)))
    t.assert_eq("none", str(tick.get("side_effect", "")))

    t.begin("CoopChunkTickets.tick_dedicated_load_focus active+valid+timer expires -> expire")
    var expire: Dictionary = CoopChunkTickets.tick_dedicated_load_focus(true, 7, 0.1, 0.5, true)
    t.assert_false(bool(expire.get("valid", true)))
    t.assert_eq(0, int(expire.get("peer_id", -1)))
    t.assert_eq(0.0, float(expire.get("timer", -1.0)))
    t.assert_eq("expire", str(expire.get("side_effect", "")))

    t.begin("CoopChunkTickets.tick_dedicated_load_focus boundary timer<=0 expires (timer-delta = 0 -> expire)")
    var boundary: Dictionary = CoopChunkTickets.tick_dedicated_load_focus(true, 5, 0.5, 0.5, true)
    t.assert_false(bool(boundary.get("valid", true)), "timer-delta == 0 -> expire (live `<= 0.0` comparison)")
    t.assert_eq("expire", str(boundary.get("side_effect", "")))
