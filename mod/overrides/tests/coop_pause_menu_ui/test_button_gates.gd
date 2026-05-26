extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopPauseMenuUI.should_show_kick_button needs is_server AND transport_is_steam")
    t.assert_true(CoopPauseMenuUI.should_show_kick_button(true, true))
    t.assert_false(CoopPauseMenuUI.should_show_kick_button(false, true))
    t.assert_false(CoopPauseMenuUI.should_show_kick_button(true, false))
    t.assert_false(CoopPauseMenuUI.should_show_kick_button(false, false))

    t.begin("CoopPauseMenuUI.is_kick_button_disabled disabled when hidden")
    t.assert_true(CoopPauseMenuUI.is_kick_button_disabled(false, false, false))

    t.begin("CoopPauseMenuUI.is_kick_button_disabled disabled when local peer")
    t.assert_true(CoopPauseMenuUI.is_kick_button_disabled(true, true, false))

    t.begin("CoopPauseMenuUI.is_kick_button_disabled disabled when state empty")
    t.assert_true(CoopPauseMenuUI.is_kick_button_disabled(true, false, true))

    t.begin("CoopPauseMenuUI.is_kick_button_disabled enabled otherwise")
    t.assert_false(CoopPauseMenuUI.is_kick_button_disabled(true, false, false))

    t.begin("CoopPauseMenuUI.is_tp_button_disabled disabled when local peer")
    t.assert_true(CoopPauseMenuUI.is_tp_button_disabled(true, true, false, true))

    t.begin("CoopPauseMenuUI.is_tp_button_disabled disabled when cannot sample player")
    t.assert_true(CoopPauseMenuUI.is_tp_button_disabled(false, false, false, true))

    t.begin("CoopPauseMenuUI.is_tp_button_disabled disabled when state empty")
    t.assert_true(CoopPauseMenuUI.is_tp_button_disabled(false, true, true, true))

    t.begin("CoopPauseMenuUI.is_tp_button_disabled disabled when peer inactive")
    t.assert_true(CoopPauseMenuUI.is_tp_button_disabled(false, true, false, false))

    t.begin("CoopPauseMenuUI.is_tp_button_disabled enabled with all good conditions")
    t.assert_false(CoopPauseMenuUI.is_tp_button_disabled(false, true, false, true))
