extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCombatSync.clamp_attack_knockback_strength floor at 0")
    t.assert_eq(0.0, CoopCombatSync.clamp_attack_knockback_strength(-1.0))
    t.assert_eq(0.0, CoopCombatSync.clamp_attack_knockback_strength(0.0))

    t.begin("CoopCombatSync.clamp_attack_knockback_strength in-range passes through")
    t.assert_eq(15.5, CoopCombatSync.clamp_attack_knockback_strength(15.5))
    t.assert_eq(CoopCombatSync.MAX_KNOCKBACK_STRENGTH,
        CoopCombatSync.clamp_attack_knockback_strength(CoopCombatSync.MAX_KNOCKBACK_STRENGTH))

    t.begin("CoopCombatSync.clamp_attack_knockback_strength clamps above max")
    t.assert_eq(CoopCombatSync.MAX_KNOCKBACK_STRENGTH,
        CoopCombatSync.clamp_attack_knockback_strength(999999.0))

    t.begin("CoopCombatSync.clamp_attack_knockback_strength accepts override max")
    t.assert_eq(10.0, CoopCombatSync.clamp_attack_knockback_strength(999.0, 10.0))

    t.begin("CoopCombatSync.clamp_attack_fly_strength symmetric")
    t.assert_eq(0.0, CoopCombatSync.clamp_attack_fly_strength(-1.0))
    t.assert_eq(15.5, CoopCombatSync.clamp_attack_fly_strength(15.5))
    t.assert_eq(CoopCombatSync.MAX_FLY_STRENGTH, CoopCombatSync.clamp_attack_fly_strength(999.0))
    t.assert_eq(8.0, CoopCombatSync.clamp_attack_fly_strength(99.0, 8.0))
