extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCombatSync.is_attack_within_reach co-located -> true")
    t.assert_true(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3.ZERO))

    t.begin("CoopCombatSync.is_attack_within_reach inside reach -> true")
    t.assert_true(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3(3.0, 0.0, 0.0), 6.0, 1.25))

    t.begin("CoopCombatSync.is_attack_within_reach exactly at reach + slack -> true (inclusive)")
    t.assert_true(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3(7.25, 0.0, 0.0), 6.0, 1.25))

    t.begin("CoopCombatSync.is_attack_within_reach just outside reach + slack -> false")
    t.assert_false(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3(7.26, 0.0, 0.0), 6.0, 1.25))

    t.begin("CoopCombatSync.is_attack_within_reach 3D distance check")
    # (3,4,0) -> distance=5, allowed=7.25 -> true
    t.assert_true(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3(3.0, 4.0, 0.0), 6.0, 1.25))
    # (6,4,3) -> distance=sqrt(61)~7.81, allowed=7.25 -> false
    t.assert_false(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3(6.0, 4.0, 3.0), 6.0, 1.25))

    t.begin("CoopCombatSync.is_attack_within_reach default reach + slack uses constants")
    var dist_inside: float = (CoopCombatSync.ATTACK_REACH_DISTANCE + CoopCombatSync.ATTACK_REACH_SLACK) * 0.9
    t.assert_true(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3(dist_inside, 0.0, 0.0)))

    t.begin("CoopCombatSync.is_attack_within_reach zero slack still allows exact max-distance hit")
    t.assert_true(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3(6.0, 0.0, 0.0), 6.0, 0.0))
    t.assert_false(CoopCombatSync.is_attack_within_reach(Vector3.ZERO, Vector3(6.01, 0.0, 0.0), 6.0, 0.0))
