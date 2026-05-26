extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerRegistry.build_cache_payload pins fields")
    var data: Dictionary = {"servers": [{"name": "alpha"}]}
    var payload: Dictionary = CoopServerRegistry.build_cache_payload(1700000000, data)
    t.assert_eq(1700000000, int(payload.get("fetched_unix", 0)))
    t.assert_eq(true, payload.get("data") == data)

    t.begin("CoopServerRegistry.build_cache_payload accepts arbitrary data Variant")
    payload = CoopServerRegistry.build_cache_payload(0, [{"a": 1}, {"b": 2}])
    t.assert_eq(0, int(payload.get("fetched_unix", 0)))
    t.assert_eq(true, payload.get("data") is Array)

    t.begin("CoopServerRegistry.build_cache_payload preserves null data")
    payload = CoopServerRegistry.build_cache_payload(123, null)
    t.assert_eq(123, int(payload.get("fetched_unix", 0)))
    t.assert_eq(true, payload.has("data"))
    t.assert_eq(true, payload.get("data") == null)
