extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPatch.merge_patch_dictionary scalar overwrite (source wins)")
    var merged: Dictionary = CoopWorldPatch.merge_patch_dictionary({"a": 1, "b": 2}, {"b": 99, "c": 3})
    t.assert_eq(1, int(merged.get("a", 0)))
    t.assert_eq(99, int(merged.get("b", 0)), "source value wins")
    t.assert_eq(3, int(merged.get("c", 0)))

    t.begin("CoopWorldPatch.merge_patch_dictionary nested dicts recurse")
    var nested: Dictionary = CoopWorldPatch.merge_patch_dictionary(
        {"world": {"chunk_block": {"x": 1}, "chunk_fire": {"y": 2}}},
        {"world": {"chunk_block": {"x": 99, "z": 3}}},
    )
    var world: Dictionary = nested.get("world", {})
    var chunk_block: Dictionary = world.get("chunk_block", {})
    t.assert_eq(99, int(chunk_block.get("x", 0)), "source wins on nested scalar")
    t.assert_eq(3, int(chunk_block.get("z", 0)))
    t.assert_true(world.has("chunk_fire"), "non-overlapping branch preserved")

    t.begin("CoopWorldPatch.merge_patch_dictionary array values overwrite (deep-copied, not concatenated)")
    var array_merge: Dictionary = CoopWorldPatch.merge_patch_dictionary(
        {"list": [1, 2, 3]},
        {"list": [9, 8]},
    )
    t.assert_eq(2, array_merge.get("list", []).size())
    t.assert_eq(9, int(array_merge.get("list", [])[0]))

    t.begin("CoopWorldPatch.merge_patch_dictionary target NOT mutated (input safety)")
    var src_target: Dictionary = {"a": {"x": 1}}
    var src_source: Dictionary = {"a": {"x": 99}}
    CoopWorldPatch.merge_patch_dictionary(src_target, src_source)
    t.assert_eq(1, int(src_target["a"]["x"]), "target untouched")
    t.assert_eq(99, int(src_source["a"]["x"]), "source untouched")

    t.begin("CoopWorldPatch.merge_patch_dictionary dict-overrides-scalar replaces scalar")
    var dict_over_scalar: Dictionary = CoopWorldPatch.merge_patch_dictionary({"x": 5}, {"x": {"nested": 1}})
    t.assert_true(dict_over_scalar.get("x", null) is Dictionary, "source dict wins over target scalar")

    t.begin("CoopWorldPatch.merge_patch_dictionary scalar-overrides-dict replaces dict")
    var scalar_over_dict: Dictionary = CoopWorldPatch.merge_patch_dictionary({"x": {"nested": 1}}, {"x": 7})
    t.assert_eq(7, int(scalar_over_dict.get("x", 0)))

    t.begin("CoopWorldPatch.merge_patch_dictionary empty source returns deep-copy of target")
    var empty_src: Dictionary = CoopWorldPatch.merge_patch_dictionary({"a": {"x": 1}}, {})
    t.assert_eq(1, int(empty_src.get("a", {}).get("x", 0)))
