extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.parse_admin_keys accepts an Array of strings")
    var from_array: PackedStringArray = CoopAdmin.parse_admin_keys(["alice", "bob"])
    t.assert_eq_packed_string_array(PackedStringArray(["alice", "bob"]), from_array)

    t.begin("CoopAdmin.parse_admin_keys trims whitespace and drops blanks in Array input")
    var trimmed_array: PackedStringArray = CoopAdmin.parse_admin_keys(["  alice  ", "", "   ", "bob"])
    t.assert_eq_packed_string_array(PackedStringArray(["alice", "bob"]), trimmed_array)

    t.begin("CoopAdmin.parse_admin_keys deduplicates Array input preserving first occurrence")
    var deduped_array: PackedStringArray = CoopAdmin.parse_admin_keys(["alice", "alice", "bob"])
    t.assert_eq_packed_string_array(PackedStringArray(["alice", "bob"]), deduped_array)

    t.begin("CoopAdmin.parse_admin_keys splits comma-separated strings")
    t.assert_eq_packed_string_array(PackedStringArray(["alice", "bob"]), CoopAdmin.parse_admin_keys("alice,bob"))

    t.begin("CoopAdmin.parse_admin_keys splits semicolon-separated strings")
    t.assert_eq_packed_string_array(PackedStringArray(["alice", "bob"]), CoopAdmin.parse_admin_keys("alice;bob"))

    t.begin("CoopAdmin.parse_admin_keys handles mixed comma+semicolon delimiters")
    t.assert_eq_packed_string_array(PackedStringArray(["alice", "bob", "carol"]), CoopAdmin.parse_admin_keys("alice,bob;carol"))

    t.begin("CoopAdmin.parse_admin_keys preserves casing (comparison is case-sensitive)")
    t.assert_eq_packed_string_array(PackedStringArray(["Alice", "bob"]), CoopAdmin.parse_admin_keys("Alice,bob"))

    t.begin("CoopAdmin.parse_admin_keys returns empty PackedStringArray for empty / whitespace input")
    t.assert_eq(0, CoopAdmin.parse_admin_keys("").size())
    t.assert_eq(0, CoopAdmin.parse_admin_keys("   ").size())
    t.assert_eq(0, CoopAdmin.parse_admin_keys([]).size())
