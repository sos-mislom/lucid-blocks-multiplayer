extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopMarkers.resolve_marker_display_name_input uses state.name when present")
    var state: Dictionary = {"name": "alpha"}
    t.assert_eq("alpha", CoopMarkers.resolve_marker_display_name_input(state, 42))

    t.begin("CoopMarkers.resolve_marker_display_name_input falls back to 'Peer <id>' when name absent")
    t.assert_eq("Peer 42", CoopMarkers.resolve_marker_display_name_input({}, 42))
    t.assert_eq("Peer 7", CoopMarkers.resolve_marker_display_name_input({"other": "x"}, 7))

    t.begin("CoopMarkers.resolve_marker_display_name_input falls back when name is null")
    state = {"name": null}
    t.assert_eq("Peer 3", CoopMarkers.resolve_marker_display_name_input(state, 3))

    t.begin("CoopMarkers.resolve_marker_display_name_input coerces non-string names via str()")
    state = {"name": 123}
    t.assert_eq("123", CoopMarkers.resolve_marker_display_name_input(state, 42))

    t.begin("CoopMarkers.resolve_marker_display_name_input preserves empty string (no fallback)")
    # Live behavior: `state.get("name", "Peer %s" % id)` only falls
    # back when the KEY is missing; an explicit empty string passes
    # through `str()` unchanged.
    state = {"name": ""}
    t.assert_eq("", CoopMarkers.resolve_marker_display_name_input(state, 42))

    t.begin("CoopMarkers.compute_marker_display_name no decoration when not downed")
    t.assert_eq("alpha", CoopMarkers.compute_marker_display_name("alpha", false))
    t.assert_eq("", CoopMarkers.compute_marker_display_name("", false))

    t.begin("CoopMarkers.compute_marker_display_name '[DOWN]' suffix when downed")
    t.assert_eq("alpha [DOWN]", CoopMarkers.compute_marker_display_name("alpha", true))
    t.assert_eq("Peer 7 [DOWN]", CoopMarkers.compute_marker_display_name("Peer 7", true))
    t.assert_eq(" [DOWN]", CoopMarkers.compute_marker_display_name("", true))
