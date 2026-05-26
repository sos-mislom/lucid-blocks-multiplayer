extends RefCounted


func run(t: CoopTester) -> void:
    var debug_names: PackedStringArray = PackedStringArray([
        "/give", "/gamemode", "/gm", "/spawn", "/spawnlist", "/spawnmenu",
        "/mobs", "/time", "/weather", "/kill", "/fly",
    ])

    t.begin("CoopAdmin.is_core_debug_command true for every name in the set")
    for name in debug_names:
        t.assert_true(CoopAdmin.is_core_debug_command(name, debug_names), "%s should be a debug command" % name)

    t.begin("CoopAdmin.is_core_debug_command is case-insensitive and trims whitespace")
    t.assert_true(CoopAdmin.is_core_debug_command("  /GIVE  ", debug_names))
    t.assert_true(CoopAdmin.is_core_debug_command("/Spawn", debug_names))

    t.begin("CoopAdmin.is_core_debug_command false for non-debug commands")
    t.assert_false(CoopAdmin.is_core_debug_command("/tp", debug_names))
    t.assert_false(CoopAdmin.is_core_debug_command("/help", debug_names))

    t.begin("CoopAdmin.is_core_debug_command false when leading slash is missing")
    t.assert_false(CoopAdmin.is_core_debug_command("give", debug_names), "missing slash means not a match (autocomplete helper handles that case)")
