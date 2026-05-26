extends RefCounted


func run(t: CoopTester) -> void:
    var base_state: Dictionary = CoopDropSync.build_host_drop_snapshot_state(
        Vector3(10.0, 10.0, 10.0),
        Vector3(0.0, 0.0, 0.0),
        "42:1",
        true,
        1,
    )

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed empty previous -> true")
    t.assert_true(CoopDropSync.is_host_drop_snapshot_state_changed({}, base_state))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed identical -> false")
    t.assert_false(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, base_state.duplicate(true)))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed item signature flip")
    var changed: Dictionary = base_state.duplicate(true)
    changed["item"] = "42:2"
    t.assert_true(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed can_collect flip")
    changed = base_state.duplicate(true)
    changed["can_collect"] = false
    t.assert_true(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed state enum flip")
    changed = base_state.duplicate(true)
    changed["state"] = 2
    t.assert_true(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed position within tolerance -> false")
    changed = base_state.duplicate(true)
    changed["position"] = Vector3(10.05, 10.0, 10.0)
    t.assert_false(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed position past tolerance -> true")
    changed = base_state.duplicate(true)
    changed["position"] = Vector3(11.0, 10.0, 10.0)
    t.assert_true(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed velocity within tolerance -> false")
    changed = base_state.duplicate(true)
    changed["velocity"] = Vector3(0.1, 0.0, 0.0)
    t.assert_false(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed velocity past tolerance -> true")
    changed = base_state.duplicate(true)
    changed["velocity"] = Vector3(0.5, 0.0, 0.0)
    t.assert_true(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed))

    t.begin("CoopDropSync.is_host_drop_snapshot_state_changed honours override thresholds")
    changed = base_state.duplicate(true)
    changed["position"] = Vector3(10.5, 10.0, 10.0)
    t.assert_false(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed, 1.0, 1.0))
    t.assert_true(CoopDropSync.is_host_drop_snapshot_state_changed(base_state, changed, 0.001, 0.001))
