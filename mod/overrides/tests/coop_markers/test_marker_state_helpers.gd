extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopMarkers.compute_marker_crouching crouching alone -> true")
    t.assert_eq(true, CoopMarkers.compute_marker_crouching(true, false))

    t.begin("CoopMarkers.compute_marker_crouching downed alone -> true (forces prone pose)")
    t.assert_eq(true, CoopMarkers.compute_marker_crouching(false, true))

    t.begin("CoopMarkers.compute_marker_crouching both true -> true")
    t.assert_eq(true, CoopMarkers.compute_marker_crouching(true, true))

    t.begin("CoopMarkers.compute_marker_crouching neither -> false")
    t.assert_eq(false, CoopMarkers.compute_marker_crouching(false, false))

    t.begin("CoopMarkers.compute_marker_active_visible both active AND same-dimension -> true")
    t.assert_eq(true, CoopMarkers.compute_marker_active_visible(true, true))

    t.begin("CoopMarkers.compute_marker_active_visible inactive even in same dimension -> false")
    t.assert_eq(false, CoopMarkers.compute_marker_active_visible(false, true))

    t.begin("CoopMarkers.compute_marker_active_visible active but different dimension -> false")
    t.assert_eq(false, CoopMarkers.compute_marker_active_visible(true, false))

    t.begin("CoopMarkers.compute_marker_active_visible inactive AND different dimension -> false")
    t.assert_eq(false, CoopMarkers.compute_marker_active_visible(false, false))
