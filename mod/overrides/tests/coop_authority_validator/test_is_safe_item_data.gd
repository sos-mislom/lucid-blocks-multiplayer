extends RefCounted

const MAX_INTS: int = 16
# PackedInt32Array(...) is not a constant expression in GDScript 4; use
# a plain Array literal (constant) instead.
const KNOWN_IDS: Array = [1, 42]


func run(t: CoopTester) -> void:
    var stub: Callable = Callable(self, "_stub_lookup")

    t.begin("CoopAuthorityValidator.is_safe_item_data rejects empty PackedInt32Array")
    t.assert_false(CoopAuthorityValidator.is_safe_item_data(PackedInt32Array([]), MAX_INTS, stub))

    t.begin("CoopAuthorityValidator.is_safe_item_data rejects oversized PackedInt32Array")
    var big: PackedInt32Array = PackedInt32Array()
    for i in range(MAX_INTS + 1):
        big.append(42)
    t.assert_false(CoopAuthorityValidator.is_safe_item_data(big, MAX_INTS, stub))

    t.begin("CoopAuthorityValidator.is_safe_item_data rejects non-positive ids")
    t.assert_false(CoopAuthorityValidator.is_safe_item_data(PackedInt32Array([0, 1, 2]), MAX_INTS, stub))
    t.assert_false(CoopAuthorityValidator.is_safe_item_data(PackedInt32Array([-1, 1, 2]), MAX_INTS, stub))

    t.begin("CoopAuthorityValidator.is_safe_item_data rejects unknown ids via the lookup")
    t.assert_false(CoopAuthorityValidator.is_safe_item_data(PackedInt32Array([7, 1, 0]), MAX_INTS, stub))

    t.begin("CoopAuthorityValidator.is_safe_item_data accepts a known id")
    t.assert_true(CoopAuthorityValidator.is_safe_item_data(PackedInt32Array([1, 1, 0]), MAX_INTS, stub))
    t.assert_true(CoopAuthorityValidator.is_safe_item_data(PackedInt32Array([42]), MAX_INTS, stub))

    t.begin("CoopAuthorityValidator.is_safe_item_data rejects when lookup callable is invalid")
    var empty: Callable = Callable()
    t.assert_false(CoopAuthorityValidator.is_safe_item_data(PackedInt32Array([1]), MAX_INTS, empty))


func _stub_lookup(id: int) -> Variant:
    for known in KNOWN_IDS:
        if known == id:
            return {"id": id}
    return null
