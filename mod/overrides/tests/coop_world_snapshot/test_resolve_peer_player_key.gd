extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldSnapshot.resolve_peer_player_key empty dict -> empty string")
    t.assert_eq("", CoopWorldSnapshot.resolve_peer_player_key({}))

    t.begin("CoopWorldSnapshot.resolve_peer_player_key explicit empty key -> empty string")
    t.assert_eq("", CoopWorldSnapshot.resolve_peer_player_key({"player_key": ""}))

    t.begin("CoopWorldSnapshot.resolve_peer_player_key whitespace-only key -> empty string")
    t.assert_eq("", CoopWorldSnapshot.resolve_peer_player_key({"player_key": "   \t\n"}))

    t.begin("CoopWorldSnapshot.resolve_peer_player_key strips surrounding whitespace")
    t.assert_eq("alice", CoopWorldSnapshot.resolve_peer_player_key({"player_key": "  alice  "}))

    t.begin("CoopWorldSnapshot.resolve_peer_player_key non-string is coerced via str()")
    t.assert_eq("12345", CoopWorldSnapshot.resolve_peer_player_key({"player_key": 12345}))

    t.begin("CoopWorldSnapshot.resolve_peer_player_key null player_key -> empty string")
    t.assert_eq("", CoopWorldSnapshot.resolve_peer_player_key({"player_key": null}))
