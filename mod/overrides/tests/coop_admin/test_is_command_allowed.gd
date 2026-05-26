extends RefCounted


func run(t: CoopTester) -> void:
    var default_policy: Dictionary = {"tp": true, "fill": false, "gamemode": false}

    t.begin("CoopAdmin.is_command_allowed returns true for commands not in the default policy")
    t.assert_true(CoopAdmin.is_command_allowed("help", {}, default_policy), "/help is always allowed")
    t.assert_true(CoopAdmin.is_command_allowed("whoami", {"whoami": false}, default_policy), "non-controlled commands ignore effective policy too")

    t.begin("CoopAdmin.is_command_allowed honours explicit allow / deny in effective policy")
    t.assert_true(CoopAdmin.is_command_allowed("fill", {"fill": true}, default_policy))
    t.assert_false(CoopAdmin.is_command_allowed("tp", {"tp": false}, default_policy))

    t.begin("CoopAdmin.is_command_allowed falls back to default policy when key missing")
    t.assert_true(CoopAdmin.is_command_allowed("tp", {}, default_policy), "tp default is true")
    t.assert_false(CoopAdmin.is_command_allowed("fill", {}, default_policy), "fill default is false")

    t.begin("CoopAdmin.is_command_allowed normalises the input command before lookup")
    t.assert_true(CoopAdmin.is_command_allowed("/TP", {}, default_policy))
    t.assert_false(CoopAdmin.is_command_allowed("GM", {"gamemode": false}, default_policy))
