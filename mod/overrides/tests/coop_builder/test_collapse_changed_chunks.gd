extends RefCounted

# CoopBuilder.collapse_changed_chunks — dedupe via snap_to_chunk, with
# identity fallback when the callable is invalid.


func _snap_to_16(pos: Vector3) -> Vector3i:
    return Vector3i(int(floor(pos.x / 16.0)), int(floor(pos.y / 16.0)), int(floor(pos.z / 16.0)))


func run(t: CoopTester) -> void:
    var snap: Callable = Callable(self, "_snap_to_16")

    t.begin("CoopBuilder.collapse_changed_chunks dedupes positions sharing a chunk")
    var dedup: Array = CoopBuilder.collapse_changed_chunks([
        Vector3i(0, 0, 0),
        Vector3i(1, 1, 1),
        Vector3i(15, 15, 15),
        Vector3i(16, 0, 0),
    ], snap)
    t.assert_eq(2, dedup.size(), "first three cells share chunk (0,0,0); fourth is (1,0,0)")
    var chunk_set: Dictionary = {}
    for key in dedup:
        chunk_set[key] = true
    t.assert_true(chunk_set.has(Vector3i(0, 0, 0)))
    t.assert_true(chunk_set.has(Vector3i(1, 0, 0)))

    t.begin("CoopBuilder.collapse_changed_chunks falls back to identity when snap is invalid")
    var identity: Array = CoopBuilder.collapse_changed_chunks([
        Vector3i(0, 0, 0),
        Vector3i(1, 1, 1),
        Vector3i(15, 15, 15),
    ], Callable())
    t.assert_eq(3, identity.size(), "each position becomes its own chunk key when snap missing")

    t.begin("CoopBuilder.collapse_changed_chunks dedupes identity-keyed duplicates")
    var identity_dup: Array = CoopBuilder.collapse_changed_chunks([
        Vector3i(5, 5, 5),
        Vector3i(5, 5, 5),
        Vector3i(5, 5, 5),
    ], Callable())
    t.assert_eq(1, identity_dup.size(), "identical Vector3is collapse to one dict key")

    t.begin("CoopBuilder.collapse_changed_chunks returns [] for empty input")
    t.assert_eq(0, CoopBuilder.collapse_changed_chunks([], snap).size())
    t.assert_eq(0, CoopBuilder.collapse_changed_chunks([], Callable()).size())
