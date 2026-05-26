extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopReconnect.format_reconnect_subtitle includes reason and 1-indexed attempt count")
    t.assert_eq(
        "Connection lost\nRetrying in 2.5s (attempt 3)",
        CoopReconnect.format_reconnect_subtitle("Connection lost", 2.5, 2),
    )

    t.begin("CoopReconnect.format_reconnect_subtitle rounds to one decimal place")
    t.assert_eq(
        "Network issue\nRetrying in 1.7s (attempt 1)",
        CoopReconnect.format_reconnect_subtitle("Network issue", 1.66666, 0),
    )

    t.begin("CoopReconnect.format_reconnect_subtitle preserves multi-line reason")
    t.assert_eq(
        "line1\nline2\nRetrying in 0.0s (attempt 5)",
        CoopReconnect.format_reconnect_subtitle("line1\nline2", 0.0, 4),
    )

    t.begin("CoopReconnect.format_attempting_now_subtitle includes reason")
    t.assert_eq(
        "Connection lost\nAttempting reconnect now...",
        CoopReconnect.format_attempting_now_subtitle("Connection lost"),
    )

    t.begin("CoopReconnect.format_attempting_now_subtitle empty reason still shows suffix")
    t.assert_eq(
        "\nAttempting reconnect now...",
        CoopReconnect.format_attempting_now_subtitle(""),
    )
