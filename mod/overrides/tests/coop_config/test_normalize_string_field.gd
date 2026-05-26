extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopConfig.normalize_string_field strips whitespace")
    t.assert_eq("alpha", CoopConfig.normalize_string_field("  alpha  ", "fallback"))
    t.assert_eq("alpha", CoopConfig.normalize_string_field("\talpha\n", "fallback"))

    t.begin("CoopConfig.normalize_string_field passes through non-empty strings")
    t.assert_eq("alpha", CoopConfig.normalize_string_field("alpha", "fallback"))
    t.assert_eq("alpha beta", CoopConfig.normalize_string_field("alpha beta", "fallback"))

    t.begin("CoopConfig.normalize_string_field empty string remains empty (not default)")
    t.assert_eq("", CoopConfig.normalize_string_field("", "fallback"))
    t.assert_eq("", CoopConfig.normalize_string_field("   ", "fallback"))

    t.begin("CoopConfig.normalize_string_field null -> stripped default")
    t.assert_eq("fallback", CoopConfig.normalize_string_field(null, "fallback"))
    t.assert_eq("fallback", CoopConfig.normalize_string_field(null, "  fallback  "))
    t.assert_eq("", CoopConfig.normalize_string_field(null, ""))

    t.begin("CoopConfig.normalize_string_field non-string values coerced via str()")
    t.assert_eq("42", CoopConfig.normalize_string_field(42, "fallback"))
    t.assert_eq("true", CoopConfig.normalize_string_field(true, "fallback"))

    t.begin("CoopConfig.normalize_string_field_with_default_when_empty falls back when stripped is empty")
    t.assert_eq("public", CoopConfig.normalize_string_field_with_default_when_empty("", "public"))
    t.assert_eq("public", CoopConfig.normalize_string_field_with_default_when_empty("   ", "public"))
    t.assert_eq("public", CoopConfig.normalize_string_field_with_default_when_empty(null, "public"))

    t.begin("CoopConfig.normalize_string_field_with_default_when_empty keeps non-empty input")
    t.assert_eq("custom", CoopConfig.normalize_string_field_with_default_when_empty("custom", "public"))
    t.assert_eq("custom", CoopConfig.normalize_string_field_with_default_when_empty("  custom  ", "public"))
