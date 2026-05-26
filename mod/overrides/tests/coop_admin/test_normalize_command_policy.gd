extends RefCounted


func run(t: CoopTester) -> void:
    var default_policy: Dictionary = {
        "tp": true,
        "gamemode": false,
        "gm": false,
        "spawnmenu": false,
        "mobs": false,
        "fill": false,
    }

    t.begin("CoopAdmin.normalize_command_policy returns default copy when raw_policy is not a Dictionary")
    var defaulted: Dictionary = CoopAdmin.normalize_command_policy(null, default_policy)
    t.assert_eq_dict(default_policy, defaulted)
    defaulted["tp"] = false
    t.assert_true(bool(default_policy.get("tp", false)), "result must be a deep copy, not aliasing default_policy")

    t.begin("CoopAdmin.normalize_command_policy overrides defaults from raw policy")
    var overridden: Dictionary = CoopAdmin.normalize_command_policy({"tp": false, "fill": true}, default_policy)
    t.assert_false(bool(overridden.get("tp", true)))
    t.assert_true(bool(overridden.get("fill", false)))

    t.begin("CoopAdmin.normalize_command_policy normalises alias keys via normalize_command_name")
    var aliased: Dictionary = CoopAdmin.normalize_command_policy({"/GM": true, "MOBS": true}, default_policy)
    t.assert_true(bool(aliased.get("gamemode", false)), "/GM canonicalises to gamemode")
    t.assert_true(bool(aliased.get("spawnmenu", false)), "MOBS canonicalises to spawnmenu")

    t.begin("CoopAdmin.normalize_command_policy mirrors gm <-> gamemode and mobs <-> spawnmenu")
    var mirror_gamemode: Dictionary = CoopAdmin.normalize_command_policy({"gamemode": true}, default_policy)
    t.assert_true(bool(mirror_gamemode.get("gm", false)), "gamemode=true must mirror to gm=true")
    var mirror_spawnmenu: Dictionary = CoopAdmin.normalize_command_policy({"spawnmenu": true}, default_policy)
    t.assert_true(bool(mirror_spawnmenu.get("mobs", false)), "spawnmenu=true must mirror to mobs=true")

    t.begin("CoopAdmin.normalize_command_policy coerces non-bool values via bool()")
    var coerced: Dictionary = CoopAdmin.normalize_command_policy({"tp": 0, "fill": "anything"}, default_policy)
    t.assert_false(bool(coerced.get("tp", true)), "0 coerces to false")
    t.assert_true(bool(coerced.get("fill", false)), "non-empty string coerces to true")

    t.begin("CoopAdmin.normalize_command_policy skips empty-name keys")
    var with_blank: Dictionary = CoopAdmin.normalize_command_policy({"": true, "/": true, "tp": false}, default_policy)
    t.assert_false(bool(with_blank.get("tp", true)))
    t.assert_false(with_blank.has(""), "empty key must not be added")
