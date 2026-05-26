extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.has_selection true when both corners are Vector3i")
    t.assert_true(CoopAdmin.has_selection({"pos1": Vector3i.ZERO, "pos2": Vector3i(1, 2, 3)}))

    t.begin("CoopAdmin.has_selection false when pos1 is missing")
    t.assert_false(CoopAdmin.has_selection({"pos2": Vector3i(1, 2, 3)}))

    t.begin("CoopAdmin.has_selection false when pos2 is missing")
    t.assert_false(CoopAdmin.has_selection({"pos1": Vector3i.ZERO}))

    t.begin("CoopAdmin.has_selection false when record is empty")
    t.assert_false(CoopAdmin.has_selection({}))

    t.begin("CoopAdmin.has_selection false when stored type is not Vector3i")
    t.assert_false(CoopAdmin.has_selection({"pos1": Vector3.ZERO, "pos2": Vector3i.ZERO}), "Vector3 (float) must not satisfy the Vector3i requirement")
    t.assert_false(CoopAdmin.has_selection({"pos1": null, "pos2": Vector3i.ZERO}))
