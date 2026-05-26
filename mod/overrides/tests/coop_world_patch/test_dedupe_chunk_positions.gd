extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPatch.dedupe_chunk_positions preserves first-seen order")
    var out: Array = CoopWorldPatch.dedupe_chunk_positions([
        Vector3i(0, 0, 0), Vector3i(16, 0, 0), Vector3i(0, 0, 0), Vector3i(32, 0, 0),
    ])
    t.assert_eq(3, out.size())
    t.assert_eq(Vector3i(0, 0, 0), out[0])
    t.assert_eq(Vector3i(16, 0, 0), out[1])
    t.assert_eq(Vector3i(32, 0, 0), out[2])

    t.begin("CoopWorldPatch.dedupe_chunk_positions skips non-Vector3i entries defensively")
    var with_junk: Array = CoopWorldPatch.dedupe_chunk_positions([
        Vector3i(0, 0, 0), null, "junk", Vector3(2.0, 0.0, 0.0), Vector3i(16, 0, 0),
    ])
    t.assert_eq(2, with_junk.size())
    t.assert_eq(Vector3i(0, 0, 0), with_junk[0])
    t.assert_eq(Vector3i(16, 0, 0), with_junk[1])

    t.begin("CoopWorldPatch.dedupe_chunk_positions empty input returns []")
    t.assert_eq(0, CoopWorldPatch.dedupe_chunk_positions([]).size())

    t.begin("CoopWorldPatch.dedupe_chunk_positions all duplicates collapse to one")
    var one: Array = CoopWorldPatch.dedupe_chunk_positions([Vector3i(5, 5, 5), Vector3i(5, 5, 5), Vector3i(5, 5, 5)])
    t.assert_eq(1, one.size())
