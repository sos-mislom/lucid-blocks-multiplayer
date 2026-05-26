extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopReconnect.compute_next_attempt_kind no Steam IDs -> lan")
    t.assert_eq("lan", CoopReconnect.compute_next_attempt_kind(0, 0, true, true))

    t.begin("CoopReconnect.compute_next_attempt_kind steam host with create_client")
    t.assert_eq("steam_create_client", CoopReconnect.compute_next_attempt_kind(12345, 0, true, false))

    t.begin("CoopReconnect.compute_next_attempt_kind steam host without create_client + lobby with connect_to_lobby")
    t.assert_eq(
        "steam_connect_to_lobby",
        CoopReconnect.compute_next_attempt_kind(12345, 67890, false, true),
    )

    t.begin("CoopReconnect.compute_next_attempt_kind lobby only with connect_to_lobby")
    t.assert_eq(
        "steam_connect_to_lobby",
        CoopReconnect.compute_next_attempt_kind(0, 67890, false, true),
    )

    t.begin("CoopReconnect.compute_next_attempt_kind lobby only without connect_to_lobby falls back to joinLobby")
    t.assert_eq(
        "steam_join_lobby",
        CoopReconnect.compute_next_attempt_kind(0, 67890, false, false),
    )

    t.begin("CoopReconnect.compute_next_attempt_kind host-only without create_client and no lobby -> lan")
    # Live fallthrough: host-id known but peer can't create_client; with no
    # lobby id we end up on the LAN branch.
    t.assert_eq(
        "lan",
        CoopReconnect.compute_next_attempt_kind(12345, 0, false, false),
    )

    t.begin("CoopReconnect.compute_next_attempt_kind host preferred over lobby when create_client is available")
    t.assert_eq(
        "steam_create_client",
        CoopReconnect.compute_next_attempt_kind(12345, 67890, true, true),
    )

    t.begin("CoopReconnect.compute_next_attempt_kind negative ids treated as zero")
    t.assert_eq(
        "lan",
        CoopReconnect.compute_next_attempt_kind(-1, -1, true, true),
    )
