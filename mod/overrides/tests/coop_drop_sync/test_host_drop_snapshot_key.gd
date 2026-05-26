extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropSync.host_drop_snapshot_key formats peer_id:uuid")
    t.assert_eq("17:drop-uuid", CoopDropSync.host_drop_snapshot_key(17, "drop-uuid"))
    t.assert_eq("1:abc", CoopDropSync.host_drop_snapshot_key(1, "abc"))

    t.begin("CoopDropSync.host_drop_snapshot_key handles empty uuid")
    t.assert_eq("2:", CoopDropSync.host_drop_snapshot_key(2, ""))

    t.begin("CoopDropSync.host_drop_snapshot_key handles zero / negative peer")
    t.assert_eq("0:abc", CoopDropSync.host_drop_snapshot_key(0, "abc"))
    t.assert_eq("-1:abc", CoopDropSync.host_drop_snapshot_key(-1, "abc"))
