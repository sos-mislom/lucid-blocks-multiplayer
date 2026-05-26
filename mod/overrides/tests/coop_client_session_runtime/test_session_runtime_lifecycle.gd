extends RefCounted


func run(t: CoopTester) -> void:
    var runtime_script: GDScript = load("res://coop_mod/coop_client_session_runtime.gd")

    t.begin("CoopClientSessionRuntime initializes host rehost port")
    var runtime = runtime_script.new(34567)
    t.assert_eq(34567, runtime.host_rehost_port)
    t.assert_eq(false, runtime.reconnect_pending)
    t.assert_eq(false, runtime.client_menu_kick_pending)

    t.begin("CoopClientSessionRuntime reset_reconnect clears reconnect route")
    runtime.reconnect_pending = true
    runtime.reconnect_attempt_count = 3
    runtime.reconnect_retry_timer = 1.5
    runtime.reconnect_reason = "Server disconnected"
    runtime.reconnect_steam_lobby_id = 123
    runtime.reconnect_steam_host_id = 456
    runtime.reset_reconnect()
    t.assert_eq(false, runtime.reconnect_pending)
    t.assert_eq(0, runtime.reconnect_attempt_count)
    t.assert_eq(0.0, runtime.reconnect_retry_timer)
    t.assert_eq("", runtime.reconnect_reason)
    t.assert_eq(0, runtime.reconnect_steam_lobby_id)
    t.assert_eq(0, runtime.reconnect_steam_host_id)

    t.begin("CoopClientSessionRuntime begin_reconnect stores route and locks restore")
    runtime.begin_reconnect("Host is rehosting", 2.0, 77, 88)
    t.assert_eq(true, runtime.reconnect_pending)
    t.assert_eq(true, runtime.client_restore_in_progress)
    t.assert_eq(0, runtime.reconnect_attempt_count)
    t.assert_eq(2.0, runtime.reconnect_retry_timer)
    t.assert_eq("Host is rehosting", runtime.reconnect_reason)
    t.assert_eq(77, runtime.reconnect_steam_lobby_id)
    t.assert_eq(88, runtime.reconnect_steam_host_id)
    t.assert_eq(false, runtime.local_quit_in_progress)

    t.begin("CoopClientSessionRuntime begin_reconnect_attempt increments attempts")
    runtime.begin_reconnect_attempt(1.25)
    t.assert_eq(true, runtime.reconnect_pending)
    t.assert_eq(true, runtime.client_restore_in_progress)
    t.assert_eq(1, runtime.reconnect_attempt_count)
    t.assert_eq(1.25, runtime.reconnect_retry_timer)

    t.begin("CoopClientSessionRuntime start_menu_kick sets pending and sequence")
    var sequence: int = runtime.start_menu_kick()
    t.assert_eq(true, runtime.client_menu_kick_pending)
    t.assert_eq(sequence, runtime.client_menu_kick_sequence)
    t.assert_eq(1, sequence)

    t.begin("CoopClientSessionRuntime finish_leave_to_menu clears leave and advances sequence")
    runtime.local_quit_in_progress = true
    runtime.client_restore_in_progress = true
    runtime.receiving_host_world = true
    runtime.host_rehost_pending = true
    runtime.finish_leave_to_menu()
    t.assert_eq(false, runtime.reconnect_pending)
    t.assert_eq(false, runtime.host_rehost_pending)
    t.assert_eq(false, runtime.client_restore_in_progress)
    t.assert_eq(false, runtime.receiving_host_world)
    t.assert_eq(false, runtime.client_menu_kick_pending)
    t.assert_eq(false, runtime.local_quit_in_progress)
    t.assert_eq(2, runtime.client_menu_kick_sequence)
