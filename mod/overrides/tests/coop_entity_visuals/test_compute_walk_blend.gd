extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntityVisuals.compute_walk_blend zero velocity -> 0")
    t.assert_eq(0.0, CoopEntityVisuals.compute_walk_blend(Vector3.ZERO, 5.0, 1.0))

    t.begin("CoopEntityVisuals.compute_walk_blend full speed -> 1.0")
    t.assert_eq(1.0, CoopEntityVisuals.compute_walk_blend(Vector3(5.0, 0.0, 0.0), 5.0, 1.0))

    t.begin("CoopEntityVisuals.compute_walk_blend half speed -> 0.5")
    t.assert_eq(0.5, CoopEntityVisuals.compute_walk_blend(Vector3(2.5, 0.0, 0.0), 5.0, 1.0))

    t.begin("CoopEntityVisuals.compute_walk_blend uses XZ-plane magnitude only (Y dropped)")
    t.assert_eq(1.0, CoopEntityVisuals.compute_walk_blend(Vector3(3.0, 999.0, 4.0), 5.0, 1.0),
        "magnitude(3, 4)=5 = base_speed -> 1.0 regardless of Y")

    t.begin("CoopEntityVisuals.compute_walk_blend over-speed clamps to 1.0")
    t.assert_eq(1.0, CoopEntityVisuals.compute_walk_blend(Vector3(50.0, 0.0, 0.0), 5.0, 1.0))

    t.begin("CoopEntityVisuals.compute_walk_blend applies speed_modifier multiplier")
    t.assert_eq(0.5, CoopEntityVisuals.compute_walk_blend(Vector3(5.0, 0.0, 0.0), 5.0, 2.0),
        "modifier 2x -> threshold doubled, half blend")
    t.assert_eq(1.0, CoopEntityVisuals.compute_walk_blend(Vector3(5.0, 0.0, 0.0), 5.0, 0.5),
        "modifier 0.5x -> threshold halved, full blend")

    t.begin("CoopEntityVisuals.compute_walk_blend zero divisor uses min floor 0.001 (no div-by-zero)")
    var safe: float = CoopEntityVisuals.compute_walk_blend(Vector3(0.0001, 0.0, 0.0), 0.0, 0.0)
    t.assert_true(safe >= 0.0 and safe <= 1.0,
        "zero base*modifier should NOT explode; floor=0.001 keeps result clamped")
    t.assert_eq(1.0, CoopEntityVisuals.compute_walk_blend(Vector3(1.0, 0.0, 0.0), 0.0, 0.0),
        "1.0 / 0.001 = 1000 clamped to 1.0")
