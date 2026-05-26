extends RefCounted

const MAX_COORD: float = 8192.0


func run(t: CoopTester) -> void:
    t.begin("CoopAuthorityValidator.is_safe_vector3 accepts ZERO and bounded values")
    t.assert_true(CoopAuthorityValidator.is_safe_vector3(Vector3.ZERO, MAX_COORD))
    t.assert_true(CoopAuthorityValidator.is_safe_vector3(Vector3(1.0, 2.0, 3.0), MAX_COORD))
    t.assert_true(CoopAuthorityValidator.is_safe_vector3(Vector3(MAX_COORD, -MAX_COORD, 0.0), MAX_COORD))

    t.begin("CoopAuthorityValidator.is_safe_vector3 rejects NaN on any axis")
    t.assert_false(CoopAuthorityValidator.is_safe_vector3(Vector3(NAN, 0.0, 0.0), MAX_COORD))
    t.assert_false(CoopAuthorityValidator.is_safe_vector3(Vector3(0.0, NAN, 0.0), MAX_COORD))
    t.assert_false(CoopAuthorityValidator.is_safe_vector3(Vector3(0.0, 0.0, NAN), MAX_COORD))

    t.begin("CoopAuthorityValidator.is_safe_vector3 rejects +inf and -inf")
    t.assert_false(CoopAuthorityValidator.is_safe_vector3(Vector3(INF, 0.0, 0.0), MAX_COORD))
    t.assert_false(CoopAuthorityValidator.is_safe_vector3(Vector3(0.0, -INF, 0.0), MAX_COORD))

    t.begin("CoopAuthorityValidator.is_safe_vector3 rejects out-of-range coordinates")
    t.assert_false(CoopAuthorityValidator.is_safe_vector3(Vector3(MAX_COORD + 1.0, 0.0, 0.0), MAX_COORD))
    t.assert_false(CoopAuthorityValidator.is_safe_vector3(Vector3(0.0, 0.0, -MAX_COORD - 1.0), MAX_COORD))

    t.begin("CoopAuthorityValidator.is_safe_float handles boundary cases")
    t.assert_true(CoopAuthorityValidator.is_safe_float(0.0, MAX_COORD))
    t.assert_true(CoopAuthorityValidator.is_safe_float(MAX_COORD, MAX_COORD))
    t.assert_false(CoopAuthorityValidator.is_safe_float(NAN, MAX_COORD))
    t.assert_false(CoopAuthorityValidator.is_safe_float(INF, MAX_COORD))
