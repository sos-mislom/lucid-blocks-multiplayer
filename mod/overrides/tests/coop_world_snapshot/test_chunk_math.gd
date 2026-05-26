extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldSnapshot.compute_snapshot_chunk_count divides evenly")
    t.assert_eq(3, CoopWorldSnapshot.compute_snapshot_chunk_count(300, 100))
    t.assert_eq(1, CoopWorldSnapshot.compute_snapshot_chunk_count(100, 100))

    t.begin("CoopWorldSnapshot.compute_snapshot_chunk_count rounds up partial last chunk")
    t.assert_eq(4, CoopWorldSnapshot.compute_snapshot_chunk_count(301, 100))
    t.assert_eq(2, CoopWorldSnapshot.compute_snapshot_chunk_count(101, 100))

    t.begin("CoopWorldSnapshot.compute_snapshot_chunk_count empty payload returns floor=1")
    t.assert_eq(1, CoopWorldSnapshot.compute_snapshot_chunk_count(0, 100))

    t.begin("CoopWorldSnapshot.compute_snapshot_chunk_count chunk_size <= 0 returns floor=1")
    t.assert_eq(1, CoopWorldSnapshot.compute_snapshot_chunk_count(1000, 0))
    t.assert_eq(1, CoopWorldSnapshot.compute_snapshot_chunk_count(1000, -100))

    t.begin("CoopWorldSnapshot.slice_snapshot_chunk middle slice")
    var buffer: PackedByteArray = PackedByteArray([10, 20, 30, 40, 50, 60, 70])
    var middle: PackedByteArray = CoopWorldSnapshot.slice_snapshot_chunk(buffer, 1, 3)
    t.assert_eq(3, middle.size())
    t.assert_eq(40, int(middle[0]))
    t.assert_eq(50, int(middle[1]))
    t.assert_eq(60, int(middle[2]))

    t.begin("CoopWorldSnapshot.slice_snapshot_chunk last partial slice")
    var tail: PackedByteArray = CoopWorldSnapshot.slice_snapshot_chunk(buffer, 2, 3)
    t.assert_eq(1, tail.size())
    t.assert_eq(70, int(tail[0]))

    t.begin("CoopWorldSnapshot.slice_snapshot_chunk first slice")
    var head: PackedByteArray = CoopWorldSnapshot.slice_snapshot_chunk(buffer, 0, 3)
    t.assert_eq(3, head.size())
    t.assert_eq(10, int(head[0]))

    t.begin("CoopWorldSnapshot.slice_snapshot_chunk out-of-range index -> empty")
    t.assert_eq(0, CoopWorldSnapshot.slice_snapshot_chunk(buffer, 10, 3).size())
    t.assert_eq(0, CoopWorldSnapshot.slice_snapshot_chunk(buffer, -1, 3).size())

    t.begin("CoopWorldSnapshot.slice_snapshot_chunk chunk_size <= 0 -> empty")
    t.assert_eq(0, CoopWorldSnapshot.slice_snapshot_chunk(buffer, 0, 0).size())
    t.assert_eq(0, CoopWorldSnapshot.slice_snapshot_chunk(buffer, 0, -1).size())

    t.begin("CoopWorldSnapshot.is_snapshot_chunk_index_valid in-range, under cap -> true")
    t.assert_true(CoopWorldSnapshot.is_snapshot_chunk_index_valid(0, 5, 500, 1000))
    t.assert_true(CoopWorldSnapshot.is_snapshot_chunk_index_valid(4, 5, 1000, 1000))

    t.begin("CoopWorldSnapshot.is_snapshot_chunk_index_valid negative index -> false")
    t.assert_false(CoopWorldSnapshot.is_snapshot_chunk_index_valid(-1, 5, 100, 1000))

    t.begin("CoopWorldSnapshot.is_snapshot_chunk_index_valid index >= expected_count -> false")
    t.assert_false(CoopWorldSnapshot.is_snapshot_chunk_index_valid(5, 5, 100, 1000))
    t.assert_false(CoopWorldSnapshot.is_snapshot_chunk_index_valid(99, 5, 100, 1000))

    t.begin("CoopWorldSnapshot.is_snapshot_chunk_index_valid data_size > max_chunk_size -> false")
    t.assert_false(CoopWorldSnapshot.is_snapshot_chunk_index_valid(0, 5, 1001, 1000))

    t.begin("CoopWorldSnapshot.is_snapshot_chunk_index_valid data_size == max_chunk_size -> true (inclusive)")
    t.assert_true(CoopWorldSnapshot.is_snapshot_chunk_index_valid(0, 5, 1000, 1000))

    t.begin("CoopWorldSnapshot.is_snapshot_chunk_index_valid max_chunk_size <= 0 disables size cap")
    t.assert_true(CoopWorldSnapshot.is_snapshot_chunk_index_valid(0, 5, 999999, 0))
    t.assert_true(CoopWorldSnapshot.is_snapshot_chunk_index_valid(0, 5, 999999, -1))
