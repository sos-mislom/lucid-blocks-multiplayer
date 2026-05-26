extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerRegistry.is_cache_payload_fresh ttl_sec <= 0 disables gate")
    t.assert_eq(true, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": 1000}, 9_999_999, 0))
    t.assert_eq(true, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": 1000}, 9_999_999, -5))

    t.begin("CoopServerRegistry.is_cache_payload_fresh missing fetched_unix is treated as fresh")
    t.assert_eq(true, CoopServerRegistry.is_cache_payload_fresh({}, 9_999_999, 60))

    t.begin("CoopServerRegistry.is_cache_payload_fresh fetched_unix <= 0 is treated as fresh")
    t.assert_eq(true, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": 0}, 9_999_999, 60))
    t.assert_eq(true, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": -10}, 9_999_999, 60))

    t.begin("CoopServerRegistry.is_cache_payload_fresh within TTL returns true")
    t.assert_eq(true, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": 1000}, 1059, 60))
    t.assert_eq(true, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": 1000}, 1060, 60))

    t.begin("CoopServerRegistry.is_cache_payload_fresh outside TTL returns false")
    t.assert_eq(false, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": 1000}, 1061, 60))
    t.assert_eq(false, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": 1000}, 99_999, 60))

    t.begin("CoopServerRegistry.is_cache_payload_fresh future fetched_unix yields negative age -> fresh")
    # Clock skew - cache appears to be from the future. Since
    # `now - fetched_unix` is negative, it is <= ttl_sec and we say it's
    # still fresh. Matches the live behavior (no special-casing).
    t.assert_eq(true, CoopServerRegistry.is_cache_payload_fresh({"fetched_unix": 5_000}, 1_000, 60))
