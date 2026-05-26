class_name CoopClientSessionRuntime
extends RefCounted

# Mutable client-session state that used to live as top-level fields on
# coop_manager.gd. RPC entry points and engine side effects stay on the manager.

var local_quit_in_progress: bool = false
var client_restore_in_progress: bool = false
var client_menu_kick_pending: bool = false
var client_menu_kick_sequence: int = 0
var reconnect_pending: bool = false
var reconnect_attempt_count: int = 0
var reconnect_retry_timer: float = 0.0
var reconnect_reason: String = ""
var reconnect_steam_lobby_id: int = 0
var reconnect_steam_host_id: int = 0
var host_rehost_pending: bool = false
var host_rehost_port: int = 24667
var receiving_host_world: bool = false


func _init(default_port: int = 24667) -> void:
    host_rehost_port = default_port


func reset_reconnect() -> void:
    reconnect_pending = false
    reconnect_attempt_count = 0
    reconnect_retry_timer = 0.0
    reconnect_reason = ""
    reconnect_steam_lobby_id = 0
    reconnect_steam_host_id = 0


func reset_leave_and_restore() -> void:
    client_restore_in_progress = false
    receiving_host_world = false
    client_menu_kick_pending = false
    local_quit_in_progress = false


func finish_leave_to_menu() -> void:
    reset_reconnect()
    host_rehost_pending = false
    reset_leave_and_restore()
    client_menu_kick_sequence += 1


func start_menu_kick() -> int:
    client_menu_kick_pending = true
    client_menu_kick_sequence += 1
    return client_menu_kick_sequence


func begin_reconnect(
    reason: String,
    retry_interval: float,
    steam_lobby_id: int,
    steam_host_id: int,
) -> void:
    reconnect_pending = true
    client_restore_in_progress = true
    reconnect_attempt_count = 0
    reconnect_retry_timer = retry_interval
    reconnect_reason = reason
    reconnect_steam_lobby_id = steam_lobby_id
    reconnect_steam_host_id = steam_host_id
    local_quit_in_progress = false


func begin_reconnect_attempt(retry_interval: float) -> void:
    reconnect_pending = true
    client_restore_in_progress = true
    reconnect_attempt_count += 1
    reconnect_retry_timer = retry_interval
    local_quit_in_progress = false
