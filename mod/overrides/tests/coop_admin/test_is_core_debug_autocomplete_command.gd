extends RefCounted


func run(t: CoopTester) -> void:
    var debug_names: PackedStringArray = PackedStringArray([
        "/give", "/gamemode", "/spawn", "/fly",
    ])

    t.begin("CoopAdmin.is_core_debug_autocomplete_command prefixes a slash and delegates")
    t.assert_true(CoopAdmin.is_core_debug_autocomplete_command("give", debug_names))
    t.assert_true(CoopAdmin.is_core_debug_autocomplete_command("gamemode", debug_names))

    t.begin("CoopAdmin.is_core_debug_autocomplete_command is case-insensitive and trims whitespace")
    t.assert_true(CoopAdmin.is_core_debug_autocomplete_command("  FLY  ", debug_names))

    t.begin("CoopAdmin.is_core_debug_autocomplete_command false for unrelated names")
    t.assert_false(CoopAdmin.is_core_debug_autocomplete_command("tp", debug_names))
    t.assert_false(CoopAdmin.is_core_debug_autocomplete_command("help", debug_names))
