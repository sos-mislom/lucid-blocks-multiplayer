extends RefCounted


func run(t: CoopTester) -> void:
    const DEFAULT_ID: String = "default_blocky"

    t.begin("CoopAvatarRegistry.resolve_skin_color default avatar always returns WHITE")
    t.assert_eq(
        Color.WHITE,
        CoopAvatarRegistry.resolve_skin_color(DEFAULT_ID, Color.RED, DEFAULT_ID, Color.BLACK),
    )

    t.begin("CoopAvatarRegistry.resolve_skin_color non-default avatar returns settings color")
    t.assert_eq(
        Color.RED,
        CoopAvatarRegistry.resolve_skin_color("alpha", Color.RED, DEFAULT_ID, Color.WHITE),
    )

    t.begin("CoopAvatarRegistry.resolve_skin_color non-default avatar with non-Color settings -> fallback")
    t.assert_eq(
        Color.BLACK,
        CoopAvatarRegistry.resolve_skin_color("alpha", "not a color", DEFAULT_ID, Color.BLACK),
    )
    t.assert_eq(
        Color.BLACK,
        CoopAvatarRegistry.resolve_skin_color("alpha", null, DEFAULT_ID, Color.BLACK),
    )

    t.begin("CoopAvatarRegistry.resolve_skin_color non-default avatar with Vector3 settings -> fallback")
    t.assert_eq(
        Color.GREEN,
        CoopAvatarRegistry.resolve_skin_color("alpha", Vector3(1, 0, 0), DEFAULT_ID, Color.GREEN),
    )

    t.begin("CoopAvatarRegistry.resolve_skin_color default fallback is Color.WHITE")
    t.assert_eq(
        Color.WHITE,
        CoopAvatarRegistry.resolve_skin_color("alpha", null, DEFAULT_ID),
    )

    t.begin("CoopAvatarRegistry.coerce_color passes Color through")
    t.assert_eq(Color.RED, CoopAvatarRegistry.coerce_color(Color.RED, Color.WHITE))

    t.begin("CoopAvatarRegistry.coerce_color non-Color returns fallback")
    t.assert_eq(Color.WHITE, CoopAvatarRegistry.coerce_color("text", Color.WHITE))
    t.assert_eq(Color.WHITE, CoopAvatarRegistry.coerce_color(42, Color.WHITE))
    t.assert_eq(Color.WHITE, CoopAvatarRegistry.coerce_color(null, Color.WHITE))
