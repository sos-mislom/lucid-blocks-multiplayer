extends RefCounted

const MAX_COORD: float = 8192.0


func run(t: CoopTester) -> void:
    t.begin("CoopAuthorityValidator.clamp_safe_vector3 returns ZERO on NaN")
    t.assert_eq(Vector3.ZERO, CoopAuthorityValidator.clamp_safe_vector3(Vector3(NAN, 1.0, 1.0), 10.0, MAX_COORD))

    t.begin("CoopAuthorityValidator.clamp_safe_vector3 returns ZERO on out-of-range")
    t.assert_eq(Vector3.ZERO, CoopAuthorityValidator.clamp_safe_vector3(Vector3(MAX_COORD + 1.0, 0.0, 0.0), 10.0, MAX_COORD))

    t.begin("CoopAuthorityValidator.clamp_safe_vector3 passes through vectors under max length")
    var small: Vector3 = Vector3(0.5, 0.0, 0.0)
    t.assert_eq(small, CoopAuthorityValidator.clamp_safe_vector3(small, 10.0, MAX_COORD))

    t.begin("CoopAuthorityValidator.clamp_safe_vector3 clamps long vectors to max_length")
    var clamped: Vector3 = CoopAuthorityValidator.clamp_safe_vector3(Vector3(100.0, 0.0, 0.0), 10.0, MAX_COORD)
    t.assert_true(absf(clamped.length() - 10.0) < 0.001, "length should equal max_length after clamp")
    t.assert_true(clamped.x > 0.0, "direction must be preserved")

    t.begin("CoopAuthorityValidator.clamp_safe_vector3 leaves near-zero vectors unchanged")
    var tiny: Vector3 = Vector3(0.0005, 0.0, 0.0)
    t.assert_eq(tiny, CoopAuthorityValidator.clamp_safe_vector3(tiny, 0.0001, MAX_COORD), "<0.001 length must not be clamped")
