extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCombatSync.compute_attack_knockback_velocity horizontal kb points away from attacker")
    var kb: Vector3 = CoopCombatSync.compute_attack_knockback_velocity(
        Vector3(5.0, 0.0, 0.0),  # target east of attacker
        Vector3(0.0, 0.0, 0.0),
        Vector3.ZERO,
        10.0,  # knockback_strength
        0.0,   # fly_strength
        1.0,
        false,
    )
    t.assert_true(kb.x > 0.0, "kb pushes east (away from attacker)")
    t.assert_eq(0.0, kb.z, "no Z component when target is purely east")

    t.begin("CoopCombatSync.compute_attack_knockback_velocity ignores Y when normalising horizontal kb")
    var kb_y: Vector3 = CoopCombatSync.compute_attack_knockback_velocity(
        Vector3(5.0, 100.0, 0.0),  # target way above attacker
        Vector3(0.0, 0.0, 0.0),
        Vector3.ZERO,
        10.0, 0.0, 1.0, false,
    )
    # Horizontal direction is (5, 0, 0) normalized = (1, 0, 0); KB at strength 10 -> ~(10, ?, 0).
    t.assert_true(absf(kb_y.x - 10.0) < 0.01, "horizontal kb X = 10 (knockback_strength)")

    t.begin("CoopCombatSync.compute_attack_knockback_velocity zero horizontal -> only vertical kb")
    var kb_v: Vector3 = CoopCombatSync.compute_attack_knockback_velocity(
        Vector3(0.0, 5.0, 0.0),  # target directly above
        Vector3(0.0, 0.0, 0.0),
        Vector3.ZERO,
        10.0,  # knockback_strength
        2.0,   # fly_strength
        1.0,
        true,  # on_floor
    )
    t.assert_eq(0.0, kb_v.x, "no horizontal kb when target is straight up")
    # Y = strength * jump_modifier * fly * 1.0 (on_floor)
    t.assert_true(absf(kb_v.y - 20.0) < 0.01, "Y = 10 * 1 * 2 * 1.0 = 20")

    t.begin("CoopCombatSync.compute_attack_knockback_velocity airborne dampens Y by 0.5")
    var kb_air: Vector3 = CoopCombatSync.compute_attack_knockback_velocity(
        Vector3(0.0, 5.0, 0.0),
        Vector3(0.0, 0.0, 0.0),
        Vector3.ZERO,
        10.0, 2.0, 1.0,
        false,  # airborne
    )
    t.assert_true(absf(kb_air.y - 10.0) < 0.01, "Y = 10 * 1 * 2 * 0.5 = 10 (airborne)")

    t.begin("CoopCombatSync.compute_attack_knockback_velocity jump_modifier scales vertical")
    var kb_jm: Vector3 = CoopCombatSync.compute_attack_knockback_velocity(
        Vector3(0.0, 5.0, 0.0),
        Vector3(0.0, 0.0, 0.0),
        Vector3.ZERO,
        10.0, 2.0,
        2.5,  # jump_modifier
        true,  # on_floor
    )
    t.assert_true(absf(kb_jm.y - 50.0) < 0.01, "Y = 10 * 2.5 * 2 * 1.0 = 50")

    t.begin("CoopCombatSync.compute_attack_knockback_velocity inherits 45% of attacker velocity")
    var kb_inh: Vector3 = CoopCombatSync.compute_attack_knockback_velocity(
        Vector3(100.0, 0.0, 0.0),  # far east -> direction (1,0,0)
        Vector3(0.0, 0.0, 0.0),
        Vector3(20.0, 0.0, 0.0),  # attacker moving east at 20
        10.0, 0.0, 1.0, false,
    )
    # base = 0.45 * (20,0,0) = (9, 0, 0); + direction*strength = (10, 0, 0) -> (19, 0, 0)
    t.assert_true(absf(kb_inh.x - 19.0) < 0.01, "X = 0.45*20 + 10 = 19")
