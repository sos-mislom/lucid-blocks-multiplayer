extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCombatSync.clamp_attack_damage floor at 1")
    t.assert_eq(1, CoopCombatSync.clamp_attack_damage(0))
    t.assert_eq(1, CoopCombatSync.clamp_attack_damage(-50))

    t.begin("CoopCombatSync.clamp_attack_damage in-range passes through")
    t.assert_eq(1, CoopCombatSync.clamp_attack_damage(1))
    t.assert_eq(50, CoopCombatSync.clamp_attack_damage(50))
    t.assert_eq(CoopCombatSync.MAX_PLAYER_DAMAGE, CoopCombatSync.clamp_attack_damage(CoopCombatSync.MAX_PLAYER_DAMAGE))

    t.begin("CoopCombatSync.clamp_attack_damage clamps above max")
    t.assert_eq(CoopCombatSync.MAX_PLAYER_DAMAGE, CoopCombatSync.clamp_attack_damage(99999))

    t.begin("CoopCombatSync.clamp_attack_damage accepts override max")
    t.assert_eq(10, CoopCombatSync.clamp_attack_damage(999, 10))
    t.assert_eq(5, CoopCombatSync.clamp_attack_damage(5, 10))
