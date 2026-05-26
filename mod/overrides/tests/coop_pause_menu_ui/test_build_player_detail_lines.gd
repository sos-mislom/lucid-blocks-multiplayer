extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopPauseMenuUI.build_player_detail_lines local peer same area")
    var lines: PackedStringArray = CoopPauseMenuUI.build_player_detail_lines(
        5,
        {"dimension_instance_key": "dim_a:0", "active": true},
        5,
        "Tim",
        "dim_a:0",
    )
    t.assert_eq_packed_string_array(PackedStringArray(["Tim", "Peer 5  |  Same area", "This is you."]), lines)

    t.begin("CoopPauseMenuUI.build_player_detail_lines host peer different area")
    lines = CoopPauseMenuUI.build_player_detail_lines(
        1,
        {"dimension_instance_key": "dim_b:0", "active": true},
        5,
        "Tim",
        "dim_a:0",
    )
    t.assert_eq_packed_string_array(PackedStringArray(["Peer 1", "Peer 1  |  Different area", "Host player."]), lines)

    t.begin("CoopPauseMenuUI.build_player_detail_lines inactive remote peer connecting")
    lines = CoopPauseMenuUI.build_player_detail_lines(
        7,
        {"active": false, "name": "Alice"},
        5,
        "Tim",
        "dim_a:0",
    )
    t.assert_eq_packed_string_array(PackedStringArray(["Alice", "Peer 7  |  Different area", "Connecting to world..."]), lines)

    t.begin("CoopPauseMenuUI.build_player_detail_lines downed remote appends Status: Downed")
    lines = CoopPauseMenuUI.build_player_detail_lines(
        7,
        {"active": true, "name": "Alice", "downed": true, "dimension_instance_key": "dim_a:0"},
        5,
        "Tim",
        "dim_a:0",
    )
    t.assert_eq_packed_string_array(PackedStringArray(["Alice", "Peer 7  |  Same area", "Status: Downed"]), lines)
