extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopConfig.normalize_bool_field null -> default")
    t.assert_eq(true, CoopConfig.normalize_bool_field(null, true))
    t.assert_eq(false, CoopConfig.normalize_bool_field(null, false))

    t.begin("CoopConfig.normalize_bool_field bool passes through")
    t.assert_eq(true, CoopConfig.normalize_bool_field(true, false))
    t.assert_eq(false, CoopConfig.normalize_bool_field(false, true))

    t.begin("CoopConfig.normalize_bool_field truthy numbers")
    t.assert_eq(true, CoopConfig.normalize_bool_field(1, false))
    t.assert_eq(true, CoopConfig.normalize_bool_field(-1, false))
    t.assert_eq(false, CoopConfig.normalize_bool_field(0, true))

    t.begin("CoopConfig.normalize_bool_field non-null preserves bool() coercion")
    # Mirrors the live `bool(config.get(<k>, <default>))` pattern — non-null
    # inputs ALWAYS run through bool(), only `null` triggers the default.
    t.assert_eq(false, CoopConfig.normalize_bool_field(0, true))
    t.assert_eq(true, CoopConfig.normalize_bool_field(1, false))
