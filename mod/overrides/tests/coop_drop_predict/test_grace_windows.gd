extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropPredict.is_drop_sync_grace_active now < grace_until -> true")
    t.assert_true(CoopDropPredict.is_drop_sync_grace_active(1500, 1000))

    t.begin("CoopDropPredict.is_drop_sync_grace_active now == grace_until -> false")
    t.assert_false(CoopDropPredict.is_drop_sync_grace_active(1000, 1000))

    t.begin("CoopDropPredict.is_drop_sync_grace_active now past grace -> false")
    t.assert_false(CoopDropPredict.is_drop_sync_grace_active(1000, 1500))
    t.assert_false(CoopDropPredict.is_drop_sync_grace_active(0, 100))

    t.begin("CoopDropPredict.is_drop_snapshot_grace_active never sampled -> false")
    t.assert_false(CoopDropPredict.is_drop_snapshot_grace_active(0, 100))
    t.assert_false(CoopDropPredict.is_drop_snapshot_grace_active(-1, 100))

    t.begin("CoopDropPredict.is_drop_snapshot_grace_active within default 1.1s window -> true")
    t.assert_true(CoopDropPredict.is_drop_snapshot_grace_active(1000, 1500))
    t.assert_true(CoopDropPredict.is_drop_snapshot_grace_active(1000, 2100))

    t.begin("CoopDropPredict.is_drop_snapshot_grace_active past default 1.1s window -> false")
    t.assert_false(CoopDropPredict.is_drop_snapshot_grace_active(1000, 2200))
    t.assert_false(CoopDropPredict.is_drop_snapshot_grace_active(1000, 5000))

    t.begin("CoopDropPredict.is_drop_snapshot_grace_active honours grace_sec override")
    t.assert_true(CoopDropPredict.is_drop_snapshot_grace_active(1000, 4000, 5.0))
    t.assert_false(CoopDropPredict.is_drop_snapshot_grace_active(1000, 1200, 0.1))

    t.begin("CoopDropPredict.is_predicted_drop_sync_grace_active mirrors is_drop_sync_grace_active")
    t.assert_true(CoopDropPredict.is_predicted_drop_sync_grace_active(2000, 1000))
    t.assert_false(CoopDropPredict.is_predicted_drop_sync_grace_active(1000, 2000))
