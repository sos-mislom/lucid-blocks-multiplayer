extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopPauseMenuUI.resolve_peer_display_name local peer -> local_player_name")
    t.assert_eq("Tim", CoopPauseMenuUI.resolve_peer_display_name(5, {}, 5, "Tim"))

    t.begin("CoopPauseMenuUI.resolve_peer_display_name uses state.name when present")
    t.assert_eq("Alice", CoopPauseMenuUI.resolve_peer_display_name(7, {"name": "Alice"}, 5, "Tim"))
    t.assert_eq("Bob", CoopPauseMenuUI.resolve_peer_display_name(7, {"name": "  Bob  "}, 5, "Tim"))

    t.begin("CoopPauseMenuUI.resolve_peer_display_name falls back to Peer <id>")
    t.assert_eq("Peer 7", CoopPauseMenuUI.resolve_peer_display_name(7, {}, 5, "Tim"))
    t.assert_eq("Peer 7", CoopPauseMenuUI.resolve_peer_display_name(7, {"name": ""}, 5, "Tim"))
    t.assert_eq("Peer 7", CoopPauseMenuUI.resolve_peer_display_name(7, {"name": "  "}, 5, "Tim"))
