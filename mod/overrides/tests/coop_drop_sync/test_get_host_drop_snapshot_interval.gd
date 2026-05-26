extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropSync.get_host_drop_snapshot_interval near band (<= 24m^2)")
    t.assert_eq(0.08, CoopDropSync.get_host_drop_snapshot_interval(0.0))
    t.assert_eq(0.08, CoopDropSync.get_host_drop_snapshot_interval(10.0))
    t.assert_eq(0.08, CoopDropSync.get_host_drop_snapshot_interval(24.0 * 24.0))

    t.begin("CoopDropSync.get_host_drop_snapshot_interval mid band (24..64m^2)")
    t.assert_eq(0.18, CoopDropSync.get_host_drop_snapshot_interval(24.0 * 24.0 + 1.0))
    t.assert_eq(0.18, CoopDropSync.get_host_drop_snapshot_interval(50.0 * 50.0))
    t.assert_eq(0.18, CoopDropSync.get_host_drop_snapshot_interval(64.0 * 64.0))

    t.begin("CoopDropSync.get_host_drop_snapshot_interval far band (> 64m^2)")
    t.assert_eq(0.35, CoopDropSync.get_host_drop_snapshot_interval(64.0 * 64.0 + 1.0))
    t.assert_eq(0.35, CoopDropSync.get_host_drop_snapshot_interval(1000.0 * 1000.0))

    t.begin("CoopDropSync.get_host_drop_snapshot_interval honours overrides")
    t.assert_eq(0.5, CoopDropSync.get_host_drop_snapshot_interval(0.0, 8.0, 32.0, 0.5, 1.0, 2.0))
    t.assert_eq(1.0, CoopDropSync.get_host_drop_snapshot_interval(100.0, 8.0, 32.0, 0.5, 1.0, 2.0))
    t.assert_eq(2.0, CoopDropSync.get_host_drop_snapshot_interval(10000.0, 8.0, 32.0, 0.5, 1.0, 2.0))
