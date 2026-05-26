extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopPauseMenuUI.compute_session_player_signature empty -> empty string")
    t.assert_eq("", CoopPauseMenuUI.compute_session_player_signature([], 5, "Tim"))

    t.begin("CoopPauseMenuUI.compute_session_player_signature single entry shape")
    var entries: Array = [
        {"peer_id": 5, "is_local": true, "active": true, "dimension_instance_key": "dim_a:0"},
    ]
    t.assert_eq("5|Tim (You)|dim_a:0|true", CoopPauseMenuUI.compute_session_player_signature(entries, 5, "Tim"))

    t.begin("CoopPauseMenuUI.compute_session_player_signature multiple entries joined by newline")
    entries = [
        {"peer_id": 5, "is_local": true, "active": true, "dimension_instance_key": "dim_a:0"},
        {"peer_id": 7, "is_local": false, "active": true, "name": "Alice", "dimension_instance_key": "dim_a:0"},
    ]
    t.assert_eq("5|Tim (You)|dim_a:0|true\n7|Alice|dim_a:0|true", CoopPauseMenuUI.compute_session_player_signature(entries, 5, "Tim"))

    t.begin("CoopPauseMenuUI.compute_session_player_signature skips non-Dictionary entries")
    entries = [
        {"peer_id": 5, "is_local": true, "active": true},
        "not a dict",
        {"peer_id": 7, "is_local": false, "active": true, "name": "Alice"},
    ]
    var signature: String = CoopPauseMenuUI.compute_session_player_signature(entries, 5, "Tim")
    t.assert_true(signature.contains("5|Tim (You)"))
    t.assert_true(signature.contains("7|Alice"))
    t.assert_eq(2, signature.count("\n") + 1)
