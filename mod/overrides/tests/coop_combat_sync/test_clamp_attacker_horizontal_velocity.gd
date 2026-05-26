extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCombatSync.clamp_attacker_horizontal_velocity remote proxy caps + dampens by 0.35")
    # Remote attacker reports move_speed = 5, current horizontal = (10, ?, 0).
    # After cap: (5, 0, 0). After damp: (5*0.35, 0, 0) = (1.75, 0, 0).
    var out: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(10.0, 3.0, 0.0),
        null,
        5.0,
        true,
    )
    t.assert_true(absf(out.x - 1.75) < 0.01, "x = 5 * 0.35 = 1.75")
    t.assert_eq(0.0, out.y, "remote proxy returns Y=0")
    t.assert_eq(0.0, out.z)

    t.begin("CoopCombatSync.clamp_attacker_horizontal_velocity remote proxy with reported_move_speed<=0 zeroes out")
    var zeroed: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(99.0, 99.0, 99.0), null, -1.0, true,
    )
    t.assert_eq(Vector3.ZERO, zeroed, "negative reported_move_speed -> zero horizontal output")

    t.begin("CoopCombatSync.clamp_attacker_horizontal_velocity local attacker, no cap when reported_move_speed<0")
    var local_uncapped: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(20.0, 5.0, 0.0), null, -1.0, false,
    )
    t.assert_eq(20.0, local_uncapped.x, "no cap -> horizontal pass-through")
    t.assert_eq(5.0, local_uncapped.y, "Y preserved (within [-8, 8])")

    t.begin("CoopCombatSync.clamp_attacker_horizontal_velocity local attacker clamps Y at +-8")
    var clamped_up: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(0.0, 99.0, 0.0), null, -1.0, false,
    )
    t.assert_eq(8.0, clamped_up.y, "Y clamped to +8.0")
    var clamped_down: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(0.0, -99.0, 0.0), null, -1.0, false,
    )
    t.assert_eq(-8.0, clamped_down.y, "Y clamped to -8.0")

    t.begin("CoopCombatSync.clamp_attacker_horizontal_velocity local attacker caps at reported_move_speed + slack")
    # reported=4, slack=1.25, allowed=5.25. Current horizontal = (10, 0, 0) -> cap at 5.25.
    var local_capped: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(10.0, 0.0, 0.0), null, 4.0, false,
    )
    t.assert_true(absf(local_capped.x - 5.25) < 0.01, "x = reported + slack = 5.25")

    t.begin("CoopCombatSync.clamp_attacker_horizontal_velocity uses movement_velocity override when provided")
    # Current = (10, 0, 0) but override = (3, 99, 0); Y on override is zeroed before clamp.
    var with_override: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(10.0, 5.0, 0.0),
        Vector3(3.0, 99.0, 0.0),
        -1.0,
        false,
    )
    t.assert_eq(3.0, with_override.x, "override horizontal X used")
    t.assert_eq(0.0, with_override.z)
    t.assert_eq(5.0, with_override.y, "Y comes from current_velocity, not override")

    t.begin("CoopCombatSync.clamp_attacker_horizontal_velocity local attacker zero horizontal stays zero")
    var local_zero: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(0.0, 0.0, 0.0), null, 4.0, false,
    )
    t.assert_eq(Vector3.ZERO, local_zero)

    t.begin("CoopCombatSync.clamp_attacker_horizontal_velocity local under-cap passes through")
    var under_cap: Vector3 = CoopCombatSync.clamp_attacker_horizontal_velocity(
        Vector3(2.0, 0.0, 0.0), null, 4.0, false,
    )
    t.assert_eq(2.0, under_cap.x, "under cap -> pass-through")
