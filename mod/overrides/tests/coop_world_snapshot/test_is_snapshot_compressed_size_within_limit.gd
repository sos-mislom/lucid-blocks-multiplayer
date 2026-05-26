extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldSnapshot.is_snapshot_compressed_size_within_limit under cap -> true")
    t.assert_true(CoopWorldSnapshot.is_snapshot_compressed_size_within_limit(100, 1024))

    t.begin("CoopWorldSnapshot.is_snapshot_compressed_size_within_limit exactly at cap -> true")
    t.assert_true(CoopWorldSnapshot.is_snapshot_compressed_size_within_limit(1024, 1024))

    t.begin("CoopWorldSnapshot.is_snapshot_compressed_size_within_limit one byte over -> false")
    t.assert_false(CoopWorldSnapshot.is_snapshot_compressed_size_within_limit(1025, 1024))

    t.begin("CoopWorldSnapshot.is_snapshot_compressed_size_within_limit max_size <= 0 disables cap")
    t.assert_true(CoopWorldSnapshot.is_snapshot_compressed_size_within_limit(99999999, 0))
    t.assert_true(CoopWorldSnapshot.is_snapshot_compressed_size_within_limit(99999999, -1))

    t.begin("CoopWorldSnapshot.is_snapshot_compressed_size_within_limit empty payload -> true")
    t.assert_true(CoopWorldSnapshot.is_snapshot_compressed_size_within_limit(0, 1024))
