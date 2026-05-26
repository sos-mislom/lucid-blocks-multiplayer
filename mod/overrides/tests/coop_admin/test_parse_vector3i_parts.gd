extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.parse_vector3i_parts returns Vector3i for three valid ints at start_index=0")
    var v: Variant = CoopAdmin.parse_vector3i_parts(PackedStringArray(["1", "2", "3"]), 0)
    t.assert_true(v is Vector3i)
    t.assert_eq(Vector3i(1, 2, 3), v)

    t.begin("CoopAdmin.parse_vector3i_parts handles negative ints")
    var negative: Variant = CoopAdmin.parse_vector3i_parts(PackedStringArray(["-10", "0", "42"]), 0)
    t.assert_eq(Vector3i(-10, 0, 42), negative)

    t.begin("CoopAdmin.parse_vector3i_parts honours start_index offset")
    var offset_parts: PackedStringArray = PackedStringArray(["/pos1", "5", "6", "7"])
    var offset_value: Variant = CoopAdmin.parse_vector3i_parts(offset_parts, 1)
    t.assert_eq(Vector3i(5, 6, 7), offset_value)

    t.begin("CoopAdmin.parse_vector3i_parts returns null when the slice is too short")
    t.assert_eq(null, CoopAdmin.parse_vector3i_parts(PackedStringArray(["1", "2"]), 0))
    t.assert_eq(null, CoopAdmin.parse_vector3i_parts(PackedStringArray(["a", "b", "c"]), 1), "off-by-one offset triggers short-slice early return")

    t.begin("CoopAdmin.parse_vector3i_parts returns null on non-integer tokens")
    t.assert_eq(null, CoopAdmin.parse_vector3i_parts(PackedStringArray(["1", "two", "3"]), 0))
    t.assert_eq(null, CoopAdmin.parse_vector3i_parts(PackedStringArray(["1.5", "2", "3"]), 0), "floats are not valid ints")
    t.assert_eq(null, CoopAdmin.parse_vector3i_parts(PackedStringArray(["", "2", "3"]), 0))
