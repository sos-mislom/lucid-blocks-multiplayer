extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopPauseMenuUI.format_session_player_label local + active")
    t.assert_eq("Tim (You)", CoopPauseMenuUI.format_session_player_label({"peer_id": 5, "is_local": true, "active": true}, 5, "Tim"))

    t.begin("CoopPauseMenuUI.format_session_player_label local + downed")
    t.assert_eq("Tim (You) [Downed]", CoopPauseMenuUI.format_session_player_label({"peer_id": 5, "is_local": true, "active": true, "downed": true}, 5, "Tim"))

    t.begin("CoopPauseMenuUI.format_session_player_label host peer")
    t.assert_eq("Peer 1 (Host)", CoopPauseMenuUI.format_session_player_label({"peer_id": 1, "is_local": false, "active": true}, 5, "Tim"))
    t.assert_eq("HostName (Host)", CoopPauseMenuUI.format_session_player_label({"peer_id": 1, "is_local": false, "active": true, "name": "HostName"}, 5, "Tim"))

    t.begin("CoopPauseMenuUI.format_session_player_label inactive peer -> Connecting")
    t.assert_eq("Peer 7 (Connecting)", CoopPauseMenuUI.format_session_player_label({"peer_id": 7, "is_local": false, "active": false}, 5, "Tim"))

    t.begin("CoopPauseMenuUI.format_session_player_label active remote peer -> no suffix")
    t.assert_eq("Alice", CoopPauseMenuUI.format_session_player_label({"peer_id": 7, "is_local": false, "active": true, "name": "Alice"}, 5, "Tim"))

    t.begin("CoopPauseMenuUI.format_session_player_label downed suffix on remote")
    t.assert_eq("Alice [Downed]", CoopPauseMenuUI.format_session_player_label({"peer_id": 7, "is_local": false, "active": true, "name": "Alice", "downed": true}, 5, "Tim"))
