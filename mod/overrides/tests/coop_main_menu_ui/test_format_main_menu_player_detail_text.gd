extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopMainMenuUI.format_main_menu_player_detail_text no live peer")
    t.assert_eq("No active multiplayer session.", CoopMainMenuUI.format_main_menu_player_detail_text(false, 1, PackedStringArray(["should be ignored"])))

    t.begin("CoopMainMenuUI.format_main_menu_player_detail_text no peer selected")
    t.assert_eq("Select a player to inspect them.", CoopMainMenuUI.format_main_menu_player_detail_text(true, 0, PackedStringArray()))
    t.assert_eq("Select a player to inspect them.", CoopMainMenuUI.format_main_menu_player_detail_text(true, -1, PackedStringArray()))

    t.begin("CoopMainMenuUI.format_main_menu_player_detail_text joins detail lines")
    t.assert_eq("Tim\nPeer 5  |  Same area\nThis is you.", CoopMainMenuUI.format_main_menu_player_detail_text(true, 5, PackedStringArray(["Tim", "Peer 5  |  Same area", "This is you."])))

    t.begin("CoopMainMenuUI.format_main_menu_player_detail_text single line peer")
    t.assert_eq("Alice", CoopMainMenuUI.format_main_menu_player_detail_text(true, 7, PackedStringArray(["Alice"])))
