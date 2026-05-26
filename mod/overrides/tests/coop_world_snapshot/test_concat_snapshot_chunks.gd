extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldSnapshot.concat_snapshot_chunks ordered assembly")
    var chunks: Dictionary = {
        0: PackedByteArray([1, 2]),
        1: PackedByteArray([3, 4]),
        2: PackedByteArray([5, 6]),
    }
    var out: PackedByteArray = CoopWorldSnapshot.concat_snapshot_chunks(chunks, 3)
    t.assert_eq(6, out.size())
    t.assert_eq(1, int(out[0]))
    t.assert_eq(2, int(out[1]))
    t.assert_eq(3, int(out[2]))
    t.assert_eq(4, int(out[3]))
    t.assert_eq(5, int(out[4]))
    t.assert_eq(6, int(out[5]))

    t.begin("CoopWorldSnapshot.concat_snapshot_chunks empty chunks dict -> empty buffer")
    t.assert_eq(0, CoopWorldSnapshot.concat_snapshot_chunks({}, 3).size())

    t.begin("CoopWorldSnapshot.concat_snapshot_chunks missing indices skipped defensively")
    var missing: Dictionary = {0: PackedByteArray([1]), 2: PackedByteArray([3])}
    var with_gap: PackedByteArray = CoopWorldSnapshot.concat_snapshot_chunks(missing, 3)
    t.assert_eq(2, with_gap.size(), "gap at index 1 is skipped, indices 0+2 concatenated")
    t.assert_eq(1, int(with_gap[0]))
    t.assert_eq(3, int(with_gap[1]))

    t.begin("CoopWorldSnapshot.concat_snapshot_chunks non-PackedByteArray entries skipped defensively")
    var with_junk: Dictionary = {0: PackedByteArray([1]), 1: "garbage", 2: PackedByteArray([3])}
    var skipped: PackedByteArray = CoopWorldSnapshot.concat_snapshot_chunks(with_junk, 3)
    t.assert_eq(2, skipped.size())
    t.assert_eq(3, int(skipped[1]))

    t.begin("CoopWorldSnapshot.concat_snapshot_chunks honors chunk_count cap")
    var capped: PackedByteArray = CoopWorldSnapshot.concat_snapshot_chunks({0: PackedByteArray([1]), 1: PackedByteArray([2])}, 1)
    t.assert_eq(1, capped.size(), "chunk_count=1 stops after index 0")
