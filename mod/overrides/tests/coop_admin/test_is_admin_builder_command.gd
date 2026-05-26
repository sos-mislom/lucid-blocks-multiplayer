extends RefCounted


func run(t: CoopTester) -> void:
    var builder_names: PackedStringArray = PackedStringArray([
        "wand", "pos1", "pos2", "sel", "fill", "clear",
        "floor", "flat", "border", "peaceful", "daylock", "builder_setup",
    ])

    t.begin("CoopAdmin.is_admin_builder_command true for every name in the set")
    for name in builder_names:
        t.assert_true(CoopAdmin.is_admin_builder_command(name, builder_names), "%s should be a builder command" % name)

    t.begin("CoopAdmin.is_admin_builder_command normalises leading slash + case")
    t.assert_true(CoopAdmin.is_admin_builder_command("/Fill", builder_names))
    t.assert_true(CoopAdmin.is_admin_builder_command("//WAND", builder_names))

    t.begin("CoopAdmin.is_admin_builder_command normalises dash to underscore")
    t.assert_true(CoopAdmin.is_admin_builder_command("builder-setup", builder_names))

    t.begin("CoopAdmin.is_admin_builder_command false for unrelated commands")
    t.assert_false(CoopAdmin.is_admin_builder_command("tp", builder_names))
    t.assert_false(CoopAdmin.is_admin_builder_command("help", builder_names))
    t.assert_false(CoopAdmin.is_admin_builder_command("", builder_names))
