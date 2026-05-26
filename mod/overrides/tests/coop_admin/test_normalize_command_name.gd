extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.normalize_command_name strips leading slashes")
    t.assert_eq("tp", CoopAdmin.normalize_command_name("/tp"))
    t.assert_eq("tp", CoopAdmin.normalize_command_name("///tp"))

    t.begin("CoopAdmin.normalize_command_name lowercases and trims whitespace")
    t.assert_eq("tp", CoopAdmin.normalize_command_name("  TP  "))
    t.assert_eq("gamemode", CoopAdmin.normalize_command_name("Gamemode"))

    t.begin("CoopAdmin.normalize_command_name replaces dashes with underscores")
    t.assert_eq("builder_setup", CoopAdmin.normalize_command_name("builder-setup"))
    t.assert_eq("server_commands", CoopAdmin.normalize_command_name("server-commands"))

    t.begin("CoopAdmin.normalize_command_name aliases gm to gamemode")
    t.assert_eq("gamemode", CoopAdmin.normalize_command_name("gm"))
    t.assert_eq("gamemode", CoopAdmin.normalize_command_name("/GM"))

    t.begin("CoopAdmin.normalize_command_name aliases mobs to spawnmenu")
    t.assert_eq("spawnmenu", CoopAdmin.normalize_command_name("mobs"))

    t.begin("CoopAdmin.normalize_command_name passes through unknown commands unchanged")
    t.assert_eq("help", CoopAdmin.normalize_command_name("/help"))
    t.assert_eq("whoami", CoopAdmin.normalize_command_name("WhoAmI"))

    t.begin("CoopAdmin.normalize_command_name returns empty for empty input")
    t.assert_eq("", CoopAdmin.normalize_command_name(""))
    t.assert_eq("", CoopAdmin.normalize_command_name("/"))
    t.assert_eq("", CoopAdmin.normalize_command_name("   "))
