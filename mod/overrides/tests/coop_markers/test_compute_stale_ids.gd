extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopMarkers.compute_stale_marker_ids returns empty when all are visible")
    var visible: Dictionary = {2: true, 3: true, 4: true}
    var stale: Array = CoopMarkers.compute_stale_marker_ids([2, 3, 4], visible)
    t.assert_eq(0, stale.size())

    t.begin("CoopMarkers.compute_stale_marker_ids returns peers absent from visible set")
    stale = CoopMarkers.compute_stale_marker_ids([2, 3, 4, 5], {2: true, 4: true})
    t.assert_eq(2, stale.size())
    t.assert_eq(3, stale[0])
    t.assert_eq(5, stale[1])

    t.begin("CoopMarkers.compute_stale_marker_ids empty markers -> empty stale")
    stale = CoopMarkers.compute_stale_marker_ids([], {2: true})
    t.assert_eq(0, stale.size())

    t.begin("CoopMarkers.compute_stale_marker_ids empty visible -> all stale")
    stale = CoopMarkers.compute_stale_marker_ids([2, 3, 4], {})
    t.assert_eq(3, stale.size())
    t.assert_eq(2, stale[0])
    t.assert_eq(3, stale[1])
    t.assert_eq(4, stale[2])

    t.begin("CoopMarkers.compute_stale_marker_ids preserves source order")
    stale = CoopMarkers.compute_stale_marker_ids([10, 5, 8, 3], {5: true})
    t.assert_eq(3, stale.size())
    t.assert_eq(10, stale[0])
    t.assert_eq(8, stale[1])
    t.assert_eq(3, stale[2])

    t.begin("CoopMarkers.compute_stale_remote_proxy_ids mirrors compute_stale_marker_ids")
    stale = CoopMarkers.compute_stale_remote_proxy_ids([7, 8, 9], {8: true})
    t.assert_eq(2, stale.size())
    t.assert_eq(7, stale[0])
    t.assert_eq(9, stale[1])
