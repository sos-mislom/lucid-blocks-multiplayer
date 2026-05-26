extends RefCounted


func run(t: CoopTester) -> void:
    const DEFAULT_ID: String = "default_blocky"

    t.begin("CoopAvatarRegistry.normalize_avatar_id passes through lowercase id")
    t.assert_eq("alpha", CoopAvatarRegistry.normalize_avatar_id("alpha", DEFAULT_ID))

    t.begin("CoopAvatarRegistry.normalize_avatar_id lowercases mixed-case input")
    t.assert_eq("alpha", CoopAvatarRegistry.normalize_avatar_id("Alpha", DEFAULT_ID))
    t.assert_eq("alpha_beta", CoopAvatarRegistry.normalize_avatar_id("ALPHA_BETA", DEFAULT_ID))

    t.begin("CoopAvatarRegistry.normalize_avatar_id strips whitespace")
    t.assert_eq("alpha", CoopAvatarRegistry.normalize_avatar_id("  alpha  ", DEFAULT_ID))
    t.assert_eq("alpha", CoopAvatarRegistry.normalize_avatar_id("\talpha\n", DEFAULT_ID))

    t.begin("CoopAvatarRegistry.normalize_avatar_id empty -> default_avatar_id")
    t.assert_eq(DEFAULT_ID, CoopAvatarRegistry.normalize_avatar_id("", DEFAULT_ID))

    t.begin("CoopAvatarRegistry.normalize_avatar_id whitespace-only -> default_avatar_id")
    t.assert_eq(DEFAULT_ID, CoopAvatarRegistry.normalize_avatar_id("   ", DEFAULT_ID))
    t.assert_eq(DEFAULT_ID, CoopAvatarRegistry.normalize_avatar_id("\t\n", DEFAULT_ID))

    t.begin("CoopAvatarRegistry.normalize_avatar_id default_avatar_id is honored")
    t.assert_eq("custom_default", CoopAvatarRegistry.normalize_avatar_id("", "custom_default"))
    t.assert_eq("alpha", CoopAvatarRegistry.normalize_avatar_id("alpha", "custom_default"))
