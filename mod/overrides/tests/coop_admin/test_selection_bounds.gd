extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.selection_bounds returns min/max when pos1 is already minimal")
    var bounds: Dictionary = CoopAdmin.selection_bounds({"pos1": Vector3i(0, 0, 0), "pos2": Vector3i(5, 6, 7)})
    t.assert_eq(Vector3i(0, 0, 0), bounds.get("min"))
    t.assert_eq(Vector3i(5, 6, 7), bounds.get("max"))

    t.begin("CoopAdmin.selection_bounds swaps axes when pos2 is smaller per-axis")
    var swapped: Dictionary = CoopAdmin.selection_bounds({"pos1": Vector3i(5, 6, 7), "pos2": Vector3i(0, 0, 0)})
    t.assert_eq(Vector3i(0, 0, 0), swapped.get("min"))
    t.assert_eq(Vector3i(5, 6, 7), swapped.get("max"))

    t.begin("CoopAdmin.selection_bounds handles per-axis mixed ordering")
    var mixed: Dictionary = CoopAdmin.selection_bounds({"pos1": Vector3i(0, 10, 0), "pos2": Vector3i(5, 0, 7)})
    t.assert_eq(Vector3i(0, 0, 0), mixed.get("min"))
    t.assert_eq(Vector3i(5, 10, 7), mixed.get("max"))

    t.begin("CoopAdmin.selection_bounds returns degenerate AABB when both corners coincide")
    var degenerate: Dictionary = CoopAdmin.selection_bounds({"pos1": Vector3i(2, 3, 4), "pos2": Vector3i(2, 3, 4)})
    t.assert_eq(Vector3i(2, 3, 4), degenerate.get("min"))
    t.assert_eq(Vector3i(2, 3, 4), degenerate.get("max"))

    t.begin("CoopAdmin.selection_bounds handles negative coordinates")
    var negative: Dictionary = CoopAdmin.selection_bounds({"pos1": Vector3i(-1, -2, -3), "pos2": Vector3i(-10, 5, -1)})
    t.assert_eq(Vector3i(-10, -2, -3), negative.get("min"))
    t.assert_eq(Vector3i(-1, 5, -1), negative.get("max"))
