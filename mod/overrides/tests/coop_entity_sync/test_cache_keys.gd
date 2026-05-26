extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.host_entity_snapshot_key formats as <peer>:<uuid>")
    t.assert_eq("2:abc-123", CoopEntitySync.host_entity_snapshot_key(2, "abc-123"))
    t.assert_eq("1:", CoopEntitySync.host_entity_snapshot_key(1, ""))

    t.begin("CoopEntitySync.host_entity_visual_key matches snapshot key shape")
    t.assert_eq(
        CoopEntitySync.host_entity_snapshot_key(7, "uuid-xyz"),
        CoopEntitySync.host_entity_visual_key(7, "uuid-xyz"),
        "visual and snapshot caches share the same key shape (different dicts though)",
    )

    t.begin("CoopEntitySync.host_drop_snapshot_key matches the same shape (Phase 14a will reuse)")
    t.assert_eq(
        CoopEntitySync.host_entity_snapshot_key(3, "drop-uuid"),
        CoopEntitySync.host_drop_snapshot_key(3, "drop-uuid"),
    )

    t.begin("CoopEntitySync.peer_cache_key_prefix matches the begins_with check")
    var prefix: String = CoopEntitySync.peer_cache_key_prefix(42)
    t.assert_eq("42:", prefix)
    t.assert_true(CoopEntitySync.host_entity_snapshot_key(42, "uuid").begins_with(prefix))
    t.assert_false(CoopEntitySync.host_entity_snapshot_key(4, "2:uuid").begins_with(prefix),
        "prefix must include the colon - peer 4 with uuid '2:uuid' must NOT match the peer-42 prefix")
