extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldSnapshot.validate_snapshot_chunks_complete every index present -> complete=true")
    var chunks: Dictionary = {0: PackedByteArray([1]), 1: PackedByteArray([2]), 2: PackedByteArray([3])}
    var result: Dictionary = CoopWorldSnapshot.validate_snapshot_chunks_complete(chunks, 3)
    t.assert_true(bool(result.get("complete", false)))
    t.assert_eq(-1, int(result.get("missing_index", -999)))

    t.begin("CoopWorldSnapshot.validate_snapshot_chunks_complete first index missing -> reports 0")
    var missing_first: Dictionary = CoopWorldSnapshot.validate_snapshot_chunks_complete({1: PackedByteArray([1]), 2: PackedByteArray([2])}, 3)
    t.assert_false(bool(missing_first.get("complete", true)))
    t.assert_eq(0, int(missing_first.get("missing_index", -1)))

    t.begin("CoopWorldSnapshot.validate_snapshot_chunks_complete middle index missing -> reports it")
    var missing_mid: Dictionary = CoopWorldSnapshot.validate_snapshot_chunks_complete({0: PackedByteArray([1]), 2: PackedByteArray([2])}, 3)
    t.assert_false(bool(missing_mid.get("complete", true)))
    t.assert_eq(1, int(missing_mid.get("missing_index", -1)))

    t.begin("CoopWorldSnapshot.validate_snapshot_chunks_complete last index missing -> reports it")
    var missing_last: Dictionary = CoopWorldSnapshot.validate_snapshot_chunks_complete({0: PackedByteArray([1]), 1: PackedByteArray([2])}, 3)
    t.assert_false(bool(missing_last.get("complete", true)))
    t.assert_eq(2, int(missing_last.get("missing_index", -1)))

    t.begin("CoopWorldSnapshot.validate_snapshot_chunks_complete expected_count=0 -> trivially complete")
    var empty: Dictionary = CoopWorldSnapshot.validate_snapshot_chunks_complete({}, 0)
    t.assert_true(bool(empty.get("complete", false)))
    t.assert_eq(-1, int(empty.get("missing_index", 0)))

    t.begin("CoopWorldSnapshot.validate_snapshot_chunks_complete reports earliest missing first")
    var multi: Dictionary = CoopWorldSnapshot.validate_snapshot_chunks_complete({0: PackedByteArray()}, 5)
    t.assert_false(bool(multi.get("complete", true)))
    t.assert_eq(1, int(multi.get("missing_index", -1)), "the first missing index is reported, not the last")
