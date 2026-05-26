extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.is_in_downed_grace returns true within grace window")
    t.assert_true(CoopRevive.is_in_downed_grace(1000, 1500, 2.0),
        "downed at msec=1000, now=1500 -> 500ms elapsed; grace 2.0s = 2000ms")

    t.begin("CoopRevive.is_in_downed_grace returns false at exactly grace boundary (< not <=)")
    t.assert_false(CoopRevive.is_in_downed_grace(1000, 3000, 2.0),
        "now-started == 2000 == grace*1000 -> NOT in grace")

    t.begin("CoopRevive.is_in_downed_grace returns false past grace window")
    t.assert_false(CoopRevive.is_in_downed_grace(1000, 5000, 2.0))

    t.begin("CoopRevive.is_in_downed_grace returns false when downed_started_msec <= 0 (not currently downed)")
    t.assert_false(CoopRevive.is_in_downed_grace(0, 1500, 2.0))
    t.assert_false(CoopRevive.is_in_downed_grace(-5, 1500, 2.0))

    t.begin("CoopRevive.is_in_downed_grace handles fractional grace_sec (truncated to ms via int())")
    t.assert_true(CoopRevive.is_in_downed_grace(0 + 1, 100, 0.1),
        "grace 0.1s = 100ms; 99ms elapsed -> in grace (1+99 < 1+100)")
    t.assert_false(CoopRevive.is_in_downed_grace(1, 101, 0.1),
        "100ms elapsed == grace -> NOT in grace")

    t.begin("CoopRevive.is_in_downed_grace clock-skew quirk: negative elapsed still matches '< grace_ms'")
    # Time.get_ticks_msec() is monotonic within a process, so this edge
    # only matters across process restarts where a stale `downed_started_msec`
    # could be larger than `now`. The live code uses signed int subtraction:
    # (1000 - 5000) = -4000; -4000 < int(2.0*1000) = -4000 < 2000 = true.
    # Pinning the live behaviour - if this ever changes, the call sites need
    # to be reviewed.
    t.assert_true(CoopRevive.is_in_downed_grace(5000, 1000, 2.0),
        "live behaviour: negative elapsed (-4000) < 2000 = true")
