extends RefCounted

const MAX_COORD: float = 8192.0


func run(t: CoopTester) -> void:
    t.begin("CoopAuthorityValidator.is_safe_vector3i accepts ZERO and bounded values")
    t.assert_true(CoopAuthorityValidator.is_safe_vector3i(Vector3i.ZERO, MAX_COORD))
    t.assert_true(CoopAuthorityValidator.is_safe_vector3i(Vector3i(1, 2, 3), MAX_COORD))
    t.assert_true(CoopAuthorityValidator.is_safe_vector3i(Vector3i(8192, -8192, 0), MAX_COORD))

    t.begin("CoopAuthorityValidator.is_safe_vector3i rejects coordinates above max_abs_coord")
    t.assert_false(CoopAuthorityValidator.is_safe_vector3i(Vector3i(8193, 0, 0), MAX_COORD))
    t.assert_false(CoopAuthorityValidator.is_safe_vector3i(Vector3i(0, -8193, 0), MAX_COORD))
    t.assert_false(CoopAuthorityValidator.is_safe_vector3i(Vector3i(0, 0, 99999), MAX_COORD))

    t.begin("CoopAuthorityValidator.is_safe_vector3i floors the max_abs_coord float")
    t.assert_true(CoopAuthorityValidator.is_safe_vector3i(Vector3i(8, 8, 8), 8.9))
    t.assert_false(CoopAuthorityValidator.is_safe_vector3i(Vector3i(9, 0, 0), 8.9), "8.9 floors to 8; 9 must be rejected")
