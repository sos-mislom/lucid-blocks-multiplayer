extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopConfig.clamp_registry_cache_ttl_sec null -> clamped default")
    t.assert_eq(60, CoopConfig.clamp_registry_cache_ttl_sec(null, 60))

    t.begin("CoopConfig.clamp_registry_cache_ttl_sec null with negative default clamps to 0")
    t.assert_eq(0, CoopConfig.clamp_registry_cache_ttl_sec(null, -10))

    t.begin("CoopConfig.clamp_registry_cache_ttl_sec positive value passes through")
    t.assert_eq(0, CoopConfig.clamp_registry_cache_ttl_sec(0, 60))
    t.assert_eq(60, CoopConfig.clamp_registry_cache_ttl_sec(60, 30))
    t.assert_eq(3600, CoopConfig.clamp_registry_cache_ttl_sec(3600, 60))

    t.begin("CoopConfig.clamp_registry_cache_ttl_sec negative value clamps to 0")
    t.assert_eq(0, CoopConfig.clamp_registry_cache_ttl_sec(-1, 60))
    t.assert_eq(0, CoopConfig.clamp_registry_cache_ttl_sec(-9999, 60))

    t.begin("CoopConfig.clamp_registry_cache_ttl_sec int-string values coerced via int()")
    t.assert_eq(120, CoopConfig.clamp_registry_cache_ttl_sec("120", 60))
    t.assert_eq(0, CoopConfig.clamp_registry_cache_ttl_sec("not a number", 60))

    t.begin("CoopConfig.clamp_registry_cache_ttl_sec float values truncated via int()")
    t.assert_eq(120, CoopConfig.clamp_registry_cache_ttl_sec(120.7, 60))
    t.assert_eq(0, CoopConfig.clamp_registry_cache_ttl_sec(0.4, 60))
