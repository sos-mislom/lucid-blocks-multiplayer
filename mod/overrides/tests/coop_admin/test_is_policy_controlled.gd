extends RefCounted


func run(t: CoopTester) -> void:
    var default_policy: Dictionary = {"tp": true, "fill": false, "gamemode": false}

    t.begin("CoopAdmin.is_policy_controlled true for known commands")
    t.assert_true(CoopAdmin.is_policy_controlled("tp", default_policy))
    t.assert_true(CoopAdmin.is_policy_controlled("/tp", default_policy))
    t.assert_true(CoopAdmin.is_policy_controlled("FILL", default_policy))

    t.begin("CoopAdmin.is_policy_controlled normalises aliases before lookup")
    t.assert_true(CoopAdmin.is_policy_controlled("gm", default_policy), "gm should canonicalise to gamemode")

    t.begin("CoopAdmin.is_policy_controlled false for commands not in default_policy")
    t.assert_false(CoopAdmin.is_policy_controlled("help", default_policy))
    t.assert_false(CoopAdmin.is_policy_controlled("whoami", default_policy))

    t.begin("CoopAdmin.is_policy_controlled false for any command when default_policy is empty")
    t.assert_false(CoopAdmin.is_policy_controlled("tp", {}))
