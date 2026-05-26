extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropPredict.should_predict_break_drops pickaxe_required without pickaxe -> false")
    t.assert_false(CoopDropPredict.should_predict_break_drops(true, false, false, false, false, false, true))
    t.assert_true(CoopDropPredict.should_predict_break_drops(true, false, false, true, false, false, true))

    t.begin("CoopDropPredict.should_predict_break_drops axe_required without axe -> false")
    t.assert_false(CoopDropPredict.should_predict_break_drops(false, true, false, false, false, false, true))
    t.assert_true(CoopDropPredict.should_predict_break_drops(false, true, false, false, true, false, true))

    t.begin("CoopDropPredict.should_predict_break_drops drop_loot set -> false (server-only loot table)")
    t.assert_false(CoopDropPredict.should_predict_break_drops(false, false, true, true, true, true, true))

    t.begin("CoopDropPredict.should_predict_break_drops explicit drop_item -> always true (passes tools)")
    t.assert_true(CoopDropPredict.should_predict_break_drops(false, false, false, false, false, true, false))
    t.assert_true(CoopDropPredict.should_predict_break_drops(false, false, false, true, true, true, false))

    t.begin("CoopDropPredict.should_predict_break_drops fallback uses can_drop")
    t.assert_true(CoopDropPredict.should_predict_break_drops(false, false, false, true, true, false, true))
    t.assert_false(CoopDropPredict.should_predict_break_drops(false, false, false, true, true, false, false))
