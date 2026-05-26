extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntityVisuals.is_segmented_worm_entity worm.gd + Segments -> true")
    t.assert_true(CoopEntityVisuals.is_segmented_worm_entity("res://entities/worm/worm.gd", true))

    t.begin("CoopEntityVisuals.is_segmented_worm_entity no Segments node -> false")
    t.assert_false(CoopEntityVisuals.is_segmented_worm_entity("res://entities/worm/worm.gd", false))

    t.begin("CoopEntityVisuals.is_segmented_worm_entity different script -> false")
    t.assert_false(CoopEntityVisuals.is_segmented_worm_entity("res://entities/sheep.gd", true))

    t.begin("CoopEntityVisuals.is_segmented_worm_entity empty path + Segments -> false")
    t.assert_false(CoopEntityVisuals.is_segmented_worm_entity("", true))

    t.begin("CoopEntityVisuals.is_segmented_worm_entity matches by suffix (/worm.gd)")
    t.assert_true(CoopEntityVisuals.is_segmented_worm_entity("res://procedural/worm.gd", true))
    t.assert_true(CoopEntityVisuals.is_segmented_worm_entity("res://mods/x/y/z/worm.gd", true))
    t.assert_false(CoopEntityVisuals.is_segmented_worm_entity("res://worm.gd.disabled", true),
        "must end with /worm.gd exactly, not .gd.something")
