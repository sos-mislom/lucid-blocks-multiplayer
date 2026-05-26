extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopStatus.build_heartbeat_headers always sets Content-Type")
    var no_token: PackedStringArray = CoopStatus.build_heartbeat_headers("")
    t.assert_eq(1, no_token.size())
    t.assert_eq("Content-Type: application/json", no_token[0])

    t.begin("CoopStatus.build_heartbeat_headers appends Bearer Authorization when token is set")
    var with_token: PackedStringArray = CoopStatus.build_heartbeat_headers("sekrit-token")
    t.assert_eq(2, with_token.size())
    t.assert_eq("Content-Type: application/json", with_token[0])
    t.assert_eq("Authorization: Bearer sekrit-token", with_token[1])

    t.begin("CoopStatus.build_heartbeat_headers trims surrounding whitespace from the token")
    var padded: PackedStringArray = CoopStatus.build_heartbeat_headers("  padded  ")
    t.assert_eq(2, padded.size())
    t.assert_eq("Authorization: Bearer padded", padded[1])

    t.begin("CoopStatus.build_heartbeat_headers treats whitespace-only token as absent")
    var whitespace_only: PackedStringArray = CoopStatus.build_heartbeat_headers("   \t")
    t.assert_eq(1, whitespace_only.size())
    t.assert_eq("Content-Type: application/json", whitespace_only[0])
