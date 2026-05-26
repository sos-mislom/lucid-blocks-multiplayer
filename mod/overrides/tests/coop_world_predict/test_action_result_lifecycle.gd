extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPredict.make_server_block_action_entry builds the canonical schema")
    var entry: Dictionary = CoopWorldPredict.make_server_block_action_entry(
        true, "dimension:0", Vector3i(1, 2, 3), 42, "ok", 5000,
    )
    t.assert_true(bool(entry.get("success", false)))
    t.assert_eq("dimension:0", str(entry.get("dimension_instance_key", "")))
    t.assert_eq(Vector3i(1, 2, 3), entry.get("block_position", Vector3i.ZERO))
    t.assert_eq(42, int(entry.get("block_id", -1)))
    t.assert_eq("ok", str(entry.get("reason", "")))
    t.assert_eq(5000, int(entry.get("created_ms", -1)))

    t.begin("CoopWorldPredict.is_action_result_expired strict-greater TTL")
    t.assert_false(CoopWorldPredict.is_action_result_expired(0, 1000, 1000), "1000ms elapsed == TTL -> kept (live `>` reject)")
    t.assert_true(CoopWorldPredict.is_action_result_expired(0, 1001, 1000), "1001ms > TTL -> expired")

    t.begin("CoopWorldPredict.is_action_result_expired now < created (clock skew) -> false")
    t.assert_false(CoopWorldPredict.is_action_result_expired(5000, 1000, 1000), "negative elapsed treated as not expired")

    t.begin("CoopWorldPredict.prune_expired_action_results removes only expired entries")
    var results: Dictionary = {
        "fresh": {"created_ms": 1500},  # elapsed = 500ms < TTL 1000
        "stale": {"created_ms": 100},   # elapsed = 1900ms > TTL 1000
    }
    var removed: int = CoopWorldPredict.prune_expired_action_results(results, 2000, 1000)
    t.assert_eq(1, removed)
    t.assert_true(results.has("fresh"))
    t.assert_false(results.has("stale"))

    t.begin("CoopWorldPredict.prune_expired_action_results missing created_ms defaults to now (survives one pass)")
    var no_ts: Dictionary = {"k": {}}
    CoopWorldPredict.prune_expired_action_results(no_ts, 2000, 1000)
    t.assert_true(no_ts.has("k"), "no timestamp -> treated as just-created")

    t.begin("CoopWorldPredict.purge_action_results_for_peer removes entries with peer prefix")
    var results2: Dictionary = {
        "3:1:place": {},
        "3:2:break": {},
        "5:1:place": {},
        "30:1:place": {},
    }
    var purged: int = CoopWorldPredict.purge_action_results_for_peer(results2, 3)
    t.assert_eq(2, purged)
    t.assert_false(results2.has("3:1:place"))
    t.assert_false(results2.has("3:2:break"))
    t.assert_true(results2.has("5:1:place"))
    t.assert_true(results2.has("30:1:place"), "peer prefix is `3:` so `30:` must NOT match")

    t.begin("CoopWorldPredict.purge_action_results_for_peer peer_id <= 0 is a no-op")
    var results3: Dictionary = {"3:1:place": {}}
    var nothing: int = CoopWorldPredict.purge_action_results_for_peer(results3, 0)
    t.assert_eq(0, nothing)
    t.assert_eq(1, results3.size())
