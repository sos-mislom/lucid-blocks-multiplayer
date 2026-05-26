extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopMarkers.is_peer_excluded_from_markers local peer is excluded")
    t.assert_eq(true, CoopMarkers.is_peer_excluded_from_markers(2, 2, false))
    t.assert_eq(true, CoopMarkers.is_peer_excluded_from_markers(1, 1, false))

    t.begin("CoopMarkers.is_peer_excluded_from_markers dedicated peer is excluded")
    t.assert_eq(true, CoopMarkers.is_peer_excluded_from_markers(3, 2, true))

    t.begin("CoopMarkers.is_peer_excluded_from_markers normal remote peer is NOT excluded")
    t.assert_eq(false, CoopMarkers.is_peer_excluded_from_markers(3, 2, false))
    t.assert_eq(false, CoopMarkers.is_peer_excluded_from_markers(99, 2, false))

    t.begin("CoopMarkers.is_peer_excluded_from_markers local AND dedicated is excluded (either path)")
    t.assert_eq(true, CoopMarkers.is_peer_excluded_from_markers(2, 2, true))
