extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.parse_on_off accepts true-flavoured tokens")
    for token in ["on", "1", "true", "yes", "enable", "enabled"]:
        t.assert_true(CoopAdmin.parse_on_off(token, false), "%s should be true" % token)
        t.assert_true(CoopAdmin.parse_on_off(token.to_upper(), false), "%s upper should be true" % token)

    t.begin("CoopAdmin.parse_on_off accepts false-flavoured tokens")
    for token in ["off", "0", "false", "no", "disable", "disabled"]:
        t.assert_false(CoopAdmin.parse_on_off(token, true), "%s should be false" % token)
        t.assert_false(CoopAdmin.parse_on_off(" %s " % token, true), "whitespace-padded %s should be false" % token)

    t.begin("CoopAdmin.parse_on_off toggles the current value for unknown tokens")
    t.assert_true(CoopAdmin.parse_on_off("garbage", false), "unknown flips false -> true")
    t.assert_false(CoopAdmin.parse_on_off("garbage", true), "unknown flips true -> false")
    t.assert_true(CoopAdmin.parse_on_off("", false), "empty value toggles current")
