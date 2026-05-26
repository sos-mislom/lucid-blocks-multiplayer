extends RefCounted


func _make_world_data(prefix: String) -> Dictionary:
    return {
        prefix + "world": {
            prefix + "chunk_block": {
                Vector3i(0, 0, 0): {"a": 1},
                Vector3i(16, 0, 0): {"b": 2},
            },
            prefix + "chunk_water": {
                Vector3i(0, 0, 0): {"w": 3},
            },
            prefix + "chunk_fire": {},  # empty - should be omitted
        },
    }


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPatch.filter_world_data_to_chunk_positions keeps only requested chunks")
    var data: Dictionary = _make_world_data("dim_0_")
    var out: Dictionary = CoopWorldPatch.filter_world_data_to_chunk_positions(data, "dim_0_", [Vector3i(0, 0, 0)])
    var root: Dictionary = out.get("dim_0_world", {})
    t.assert_true(root.has("dim_0_chunk_block"))
    t.assert_eq(1, root.get("dim_0_chunk_block", {}).size())
    t.assert_true(root.get("dim_0_chunk_block", {}).has(Vector3i(0, 0, 0)))
    t.assert_false(root.get("dim_0_chunk_block", {}).has(Vector3i(16, 0, 0)))

    t.begin("CoopWorldPatch.filter_world_data_to_chunk_positions omits suffixes with no matching chunks")
    var without_water: Dictionary = CoopWorldPatch.filter_world_data_to_chunk_positions(data, "dim_0_", [Vector3i(16, 0, 0)])
    var root2: Dictionary = without_water.get("dim_0_world", {})
    t.assert_true(root2.has("dim_0_chunk_block"))
    t.assert_false(root2.has("dim_0_chunk_water"), "no water entry at (16,0,0) -> suffix omitted")

    t.begin("CoopWorldPatch.filter_world_data_to_chunk_positions deep-copies kept entries (mutation safety)")
    var data_copy: Dictionary = _make_world_data("dim_0_")
    var out_copy: Dictionary = CoopWorldPatch.filter_world_data_to_chunk_positions(data_copy, "dim_0_", [Vector3i(0, 0, 0)])
    out_copy["dim_0_world"]["dim_0_chunk_block"][Vector3i(0, 0, 0)]["a"] = 999
    t.assert_eq(1, int(data_copy["dim_0_world"]["dim_0_chunk_block"][Vector3i(0, 0, 0)]["a"]),
        "mutating filter result must not poison source")

    t.begin("CoopWorldPatch.filter_world_data_to_chunk_positions empty chunk_positions returns {}")
    var none: Dictionary = CoopWorldPatch.filter_world_data_to_chunk_positions(data, "dim_0_", [])
    t.assert_eq(0, none.size())

    t.begin("CoopWorldPatch.filter_world_data_to_chunk_positions missing source root returns {}")
    var missing: Dictionary = CoopWorldPatch.filter_world_data_to_chunk_positions({}, "dim_0_", [Vector3i(0, 0, 0)])
    t.assert_eq(0, missing.size())

    t.begin("CoopWorldPatch.filter_world_data_to_chunk_positions non-Dictionary source root returns {}")
    var bad_root: Dictionary = CoopWorldPatch.filter_world_data_to_chunk_positions({"dim_0_world": "garbage"}, "dim_0_", [Vector3i(0, 0, 0)])
    t.assert_eq(0, bad_root.size())
