extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.format_vector3i renders space-separated coordinates")
    t.assert_eq("1 2 3", CoopAdmin.format_vector3i(Vector3i(1, 2, 3)))

    t.begin("CoopAdmin.format_vector3i renders zero")
    t.assert_eq("0 0 0", CoopAdmin.format_vector3i(Vector3i.ZERO))

    t.begin("CoopAdmin.format_vector3i renders negative coordinates")
    t.assert_eq("-1 -2 -3", CoopAdmin.format_vector3i(Vector3i(-1, -2, -3)))

    t.begin("CoopAdmin.format_vector3i renders large coordinates without scientific notation")
    t.assert_eq("1000000 -1000000 42", CoopAdmin.format_vector3i(Vector3i(1000000, -1000000, 42)))
