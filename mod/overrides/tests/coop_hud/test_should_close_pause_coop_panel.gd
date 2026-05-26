extends RefCounted


func run(t: CoopTester) -> void:
    const COOP_PAUSE_STATE: int = 4

    t.begin("CoopHud.should_close_pause_coop_panel_for_sync returns false when panel already closed")
    t.assert_eq(false, CoopHud.should_close_pause_coop_panel_for_sync(false, true, true, true, COOP_PAUSE_STATE, COOP_PAUSE_STATE))
    t.assert_eq(false, CoopHud.should_close_pause_coop_panel_for_sync(false, false, false, false, 0, COOP_PAUSE_STATE))

    t.begin("CoopHud.should_close_pause_coop_panel_for_sync stays open when owner present, visible, game menu in pause state")
    t.assert_eq(false, CoopHud.should_close_pause_coop_panel_for_sync(true, true, true, true, COOP_PAUSE_STATE, COOP_PAUSE_STATE))

    t.begin("CoopHud.should_close_pause_coop_panel_for_sync stays open when game menu is missing (don't force-close)")
    # Live code: `is_instance_valid(Ref.game_menu)` is false -> the
    # `int(Ref.game_menu.state) != 4` branch is skipped, so the
    # panel stays open until owner-visibility drives it closed.
    t.assert_eq(false, CoopHud.should_close_pause_coop_panel_for_sync(true, true, true, false, 0, COOP_PAUSE_STATE))

    t.begin("CoopHud.should_close_pause_coop_panel_for_sync closes when owner is missing")
    t.assert_eq(true, CoopHud.should_close_pause_coop_panel_for_sync(true, false, false, true, COOP_PAUSE_STATE, COOP_PAUSE_STATE))
    # Even if game_menu state is fine - the owner being missing wins.
    t.assert_eq(true, CoopHud.should_close_pause_coop_panel_for_sync(true, false, true, true, COOP_PAUSE_STATE, COOP_PAUSE_STATE))

    t.begin("CoopHud.should_close_pause_coop_panel_for_sync closes when owner hidden")
    t.assert_eq(true, CoopHud.should_close_pause_coop_panel_for_sync(true, true, false, true, COOP_PAUSE_STATE, COOP_PAUSE_STATE))

    t.begin("CoopHud.should_close_pause_coop_panel_for_sync closes when game menu state != coop pause state")
    t.assert_eq(true, CoopHud.should_close_pause_coop_panel_for_sync(true, true, true, true, 0, COOP_PAUSE_STATE))
    t.assert_eq(true, CoopHud.should_close_pause_coop_panel_for_sync(true, true, true, true, 1, COOP_PAUSE_STATE))
    t.assert_eq(true, CoopHud.should_close_pause_coop_panel_for_sync(true, true, true, true, 99, COOP_PAUSE_STATE))

    t.begin("CoopHud.should_close_pause_coop_panel_for_sync coop_pause_state_value is threaded in")
    # Hypothetical: if the live game menu used `7` for coop pause
    # state, the helper should compare against `7`, not the
    # hardcoded `4`.
    t.assert_eq(false, CoopHud.should_close_pause_coop_panel_for_sync(true, true, true, true, 7, 7))
    t.assert_eq(true, CoopHud.should_close_pause_coop_panel_for_sync(true, true, true, true, 4, 7))
