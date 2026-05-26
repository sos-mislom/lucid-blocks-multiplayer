extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopHud.should_close_main_coop_panel_for_sync returns false when panel already closed")
    t.assert_eq(false, CoopHud.should_close_main_coop_panel_for_sync(false, true, true))
    t.assert_eq(false, CoopHud.should_close_main_coop_panel_for_sync(false, false, false))

    t.begin("CoopHud.should_close_main_coop_panel_for_sync stays open when owner present and visible")
    t.assert_eq(false, CoopHud.should_close_main_coop_panel_for_sync(true, true, true))

    t.begin("CoopHud.should_close_main_coop_panel_for_sync closes when owner missing")
    t.assert_eq(true, CoopHud.should_close_main_coop_panel_for_sync(true, false, false))
    t.assert_eq(true, CoopHud.should_close_main_coop_panel_for_sync(true, false, true))

    t.begin("CoopHud.should_close_main_coop_panel_for_sync closes when owner hidden")
    t.assert_eq(true, CoopHud.should_close_main_coop_panel_for_sync(true, true, false))
