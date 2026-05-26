extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCommandPolicyRPC.apply_value returns input untouched when command_name is empty")
    var input: Dictionary = {"tp": true, "gamemode": false}
    var untouched: Dictionary = CoopCommandPolicyRPC.apply_value(input, "", true)
    t.assert_eq_dict(input, untouched)
    # identity check: empty name is the early-return path
    t.assert_true(input == untouched, "empty command_name must return the same dict reference")

    t.begin("CoopCommandPolicyRPC.apply_value writes the requested key + bool value")
    var seeded: Dictionary = {"tp": false, "fill": false}
    var updated: Dictionary = CoopCommandPolicyRPC.apply_value(seeded, "tp", true)
    t.assert_true(bool(updated.get("tp", false)), "tp=true must land in the returned dict")
    t.assert_false(bool(updated.get("fill", true)), "fill stays false (unchanged keys preserved)")

    t.begin("CoopCommandPolicyRPC.apply_value does NOT mutate the input dictionary")
    var original: Dictionary = {"tp": false}
    var derived: Dictionary = CoopCommandPolicyRPC.apply_value(original, "tp", true)
    t.assert_false(bool(original.get("tp", true)), "input must remain untouched after apply_value")
    t.assert_true(bool(derived.get("tp", false)), "derived dict carries the new value")

    t.begin("CoopCommandPolicyRPC.apply_value mirrors gamemode -> gm")
    var gm_true: Dictionary = CoopCommandPolicyRPC.apply_value({"gamemode": false, "gm": false}, "gamemode", true)
    t.assert_true(bool(gm_true.get("gamemode", false)))
    t.assert_true(bool(gm_true.get("gm", false)), "gamemode=true must mirror to gm=true")

    t.begin("CoopCommandPolicyRPC.apply_value mirrors gm -> gamemode")
    var gamemode_false: Dictionary = CoopCommandPolicyRPC.apply_value({"gamemode": true, "gm": true}, "gm", false)
    t.assert_false(bool(gamemode_false.get("gm", true)))
    t.assert_false(bool(gamemode_false.get("gamemode", true)), "gm=false must mirror to gamemode=false")

    t.begin("CoopCommandPolicyRPC.apply_value mirrors spawnmenu -> mobs")
    var mobs_true: Dictionary = CoopCommandPolicyRPC.apply_value({"spawnmenu": false, "mobs": false}, "spawnmenu", true)
    t.assert_true(bool(mobs_true.get("spawnmenu", false)))
    t.assert_true(bool(mobs_true.get("mobs", false)), "spawnmenu=true must mirror to mobs=true")

    t.begin("CoopCommandPolicyRPC.apply_value mirrors mobs -> spawnmenu")
    var spawnmenu_false: Dictionary = CoopCommandPolicyRPC.apply_value({"spawnmenu": true, "mobs": true}, "mobs", false)
    t.assert_false(bool(spawnmenu_false.get("mobs", true)))
    t.assert_false(bool(spawnmenu_false.get("spawnmenu", true)), "mobs=false must mirror to spawnmenu=false")

    t.begin("CoopCommandPolicyRPC.apply_value preserves unrelated keys verbatim")
    var preserved: Dictionary = CoopCommandPolicyRPC.apply_value({"tp": true, "fill": true, "kick": false}, "fill", false)
    t.assert_true(bool(preserved.get("tp", false)), "tp untouched")
    t.assert_false(bool(preserved.get("fill", true)), "fill flipped to false")
    t.assert_false(bool(preserved.get("kick", true)), "kick untouched")

    t.begin("CoopCommandPolicyRPC.apply_value is idempotent (apply twice with same args)")
    var once: Dictionary = CoopCommandPolicyRPC.apply_value({"tp": false}, "tp", true)
    var twice: Dictionary = CoopCommandPolicyRPC.apply_value(once, "tp", true)
    t.assert_eq_dict(once, twice)

    t.begin("CoopCommandPolicyRPC.apply_value of non-alias key does not pollute alias slots")
    var no_mirror: Dictionary = CoopCommandPolicyRPC.apply_value({}, "tp", true)
    t.assert_true(bool(no_mirror.get("tp", false)))
    t.assert_false(no_mirror.has("gm"), "tp toggle must not introduce gm key")
    t.assert_false(no_mirror.has("mobs"), "tp toggle must not introduce mobs key")
