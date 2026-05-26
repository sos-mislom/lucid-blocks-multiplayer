extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropSync.make_recent_drop_visibility_record fields")
    var record: Dictionary = CoopDropSync.make_recent_drop_visibility_record(
        "dim_overworld:0",
        3,
        true,
        123456,
    )
    t.assert_eq("dim_overworld:0", record.get("dimension_instance_key"))
    t.assert_eq(3, record.get("source_peer_id"))
    t.assert_eq(true, record.get("force_same_instance_peers"))
    t.assert_eq(123456, record.get("expires_at_msec"))

    t.begin("CoopDropSync.is_recent_drop_visibility_expired empty -> true")
    t.assert_true(CoopDropSync.is_recent_drop_visibility_expired({}, 0))

    t.begin("CoopDropSync.is_recent_drop_visibility_expired past expiry -> true")
    var expired_record: Dictionary = CoopDropSync.make_recent_drop_visibility_record("", 0, false, 1000)
    t.assert_true(CoopDropSync.is_recent_drop_visibility_expired(expired_record, 1000))
    t.assert_true(CoopDropSync.is_recent_drop_visibility_expired(expired_record, 2000))

    t.begin("CoopDropSync.is_recent_drop_visibility_expired live record -> false")
    var live_record: Dictionary = CoopDropSync.make_recent_drop_visibility_record("", 0, false, 5000)
    t.assert_false(CoopDropSync.is_recent_drop_visibility_expired(live_record, 1000))
    t.assert_false(CoopDropSync.is_recent_drop_visibility_expired(live_record, 4999))

    t.begin("CoopDropSync.is_recent_drop_visible_to_peer empty / non-positive peer -> false")
    t.assert_false(CoopDropSync.is_recent_drop_visible_to_peer({}, 5, "dim", false))
    t.assert_false(CoopDropSync.is_recent_drop_visible_to_peer(live_record, 0, "dim", true))
    t.assert_false(CoopDropSync.is_recent_drop_visible_to_peer(live_record, -3, "dim", true))

    t.begin("CoopDropSync.is_recent_drop_visible_to_peer instance mismatch -> false")
    var instance_record: Dictionary = CoopDropSync.make_recent_drop_visibility_record("dim_a:0", 5, false, 5000)
    t.assert_false(CoopDropSync.is_recent_drop_visible_to_peer(instance_record, 7, "dim_b:0", false))

    t.begin("CoopDropSync.is_recent_drop_visible_to_peer source peer is always visible")
    var source_record: Dictionary = CoopDropSync.make_recent_drop_visibility_record("dim_a:0", 5, false, 5000)
    t.assert_true(CoopDropSync.is_recent_drop_visible_to_peer(source_record, 5, "dim_a:0", false))

    t.begin("CoopDropSync.is_recent_drop_visible_to_peer empty instance key matches any active key")
    var any_instance_record: Dictionary = CoopDropSync.make_recent_drop_visibility_record("", 5, false, 5000)
    t.assert_true(CoopDropSync.is_recent_drop_visible_to_peer(any_instance_record, 5, "dim_anything", false))

    t.begin("CoopDropSync.is_recent_drop_visible_to_peer force_same_instance_peers requires same-instance peer")
    var force_record: Dictionary = CoopDropSync.make_recent_drop_visibility_record("dim_a:0", 5, true, 5000)
    t.assert_true(CoopDropSync.is_recent_drop_visible_to_peer(force_record, 7, "dim_a:0", true))
    t.assert_false(CoopDropSync.is_recent_drop_visible_to_peer(force_record, 7, "dim_a:0", false))

    t.begin("CoopDropSync.is_recent_drop_visible_to_peer non-source, non-force peer -> false")
    var strict_record: Dictionary = CoopDropSync.make_recent_drop_visibility_record("dim_a:0", 5, false, 5000)
    t.assert_false(CoopDropSync.is_recent_drop_visible_to_peer(strict_record, 7, "dim_a:0", true))
    t.assert_false(CoopDropSync.is_recent_drop_visible_to_peer(strict_record, 7, "dim_a:0", false))
