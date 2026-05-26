extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopConfig.clamp_server_entity_radius null -> clamped default")
    t.assert_eq(64.0, CoopConfig.clamp_server_entity_radius(null, 64.0))

    t.begin("CoopConfig.clamp_server_entity_radius null with out-of-range default still clamped")
    t.assert_eq(16.0, CoopConfig.clamp_server_entity_radius(null, 0.0))
    t.assert_eq(16.0, CoopConfig.clamp_server_entity_radius(null, -100.0))
    t.assert_eq(256.0, CoopConfig.clamp_server_entity_radius(null, 9999.0))

    t.begin("CoopConfig.clamp_server_entity_radius value passes through within range")
    t.assert_eq(16.0, CoopConfig.clamp_server_entity_radius(16.0, 64.0))
    t.assert_eq(128.0, CoopConfig.clamp_server_entity_radius(128.0, 64.0))
    t.assert_eq(256.0, CoopConfig.clamp_server_entity_radius(256.0, 64.0))

    t.begin("CoopConfig.clamp_server_entity_radius below min clamps to 16")
    t.assert_eq(16.0, CoopConfig.clamp_server_entity_radius(0.0, 64.0))
    t.assert_eq(16.0, CoopConfig.clamp_server_entity_radius(-10.0, 64.0))
    t.assert_eq(16.0, CoopConfig.clamp_server_entity_radius(15.5, 64.0))

    t.begin("CoopConfig.clamp_server_entity_radius above max clamps to 256")
    t.assert_eq(256.0, CoopConfig.clamp_server_entity_radius(257.0, 64.0))
    t.assert_eq(256.0, CoopConfig.clamp_server_entity_radius(10000.0, 64.0))

    t.begin("CoopConfig.clamp_server_entity_radius int values coerced to float")
    t.assert_eq(64.0, CoopConfig.clamp_server_entity_radius(64, 32.0))
    t.assert_eq(16.0, CoopConfig.clamp_server_entity_radius(0, 32.0))

    t.begin("CoopConfig.clamp_server_entity_radius string-numeric values coerced via float()")
    t.assert_eq(64.0, CoopConfig.clamp_server_entity_radius("64", 32.0))
