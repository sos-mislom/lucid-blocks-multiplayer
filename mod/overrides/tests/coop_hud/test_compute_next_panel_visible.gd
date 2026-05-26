extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopHud.compute_next_panel_visible null flips current visibility")
    t.assert_eq(true, CoopHud.compute_next_panel_visible(null, false))
    t.assert_eq(false, CoopHud.compute_next_panel_visible(null, true))

    t.begin("CoopHud.compute_next_panel_visible bool overrides regardless of current")
    t.assert_eq(true, CoopHud.compute_next_panel_visible(true, false))
    t.assert_eq(true, CoopHud.compute_next_panel_visible(true, true))
    t.assert_eq(false, CoopHud.compute_next_panel_visible(false, false))
    t.assert_eq(false, CoopHud.compute_next_panel_visible(false, true))

    t.begin("CoopHud.compute_next_panel_visible truthy non-bool overrides")
    t.assert_eq(true, CoopHud.compute_next_panel_visible(1, false))
    t.assert_eq(true, CoopHud.compute_next_panel_visible(-1, false))
    t.assert_eq(false, CoopHud.compute_next_panel_visible(0, true))

    t.begin("CoopHud.should_skip_panel_toggle skips when next == current")
    t.assert_eq(true, CoopHud.should_skip_panel_toggle(true, true))
    t.assert_eq(true, CoopHud.should_skip_panel_toggle(false, false))

    t.begin("CoopHud.should_skip_panel_toggle does NOT skip when changing")
    t.assert_eq(false, CoopHud.should_skip_panel_toggle(true, false))
    t.assert_eq(false, CoopHud.should_skip_panel_toggle(false, true))
