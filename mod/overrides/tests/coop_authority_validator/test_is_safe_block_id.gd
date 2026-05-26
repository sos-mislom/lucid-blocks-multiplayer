extends RefCounted

# Stub callable for ItemMap.map. Returns a sentinel non-null object for ids
# in `known_ids`, null otherwise.

# PackedInt32Array(...) is not a constant expression in GDScript 4, so we
# use a plain Array literal (constant) and iterate it the same way.
const KNOWN_IDS: Array = [1, 2, 99]


func run(t: CoopTester) -> void:
    var stub: Callable = Callable(self, "_stub_lookup")

    t.begin("CoopAuthorityValidator.is_safe_block_id accepts 0 unconditionally (air)")
    t.assert_true(CoopAuthorityValidator.is_safe_block_id(0, stub))

    t.begin("CoopAuthorityValidator.is_safe_block_id rejects negative ids")
    t.assert_false(CoopAuthorityValidator.is_safe_block_id(-1, stub))
    t.assert_false(CoopAuthorityValidator.is_safe_block_id(-9999, stub))

    t.begin("CoopAuthorityValidator.is_safe_block_id consults the lookup callable for non-zero ids")
    t.assert_true(CoopAuthorityValidator.is_safe_block_id(1, stub), "known id 1 must pass")
    t.assert_true(CoopAuthorityValidator.is_safe_block_id(99, stub), "known id 99 must pass")
    t.assert_false(CoopAuthorityValidator.is_safe_block_id(7, stub), "unknown id 7 must fail")

    t.begin("CoopAuthorityValidator.is_safe_block_id rejects positive ids when callable is invalid")
    var empty: Callable = Callable()
    t.assert_true(CoopAuthorityValidator.is_safe_block_id(0, empty), "0 should still pass without a lookup")
    t.assert_false(CoopAuthorityValidator.is_safe_block_id(1, empty), "no lookup must reject non-zero ids")


func _stub_lookup(id: int) -> Variant:
    for known in KNOWN_IDS:
        if known == id:
            return {"id": id}
    return null
