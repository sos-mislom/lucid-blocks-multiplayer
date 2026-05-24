extends Node


const AvatarRegistry = preload("res://coop_mod/avatar_registry.gd")
const RemotePlayerMarkerScript = preload("res://coop_mod/remote_player_marker.gd")
const CONFIG_PATH: String = "user://lucid_blocks_coop_config.json"
const SERVER_REGISTRY_PATH: String = "user://lucid_blocks_server_registry.json"
const SERVER_REGISTRY_CACHE_PATH: String = "user://lucid_blocks_server_registry_cache.json"
const DEFAULT_PORT: int = 24667
const MAX_CLIENTS: int = 4
const DEFAULT_DEDICATED_WORLD_TITLE: String = "Dedicated Coop"
const DEFAULT_STATUS_PORT_OFFSET: int = 1
const SESSION_TRANSPORT_LAN: String = "lan"
const SESSION_TRANSPORT_STEAM: String = "steam"
const SERVER_WORLD_ONLY_KEY: String = "coop_server_only"
const SERVER_WORLD_SEAL_VERSION_KEY: String = "coop_server_seal_version"
const SERVER_WORLD_SEAL_HASH_KEY: String = "coop_server_seal_hash"
const SERVER_WORLD_SEAL_TIME_KEY: String = "coop_server_seal_time"
const SERVER_WORLD_SEAL_VERSION: int = 1
const SERVER_AUTHORITATIVE_WORLD: bool = true
const COOP_PROTOCOL_NAME: String = "lucid-blocks-coop"
const COOP_PROTOCOL_VERSION: int = 1
const COOP_PROTOCOL_MIN_COMPATIBLE: int = 1
const COOP_PROTOCOL_FEATURES: Array = []
const COOP_PROTOCOL_REQUIRED_FEATURES: Array = []
const COOP_BUILD_TAG: String = "client-cache-hidden-leave-force-2026-05-24"
const SERVER_BROWSER_CARD_WIDTH: float = 300.0
const SERVER_BROWSER_CARD_HEIGHT: float = 64.0
const SERVER_BROWSER_TIMEOUT_MSEC: int = 8000
const SERVER_CONNECT_TIMEOUT_MSEC: int = 12000
const CLIENT_MENU_KICK_TIMEOUT_SEC: float = 3.0
const CLIENT_GUEST_RESTORE_TIMEOUT_SEC: float = 2.0
const SERVER_REGISTRY_CACHE_TTL_SEC: int = 15 * 60
const SERVER_REGISTRY_HEARTBEAT_INTERVAL_SEC: float = 30.0
const DEFAULT_PUBLIC_SERVERS: Array = []
const SEND_INTERVAL: float = 0.025
const WORLD_STATE_INTERVAL: float = 0.05
const DEDICATED_TARGET_TPS: int = 60
const DEDICATED_SEND_INTERVAL: float = 1.0 / 20.0
const DEDICATED_WORLD_STATE_INTERVAL: float = 0.08
const DEDICATED_WATER_SYNC_INTERVAL: float = 1.25
const DEDICATED_TPS_SAMPLE_INTERVAL: float = 2.0
const DEDICATED_TPS_WARN_INTERVAL: float = 15.0
const DEDICATED_HEALTH_LOG_INTERVAL: float = 30.0
const DEDICATED_TPS_SOFT_FLOOR: float = 50.0
const DEDICATED_TPS_HARD_FLOOR: float = 42.0
const DEDICATED_LOAD_FOCUS_HOLD_SEC: float = 2.5
const DEDICATED_ACTION_LOAD_TIMEOUT_SEC: float = 4.0
const DEDICATED_CHUNK_TICKET_HOLD_SEC: float = 6.0
const DEDICATED_CHUNK_TICKET_CLEANUP_INTERVAL_SEC: float = 0.5
const DEDICATED_MAX_WORLD_LOAD_TICKET_CENTERS: int = 4
const SERVER_ACTION_RESULT_TTL_MSEC: int = 60000
const SERVER_ACTION_RESULT_CLEANUP_INTERVAL_SEC: float = 5.0
const SERVER_DIRTY_CHUNK_FLUSH_INTERVAL_SEC: float = 60.0
const SERVER_RECENT_DROP_VISIBILITY_SEC: float = 8.0
const DEFAULT_DEDICATED_LOAD_RADIUS: int = 80
const DEFAULT_DEDICATED_BUFFER_RADIUS: int = 80
const ENTITY_DR_POS_ERR_SQ: float = 0.0225
const ENTITY_DR_KB_ERR_SQ: float = 0.25
const ENTITY_DR_YAW_ERR_DEG: float = 5.0
const ENTITY_DR_HEARTBEAT_SEC: float = 0.25
const ENTITY_WORLD_STATE_MAX_INTERVAL_SEC: float = 1.25
const ENTITY_VISUAL_STATE_INTERVAL: float = 0.15
const CLIENT_ENTITY_SYNC_GRACE_SEC: float = 2.0
const DROP_DR_POS_ERR_SQ: float = 0.01
const DROP_DR_VEL_ERR_SQ: float = 0.04
const DROP_WORLD_STATE_MAX_INTERVAL_SEC: float = 0.75
const CLIENT_DROP_SYNC_GRACE_SEC: float = 1.1
const PERSIST_INTERVAL: float = 1.0
const AUTOSAVE_INTERVAL: float = 15.0 * 60.0
const HOST_TIMEOUT_SECONDS: float = 30.0
const AUTO_RECONNECT_INTERVAL: float = 2.0
const PANEL_WIDTH: float = 224.0
const SNAPSHOT_CHUNK_SIZE: int = 60000
const CLIENT_SAFE_MAX_TEXT_LENGTH: int = 512
const CLIENT_SAFE_MAX_COMMAND_RESPONSE_LENGTH: int = 1024
const CLIENT_SAFE_MAX_REGISTER_JSON_BYTES: int = 512 * 1024
const CLIENT_SAFE_MAX_SNAPSHOT_CHUNKS: int = 256
const CLIENT_SAFE_MAX_SNAPSHOT_COMPRESSED_BYTES: int = 24 * 1024 * 1024
const CLIENT_SAFE_MAX_SNAPSHOT_DECOMPRESSED_BYTES: int = 96 * 1024 * 1024
const CLIENT_SAFE_MAX_ENTITY_SNAPSHOTS: int = 384
const CLIENT_SAFE_MAX_DROP_SNAPSHOTS: int = 768
const CLIENT_SAFE_MAX_PEER_SNAPSHOT_ENTRIES: int = 16
const CLIENT_SAFE_MAX_WORLD_CHANGES: int = 2048
const CLIENT_SAFE_MAX_STORAGE_ITEMS: int = 128
const CLIENT_SAFE_MAX_ITEM_DATA_INTS: int = 128
const CLIENT_SAFE_MAX_UUID_LENGTH: int = 96
const CLIENT_SAFE_MAX_ABS_COORD: float = 1000000.0
const CLIENT_SAFE_MAX_PLAYER_DAMAGE: int = 200
const CLIENT_SAFE_MAX_KNOCKBACK: float = 60.0
const CLIENT_SAFE_ENTITY_SCENE_PREFIXES: PackedStringArray = [
    "res://main/entity/"
]
const CLIENT_SAFE_SAVE_SCENE_PREFIXES: PackedStringArray = [
    "res://main/entity/",
    "res://main/world/living_block/"
]
const DEFAULT_AVATAR_ID: String = "default_blocky"
const REMOTE_PROXY_SCENE_PATH: String = "res://coop_mod/remote_player_proxy.tscn"
const HOST_SESSION_MIN_LOAD_RADIUS: int = 96
const HOST_SESSION_MAX_LOAD_RADIUS: int = 96
const HOST_SESSION_EDGE_BUFFER: float = 72.0
const HOST_SESSION_RADIUS_STEP: int = 16
const SHARED_BUBBLE_SOFT_TETHER_DISTANCE: float = 64.0
const SHARED_BUBBLE_HARD_TETHER_DISTANCE: float = 80.0
const SHARED_BUBBLE_TETHER_PULL: float = 10.0
const ENTITY_SYNC_RADIUS: float = 112.0
const DEFAULT_SERVER_ENTITY_VIEW_RADIUS: float = ENTITY_SYNC_RADIUS
const DEFAULT_SERVER_ENTITY_SIMULATION_RADIUS: float = 128.0
const DROP_SYNC_RADIUS: float = 96.0
const CLIENT_ENTITY_DUMMY_SIZE: Vector3 = Vector3(0.55, 1.35, 0.55)
const GUEST_LOCAL_ENTITY_AUTHORITY_DISTANCE: float = 192.0
const GUEST_LOCAL_ENTITY_RELEASE_DISTANCE: float = 160.0
const GUEST_ENTITY_STATE_INTERVAL: float = 0.35
const SESSION_TARGET_STICK_DISTANCE: float = 8.0
const ENTITY_ATTACK_REQUEST_MAX_DISTANCE: float = 6.0
const BREAK_OUTLINE_SCENE_PATH: String = "res://main/entity/behaviors/break_blocks/break_block_outline.tscn"
const DROPPED_ITEM_SCENE_PATH: String = "res://main/items/dropped_item/dropped_item.tscn"
const VISUAL_BALL_SCENE_PATH: String = "res://main/items/held_item/held_ball_thrower/ball.tscn"
const VISUAL_BOLT_SCENE_PATH: String = "res://main/entity/baal/bolt/mini_bolt.tscn"
const VISUAL_HEART_SCENE_PATH: String = "res://main/items/held_item/held_heart_thrower/heart/heart.tscn"
const VISUAL_BLAST_SCENE_PATH: String = "res://main/items/held_item/held_blaster/blast/blast.tscn"
const AUTHORITATIVE_BOLT_SCENE_PATH: String = "res://main/entity/baal/bolt/bolt.tscn"
const VISUAL_PROJECTILE_LIFETIME: float = 5.0
const CLIENT_DROP_CORRECTION_DISTANCE: float = 1.35
const CLIENT_DROP_POSITION_BLEND: float = 0.45
const CLIENT_DROP_VELOCITY_BLEND: float = 0.7
const CLIENT_PREDICTED_DROP_MATCH_DISTANCE: float = 2.5
const CLIENT_PREDICTED_DROP_LIFETIME: float = 1.5
const CLIENT_PENDING_PICKUP_LIFETIME: float = 4.0
const CLIENT_AUTO_PICKUP_RADIUS: float = 2.35
const CLIENT_PREDICTED_DROP_SYNC_GRACE_MS: int = 350
const CLIENT_DIRECT_DROP_SYNC_GRACE_MS: int = 900
const CLIENT_DROP_MERGE_ANIMATION_DISTANCE: float = 2.6
const CLIENT_DROP_MERGE_ANIMATION_TIME: float = 0.12
const CLIENT_PICKUP_PULL_ANIMATION_TIME: float = 0.1
const CLIENT_PICKUP_PULL_OFFSET: Vector3 = Vector3(0.0, 0.95, 0.0)
const CLIENT_ENTITY_QUERY_LAYER: int = 16
const CLIENT_ENTITY_HIT_COOLDOWN_SEC: float = 0.33
const WATER_SYNC_INTERVAL: float = 0.12
const HOST_DYNAMIC_CELL_RESAMPLE_INTERVAL_SEC: float = 1.0
const LOCAL_WORLD_PATCH_FLUSH_INTERVAL: float = 0.18
const GUEST_WORLD_PATCH_FLUSH_TIMEOUT_SEC: float = 0.4
const WATER_SYNC_HORIZONTAL_RADIUS: int = 8
const WATER_SYNC_VERTICAL_RADIUS: int = 6
const WATER_SYNC_BUCKET_SIZE: float = 4.0
const CLIENT_SYNCED_ENTITY_VISUAL_NEAR_RADIUS: float = 48.0
const CLIENT_SYNCED_ENTITY_VISUAL_MID_RADIUS: float = 88.0
const CLIENT_SYNCED_ENTITY_VISUAL_MID_INTERVAL: float = 1.0 / 30.0
const CLIENT_SYNCED_ENTITY_VISUAL_FAR_INTERVAL: float = 1.0 / 15.0
const DEBUG_SPAWN_DISTANCE: float = 6.0
const DEBUG_SPAWN_RESOURCE_DIR: String = "res://main/items/data/spawners"
const ENABLE_DEBUG_CONSOLE_COMMANDS_DEFAULT: bool = false
const ENABLE_CLIENT_VISUAL_MOD_DEFAULT: bool = true
const ENABLE_AVATAR_CUSTOMIZATION_DEFAULT: bool = false
const ENABLE_AVATAR_ALIAS_COMMAND_DEFAULT: bool = false
const WORLD_EDIT_CHUNK_SIZE_X: int = 16
const WORLD_EDIT_CHUNK_SIZE_Z: int = 16
const WORLD_EDIT_DEFAULT_CLEAR_HEIGHT: int = 18
const WORLD_EDIT_DEFAULT_BORDER_HEIGHT: int = 5
const WORLD_EDIT_MAX_BLOCK_OPS: int = 300000
const DEFAULT_SERVER_COMMAND_POLICY: Dictionary = {
    "tp": true,
    "fly": false,
    "give": false,
    "gamemode": false,
    "gm": false,
    "spawn": false,
    "spawnlist": false,
    "spawnmenu": false,
    "mobs": false,
    "time": false,
    "weather": false,
    "kill": false,
    "wand": false,
    "pos1": false,
    "pos2": false,
    "sel": false,
    "fill": false,
    "clear": false,
    "floor": false,
    "flat": false,
    "border": false,
    "peaceful": false,
    "daylock": false,
    "builder_setup": false,
}
const CORE_DEBUG_COMMAND_NAMES: PackedStringArray = [
    "/give", "/gamemode", "/gm", "/spawn", "/spawnlist", "/spawnmenu", "/mobs",
    "/time", "/weather", "/kill", "/fly"
]
const ADMIN_BUILDER_COMMAND_NAMES: PackedStringArray = [
    "wand", "pos1", "pos2", "sel", "fill", "clear", "floor", "flat", "border",
    "peaceful", "daylock", "builder_setup"
]
const STEAM_LOBBY_TYPE_FRIENDS_ONLY: int = 1
const STEAM_RESULT_OK: int = 1
const STEAM_CHAT_ROOM_ENTER_RESPONSE_SUCCESS: int = 1
const STEAM_LOBBY_DATA_NAME: String = "name"
const STEAM_LOBBY_DATA_TRANSPORT: String = "lb_transport"
const STEAM_LOBBY_DATA_HOST_NAME: String = "lb_host_name"
const STEAM_RICH_PRESENCE_CONNECT_KEY: String = "connect"
const STEAM_RICH_PRESENCE_STATUS_KEY: String = "status"
const STEAM_CONNECT_LOBBY_PREFIX: String = "+connect_lobby "
const DEBUG_SPAWN_FALLBACK_IDS: PackedStringArray = [
    "agni", "archangel", "baal", "bee", "blasphemy", "boid", "bubble", "bubblebear", "chicken", "diatom", "egg_bubblebear", "egg_chicken", "fish", "floating_fish", "fruit_girl", "fungus_bubblebear", "gel", "glaggler", "golem", "hamsa", "kali", "kodama", "leviathan", "manikin", "meeshuu", "metal_gel", "metal_golem", "mimic", "mini_gel", "moccos", "ofanim", "plastic_sheep", "preta", "shark", "sheep", "sunny", "vyrm", "wildebeest", "worm", "yhvh"
]
const REVIVE_RADIUS: float = 3.2
const REVIVE_HOLD_TIME: float = 1.6
const DOWNED_VOID_Y: float = -96.0
const DOWNED_REVIVER_GRACE_SEC: float = 2.0
const ENABLE_ENTITY_SYNC: bool = true


var config: Dictionary = {
    "address": "127.0.0.1",
    "port": DEFAULT_PORT,
    "avatar_id": DEFAULT_AVATAR_ID,
    "server_registry_url": "",
    "server_registry_heartbeat_url": "",
    "server_registry_token": "",
    "server_save_secret": "",
    "server_public_address": "",
    "server_public_name": "",
    "server_public_region": "public",
    "show_direct_connect_tab": false,
    "enable_debug_console_commands": ENABLE_DEBUG_CONSOLE_COMMANDS_DEFAULT,
    "enable_client_visual_mod": ENABLE_CLIENT_VISUAL_MOD_DEFAULT,
    "enable_avatar_customization": ENABLE_AVATAR_CUSTOMIZATION_DEFAULT,
    "enable_avatar_alias_command": ENABLE_AVATAR_ALIAS_COMMAND_DEFAULT,
    "server_registry_cache_ttl_sec": SERVER_REGISTRY_CACHE_TTL_SEC,
    "server_entity_view_radius": DEFAULT_SERVER_ENTITY_VIEW_RADIUS,
    "server_entity_simulation_radius": DEFAULT_SERVER_ENTITY_SIMULATION_RADIUS,
    "server_command_policy": DEFAULT_SERVER_COMMAND_POLICY.duplicate(true),
    "server_admin_keys": [],
}
var dedicated_server_enabled: bool = false
var dedicated_server_started: bool = false
var dedicated_server_ready: bool = false
var dedicated_boot_phase: String = "disabled"
var dedicated_server_autocreate: bool = true
var dedicated_server_world_identifier: String = ""
var dedicated_server_world_title: String = DEFAULT_DEDICATED_WORLD_TITLE
var dedicated_server_seed: String = ""
var dedicated_server_port: int = DEFAULT_PORT
var dedicated_status_enabled: bool = true
var dedicated_status_port: int = DEFAULT_PORT + DEFAULT_STATUS_PORT_OFFSET
var dedicated_load_radius: int = DEFAULT_DEDICATED_LOAD_RADIUS
var dedicated_buffer_radius: int = DEFAULT_DEDICATED_BUFFER_RADIUS
var dedicated_status_udp: PacketPeerUDP
var dedicated_tps_sample_elapsed: float = 0.0
var dedicated_tps_sample_frames: int = 0
var dedicated_current_tps: float = float(DEDICATED_TARGET_TPS)
var dedicated_min_tps: float = float(DEDICATED_TARGET_TPS)
var dedicated_last_delta_ms: float = 0.0
var dedicated_tps_warn_timer: float = 0.0
var dedicated_health_log_timer: float = 0.0
var dedicated_load_focus_valid: bool = false
var dedicated_load_focus_position: Vector3 = Vector3.ZERO
var dedicated_load_focus_peer_id: int = 0
var dedicated_load_focus_timer: float = 0.0
var dedicated_status_thread: Thread
var dedicated_status_thread_running: bool = false
var auto_connect_enabled: bool = false
var auto_connect_started: bool = false
var auto_connect_address: String = "127.0.0.1"
var auto_connect_port: int = DEFAULT_PORT
var active_session_transport: String = SESSION_TRANSPORT_LAN
var active_steam_lobby_id: int = 0
var active_steam_host_id: int = 0
var pending_steam_action: String = ""
var pending_steam_lobby_id: int = 0
var pending_steam_open_invite_dialog: bool = false
var reconnect_steam_lobby_id: int = 0
var reconnect_steam_host_id: int = 0
var join_protocol_pending: bool = false
var join_protocol_accepted: bool = false
var join_protocol_deadline_msec: int = 0
var client_connection_deadline_msec: int = 0

var peer_states: Dictionary = {}
var markers: Dictionary = {}
var send_timer: float = 0.0
var world_state_timer: float = 0.0
var water_sync_timer: float = 0.0
var persist_timer: float = 0.0
var guest_entity_state_timer: float = 0.0
var autosave_timer: float = 0.0
var server_only_save_menu_filter_timer: float = 0.0
var status_message: String = "Idle"
var panel_visible: bool = false
var restore_capture_on_close: bool = false
var receiving_host_world: bool = false
var incoming_snapshot_register_json: String = ""
var incoming_snapshot_chunk_count: int = 0
var incoming_snapshot_chunks: Dictionary = {}
var incoming_snapshot_host_position: Vector3 = Vector3.ZERO
var incoming_snapshot_follow_host_position: bool = false
var remote_break_outlines: Dictionary = {}
var synced_entities: Dictionary = {}
var client_entity_dummies: Dictionary = {}
var synced_dropped_items: Dictionary = {}
var client_world_sync_ready: bool = false
var coop_player_death_hooked: bool = false
var coop_player_death_hooked_instance_id: int = 0
var local_fake_death_pending: bool = false
var local_fake_death_save_override: Dictionary = {}
var local_fake_death_respawn_target: Vector3 = Vector3.ZERO
var local_fake_death_respawn_target_valid: bool = false
var clear_fake_death_override_after_shutdown: bool = false
var handling_client_respawn: bool = false
var handling_host_respawn: bool = false
var host_respawning: bool = false
var remote_host_respawning: bool = false
var host_respawn_sequence: int = 0
var last_local_world_authority: bool = true
var last_local_entity_authority: bool = true
var guest_authoritative_entity_registry: Dictionary = {}
var session_load_radius_applied: bool = false
var session_previous_instance_radius: int = -1
var session_previous_buffer_instance_radius: int = -1
var local_quit_in_progress: bool = false
var guest_persistent_ready: bool = false
var autosave_in_progress: bool = false
var deferred_host_autosave_pending: bool = false
var last_host_contact_time: int = 0
var last_sent_client_state_hash: int = 0
var client_state_heartbeat_timer: float = 0.0
var local_state_sequence: int = 0
var host_snapshot_sequence: int = 0
var last_received_host_snapshot_sequence: int = -1
var client_restore_in_progress: bool = false
var client_menu_kick_pending: bool = false
var client_menu_kick_sequence: int = 0
var reconnect_pending: bool = false
var reconnect_attempt_count: int = 0
var reconnect_retry_timer: float = 0.0
var reconnect_reason: String = ""
var host_rehost_pending: bool = false
var host_rehost_port: int = DEFAULT_PORT
var suppress_local_game_quit_session_shutdown: bool = false
var single_player_shutdown_world_pause_override: bool = false
var single_player_shutdown_world_original_process_mode: int = -1
var local_world_patch_timer: float = 0.0
var pending_local_world_patch_chunks: Dictionary = {}
var pending_local_world_patch_dimension: int = -1
var pending_local_world_patch_pocket_owner_key: String = ""
var pending_local_world_patch_instance_key: String = ""
var cached_world_chunk_size: Vector3i = Vector3i.ZERO
var guest_world_patch_flush_request_counter: int = 0
var pending_guest_world_patch_flush_acks: Dictionary = {}
var group_dimension_transfer_in_progress: bool = false
var pending_remote_block_changes: Dictionary = {}
var pending_remote_water_changes: Dictionary = {}
var pending_remote_fire_changes: Dictionary = {}
var pending_remote_storage_changes: Dictionary = {}
var server_dirty_chunk_keys: Dictionary = {}
var server_chunk_journal_sequence: int = 0
var server_dirty_chunk_flush_timer: float = 0.0
var server_chunk_tickets: Dictionary = {}
var server_chunk_ticket_cleanup_timer: float = 0.0
var client_block_action_sequence: int = 0
var client_pending_block_actions: Dictionary = {}
var server_recent_block_action_results: Dictionary = {}
var server_action_result_cleanup_timer: float = 0.0
var dedicated_block_action_count: int = 0
var dedicated_block_action_fail_count: int = 0
var dedicated_block_action_deferred_count: int = 0
var dedicated_block_action_last_latency_ms: int = 0
var client_item_action_sequence: int = 0
var client_pending_item_actions: Dictionary = {}
var server_recent_item_action_results: Dictionary = {}
var dedicated_item_action_count: int = 0
var dedicated_item_action_fail_count: int = 0
var dedicated_item_action_last_latency_ms: int = 0
var remote_player_proxies: Dictionary = {}
var spawn_anchor_index: int = 0
var host_world_state_sequence: int = 0
var client_last_world_state_sequence: int = -1
var host_entity_update_counter: int = 0
var tracked_root_entities: Array = []
var tracked_root_drops: Array = []
var animation_tree_parameter_cache: Dictionary = {}
var pending_pickup_receipts: Array = []
var client_collected_drop_uuids: Dictionary = {}
var reconnect_restore_capture_on_close: bool = false
var entity_interp_map: Dictionary = {}
var host_entity_last_sent: Dictionary = {}
var host_entity_snapshot_last_sent: Dictionary = {}
var host_entity_snapshot_last_state: Dictionary = {}
var host_drop_snapshot_last_sent: Dictionary = {}
var host_drop_snapshot_last_state: Dictionary = {}
var host_interest_last_peer_count: int = 0
var host_interest_last_drop_count: int = 0
var host_interest_last_entity_count: int = 0
var host_interest_spawn_drop_sends: int = 0
var host_entity_activity_refresh_timer: float = 0.0
var host_entity_activity_override_active: bool = false
var host_recent_drop_visibility: Dictionary = {}
var host_server_time: float = 0.0
var client_server_time: float = 0.0
var client_server_time_initialized: bool = false
var active_server_command_policy: Dictionary = DEFAULT_SERVER_COMMAND_POLICY.duplicate(true)
var debug_spawn_catalog: Dictionary = {}
var local_downed: bool = false
var local_downed_position: Vector3 = Vector3.ZERO
var local_downed_position_valid: bool = false
var local_downed_started_msec: int = 0
var double_downed_recovery_pending: bool = false
var revive_hold_progress: float = 0.0
var revive_target_peer_id: int = -1
var revive_request_pending: bool = false
var downed_respawn_key_down: bool = false
var host_water_snapshot_cache: Dictionary = {}
var host_fire_snapshot_cache: Dictionary = {}
var applying_remote_storage_positions: Dictionary = {}
var world_edit_pos1: Variant = null
var world_edit_pos2: Variant = null
var server_world_edit_selections: Dictionary = {}
var builder_peaceful_enabled: bool = false
var builder_day_lock_enabled: bool = false
var builder_peaceful_sweep_timer: float = 0.0

var hud: CanvasLayer
var overlay: Control
var panel: PanelContainer
var panel_scroll: ScrollContainer
var panel_column: VBoxContainer
var death_overlay: Control
var death_overlay_title: Label
var death_overlay_subtitle: Label
var revive_prompt_label: Label
var spawn_browser_overlay: Control
var spawn_browser_panel: PanelContainer
var spawn_browser_search_input: LineEdit
var spawn_browser_list: ItemList
var spawn_browser_hint_label: Label
var spawn_browser_restore_capture_on_close: bool = false
var spawn_browser_entries: PackedStringArray = PackedStringArray()
var char_select_overlay: Control
var char_select_panel: PanelContainer
var char_select_list: ItemList
var char_select_preview_container: SubViewportContainer
var char_select_preview_viewport: SubViewport
var char_select_preview_instance: Node3D
var char_select_entries: Array = []
var char_select_restore_capture_on_close: bool = false
var reconnect_overlay: Control
var reconnect_overlay_title: Label
var reconnect_overlay_subtitle: Label
var quit_overlay: Control
var quit_overlay_title: Label
var quit_overlay_subtitle: Label
var player_list_overlay: PanelContainer
var player_list_overlay_label: Label
var local_ip_label: Label
var status_label: Label
var address_input: LineEdit
var port_input: SpinBox
var pause_menu_owner: Control
var pause_menu_container: Control
var pause_menu_resume_button: Button
var pause_menu_coop_button: Button
var pause_menu_coop_panel: Control
var pause_menu_coop_shell: PanelContainer
var pause_menu_coop_status_label: Label
var pause_menu_coop_address_input: LineEdit
var pause_menu_coop_port_input: SpinBox
var pause_menu_coop_players_section: VBoxContainer
var pause_menu_coop_player_list: ItemList
var pause_menu_coop_player_detail_label: Label
var pause_menu_coop_tp_button: Button
var pause_menu_coop_kick_button: Button
var pause_menu_coop_player_signature: String = ""
var main_menu_owner: Control
var main_menu_coop_button: Button
var main_menu_coop_panel: Control
var main_menu_coop_shell: PanelContainer
var main_menu_coop_server_name_input: LineEdit
var main_menu_coop_address_input: LineEdit
var main_menu_coop_port_input: SpinBox
var main_menu_coop_steam_lobby_input: LineEdit
var main_menu_server_cards_scroll: ScrollContainer
var main_menu_server_cards_container: VBoxContainer
var main_menu_server_card_buttons: Array[Control] = []
var main_menu_server_detail_label: Label
var main_menu_server_refresh_button: Button
var main_menu_server_add_button: Button
var main_menu_servers_page: VBoxContainer
var main_menu_players_page: VBoxContainer
var main_menu_player_list: ItemList
var main_menu_player_detail_label: Label
var main_menu_steam_page: VBoxContainer
var main_menu_direct_page: VBoxContainer
var main_menu_server_tab_button: Button
var main_menu_players_tab_button: Button
var main_menu_steam_tab_button: Button
var main_menu_direct_tab_button: Button
var main_menu_selected_tab: String = "servers"
var main_menu_player_signature: String = ""
var main_menu_coop_status_label: Label
var server_browser_udp: PacketPeerUDP
var server_browser_registry_request: HTTPRequest
var server_registry_heartbeat_request: HTTPRequest
var server_registry_heartbeat_timer: float = 0.0
var server_registry_heartbeat_in_flight: bool = false
var server_browser_entries: Array = []
var server_browser_pending: Dictionary = {}
var server_browser_deadline_msec: int = 0
var server_browser_local_registry_loaded: bool = false
var server_browser_registry_cache_loaded: bool = false
var server_browser_remote_registry_requested: bool = false


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    _load_config()
    _configure_dedicated_server_from_args()
    if dedicated_server_enabled:
        _apply_dedicated_performance_profile()
        _prepare_dedicated_profile()
    _build_hud()
    if get_viewport() != null and not get_viewport().size_changed.is_connected(_refresh_overlay_layout):
        get_viewport().size_changed.connect(_refresh_overlay_layout)
    call_deferred("_refresh_overlay_layout")

    if is_instance_valid(Ref.main) and not Ref.main.game_quit.is_connected(_on_local_game_quit):
        Ref.main.game_quit.connect(_on_local_game_quit)
    if is_instance_valid(Ref.main) and not Ref.main.world_loaded.is_connected(_on_local_world_loaded):
        Ref.main.world_loaded.connect(_on_local_world_loaded)
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)
    multiplayer.connected_to_server.connect(_on_connected_to_server)
    multiplayer.connection_failed.connect(_on_connection_failed)
    multiplayer.server_disconnected.connect(_on_server_disconnected)
    _install_steam_integration()
    call_deferred("_ensure_pause_menu_coop_ui")
    call_deferred("_ensure_main_menu_coop_ui")
    call_deferred("_hide_local_server_only_save_registers")

    get_tree().get_root().child_entered_tree.connect(_on_root_child_entered)
    get_tree().get_root().child_exiting_tree.connect(_on_root_child_exiting)
    _rebuild_tracked_root_runtime_lists()

    print("[lucid-blocks-coop] manager ready build=%s" % COOP_BUILD_TAG)
    _update_status_text()
    if dedicated_server_enabled:
        dedicated_boot_phase = "starting"
        print("[lucid-blocks-coop] dedicated server mode requested on port %s" % dedicated_server_port)
        _start_dedicated_status_udp()
        call_deferred("_dedicated_server_bootstrap")
    elif auto_connect_enabled:
        print("[lucid-blocks-coop] auto-connect requested for %s:%s" % [auto_connect_address, auto_connect_port])
        call_deferred("_auto_connect_bootstrap")


func _exit_tree() -> void:
    _stop_dedicated_status_thread()


func _get_coop_cmdline_args() -> Array[String]:
    var args: Array[String] = []
    for arg in OS.get_cmdline_args():
        args.append(str(arg))
    for arg in OS.get_cmdline_user_args():
        var user_arg: String = str(arg)
        if not args.has(user_arg):
            args.append(user_arg)
    return args


func _cmdline_has_flag(args: Array[String], names: Array[String]) -> bool:
    for raw_arg in args:
        var arg: String = str(raw_arg).strip_edges()
        for name in names:
            if arg == name:
                return true
            if arg.begins_with("%s=" % name):
                var value: String = arg.substr(name.length() + 1).strip_edges().to_lower()
                return not ["0", "false", "no", "off"].has(value)
    return false


func _read_cmdline_value(args: Array[String], names: Array[String], default_value: String = "") -> String:
    for i in range(args.size()):
        var arg: String = str(args[i]).strip_edges()
        for name in names:
            if arg == name and i + 1 < args.size():
                return str(args[i + 1]).strip_edges()
            if arg.begins_with("%s=" % name):
                return arg.substr(name.length() + 1).strip_edges()
    return default_value


func _read_env_value(name: String, default_value: String = "") -> String:
    var value: String = str(OS.get_environment(name)).strip_edges()
    return value if value != "" else default_value


func _read_cmdline_bool(args: Array[String], names: Array[String], default_value: bool) -> bool:
    var value: String = _read_cmdline_value(args, names, "").strip_edges().to_lower()
    if value == "":
        return default_value
    if ["1", "true", "yes", "on"].has(value):
        return true
    if ["0", "false", "no", "off"].has(value):
        return false
    return default_value


func _parse_server_admin_keys(raw_keys: Variant) -> PackedStringArray:
    var keys: PackedStringArray = PackedStringArray()
    if raw_keys is Array:
        for raw_entry in raw_keys:
            var entry: String = str(raw_entry).strip_edges()
            if entry != "" and not keys.has(entry):
                keys.append(entry)
        return keys

    var text: String = str(raw_keys).strip_edges()
    if text == "":
        return keys
    for raw_entry in text.replace(";", ",").split(",", false):
        var entry: String = str(raw_entry).strip_edges()
        if entry != "" and not keys.has(entry):
            keys.append(entry)
    return keys


func _configure_dedicated_server_from_args() -> void:
    var args: Array[String] = _get_coop_cmdline_args()
    dedicated_server_enabled = _cmdline_has_flag(args, ["--lb-dedicated", "--lucid-dedicated", "--dedicated"])
    _configure_auto_connect_from_args(args)
    if not dedicated_server_enabled:
        dedicated_server_ready = false
        dedicated_boot_phase = "idle"
        dedicated_status_enabled = false
        return

    dedicated_server_world_identifier = _read_cmdline_value(args, ["--lb-world", "--lb-save", "--world"], str(config.get("dedicated_world", "")))
    dedicated_server_world_title = _read_cmdline_value(args, ["--lb-world-title", "--lb-title", "--world-title"], str(config.get("dedicated_world_title", DEFAULT_DEDICATED_WORLD_TITLE)))
    dedicated_server_seed = _read_cmdline_value(args, ["--lb-seed", "--seed"], str(config.get("dedicated_seed", "")))
    dedicated_server_autocreate = _read_cmdline_bool(args, ["--lb-autocreate", "--autocreate"], bool(config.get("dedicated_autocreate", true)))
    config["server_registry_url"] = _read_cmdline_value(args, ["--lb-registry-url", "--registry-url"], str(config.get("server_registry_url", "")))
    config["server_registry_heartbeat_url"] = _read_cmdline_value(args, ["--lb-registry-heartbeat-url", "--registry-heartbeat-url"], str(config.get("server_registry_heartbeat_url", "")))
    config["server_registry_token"] = _read_cmdline_value(args, ["--lb-registry-token", "--registry-token"], str(config.get("server_registry_token", "")))
    config["server_save_secret"] = _read_cmdline_value(args, ["--lb-save-secret", "--save-secret"], _read_env_value("LB_SAVE_SECRET", str(config.get("server_save_secret", ""))))
    config["server_public_address"] = _read_cmdline_value(args, ["--lb-public-address", "--public-address"], str(config.get("server_public_address", "")))
    config["server_public_name"] = _read_cmdline_value(args, ["--lb-public-name", "--public-name"], str(config.get("server_public_name", "")))
    config["server_public_region"] = _read_cmdline_value(args, ["--lb-public-region", "--public-region"], str(config.get("server_public_region", "public")))
    var admin_keys_text: String = _read_cmdline_value(args, ["--lb-admin-keys", "--admin-keys", "--lb-admin-key", "--admin-key"], _read_env_value("LB_ADMIN_KEYS", ""))
    if admin_keys_text.strip_edges() != "":
        config["server_admin_keys"] = _parse_server_admin_keys(admin_keys_text)
    dedicated_status_enabled = _read_cmdline_bool(args, ["--lb-status", "--status"], bool(config.get("dedicated_status_enabled", true)))
    var load_radius_text: String = _read_cmdline_value(args, ["--lb-load-radius", "--load-radius"], str(config.get("dedicated_load_radius", DEFAULT_DEDICATED_LOAD_RADIUS)))
    if load_radius_text.is_valid_int():
        dedicated_load_radius = clampi(int(load_radius_text), 16, 128)
    else:
        dedicated_load_radius = DEFAULT_DEDICATED_LOAD_RADIUS
    var buffer_radius_text: String = _read_cmdline_value(args, ["--lb-buffer-radius", "--buffer-radius"], str(config.get("dedicated_buffer_radius", maxi(dedicated_load_radius, DEFAULT_DEDICATED_BUFFER_RADIUS))))
    if buffer_radius_text.is_valid_int():
        dedicated_buffer_radius = clampi(int(buffer_radius_text), dedicated_load_radius, 192)
    else:
        dedicated_buffer_radius = maxi(dedicated_load_radius, DEFAULT_DEDICATED_BUFFER_RADIUS)

    if dedicated_server_world_title.strip_edges() == "":
        dedicated_server_world_title = DEFAULT_DEDICATED_WORLD_TITLE
    dedicated_server_world_title = dedicated_server_world_title.substr(0, 24).strip_edges()

    var port_text: String = _read_cmdline_value(args, ["--lb-port", "--port"], str(config.get("port", DEFAULT_PORT)))
    if port_text.is_valid_int():
        dedicated_server_port = clampi(int(port_text), 1, 65535)
    else:
        dedicated_server_port = DEFAULT_PORT
    var status_port_text: String = _read_cmdline_value(args, ["--lb-status-port", "--status-port"], str(config.get("dedicated_status_port", dedicated_server_port + DEFAULT_STATUS_PORT_OFFSET)))
    if status_port_text.is_valid_int():
        dedicated_status_port = clampi(int(status_port_text), 1, 65535)
    else:
        dedicated_status_port = clampi(dedicated_server_port + DEFAULT_STATUS_PORT_OFFSET, 1, 65535)
    config["port"] = dedicated_server_port
    config["dedicated_world"] = dedicated_server_world_identifier
    config["dedicated_world_title"] = dedicated_server_world_title
    config["dedicated_seed"] = dedicated_server_seed
    config["dedicated_autocreate"] = dedicated_server_autocreate
    config["dedicated_status_enabled"] = dedicated_status_enabled
    config["dedicated_status_port"] = dedicated_status_port
    config["dedicated_load_radius"] = dedicated_load_radius
    config["dedicated_buffer_radius"] = dedicated_buffer_radius
    _save_config()


func _configure_auto_connect_from_args(args: Array[String]) -> void:
    var connect_target: String = _read_cmdline_value(args, ["--lb-connect", "--connect"], "")
    auto_connect_enabled = connect_target != "" or _cmdline_has_flag(args, ["--lb-join", "--join"])
    if not auto_connect_enabled:
        return

    var address: String = _read_cmdline_value(args, ["--lb-address", "--address"], str(config.get("address", "127.0.0.1")))
    var port: int = int(config.get("port", DEFAULT_PORT))
    if connect_target != "":
        var parsed: Dictionary = _parse_address_port(connect_target, address, port)
        address = str(parsed.get("address", address))
        port = int(parsed.get("port", port))

    var port_text: String = _read_cmdline_value(args, ["--lb-port", "--port"], str(port))
    if port_text.is_valid_int():
        port = clampi(int(port_text), 1, 65535)

    auto_connect_address = address.strip_edges()
    if auto_connect_address == "":
        auto_connect_address = "127.0.0.1"
    auto_connect_port = clampi(port, 1, 65535)
    config["address"] = auto_connect_address
    config["port"] = auto_connect_port


func _parse_address_port(raw_target: String, default_address: String, default_port: int) -> Dictionary:
    var target: String = raw_target.strip_edges()
    var address: String = default_address
    var port: int = default_port
    if target == "":
        return {"address": address, "port": port}

    if target.begins_with("[") and target.find("]") > 0:
        var close_index: int = target.find("]")
        address = target.substr(1, close_index - 1)
        var suffix: String = target.substr(close_index + 1).strip_edges()
        if suffix.begins_with(":") and suffix.substr(1).is_valid_int():
            port = int(suffix.substr(1))
        return {"address": address, "port": clampi(port, 1, 65535)}

    var colon_index: int = target.rfind(":")
    if colon_index > 0 and target.find(":") == colon_index:
        var maybe_port: String = target.substr(colon_index + 1).strip_edges()
        if maybe_port.is_valid_int():
            address = target.substr(0, colon_index).strip_edges()
            port = int(maybe_port)
        else:
            address = target
    else:
        address = target

    return {"address": address, "port": clampi(port, 1, 65535)}


func _prepare_dedicated_profile() -> void:
    if Ref.save_file_manager == null:
        return
    if Ref.save_file_manager.device_file != null and Ref.save_file_manager.device_file.get_data("tutorial", true):
        Ref.save_file_manager.device_file.set_data("tutorial", false)
        Ref.save_file_manager.write_device_file()


func is_dedicated_server_mode() -> bool:
    return dedicated_server_enabled


func is_client_visual_mod_enabled() -> bool:
    if dedicated_server_enabled:
        return false
    return bool(config.get("enable_client_visual_mod", ENABLE_CLIENT_VISUAL_MOD_DEFAULT))


func is_avatar_customization_enabled() -> bool:
    return bool(config.get("enable_avatar_customization", ENABLE_AVATAR_CUSTOMIZATION_DEFAULT))


func is_avatar_alias_command_enabled() -> bool:
    return bool(config.get("enable_avatar_alias_command", ENABLE_AVATAR_ALIAS_COMMAND_DEFAULT)) or _are_console_debug_commands_enabled()


func get_dedicated_load_radius(default_radius: int = DEFAULT_DEDICATED_LOAD_RADIUS) -> int:
    if not dedicated_server_enabled:
        return default_radius
    return clampi(dedicated_load_radius, 16, 128)


func get_dedicated_buffer_radius(default_radius: int = DEFAULT_DEDICATED_BUFFER_RADIUS) -> int:
    if not dedicated_server_enabled:
        return default_radius
    return clampi(dedicated_buffer_radius, get_dedicated_load_radius(), 192)


func get_server_entity_view_radius(default_radius: float = DEFAULT_SERVER_ENTITY_VIEW_RADIUS) -> float:
    return clampf(float(config.get("server_entity_view_radius", default_radius)), 16.0, 256.0)


func get_server_entity_simulation_radius(default_radius: float = DEFAULT_SERVER_ENTITY_SIMULATION_RADIUS) -> float:
    return clampf(float(config.get("server_entity_simulation_radius", default_radius)), 16.0, 256.0)


func _apply_dedicated_performance_profile() -> void:
    if not dedicated_server_enabled:
        return
    Engine.physics_ticks_per_second = DEDICATED_TARGET_TPS
    Engine.max_fps = DEDICATED_TARGET_TPS
    if OS is Object:
        OS.set("low_processor_usage_mode", false)
        OS.set("low_processor_usage_mode_sleep_usec", 0)
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _dedicated_server_bootstrap() -> void:
    if dedicated_server_started:
        return
    dedicated_server_started = true
    _prepare_dedicated_profile()

    if not is_instance_valid(Ref.main):
        _dedicated_server_fail("Dedicated server cannot find Main")
        return
    print("[lucid-blocks-coop] Dedicated bootstrap begin main_loaded=%s world_started=%s" % [
        str(bool(Ref.main.loaded)),
        str(is_instance_valid(Ref.world) and bool(Ref.world.started_up)),
    ])
    if not Ref.main.loaded:
        dedicated_boot_phase = "waiting_main"
        await _await_dedicated_main_loaded()
    if is_instance_valid(Ref.world) and not Ref.world.started_up:
        dedicated_boot_phase = "waiting_world"
        await _await_dedicated_world_started()
    await get_tree().process_frame

    var save_register: SaveFileRegister = _find_dedicated_save_register()
    var creating_save: bool = false
    if save_register == null:
        if not dedicated_server_autocreate:
            _dedicated_server_fail("Dedicated world was not found and autocreate is disabled")
            return
        save_register = _create_dedicated_save_register()
        creating_save = true

    if save_register == null:
        _dedicated_server_fail("Dedicated world could not be prepared")
        return

    _mark_dedicated_world_register(save_register)
    if not creating_save and not _verify_dedicated_server_world_seal(save_register):
        return

    dedicated_boot_phase = "loading_world"
    print("[lucid-blocks-coop] dedicated loading world '%s' (%s)" % [
        str(save_register.get_data("title", dedicated_server_world_title)),
        str(save_register.get_data("uuid", ""))
    ])

    if is_instance_valid(Ref.audio_manager) and Ref.main.main_menu_music != null:
        Ref.audio_manager.stop_song(Ref.main.main_menu_music)

    Ref.save_file_manager.load_file(save_register, not creating_save)
    if creating_save:
        _mark_intro_seen_for_dedicated_boot()
        print("[lucid-blocks-coop] Dedicated bootstrap new_game start")
        await Ref.main.new_game()
        print("[lucid-blocks-coop] Dedicated bootstrap enter_game new start")
        await Ref.main.enter_game(true, true)
        print("[lucid-blocks-coop] Dedicated bootstrap initial save start")
        await Ref.save_file_manager.save_file(true)
        _seal_loaded_server_world_if_needed()
    else:
        print("[lucid-blocks-coop] Dedicated bootstrap enter_game existing start")
        await Ref.main.enter_game(false, false)
        _seal_loaded_server_world_if_needed()

    print("[lucid-blocks-coop] Dedicated bootstrap enter_game done")
    _apply_dedicated_player_safety()
    config["port"] = dedicated_server_port
    _save_config()
    dedicated_boot_phase = "starting_host"
    print("[lucid-blocks-coop] Dedicated bootstrap host_session start")
    var dedicated_host_ok: bool = _start_lan_host(dedicated_server_port, true)
    if dedicated_host_ok and _has_live_peer() and multiplayer.is_server():
        dedicated_boot_phase = "replaying_journal"
        await _replay_server_chunk_journal()
        status_message = "Dedicated server hosting"
        print("[lucid-blocks-coop] Dedicated server hosting on port %s" % dedicated_server_port)
        _start_dedicated_status_udp()
        dedicated_server_ready = true
        dedicated_boot_phase = "ready"
        _update_status_text()
        _refresh_world_runtime_mode()
        print("[lucid-blocks-coop] Dedicated ready world='%s' status_port=%s load_radius=%s buffer_radius=%s" % [
            str(save_register.get_data("title", dedicated_server_world_title)),
            dedicated_status_port,
            dedicated_load_radius,
            dedicated_buffer_radius,
        ])
    else:
        _dedicated_server_fail("Dedicated server failed to create ENet host")


func _await_dedicated_main_loaded() -> void:
    var frames_waited: int = 0
    while is_instance_valid(Ref.main) and not bool(Ref.main.loaded) and frames_waited < 300:
        await get_tree().process_frame
        frames_waited += 1
    print("[lucid-blocks-coop] Dedicated main load wait done loaded=%s frames=%s" % [
        str(is_instance_valid(Ref.main) and bool(Ref.main.loaded)),
        frames_waited,
    ])


func _await_dedicated_world_started() -> void:
    var frames_waited: int = 0
    while is_instance_valid(Ref.world) and not bool(Ref.world.started_up) and frames_waited < 300:
        await get_tree().process_frame
        frames_waited += 1
    print("[lucid-blocks-coop] Dedicated world startup wait done started=%s frames=%s" % [
        str(is_instance_valid(Ref.world) and bool(Ref.world.started_up)),
        frames_waited,
    ])


func _auto_connect_bootstrap() -> void:
    if auto_connect_started:
        return
    auto_connect_started = true
    if dedicated_server_enabled:
        return

    if is_instance_valid(Ref.main) and not Ref.main.loaded:
        await Ref.main.all_loaded
    await get_tree().process_frame

    config["address"] = auto_connect_address
    config["port"] = auto_connect_port
    _save_config()
    status_message = "Auto-joining configured server"
    print("[lucid-blocks-coop] Auto-joining %s:%s" % [auto_connect_address, auto_connect_port])
    _update_status_text()
    join_session()


func _dedicated_server_fail(message: String, exit_code: int = 2) -> void:
    status_message = message
    dedicated_server_ready = false
    dedicated_boot_phase = "failed"
    push_error("[lucid-blocks-coop] %s" % message)
    _update_status_text()
    get_tree().quit(exit_code)


func _apply_dedicated_player_safety() -> void:
    if not dedicated_server_enabled or not is_instance_valid(Ref.player):
        return
    _neutralize_dedicated_player_anchor()
    _purge_dedicated_player_inventory()
    _clear_dedicated_player_save_inventory_data()
    Ref.player.invincible = true
    Ref.player.invincible_temporary = true
    Ref.player.dead = false
    Ref.player.disabled = false
    if _object_has_property(Ref.player, "fake_dead"):
        Ref.player.set("fake_dead", false)
    if _object_has_property(Ref.player, "health") and _object_has_property(Ref.player, "max_health"):
        Ref.player.health = Ref.player.max_health
    if _object_has_property(Ref.player, "knockback_velocity"):
        Ref.player.knockback_velocity = Vector3.ZERO


func _neutralize_dedicated_player_anchor() -> void:
    if not dedicated_server_enabled or not is_instance_valid(Ref.player):
        return
    Ref.player.set_meta("coop_dedicated_anchor", true)
    if Ref.player is Node3D:
        (Ref.player as Node3D).visible = false
    _neutralize_dedicated_player_anchor_node(Ref.player)


func _neutralize_dedicated_player_anchor_node(node: Node) -> void:
    if node == null or not is_instance_valid(node):
        return

    if node is Node3D:
        (node as Node3D).visible = false
    if node is CanvasItem:
        (node as CanvasItem).visible = false
    if node is CollisionObject3D:
        var collision_object := node as CollisionObject3D
        collision_object.collision_layer = 0
        collision_object.collision_mask = 0
    if node is CollisionShape3D:
        (node as CollisionShape3D).disabled = true
    if node is Camera3D:
        (node as Camera3D).current = false
    if node is AudioStreamPlayer:
        (node as AudioStreamPlayer).stop()
    if node is AudioStreamPlayer3D:
        (node as AudioStreamPlayer3D).stop()

    node.set_process_input(false)
    node.set_process_unhandled_input(false)
    node.set_process_unhandled_key_input(false)
    node.set_process(false)
    node.set_physics_process(false)

    for child in node.get_children():
        if child is Node:
            _neutralize_dedicated_player_anchor_node(child)


func _get_dedicated_player_inventories() -> Array:
    var inventories: Array = []
    for inventory in [
        Ref.player_hotbar,
        Ref.player_inventory,
        Ref.player_equipment,
        Ref.player_fusion_source,
        Ref.player_fusion_result,
    ]:
        if inventory != null and is_instance_valid(inventory) and not inventories.has(inventory):
            inventories.append(inventory)

    if is_instance_valid(Ref.player):
        for path in ["%Hotbar", "%Inventory", "%Equipment", "%FusionSource", "%FusionResult"]:
            var inventory = Ref.player.get_node_or_null(path)
            if inventory != null and is_instance_valid(inventory) and not inventories.has(inventory):
                inventories.append(inventory)

    return inventories


func _inventory_has_items(inventory) -> bool:
    if inventory == null or not is_instance_valid(inventory) or not _object_has_property(inventory, "items"):
        return false
    for item in inventory.items:
        if item != null:
            return true
    return false


func _purge_dedicated_player_inventory() -> void:
    if not dedicated_server_enabled or not is_instance_valid(Ref.player):
        return

    var changed: bool = false
    for inventory in _get_dedicated_player_inventories():
        if _inventory_has_items(inventory):
            _clear_inventory_contents(inventory)
            changed = true

    if _object_has_property(Ref.player, "held_item_index") and int(Ref.player.held_item_index) != 0:
        Ref.player.held_item_index = 0
        changed = true
    if _object_has_property(Ref.player, "held_item") and is_instance_valid(Ref.player.held_item):
        if Ref.player.has_method("unhold_item"):
            Ref.player.unhold_item()
        changed = true
    if changed and Ref.player.has_method("hold_item"):
        Ref.player.hold_item(0)


func _clear_dedicated_player_save_inventory_data() -> void:
    if not dedicated_server_enabled or Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null:
        return

    var inventory_node_names: Array[String] = ["Hotbar", "Inventory", "Equipment", "FusionSource", "FusionResult"]
    for node_name in inventory_node_names:
        Ref.save_file_manager.loaded_file.erase_data("node/player/%s/items" % node_name)
        Ref.save_file_manager.loaded_file.erase_data("node/player/%s/capacity" % node_name)

    for dimension_namespace in SaveFile.DIMENSION_MAP.values():
        var namespace_text: String = str(dimension_namespace)
        if namespace_text == "":
            continue
        for node_name in inventory_node_names:
            Ref.save_file_manager.loaded_file.erase_data("%s/node/player/%s/items" % [namespace_text, node_name])
            Ref.save_file_manager.loaded_file.erase_data("%s/node/player/%s/capacity" % [namespace_text, node_name])


func _enforce_dedicated_player_safety() -> void:
    if not dedicated_server_enabled or not is_instance_valid(Ref.player):
        return
    var needs_safety: bool = bool(Ref.player.dead) or bool(Ref.player.disabled)
    if _object_has_property(Ref.player, "health") and _object_has_property(Ref.player, "max_health"):
        needs_safety = needs_safety or int(Ref.player.health) < int(Ref.player.max_health)
    for inventory in _get_dedicated_player_inventories():
        if _inventory_has_items(inventory):
            needs_safety = true
            break
    if needs_safety:
        _apply_dedicated_player_safety()


func _mark_intro_seen_for_dedicated_boot() -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.soul_file == null:
        return
    if not Ref.save_file_manager.soul_file.get_data("created_qualia", false):
        Ref.save_file_manager.soul_file.set_data("created_qualia", true)
        Ref.save_file_manager.write_soul_file()


func _find_dedicated_save_register() -> SaveFileRegister:
    if Ref.save_file_manager == null:
        return null
    var identifier: String = dedicated_server_world_identifier.strip_edges()
    var title: String = dedicated_server_world_title.strip_edges()
    for save_register in Ref.save_file_manager.get_save_file_registers():
        var register_uuid: String = str(save_register.get_data("uuid", "")).strip_edges()
        var register_title: String = str(save_register.get_data("title", "")).strip_edges()
        if identifier != "" and (register_uuid == identifier or register_title.nocasecmp_to(identifier) == 0):
            return save_register
        if identifier == "" and title != "" and register_title.nocasecmp_to(title) == 0:
            return save_register
    return null


func _create_dedicated_save_register() -> SaveFileRegister:
    if Ref.save_file_manager == null:
        return null
    Ref.save_file_manager.initialize_file()
    var save_register: SaveFileRegister = Ref.save_file_manager.loaded_file_register
    var seed_string: String = dedicated_server_seed.strip_edges()
    if seed_string == "":
        seed_string = dedicated_server_world_title
    save_register.set_data("world_seed", hash(seed_string))
    save_register.set_data("seed_string", seed_string)
    save_register.set_data("starter_kit", true)
    save_register.set_data("upside_down", false)
    save_register.set_data("wrath", false)
    save_register.set_data("divine", false)
    save_register.set_data("progression_disabled", false)
    save_register.set_data("title", dedicated_server_world_title)
    save_register.set_data("file_background", 0)
    save_register.set_data("file_color_1", Color.from_hsv(0.58, 0.32, 0.95))
    save_register.set_data("file_color_2", Color.from_hsv(0.09, 0.62, 0.8))
    _mark_dedicated_world_register(save_register)
    print("[lucid-blocks-coop] dedicated created new world register '%s'" % dedicated_server_world_title)
    return save_register


func _mark_dedicated_world_register(save_register: SaveFileRegister) -> void:
    if save_register == null:
        return
    save_register.set_data(SERVER_WORLD_ONLY_KEY, true, true)
    save_register.set_data("coop_server_host", "", true)
    save_register.set_data("coop_server_port", dedicated_server_port, true)
    save_register.set_data("coop_server_status_port", dedicated_status_port, true)
    save_register.set_data("coop_server_note", "Join this world through Co-op. Do not open it as a local save.", true)


func _get_server_save_secret() -> String:
    return str(config.get("server_save_secret", "")).strip_edges()


func _get_server_save_directory_for_register(save_register: SaveFileRegister) -> String:
    if Ref.save_file_manager == null or save_register == null:
        return ""
    var uuid: String = str(save_register.get_data("uuid", "")).strip_edges()
    if uuid == "":
        return ""
    if not Ref.save_file_manager.has_method("get_save_file_directory"):
        return ""
    return ProjectSettings.globalize_path(str(Ref.save_file_manager.get_save_file_directory(uuid)))


func _collect_server_world_file_hashes(abs_dir: String, rel_prefix: String = "") -> Array[String]:
    var hashes: Array[String] = []
    var dir := DirAccess.open(abs_dir)
    if dir == null:
        return hashes

    dir.list_dir_begin()
    var file_name: String = dir.get_next()
    while file_name != "":
        if file_name.begins_with(".") or file_name == "register.txt" or file_name == "steam_autocloud.vdf":
            file_name = dir.get_next()
            continue

        var abs_path: String = abs_dir.path_join(file_name)
        var rel_path: String = file_name if rel_prefix == "" else rel_prefix.path_join(file_name)
        if dir.current_is_dir():
            hashes.append_array(_collect_server_world_file_hashes(abs_path, rel_path))
        else:
            hashes.append("%s=%s" % [rel_path, FileAccess.get_sha256(abs_path)])
        file_name = dir.get_next()
    dir.list_dir_end()

    hashes.sort()
    return hashes


func _compute_server_world_seal_for_register(save_register: SaveFileRegister) -> String:
    var secret: String = _get_server_save_secret()
    if secret == "":
        return ""

    var save_dir: String = _get_server_save_directory_for_register(save_register)
    if save_dir == "" or not DirAccess.dir_exists_absolute(save_dir):
        return ""

    var uuid: String = str(save_register.get_data("uuid", "")).strip_edges()
    var file_hashes: Array[String] = _collect_server_world_file_hashes(save_dir)
    var payload: String = JSON.stringify({
        "version": SERVER_WORLD_SEAL_VERSION,
        "uuid": uuid,
        "files": file_hashes,
    })
    return ("%s\n%s" % [secret, payload]).sha256_text()


func _verify_dedicated_server_world_seal(save_register: SaveFileRegister) -> bool:
    if not dedicated_server_enabled or save_register == null or not bool(save_register.get_data(SERVER_WORLD_ONLY_KEY, false)):
        return true

    var expected: String = str(save_register.get_data(SERVER_WORLD_SEAL_HASH_KEY, "")).strip_edges()
    if expected == "":
        print("[lucid-blocks-coop] Server world is not sealed yet; it will be sealed on next save.")
        return true

    var actual: String = _compute_server_world_seal_for_register(save_register)
    if actual == "":
        _dedicated_server_fail("Dedicated world seal could not be verified")
        return false
    if not actual == expected:
        _dedicated_server_fail("Dedicated world seal mismatch; refusing to load modified server save")
        return false
    print("[lucid-blocks-coop] Dedicated world seal verified.")
    return true


func _seal_loaded_server_world_if_needed() -> void:
    if not dedicated_server_enabled or Ref.save_file_manager == null or Ref.save_file_manager.loaded_file_register == null:
        return

    var save_register: SaveFileRegister = Ref.save_file_manager.loaded_file_register
    if not bool(save_register.get_data(SERVER_WORLD_ONLY_KEY, false)):
        return

    var secret: String = _get_server_save_secret()
    if secret == "":
        return

    var seal: String = _compute_server_world_seal_for_register(save_register)
    if seal == "":
        push_warning("[lucid-blocks-coop] Could not seal dedicated server world")
        return

    save_register.set_data(SERVER_WORLD_SEAL_VERSION_KEY, SERVER_WORLD_SEAL_VERSION, true)
    save_register.set_data(SERVER_WORLD_SEAL_HASH_KEY, seal, true)
    save_register.set_data(SERVER_WORLD_SEAL_TIME_KEY, Time.get_unix_time_from_system(), true)
    print("[lucid-blocks-coop] Dedicated world sealed.")


func _start_dedicated_status_udp() -> void:
    if not dedicated_server_enabled or not dedicated_status_enabled:
        return
    _stop_dedicated_status_thread()
    if dedicated_status_udp != null:
        dedicated_status_udp.close()
        dedicated_status_udp = null

    dedicated_status_udp = PacketPeerUDP.new()
    var err: Error = dedicated_status_udp.bind(dedicated_status_port, "*")
    if err != OK:
        push_warning("[lucid-blocks-coop] UDP status bind failed on port %s: %s" % [dedicated_status_port, err])
        dedicated_status_udp = null
        return

    print("[lucid-blocks-coop] UDP status listening on port %s" % dedicated_status_port)
    dedicated_status_thread_running = true
    dedicated_status_thread = Thread.new()
    var thread_err: Error = dedicated_status_thread.start(Callable(self, "_dedicated_status_thread_main"))
    if thread_err != OK:
        dedicated_status_thread_running = false
        push_warning("[lucid-blocks-coop] UDP status thread failed to start: %s" % thread_err)


func _stop_dedicated_status_thread() -> void:
    dedicated_status_thread_running = false
    if dedicated_status_thread != null:
        dedicated_status_thread.wait_to_finish()
        dedicated_status_thread = null


func _dedicated_status_thread_main() -> void:
    while dedicated_status_thread_running:
        _poll_dedicated_status_udp(true)
        OS.delay_msec(25)


func _tick_dedicated_status_udp() -> void:
    if dedicated_status_thread_running:
        return
    _poll_dedicated_status_udp(false)


func _poll_dedicated_status_udp(thread_safe_payload: bool = false) -> void:
    if dedicated_status_udp == null:
        return
    while dedicated_status_udp.get_available_packet_count() > 0:
        var packet: PackedByteArray = dedicated_status_udp.get_packet()
        var source_ip: String = dedicated_status_udp.get_packet_ip()
        var source_port: int = dedicated_status_udp.get_packet_port()
        var request: String = packet.get_string_from_utf8().strip_edges().to_lower()
        if request.begins_with("{"):
            var parsed_request: Variant = JSON.parse_string(request)
            if parsed_request is Dictionary:
                request = str(parsed_request.get("type", parsed_request.get("request", ""))).strip_edges().to_lower()
        if request == "" or request == "ping" or request == "status" or request == "health":
            dedicated_status_udp.set_dest_address(source_ip, source_port)
            var payload: Dictionary = _get_dedicated_status_thread_payload() if thread_safe_payload else _get_dedicated_status_payload()
            dedicated_status_udp.put_packet(JSON.stringify(payload).to_utf8_buffer())


func _get_dedicated_status_thread_payload() -> Dictionary:
    var ready: bool = dedicated_server_ready
    var phase: String = dedicated_boot_phase if dedicated_boot_phase != "" else ("ready" if ready else "starting")
    return {
        "protocol": "lucid-blocks-coop-udp",
        "coop_protocol": COOP_PROTOCOL_NAME,
        "coop_protocol_version": COOP_PROTOCOL_VERSION,
        "coop_protocol_min": COOP_PROTOCOL_MIN_COMPATIBLE,
        "coop_protocol_features": COOP_PROTOCOL_FEATURES,
        "coop_protocol_required_features": COOP_PROTOCOL_REQUIRED_FEATURES,
        "ok": ready,
        "status": phase,
        "ready": ready,
        "boot_phase": phase,
        "game_port": dedicated_server_port,
        "status_port": dedicated_status_port,
        "transport": SESSION_TRANSPORT_LAN,
        "message": status_message,
        "players": 0,
        "max_players": MAX_CLIENTS,
        "world_title": dedicated_server_world_title,
        "version": str(ProjectSettings.get("application/config/version")),
        "target_tps": DEDICATED_TARGET_TPS,
        "tps": snappedf(dedicated_current_tps, 0.1),
        "min_tps": snappedf(dedicated_min_tps, 0.1),
        "last_frame_ms": snappedf(dedicated_last_delta_ms, 0.1),
        "tps_health": _get_dedicated_tps_health(),
        "load_radius": dedicated_load_radius,
        "buffer_radius": dedicated_buffer_radius,
        "entity_view_radius": get_server_entity_view_radius(),
        "entity_simulation_radius": get_server_entity_simulation_radius(),
    }


func _get_dedicated_status_payload() -> Dictionary:
    var runtime_metrics: Dictionary = _get_server_runtime_metrics()
    var ready: bool = dedicated_server_ready and multiplayer.multiplayer_peer != null and multiplayer.is_server()
    var phase: String = dedicated_boot_phase if dedicated_boot_phase != "" else ("ready" if ready else "starting")
    var payload: Dictionary = {
        "protocol": "lucid-blocks-coop-udp",
        "coop_protocol": COOP_PROTOCOL_NAME,
        "coop_protocol_version": COOP_PROTOCOL_VERSION,
        "coop_protocol_min": COOP_PROTOCOL_MIN_COMPATIBLE,
        "coop_protocol_features": COOP_PROTOCOL_FEATURES,
        "coop_protocol_required_features": COOP_PROTOCOL_REQUIRED_FEATURES,
        "ok": ready,
        "status": phase,
        "ready": ready,
        "boot_phase": phase,
        "game_port": dedicated_server_port,
        "status_port": dedicated_status_port,
        "transport": SESSION_TRANSPORT_LAN,
        "message": status_message,
        "players": 0,
        "max_players": MAX_CLIENTS,
        "world_title": dedicated_server_world_title,
        "version": str(ProjectSettings.get("application/config/version")),
        "target_tps": DEDICATED_TARGET_TPS,
        "tps": snappedf(dedicated_current_tps, 0.1),
        "min_tps": snappedf(dedicated_min_tps, 0.1),
        "last_frame_ms": snappedf(dedicated_last_delta_ms, 0.1),
        "tps_health": _get_dedicated_tps_health(),
        "net_backoff": snappedf(_get_dedicated_net_backoff_multiplier(), 0.1),
        "send_hz": snappedf(1.0 / _get_effective_send_interval(), 0.1),
        "world_hz": snappedf(1.0 / _get_effective_world_state_interval(), 0.1),
        "load_radius": dedicated_load_radius,
        "buffer_radius": dedicated_buffer_radius,
        "entity_view_radius": get_server_entity_view_radius(),
        "entity_simulation_radius": get_server_entity_simulation_radius(),
        "runtime": runtime_metrics,
        "memory_static_mb": runtime_metrics.get("memory_static_mb", 0.0),
        "memory_static_peak_mb": runtime_metrics.get("memory_static_peak_mb", 0.0),
        "ram_mb": runtime_metrics.get("memory_static_mb", 0.0),
        "ram_peak_mb": runtime_metrics.get("memory_static_peak_mb", 0.0),
        "entity_count": runtime_metrics.get("entity_count", 0),
        "drop_count": runtime_metrics.get("drop_count", 0),
        "dirty_chunk_count": runtime_metrics.get("dirty_chunk_count", 0),
        "dirty_journal_backlog": runtime_metrics.get("dirty_journal_backlog", 0),
        "chunk_journal_sequence": runtime_metrics.get("chunk_journal_sequence", 0),
        "chunk_ticket_count": runtime_metrics.get("chunk_ticket_count", 0),
        "loaded_region_count": runtime_metrics.get("loaded_region_count", 0),
        "native_active_region_centers": runtime_metrics.get("native_active_region_centers", 0),
        "packet_backlog": runtime_metrics.get("packet_backlog", 0),
        "pending_world_patches": runtime_metrics.get("pending_world_patches", 0),
        "pending_remote_changes": runtime_metrics.get("pending_remote_changes", 0),
    }
    if is_instance_valid(Ref.save_file_manager) and Ref.save_file_manager.loaded_file_register != null:
        payload["world_title"] = str(Ref.save_file_manager.loaded_file_register.get_data("title", dedicated_server_world_title))
        payload["world_uuid"] = str(Ref.save_file_manager.loaded_file_register.get_data("uuid", ""))
    if multiplayer.multiplayer_peer != null and multiplayer.is_server():
        var connected_count: int = 0
        for peer_id in peer_states.keys():
            if int(peer_id) != 1:
                connected_count += 1
        payload["players"] = connected_count
    return payload


func _resolve_server_registry_heartbeat_url() -> String:
    var heartbeat_url: String = str(config.get("server_registry_heartbeat_url", "")).strip_edges()
    if heartbeat_url != "":
        return heartbeat_url
    var registry_url: String = str(config.get("server_registry_url", "")).strip_edges()
    if registry_url.ends_with("/servers.json"):
        return registry_url.substr(0, registry_url.length() - "/servers.json".length()) + "/heartbeat"
    return ""


func _tick_dedicated_registry_heartbeat(delta: float) -> void:
    if not dedicated_server_enabled or not dedicated_server_ready:
        server_registry_heartbeat_timer = 0.0
        return
    var heartbeat_url: String = _resolve_server_registry_heartbeat_url()
    if heartbeat_url == "" or not (heartbeat_url.begins_with("https://") or heartbeat_url.begins_with("http://")):
        return

    server_registry_heartbeat_timer += delta
    if server_registry_heartbeat_timer < SERVER_REGISTRY_HEARTBEAT_INTERVAL_SEC and server_registry_heartbeat_request != null:
        return
    if server_registry_heartbeat_timer < SERVER_REGISTRY_HEARTBEAT_INTERVAL_SEC and not server_registry_heartbeat_in_flight:
        return

    if server_registry_heartbeat_in_flight:
        return

    server_registry_heartbeat_timer = 0.0
    _send_dedicated_registry_heartbeat(heartbeat_url)


func _send_dedicated_registry_heartbeat(heartbeat_url: String) -> void:
    if server_registry_heartbeat_request == null:
        server_registry_heartbeat_request = HTTPRequest.new()
        server_registry_heartbeat_request.timeout = 6.0
        server_registry_heartbeat_request.request_completed.connect(_on_dedicated_registry_heartbeat_completed)
        add_child(server_registry_heartbeat_request)

    var payload: Dictionary = _get_dedicated_status_payload()
    var public_name: String = str(config.get("server_public_name", "")).strip_edges()
    if public_name != "":
        payload["name"] = public_name
        payload["world_title"] = public_name
    var public_address: String = str(config.get("server_public_address", "")).strip_edges()
    if public_address != "":
        payload["address"] = public_address
    payload["region"] = str(config.get("server_public_region", "public")).strip_edges()
    payload["protocol"] = "lucid-blocks-coop-master"

    var headers: PackedStringArray = PackedStringArray(["Content-Type: application/json"])
    var token: String = str(config.get("server_registry_token", "")).strip_edges()
    if token != "":
        headers.append("Authorization: Bearer %s" % token)

    server_registry_heartbeat_in_flight = true
    var err: Error = server_registry_heartbeat_request.request(heartbeat_url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
    if err != OK:
        server_registry_heartbeat_in_flight = false
        push_warning("[lucid-blocks-coop] Registry heartbeat failed to start: %s" % err)


func _on_dedicated_registry_heartbeat_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
    server_registry_heartbeat_in_flight = false
    if response_code < 200 or response_code >= 300:
        push_warning("[lucid-blocks-coop] Registry heartbeat returned HTTP %s" % response_code)


func _get_server_runtime_metrics() -> Dictionary:
    var live_entities: Array = _get_live_tracked_entities() if is_inside_tree() else []
    var live_drops: Array = _get_live_tracked_drops() if is_inside_tree() else []
    var world_metrics: Dictionary = _get_world_streaming_runtime_metrics()
    var connected_count: int = 0
    if multiplayer.multiplayer_peer != null and multiplayer.is_server():
        for peer_id in peer_states.keys():
            if int(peer_id) != 1:
                connected_count += 1

    var pending_remote_total: int = pending_remote_block_changes.size() \
        + pending_remote_water_changes.size() \
        + pending_remote_fire_changes.size() \
        + pending_remote_storage_changes.size()
    var packet_backlog: int = pending_remote_total \
        + pending_local_world_patch_chunks.size() \
        + client_pending_block_actions.size() \
        + client_pending_item_actions.size() \
        + pending_guest_world_patch_flush_acks.size() \
        + incoming_snapshot_chunks.size() \
        + server_recent_block_action_results.size() \
        + server_recent_item_action_results.size()

    var memory_static_mb: float = float(Performance.get_monitor(Performance.MEMORY_STATIC)) / 1048576.0
    var memory_static_peak_mb: float = float(Performance.get_monitor(Performance.MEMORY_STATIC_MAX)) / 1048576.0
    return {
        "uptime_sec": snappedf(float(Time.get_ticks_msec()) / 1000.0, 0.1),
        "players": connected_count,
        "entity_count": live_entities.size(),
        "drop_count": live_drops.size(),
        "tracked_entity_slots": tracked_root_entities.size(),
        "tracked_drop_slots": tracked_root_drops.size(),
        "dirty_chunk_count": server_dirty_chunk_keys.size(),
        "dirty_journal_backlog": server_dirty_chunk_keys.size(),
        "chunk_journal_sequence": server_chunk_journal_sequence,
        "chunk_ticket_count": server_chunk_tickets.size(),
        "loaded_region_count": int(world_metrics.get("loaded_region_count", 0)),
        "native_active_region_centers": int(world_metrics.get("native_active_region_centers", 0)),
        "native_multi_region_hooks_installed": bool(world_metrics.get("native_multi_region_hooks_installed", false)),
        "world_all_loaded": bool(world_metrics.get("world_all_loaded", false)),
        "world_instance_radius": int(world_metrics.get("world_instance_radius", 0)),
        "world_buffer_radius": int(world_metrics.get("world_buffer_radius", 0)),
        "packet_backlog": packet_backlog,
        "pending_world_patches": pending_local_world_patch_chunks.size(),
        "pending_remote_changes": pending_remote_total,
        "client_pending_block_actions": client_pending_block_actions.size(),
        "dedicated_block_actions": dedicated_block_action_count,
        "dedicated_block_action_fails": dedicated_block_action_fail_count,
        "dedicated_block_action_deferred": dedicated_block_action_deferred_count,
        "dedicated_block_action_last_latency_ms": dedicated_block_action_last_latency_ms,
        "server_recent_block_action_results": server_recent_block_action_results.size(),
        "client_pending_item_actions": client_pending_item_actions.size(),
        "dedicated_item_actions": dedicated_item_action_count,
        "dedicated_item_action_fails": dedicated_item_action_fail_count,
        "dedicated_item_action_last_latency_ms": dedicated_item_action_last_latency_ms,
        "server_recent_item_action_results": server_recent_item_action_results.size(),
        "pending_remote_blocks": pending_remote_block_changes.size(),
        "pending_remote_water": pending_remote_water_changes.size(),
        "pending_remote_fire": pending_remote_fire_changes.size(),
        "pending_remote_storage": pending_remote_storage_changes.size(),
        "host_entity_cache": host_entity_last_sent.size(),
        "recent_drop_visibility": host_recent_drop_visibility.size(),
        "client_entity_dummies": client_entity_dummies.size(),
        "interest_peers": host_interest_last_peer_count,
        "interest_drops": host_interest_last_drop_count,
        "interest_entities": host_interest_last_entity_count,
        "interest_spawn_drop_sends": host_interest_spawn_drop_sends,
        "host_entity_activity_override": host_entity_activity_override_active,
        "autosave_in_progress": autosave_in_progress,
        "autosave_due": _has_pending_host_periodic_autosave(),
        "deferred_autosave": deferred_host_autosave_pending,
        "load_focus": dedicated_load_focus_valid,
        "load_focus_peer": dedicated_load_focus_peer_id,
        "chunk_tickets": server_chunk_tickets.size(),
        "object_count": int(Performance.get_monitor(Performance.OBJECT_COUNT)),
        "node_count": int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
        "resource_count": int(Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)),
        "orphan_node_count": int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)),
        "memory_static_mb": snappedf(memory_static_mb, 0.1),
        "memory_static_peak_mb": snappedf(memory_static_peak_mb, 0.1),
    }


func _get_world_streaming_runtime_metrics() -> Dictionary:
    var metrics: Dictionary = {
        "loaded_region_count": 0,
        "native_active_region_centers": 0,
        "native_multi_region_hooks_installed": false,
        "world_all_loaded": false,
        "world_instance_radius": 0,
        "world_buffer_radius": 0,
    }

    if is_instance_valid(Ref.world):
        if "instance_radius" in Ref.world:
            metrics["world_instance_radius"] = int(Ref.world.instance_radius)
        if "buffer_instance_radius" in Ref.world:
            metrics["world_buffer_radius"] = int(Ref.world.buffer_instance_radius)
        if Ref.world.has_method("is_all_loaded"):
            metrics["world_all_loaded"] = bool(Ref.world.call("is_all_loaded"))

    var session_region_count: int = _get_same_instance_session_positions().size() if _can_sample_player() else 0
    var ticket_region_count: int = _get_active_server_chunk_ticket_positions(DEDICATED_MAX_WORLD_LOAD_TICKET_CENTERS, false).size()
    metrics["loaded_region_count"] = session_region_count + ticket_region_count

    if Ref.coop_native_patch != null and Ref.coop_native_patch.has_method("get_status"):
        var status: Variant = Ref.coop_native_patch.call("get_status")
        if status is Dictionary:
            metrics["native_active_region_centers"] = int(status.get("active_region_center_count", 0))
            metrics["native_multi_region_hooks_installed"] = bool(status.get("multi_region_hooks_installed", false))

    return metrics


func _get_dedicated_tps_health() -> String:
    if dedicated_current_tps >= DEDICATED_TPS_SOFT_FLOOR:
        return "good"
    if dedicated_current_tps >= DEDICATED_TPS_HARD_FLOOR:
        return "strained"
    return "bad"


func _get_dedicated_net_backoff_multiplier() -> float:
    if not dedicated_server_enabled:
        return 1.0
    if dedicated_current_tps < DEDICATED_TPS_HARD_FLOOR:
        return 2.0
    if dedicated_current_tps < DEDICATED_TPS_SOFT_FLOOR:
        return 1.5
    return 1.0


func _get_effective_send_interval() -> float:
    if dedicated_server_enabled and multiplayer.is_server():
        return DEDICATED_SEND_INTERVAL * _get_dedicated_net_backoff_multiplier()
    return SEND_INTERVAL


func _get_effective_world_state_interval() -> float:
    if dedicated_server_enabled and multiplayer.is_server():
        return DEDICATED_WORLD_STATE_INTERVAL * _get_dedicated_net_backoff_multiplier()
    return WORLD_STATE_INTERVAL


func _get_effective_water_sync_interval() -> float:
    if dedicated_server_enabled and multiplayer.is_server():
        return DEDICATED_WATER_SYNC_INTERVAL * _get_dedicated_net_backoff_multiplier()
    return WATER_SYNC_INTERVAL


func _get_steam_api() -> Object:
    var steamworks_node: Node = get_node_or_null("/root/Steamworks")
    if steamworks_node != null and (
        steamworks_node.has_method("createLobby")
        or steamworks_node.has_method("create_lobby")
        or steamworks_node.has_method("joinLobby")
        or steamworks_node.has_method("join_lobby")
    ):
        return steamworks_node
    if Engine.has_singleton("Steam"):
        return Engine.get_singleton("Steam")
    if steamworks_node != null:
        return steamworks_node
    return null


func _steam_has_any_method(method_names: Array[String]) -> bool:
    var steam_api: Object = _get_steam_api()
    if steam_api == null:
        return false
    for method_name in method_names:
        if steam_api.has_method(method_name):
            return true
    return false


func _steam_call(method_name: String, args: Array = []) -> Variant:
    return _steam_call_alias([method_name], args)


func _steam_call_alias(method_names: Array[String], args: Array = []) -> Variant:
    var steam_api: Object = _get_steam_api()
    if steam_api == null:
        return null
    for method_name in method_names:
        if steam_api.has_method(method_name):
            return steam_api.callv(method_name, args)
    return null


func _has_steam_multiplayer_peer_support() -> bool:
    return ClassDB.can_instantiate("SteamMultiplayerPeer")


func _can_use_steam_sessions() -> bool:
    return _steam_has_any_method(["createLobby", "create_lobby"]) \
        and _steam_has_any_method(["joinLobby", "join_lobby"]) \
        and _has_steam_multiplayer_peer_support()


func _connect_steam_signal(signal_name: String, method_name: String) -> void:
    var steam_api: Object = _get_steam_api()
    if steam_api == null or not steam_api.has_signal(signal_name):
        return
    var callable := Callable(self, method_name)
    if not steam_api.is_connected(signal_name, callable):
        steam_api.connect(signal_name, callable)


func _install_steam_integration() -> void:
    if _get_steam_api() == null:
        return
    _connect_steam_signal("lobby_created", "_on_steam_lobby_created")
    _connect_steam_signal("lobby_joined", "_on_steam_lobby_joined")
    _connect_steam_signal("join_requested", "_on_steam_join_requested")
    _connect_steam_signal("game_lobby_join_requested", "_on_steam_join_requested")
    _connect_steam_signal("join_game_requested", "_on_steam_join_game_requested")
    _connect_steam_signal("lobby_invite", "_on_steam_lobby_invite")
    call_deferred("_handle_pending_steam_launch_invite")


func _handle_pending_steam_launch_invite() -> void:
    var launch_lobby_id: int = _extract_lobby_id_from_connect_string(" ".join(OS.get_cmdline_args()))
    if launch_lobby_id <= 0:
        return
    _join_steam_lobby_by_id(launch_lobby_id, false)


func _extract_lobby_id_from_connect_string(raw_text: String) -> int:
    var text: String = raw_text.strip_edges()
    if text == "":
        return 0
    if text.is_valid_int():
        return int(text)

    var connect_index: int = text.find(STEAM_CONNECT_LOBBY_PREFIX)
    if connect_index >= 0:
        var suffix: String = text.substr(connect_index + STEAM_CONNECT_LOBBY_PREFIX.length()).strip_edges()
        var lobby_text: String = suffix.get_slice(" ", 0)
        if lobby_text.is_valid_int():
            return int(lobby_text)

    var marker_index: int = text.find("steam_lobby=")
    if marker_index >= 0:
        var marker_suffix: String = text.substr(marker_index + len("steam_lobby=")).strip_edges()
        var marker_lobby_text: String = marker_suffix.get_slice(" ", 0)
        if marker_lobby_text.is_valid_int():
            return int(marker_lobby_text)

    return 0


func _prepare_session_start_state(is_host: bool) -> void:
    local_quit_in_progress = false
    local_fake_death_save_override.clear()
    local_fake_death_respawn_target_valid = false
    clear_fake_death_override_after_shutdown = false
    _clear_local_downed_state()
    guest_persistent_ready = is_host
    last_host_contact_time = Time.get_ticks_msec() if is_host else 0
    autosave_timer = 0.0
    deferred_host_autosave_pending = false
    client_state_heartbeat_timer = 0.0
    last_sent_client_state_hash = 0
    host_rehost_pending = false
    if is_host:
        host_rehost_port = int(config.get("port", DEFAULT_PORT))


func _get_local_steam_id() -> int:
    if Steamworks != null and int(Steamworks.steam_id) > 0:
        return int(Steamworks.steam_id)
    var steam_id_value: Variant = _steam_call_alias(["getSteamID", "get_steam_id"])
    return int(steam_id_value) if steam_id_value != null else 0


func _create_steam_multiplayer_peer() -> MultiplayerPeer:
    if not _has_steam_multiplayer_peer_support():
        return null
    return ClassDB.instantiate("SteamMultiplayerPeer") as MultiplayerPeer


func _configure_hosted_steam_lobby(lobby_id: int) -> void:
    if lobby_id <= 0:
        return
    _steam_call_alias(["setLobbyData", "set_lobby_data"], [lobby_id, STEAM_LOBBY_DATA_NAME, "%s's Co-op" % _get_local_player_name()])
    _steam_call_alias(["setLobbyData", "set_lobby_data"], [lobby_id, STEAM_LOBBY_DATA_TRANSPORT, SESSION_TRANSPORT_STEAM])
    _steam_call_alias(["setLobbyData", "set_lobby_data"], [lobby_id, STEAM_LOBBY_DATA_HOST_NAME, _get_local_player_name()])
    _steam_call_alias(["setLobbyJoinable", "set_lobby_joinable"], [lobby_id, true])
    _steam_call_alias(["setRichPresence", "set_rich_presence"], [STEAM_RICH_PRESENCE_STATUS_KEY, "Hosting co-op"])
    _steam_call_alias(["setRichPresence", "set_rich_presence"], [STEAM_RICH_PRESENCE_CONNECT_KEY, "%s%d" % [STEAM_CONNECT_LOBBY_PREFIX, lobby_id]])


func _clear_steam_presence() -> void:
    var steam_api: Object = _get_steam_api()
    if steam_api == null:
        return
    if steam_api.has_method("clearRichPresence"):
        steam_api.call("clearRichPresence")
        return
    if steam_api.has_method("clear_rich_presence"):
        steam_api.call("clear_rich_presence")
        return
    if steam_api.has_method("setRichPresence"):
        steam_api.call("setRichPresence", STEAM_RICH_PRESENCE_STATUS_KEY, "")
        steam_api.call("setRichPresence", STEAM_RICH_PRESENCE_CONNECT_KEY, "")
    elif steam_api.has_method("set_rich_presence"):
        steam_api.call("set_rich_presence", STEAM_RICH_PRESENCE_STATUS_KEY, "")
        steam_api.call("set_rich_presence", STEAM_RICH_PRESENCE_CONNECT_KEY, "")


func _leave_active_steam_lobby() -> void:
    if active_steam_lobby_id > 0:
        _steam_call_alias(["leaveLobby", "leave_lobby"], [active_steam_lobby_id])


func _clear_active_steam_session_state(leave_lobby: bool = true) -> void:
    if leave_lobby:
        _leave_active_steam_lobby()
    _clear_steam_presence()
    active_steam_lobby_id = 0
    active_steam_host_id = 0
    active_session_transport = SESSION_TRANSPORT_LAN


func _start_steam_host_peer(lobby_id: int) -> void:
    var peer := _create_steam_multiplayer_peer()
    if peer == null:
        status_message = "Steam host unavailable"
        _update_status_text()
        _clear_active_steam_session_state(true)
        return

    var err: Error = ERR_UNAVAILABLE
    if peer.has_method("host_with_lobby"):
        err = peer.call("host_with_lobby", lobby_id)
    elif peer.has_method("create_host"):
        err = peer.call("create_host", 0)
    if err != OK:
        status_message = "Steam host failed (%s)" % err
        _update_status_text()
        _clear_active_steam_session_state(true)
        return

    multiplayer.multiplayer_peer = peer
    peer_states.clear()
    active_session_transport = SESSION_TRANSPORT_STEAM
    active_steam_lobby_id = lobby_id
    active_steam_host_id = _get_local_steam_id()
    reconnect_steam_lobby_id = active_steam_lobby_id
    reconnect_steam_host_id = active_steam_host_id
    _install_player_death_hook()
    _install_game_menu_quit_hook()
    status_message = "Hosting Steam lobby"
    _update_status_text()
    if pending_steam_open_invite_dialog:
        pending_steam_open_invite_dialog = false
        _open_steam_invite_dialog()


func _start_steam_client_peer(lobby_id: int) -> void:
    var peer := _create_steam_multiplayer_peer()
    if peer == null:
        status_message = "Steam join unavailable"
        _update_status_text()
        _clear_active_steam_session_state(true)
        return

    active_steam_host_id = int(_steam_call_alias(["getLobbyOwner", "get_lobby_owner"], [lobby_id]))

    var err: Error = ERR_UNAVAILABLE
    if peer.has_method("connect_to_lobby"):
        err = peer.call("connect_to_lobby", lobby_id)
    elif peer.has_method("create_client"):
        err = peer.call("create_client", active_steam_host_id, 0)
    if err != OK:
        status_message = "Steam join failed (%s)" % err
        _update_status_text()
        _clear_active_steam_session_state(true)
        return

    multiplayer.multiplayer_peer = peer
    peer_states.clear()
    active_session_transport = SESSION_TRANSPORT_STEAM
    active_steam_lobby_id = lobby_id
    reconnect_steam_lobby_id = active_steam_lobby_id
    reconnect_steam_host_id = active_steam_host_id
    _install_player_death_hook()
    _install_game_menu_quit_hook()
    status_message = "Joining Steam lobby"
    _update_status_text()


func host_steam_session(auto_open_invite_dialog: bool = true) -> void:
    if not _can_share_loaded_world():
        status_message = "Open Steam co-op from inside a loaded world"
        _update_status_text()
        return
    if not _can_use_steam_sessions():
        status_message = "Steam co-op is unavailable"
        _update_status_text()
        return

    reconnect_pending = false
    reconnect_attempt_count = 0
    reconnect_retry_timer = 0.0
    reconnect_reason = ""
    reconnect_steam_lobby_id = 0
    reconnect_steam_host_id = 0
    pending_steam_action = "host"
    pending_steam_lobby_id = 0
    pending_steam_open_invite_dialog = auto_open_invite_dialog
    _set_reconnect_overlay_visible(false)
    _apply_ui_to_config()
    _prepare_session_start_state(true)
    disconnect_session(false)
    status_message = "Creating Steam lobby..."
    _update_status_text()
    _steam_call_alias(["createLobby", "create_lobby"], [STEAM_LOBBY_TYPE_FRIENDS_ONLY, MAX_CLIENTS])


func _join_steam_lobby_by_id(lobby_id: int, reset_reconnect_state: bool = true) -> void:
    if lobby_id <= 0:
        status_message = "Invalid Steam lobby"
        _update_status_text()
        return
    if not _can_use_steam_sessions():
        status_message = "Steam co-op is unavailable"
        _update_status_text()
        return

    if reset_reconnect_state:
        reconnect_pending = false
        reconnect_attempt_count = 0
        reconnect_retry_timer = 0.0
        reconnect_reason = ""
        reconnect_steam_lobby_id = 0
        reconnect_steam_host_id = 0
        _set_reconnect_overlay_visible(false)

    pending_steam_action = "join"
    pending_steam_lobby_id = lobby_id
    pending_steam_open_invite_dialog = false
    _prepare_session_start_state(false)
    disconnect_session(false)
    status_message = "Joining Steam lobby %s..." % lobby_id
    _update_status_text()
    _steam_call_alias(["joinLobby", "join_lobby"], [lobby_id])


func _open_steam_invite_dialog() -> void:
    if active_session_transport != SESSION_TRANSPORT_STEAM or active_steam_lobby_id <= 0:
        status_message = "Host a Steam session first"
        _update_status_text()
        return
    if not multiplayer.is_server():
        status_message = "Only the host can invite via Steam"
        _update_status_text()
        return

    var steam_api: Object = _get_steam_api()
    if steam_api == null:
        status_message = "Steam overlay unavailable"
        _update_status_text()
        return
    if steam_api.has_method("activateGameOverlayInviteDialog"):
        steam_api.call("activateGameOverlayInviteDialog", active_steam_lobby_id)
        status_message = "Steam invite dialog opened"
    elif steam_api.has_method("activate_game_overlay_invite_dialog"):
        steam_api.call("activate_game_overlay_invite_dialog", active_steam_lobby_id)
        status_message = "Steam invite dialog opened"
    elif steam_api.has_method("activateGameOverlay"):
        steam_api.call("activateGameOverlay", "Friends")
        status_message = "Opened Steam friends overlay"
    elif steam_api.has_method("activate_game_overlay"):
        steam_api.call("activate_game_overlay", "Friends")
        status_message = "Opened Steam friends overlay"
    else:
        status_message = "Steam invite dialog unavailable"
    _update_status_text()


func _on_steam_lobby_created(connect_status = null, lobby_id = null) -> void:
    if pending_steam_action != "host":
        return
    pending_steam_action = ""

    var created_lobby_id: int = int(lobby_id)
    var status_code: int = int(connect_status)
    if created_lobby_id <= 0 or (status_code not in [0, STEAM_RESULT_OK]):
        pending_steam_open_invite_dialog = false
        status_message = "Steam lobby creation failed"
        _update_status_text()
        return

    active_steam_lobby_id = created_lobby_id
    _configure_hosted_steam_lobby(created_lobby_id)
    _start_steam_host_peer(created_lobby_id)


func _on_steam_lobby_joined(lobby_id = null, _permissions = null, _locked = null, response = null, connection_failure = false) -> void:
    if pending_steam_action != "join":
        return

    var joined_lobby_id: int = int(lobby_id)
    var response_code: int = int(response)
    if bool(connection_failure) or joined_lobby_id <= 0 or (response != null and response_code != STEAM_CHAT_ROOM_ENTER_RESPONSE_SUCCESS):
        pending_steam_action = ""
        status_message = "Steam lobby join failed"
        _update_status_text()
        return

    pending_steam_action = ""
    active_steam_lobby_id = joined_lobby_id
    _start_steam_client_peer(joined_lobby_id)


func _on_steam_join_requested(arg0 = null, arg1 = null, arg2 = null) -> void:
    var lobby_id: int = 0
    for value in [arg0, arg1, arg2]:
        if value == null:
            continue
        var candidate: int = _extract_lobby_id_from_connect_string(str(value))
        if candidate > 0:
            lobby_id = candidate
            break
    if lobby_id <= 0:
        return
    _join_steam_lobby_by_id(lobby_id, true)


func _on_steam_join_game_requested(arg0 = null, arg1 = null, arg2 = null) -> void:
    var lobby_id: int = 0
    for value in [arg0, arg1, arg2]:
        if value == null:
            continue
        lobby_id = _extract_lobby_id_from_connect_string(str(value))
        if lobby_id > 0:
            break
    if lobby_id <= 0:
        return
    _join_steam_lobby_by_id(lobby_id, true)


func _on_steam_lobby_invite(_arg0 = null, _arg1 = null, _arg2 = null) -> void:
    status_message = "Steam invite received"
    _update_status_text()


func _get_game_menu_node() -> Control:
    if is_instance_valid(Ref.main):
        var main_game_menu: Control = Ref.main.get_node_or_null("%GameMenu") as Control
        if main_game_menu != null:
            return main_game_menu
    if is_instance_valid(Ref.game_menu):
        return Ref.game_menu as Control
    return null


func _get_main_menu_node() -> Control:
	if is_instance_valid(Ref.main):
		var main_menu: Control = Ref.main.get_node_or_null("%MainMenu") as Control
		if main_menu != null:
			return main_menu
    if is_instance_valid(Ref.ui):
		var ui_main_menu: Control = Ref.ui.find_child("MainMenu", true, false) as Control
		if ui_main_menu != null:
			return ui_main_menu
		var detected_menu: Control = _find_main_menu_from_visible_buttons(Ref.ui)
		if detected_menu != null:
			return detected_menu
	if is_instance_valid(Ref.main):
		var detected_main_menu: Control = _find_main_menu_from_visible_buttons(Ref.main)
		if detected_main_menu != null:
			return detected_main_menu
	var root := get_tree().get_root()
	if root != null:
		var detected_root_menu: Control = _find_main_menu_from_visible_buttons(root)
		if detected_root_menu != null:
			return detected_root_menu
	return null


func _clear_pause_menu_coop_ui() -> void:
    if is_instance_valid(pause_menu_coop_button):
        pause_menu_coop_button.queue_free()
    if is_instance_valid(pause_menu_coop_panel):
        pause_menu_coop_panel.queue_free()
    pause_menu_owner = null
    pause_menu_container = null
    pause_menu_resume_button = null
    pause_menu_coop_button = null
    pause_menu_coop_panel = null
    pause_menu_coop_shell = null
    pause_menu_coop_status_label = null
    pause_menu_coop_address_input = null
    pause_menu_coop_port_input = null
    pause_menu_coop_players_section = null
    pause_menu_coop_player_list = null
    pause_menu_coop_player_detail_label = null
    pause_menu_coop_tp_button = null
    pause_menu_coop_kick_button = null
    pause_menu_coop_player_signature = ""


func _clear_main_menu_coop_ui() -> void:
    if is_instance_valid(main_menu_coop_button):
        main_menu_coop_button.queue_free()
    if is_instance_valid(main_menu_coop_panel):
        main_menu_coop_panel.queue_free()
    main_menu_owner = null
    main_menu_coop_button = null
    main_menu_coop_panel = null
    main_menu_coop_shell = null
    main_menu_coop_server_name_input = null
    main_menu_coop_address_input = null
    main_menu_coop_port_input = null
    main_menu_coop_steam_lobby_input = null
    main_menu_server_cards_scroll = null
    main_menu_server_cards_container = null
    main_menu_server_card_buttons.clear()
    main_menu_server_detail_label = null
    main_menu_server_refresh_button = null
    main_menu_server_add_button = null
    main_menu_servers_page = null
    main_menu_players_page = null
    main_menu_player_list = null
    main_menu_player_detail_label = null
    main_menu_steam_page = null
    main_menu_direct_page = null
    main_menu_server_tab_button = null
    main_menu_players_tab_button = null
    main_menu_steam_tab_button = null
    main_menu_direct_tab_button = null
    main_menu_selected_tab = "servers"
    main_menu_player_signature = ""
    main_menu_coop_status_label = null


func _copy_pause_menu_button_style(source: Button, target: Button) -> void:
    if source == null or target == null:
        return
    target.theme = source.theme
    target.theme_type_variation = source.theme_type_variation
    target.focus_mode = source.focus_mode
    target.custom_minimum_size = source.custom_minimum_size
    target.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    target.flat = source.flat


func _copy_pause_menu_label_style(source: Label, target: Label, font_size: int = -1) -> void:
    if source == null or target == null:
        return
    target.theme = source.theme
    target.theme_type_variation = source.theme_type_variation
    target.horizontal_alignment = source.horizontal_alignment
    var resolved_font_size: int = font_size if font_size > 0 else source.get_theme_font_size("font_size")
    if resolved_font_size > 0:
        target.add_theme_font_size_override("font_size", resolved_font_size)


func _find_vanilla_qualia_card_sample() -> Button:
    var root := get_tree().get_root()
    if root == null:
        return null
    for node in root.find_children("SaveFileVBoxContainer", "", true, false):
        if node == null:
            continue
        for child in node.get_children():
            if child is Button:
                return child as Button
            if child is Node:
                for nested in (child as Node).find_children("*", "Button", true, false):
                    if nested is Button:
                        return nested as Button
    return null


func _find_vanilla_save_file_menu() -> Node:
    var root := get_tree().get_root()
    if root == null:
        return null
    for node in root.find_children("*", "", true, false):
        if node == null:
            continue
        if node.has_method("update_save_files") and node.has_method("_on_new_world_pressed") and _object_has_property(node, "save_file_container_scene"):
            return node
    return null


func _get_vanilla_save_file_container_scene() -> PackedScene:
    var save_file_menu: Node = _find_vanilla_save_file_menu()
    if save_file_menu == null:
        return null
    var scene: Variant = save_file_menu.get("save_file_container_scene")
    return scene as PackedScene if scene is PackedScene else null


func _make_server_browser_save_register(index: int, entry: Dictionary) -> SaveFileRegister:
    var register := SaveFileRegister.new()
    register.is_dimensional = false
    register.data = {}
    var title: String = str(entry.get("world_title", entry.get("name", "Server"))).strip_edges()
    if title == "":
        title = "Server"
    register.set_data("title", title.substr(0, 24))
    register.set_data("uuid", "coop-server-%s-%s" % [index, _make_server_browser_entry_key(entry).md5_text()])
    register.set_data("version", str(ProjectSettings.get("application/config/version")))
    register.set_data("file_color_1", entry.get("file_color_1", Color.from_hsv(0.58, 0.32, 0.95)))
    register.set_data("file_color_2", entry.get("file_color_2", Color.from_hsv(0.09, 0.62, 0.8)))
    register.set_data("coop_server_browser_entry", true)
    return register


func _connect_server_card_activation(control: Control, entry: Dictionary) -> void:
    if control == null:
        return
    var entry_copy: Dictionary = entry.duplicate(true)
    var callback := func(_a: Variant = null, _b: Variant = null, _c: Variant = null) -> void:
        _join_main_menu_server_entry(entry_copy.duplicate(true))
    if control.has_signal("play_button_pressed"):
        control.connect("play_button_pressed", callback)
    if control is BaseButton:
        var button := control as BaseButton
        button.pressed.connect(callback)

    for child in control.find_children("*", "BaseButton", true, false):
        if child is BaseButton:
            (child as BaseButton).pressed.connect(callback)

    var hitbox := Button.new()
    hitbox.name = "CoopServerCardHitbox"
    hitbox.text = ""
    hitbox.flat = true
    hitbox.mouse_filter = Control.MOUSE_FILTER_STOP
    hitbox.focus_mode = Control.FOCUS_ALL
    hitbox.set_anchors_preset(Control.PRESET_FULL_RECT)
    hitbox.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
    hitbox.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
    hitbox.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
    hitbox.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
    hitbox.mouse_entered.connect(func() -> void:
        _set_vanilla_server_card_hover_visual(control, true)
    )
    hitbox.mouse_exited.connect(func() -> void:
        _set_vanilla_server_card_hover_visual(control, false)
    )
    hitbox.focus_entered.connect(func() -> void:
        _set_vanilla_server_card_hover_visual(control, true)
    )
    hitbox.focus_exited.connect(func() -> void:
        _set_vanilla_server_card_hover_visual(control, false)
    )
    hitbox.pressed.connect(callback)
    hitbox.gui_input.connect(func(event: InputEvent) -> void:
        if event.is_action_pressed("ui_accept"):
            _join_main_menu_server_entry(entry_copy.duplicate(true))
    )
    control.add_child(hitbox)


func _set_vanilla_server_card_hover_visual(control: Control, hovered: bool) -> void:
    if control == null:
        return
    control.modulate = Color(1.08, 1.08, 1.1, 1.0) if hovered else Color.WHITE


func _format_server_browser_status_line(entry: Dictionary) -> String:
	return "%s  %s" % [_format_server_browser_presence_text(entry), _format_server_browser_detail_line(entry)]


func _format_server_browser_presence_text(entry: Dictionary) -> String:
	var status: String = str(entry.get("status", "unknown")).strip_edges().to_lower()
	if status == "online" or status == "ready":
		return "ONLINE"
	if status == "checking":
		return "CHECKING"
	if status == "relay":
		return "RELAY"
	if status == "incompatible":
		return "UPDATE"
	if status == "offline":
		return "OFFLINE"
	return "IDLE"


func _format_server_browser_detail_line(entry: Dictionary) -> String:
	var status: String = str(entry.get("status", "unknown")).strip_edges().to_lower()
	var region: String = str(entry.get("region", "public")).strip_edges()
	var region_text: String = region if region != "" else "public"
	if status == "online" or status == "ready":
		var tps_text: String = "? TPS"
		if entry.has("tps"):
			tps_text = "%s TPS" % int(round(float(entry.get("tps", 0.0))))
		return "%s/%s  |  %s  |  %s" % [
			int(entry.get("players", 0)),
			int(entry.get("max_players", MAX_CLIENTS)),
			tps_text,
			region_text.substr(0, 3).to_upper(),
		]
	if status == "checking":
		return "WAITING  %s" % region_text.substr(0, 3).to_upper()
	if status == "relay":
		return "WAITING"
	if status == "incompatible":
		return "PROTOCOL"
	if status == "offline":
		return region_text.substr(0, 3).to_upper()
	return region_text.substr(0, 3).to_upper()


func _format_server_browser_region_line(entry: Dictionary) -> String:
	var region: String = str(entry.get("region", "preta")).strip_edges()
	return (region if region != "" else "preta").to_upper()


func _format_server_browser_meta_line(entry: Dictionary) -> String:
	var version: String = str(entry.get("version", ProjectSettings.get("application/config/version"))).strip_edges()
	if version == "":
		version = str(ProjectSettings.get("application/config/version"))
	var presence: String = _format_server_browser_presence_text(entry)
	var details: String = _format_server_browser_detail_line(entry)
	return "V%s   %s   %s" % [version, presence, details]


func _add_server_card_overlay_label(card: Control, label_name: String, text: String, left: float, top: float, right: float, bottom: float, font_size: int = 7) -> Label:
	var label := Label.new()
	label.name = label_name
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = text
	label.z_index = 4096
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.clip_text = true
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.86, 0.88, 0.9))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.78))
	label.add_theme_constant_override("shadow_outline_size", 2 if font_size > 4 else 1)
	card.add_child(label)
	_position_server_card_overlay_label(card, label, left, top, right, bottom)
	call_deferred("_position_server_card_overlay_label", card, label, left, top, right, bottom)
	if not card.resized.is_connected(_position_server_card_overlay_label.bind(card, label, left, top, right, bottom)):
		card.resized.connect(_position_server_card_overlay_label.bind(card, label, left, top, right, bottom))
	return label


func _position_server_card_overlay_label(card: Control, label: Label, left: float, top: float, right: float, bottom: float) -> void:
	if card == null or label == null or not is_instance_valid(card) or not is_instance_valid(label):
		return
	label.position = Vector2(left, top)
	label.size = Vector2(maxf(1.0, card.size.x - left + right), maxf(1.0, bottom - top))


func _decorate_vanilla_server_card(card: Control, entry: Dictionary) -> void:
    if card == null:
        return
    card.set_meta("coop_server_browser_entry", entry.duplicate(true))
    card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	card.custom_minimum_size.y = SERVER_BROWSER_CARD_HEIGHT
	card.focus_mode = Control.FOCUS_ALL

	_add_server_card_overlay_label(card, "CoopServerPresenceLine", _format_server_browser_presence_text(entry), 104.0, 47.0, -18.0, 59.0, 7)
	_add_server_card_overlay_label(card, "CoopServerStatusLine", _format_server_browser_detail_line(entry), 178.0, 56.0, -18.0, 62.0, 4)


func _try_build_vanilla_main_menu_server_card(index: int, entry: Dictionary) -> Control:
	# The vanilla save card keeps a large internal minimum height after initialization.
	# Server cards need the same visual language, but a much tighter browser row.
	return null

    var scene: PackedScene = _get_vanilla_save_file_container_scene()
    if scene == null:
        return null
    var instance: Node = scene.instantiate()
    if not (instance is Control) or not instance.has_method("initialize"):
        if instance != null:
            instance.queue_free()
        return null
    var card := instance as Control
    var register: SaveFileRegister = _make_server_browser_save_register(index, entry)
    card.call("initialize", register, false, false, false)
    _decorate_vanilla_server_card(card, entry)
    _connect_server_card_activation(card, entry)
    return card


func _copy_button_theme_styleboxes(source: Button, target: Button) -> bool:
    if source == null or target == null:
        return false
    target.theme = source.theme
    target.theme_type_variation = source.theme_type_variation
    for style_name in ["normal", "hover", "pressed", "focus", "disabled"]:
        var style: StyleBox = source.get_theme_stylebox(style_name)
        if style != null:
            target.add_theme_stylebox_override(style_name, style.duplicate(true))
    return true


func _find_vanilla_qualia_background_texture() -> Texture2D:
    var vanilla_sample: Button = _find_vanilla_qualia_card_sample()
    if vanilla_sample == null:
        return null
    for node in vanilla_sample.find_children("*", "TextureRect", true, false):
        if node is TextureRect and (node as TextureRect).texture != null:
            return (node as TextureRect).texture
    return null


func _make_qualia_server_card_style(bg_color: Color, border_color: Color, raised: bool = false) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = bg_color
    style.border_color = border_color
    style.set_border_width_all(2 if raised else 1)
    style.set_corner_radius_all(16)
    style.set_content_margin(SIDE_LEFT, 0.0)
    style.set_content_margin(SIDE_RIGHT, 0.0)
    style.set_content_margin(SIDE_TOP, 0.0)
    style.set_content_margin(SIDE_BOTTOM, 0.0)
    return style


func _apply_qualia_server_card_style(button: Button, entry: Dictionary) -> void:
    if button == null:
        return
    var base_color: Color = entry.get("file_color_1", Color.from_hsv(0.58, 0.32, 0.95))
    var accent_color: Color = entry.get("file_color_2", Color.from_hsv(0.09, 0.62, 0.8))
    var status: String = str(entry.get("status", "unknown"))
    var normal_color: Color = Color(0.015, 0.016, 0.018, 0.88).lerp(base_color.darkened(0.62), 0.18)
    var hover_color: Color = Color(0.035, 0.038, 0.044, 0.94).lerp(base_color.darkened(0.36), 0.28)
    var pressed_color: Color = Color(0.02, 0.022, 0.026, 0.97).lerp(accent_color.darkened(0.28), 0.32)
    if status == "offline" or status == "relay":
        normal_color = normal_color.darkened(0.28)
        hover_color = normal_color.lightened(0.05)
        pressed_color = normal_color.darkened(0.08)
        accent_color = Color(0.42, 0.42, 0.46)

    button.add_theme_stylebox_override("normal", _make_qualia_server_card_style(normal_color, accent_color))
    button.add_theme_stylebox_override("hover", _make_qualia_server_card_style(hover_color, accent_color, true))
    button.add_theme_stylebox_override("pressed", _make_qualia_server_card_style(pressed_color, accent_color, true))
    button.add_theme_stylebox_override("focus", _make_qualia_server_card_style(hover_color, Color(1.0, 0.92, 0.64), true))


func _make_qualia_menu_panel_style() -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.012, 0.012, 0.016, 0.84)
    style.border_color = Color(0.22, 0.22, 0.28, 0.95)
    style.set_border_width_all(2)
    style.set_corner_radius_all(2)
    style.set_content_margin(SIDE_LEFT, 0.0)
    style.set_content_margin(SIDE_RIGHT, 0.0)
    style.set_content_margin(SIDE_TOP, 0.0)
    style.set_content_margin(SIDE_BOTTOM, 0.0)
    return style


func _make_qualia_tab_style(active: bool = false) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.018, 0.018, 0.022, 0.92) if not active else Color(0.08, 0.08, 0.095, 0.98)
    style.border_color = Color(0.16, 0.16, 0.2, 0.98) if not active else Color(0.48, 0.48, 0.56, 1.0)
    style.set_border_width_all(2)
    style.set_corner_radius_all(2)
    style.set_content_margin(SIDE_LEFT, 8.0)
    style.set_content_margin(SIDE_RIGHT, 8.0)
    style.set_content_margin(SIDE_TOP, 3.0)
    style.set_content_margin(SIDE_BOTTOM, 3.0)
    return style


func _apply_qualia_tab_button_style(button: Button) -> void:
    if button == null:
        return
    button.add_theme_stylebox_override("normal", _make_qualia_tab_style(false))
    button.add_theme_stylebox_override("hover", _make_qualia_tab_style(true))
    button.add_theme_stylebox_override("pressed", _make_qualia_tab_style(true))
    button.add_theme_stylebox_override("focus", _make_qualia_tab_style(true))
    button.add_theme_stylebox_override("disabled", _make_qualia_tab_style(false))
    button.add_theme_color_override("font_color", Color(0.86, 0.86, 0.9))
    button.add_theme_color_override("font_hover_color", Color(1.0, 0.98, 0.9))
    button.add_theme_color_override("font_pressed_color", Color(1.0, 0.98, 0.9))
    button.add_theme_font_size_override("font_size", 7)


func _make_qualia_emblem_style(color: Color) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.1, 0.09, 0.075, 0.96).lerp(color.darkened(0.35), 0.42)
    style.border_color = color.lightened(0.22)
    style.set_border_width_all(2)
    style.set_corner_radius_all(12)
    return style


func _make_qualia_card_tint_style(entry: Dictionary) -> StyleBoxFlat:
    var base_color: Color = entry.get("file_color_1", Color.from_hsv(0.58, 0.32, 0.95))
    var accent_color: Color = entry.get("file_color_2", Color.from_hsv(0.09, 0.62, 0.8))
    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.025, 0.028, 0.032, 0.82).lerp(base_color.darkened(0.45), 0.24)
    style.border_color = accent_color.lightened(0.12)
    style.set_border_width_all(1)
    style.set_corner_radius_all(16)
    return style


func _make_qualia_card_background_texture(entry: Dictionary) -> Texture2D:
    var vanilla_texture: Texture2D = _find_vanilla_qualia_background_texture()
    if vanilla_texture != null:
        return vanilla_texture

    var base_color: Color = entry.get("file_color_1", Color.from_hsv(0.58, 0.32, 0.95))
    var accent_color: Color = entry.get("file_color_2", Color.from_hsv(0.09, 0.62, 0.8))
    var gradient := Gradient.new()
    gradient.offsets = PackedFloat32Array([0.0, 0.38, 0.72, 1.0])
    gradient.colors = PackedColorArray([
        base_color.darkened(0.58),
        Color(0.025, 0.028, 0.032, 1.0),
        accent_color.darkened(0.42),
        Color(0.0, 0.0, 0.0, 1.0),
    ])
    var texture := GradientTexture2D.new()
    texture.width = 640
    texture.height = 96
    texture.gradient = gradient
    texture.fill = GradientTexture2D.FILL_LINEAR
    texture.fill_from = Vector2(0.0, 0.0)
    texture.fill_to = Vector2(1.0, 0.72)
    return texture


func _setup_qualia_card_button(button: Button, entry: Dictionary, min_height: float) -> void:
    button.text = ""
    button.custom_minimum_size = Vector2(SERVER_BROWSER_CARD_WIDTH, min_height)
    button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
    button.focus_mode = Control.FOCUS_ALL
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.clip_contents = true
    button.disabled = false
    _apply_qualia_server_card_style(button, entry)


func _add_qualia_card_backdrop(button: Button, entry: Dictionary, alpha: float = 0.62) -> void:
    var background := TextureRect.new()
    background.name = "CoopServerCardBackdrop"
    background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    background.offset_left = 3.0
    background.offset_top = 3.0
    background.offset_right = -3.0
    background.offset_bottom = -3.0
    background.texture = _make_qualia_card_background_texture(entry)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_SCALE
    background.modulate = Color(1.0, 1.0, 1.0, alpha)
    background.set_meta("coop_base_alpha", alpha)
    button.add_child(background)

    var tint := Panel.new()
    tint.name = "CoopServerCardTint"
    tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
    tint.set_anchors_preset(Control.PRESET_FULL_RECT)
    tint.add_theme_stylebox_override("panel", _make_qualia_card_tint_style(entry))
    button.add_child(tint)


func _bind_qualia_card_hover(button: Button) -> void:
    if button == null or bool(button.get_meta("coop_hover_bound", false)):
        return
    button.set_meta("coop_hover_bound", true)
    button.mouse_entered.connect(func() -> void:
        _set_qualia_card_hover_visual(button, true)
    )
    button.mouse_exited.connect(func() -> void:
        _set_qualia_card_hover_visual(button, false)
    )
    button.focus_entered.connect(func() -> void:
        _set_qualia_card_hover_visual(button, true)
    )
    button.focus_exited.connect(func() -> void:
        _set_qualia_card_hover_visual(button, false)
    )
    button.button_down.connect(func() -> void:
        _set_qualia_card_pressed_visual(button, true)
    )
    button.button_up.connect(func() -> void:
        _set_qualia_card_pressed_visual(button, false)
    )
    _set_qualia_card_hover_visual(button, false)


func _set_qualia_card_hover_visual(button: Button, hovered: bool) -> void:
    if button == null:
        return
    button.self_modulate = Color(1.06, 1.06, 1.08, 1.0) if hovered else Color.WHITE

    var background := button.get_node_or_null("CoopServerCardBackdrop") as CanvasItem
    if background != null:
        var base_alpha: float = float(background.get_meta("coop_base_alpha", 0.64))
        var hover_alpha: float = minf(base_alpha + 0.18, 0.92)
        background.modulate = Color(1.14, 1.14, 1.18, hover_alpha) if hovered else Color(1.0, 1.0, 1.0, base_alpha)

    var tint := button.get_node_or_null("CoopServerCardTint") as CanvasItem
    if tint != null:
        tint.modulate = Color(1.2, 1.18, 1.12, 1.0) if hovered else Color.WHITE


func _set_qualia_card_pressed_visual(button: Button, pressed: bool) -> void:
    if button == null:
        return
    button.self_modulate = Color(0.92, 0.92, 0.95, 1.0) if pressed else Color.WHITE


func _add_qualia_card_emblem(parent: BoxContainer, entry: Dictionary, size: float) -> void:
    var accent_color: Color = entry.get("file_color_2", Color.from_hsv(0.09, 0.62, 0.8))
    var emblem := PanelContainer.new()
    emblem.mouse_filter = Control.MOUSE_FILTER_IGNORE
    emblem.custom_minimum_size = Vector2(size, size)
    emblem.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    emblem.add_theme_stylebox_override("panel", _make_qualia_emblem_style(accent_color))
    parent.add_child(emblem)

    var emblem_center := CenterContainer.new()
    emblem_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
    emblem.add_child(emblem_center)

    var emblem_label := Label.new()
    emblem_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    emblem_label.text = str(entry.get("world_title", entry.get("name", "Q"))).substr(0, 1).to_upper()
    emblem_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    emblem_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    emblem_label.add_theme_font_size_override("font_size", 10)
    emblem_label.add_theme_color_override("font_color", Color(0.9, 0.92, 0.96))
    emblem_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.75))
    emblem_label.add_theme_constant_override("shadow_outline_size", 3)
    emblem_center.add_child(emblem_label)


func _add_qualia_card_swatch(parent: BoxContainer, entry: Dictionary) -> void:
    var accent_color: Color = entry.get("file_color_2", Color.from_hsv(0.09, 0.62, 0.8))
    var swatch := ColorRect.new()
    swatch.mouse_filter = Control.MOUSE_FILTER_IGNORE
    swatch.color = accent_color
    swatch.custom_minimum_size = Vector2(4.0, 0.0)
    parent.add_child(swatch)


func _make_qualia_card_label(text: String, font_size: int, color: Color, min_height: float = 0.0) -> Label:
    var label := Label.new()
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    label.text = text
    label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
    label.clip_text = true
    if min_height > 0.0:
        label.custom_minimum_size = Vector2(0.0, min_height)
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", color)
    label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.78))
    label.add_theme_constant_override("shadow_outline_size", 1 if font_size <= 6 else 2)
    return label


func _get_overlay_parent(source: Control) -> Control:
    var overlay_parent: Control = source
    while overlay_parent.get_parent() is Control:
        overlay_parent = overlay_parent.get_parent() as Control
    return overlay_parent


func _get_spin_box_int_value(spin_box: SpinBox, fallback: int) -> int:
    if spin_box == null:
        return fallback

    var min_value: int = maxi(1, int(floor(spin_box.min_value)))
    var max_value: int = maxi(min_value, int(ceil(spin_box.max_value)))
    var line_edit: LineEdit = spin_box.get_line_edit()
    if line_edit != null:
        var raw_text: String = line_edit.text.strip_edges()
        if raw_text.is_valid_int():
            return clampi(int(raw_text), min_value, max_value)
    return clampi(int(round(spin_box.value)), min_value, max_value)


func _build_pause_menu_coop_panel(sample_button: Button, sample_title: Label, sample_container: Control) -> Control:
    var submenu_panel := Control.new()
    submenu_panel.visible = false
    submenu_panel.mouse_filter = Control.MOUSE_FILTER_STOP
    submenu_panel.focus_mode = Control.FOCUS_ALL
    submenu_panel.z_index = 100
    submenu_panel.set_anchors_preset(Control.PRESET_FULL_RECT)

    var safe_area := MarginContainer.new()
    safe_area.set_anchors_preset(Control.PRESET_FULL_RECT)
    safe_area.add_theme_constant_override("margin_left", 18)
    safe_area.add_theme_constant_override("margin_right", 18)
    safe_area.add_theme_constant_override("margin_top", 18)
    safe_area.add_theme_constant_override("margin_bottom", 18)
    submenu_panel.add_child(safe_area)

    var center := CenterContainer.new()
    center.set_anchors_preset(Control.PRESET_FULL_RECT)
    safe_area.add_child(center)

    pause_menu_coop_shell = PanelContainer.new()
    pause_menu_coop_shell.clip_contents = true
    if sample_container != null:
        pause_menu_coop_shell.theme = sample_container.theme
        pause_menu_coop_shell.theme_type_variation = sample_container.theme_type_variation
    center.add_child(pause_menu_coop_shell)

    var scroll := ScrollContainer.new()
    scroll.anchor_right = 1.0
    scroll.anchor_bottom = 1.0
    scroll.offset_right = 0.0
    scroll.offset_bottom = 0.0
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    scroll.follow_focus = true
    pause_menu_coop_shell.add_child(scroll)

    var margin := MarginContainer.new()
    margin.add_theme_constant_override("margin_left", 18)
    margin.add_theme_constant_override("margin_right", 18)
    margin.add_theme_constant_override("margin_top", 18)
    margin.add_theme_constant_override("margin_bottom", 18)
    scroll.add_child(margin)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 10)
    margin.add_child(column)

    var title_row := HBoxContainer.new()
    title_row.add_theme_constant_override("separation", 8)
    column.add_child(title_row)

    var title_back_button := Button.new()
    _copy_pause_menu_button_style(sample_button, title_back_button)
    title_back_button.text = "Back"
    title_back_button.custom_minimum_size = Vector2(72.0, sample_button.custom_minimum_size.y)
    title_back_button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
    title_back_button.pressed.connect(_close_pause_menu_coop_panel)
    title_row.add_child(title_back_button)

    var title := Label.new()
    title.text = "CO-OP"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    if sample_title != null:
        _copy_pause_menu_label_style(sample_title, title, sample_title.get_theme_font_size("font_size"))
    else:
        title.add_theme_font_size_override("font_size", 18)
    title_row.add_child(title)

    var title_spacer := Control.new()
    title_spacer.custom_minimum_size = Vector2(72.0, sample_button.custom_minimum_size.y)
    title_row.add_child(title_spacer)

    var subtitle := Label.new()
    subtitle.text = "Invite friends through Steam or connect over your local network"
    subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    if sample_title != null:
        _copy_pause_menu_label_style(sample_title, subtitle, max(10, sample_title.get_theme_font_size("font_size") - 6))
    else:
        subtitle.add_theme_font_size_override("font_size", 11)
    column.add_child(subtitle)

    var steam_heading := Label.new()
    steam_heading.text = "STEAM"
    steam_heading.add_theme_font_size_override("font_size", 11)
    column.add_child(steam_heading)

    var steam_buttons := HBoxContainer.new()
    steam_buttons.add_theme_constant_override("separation", 8)
    column.add_child(steam_buttons)

    var steam_host_button := Button.new()
    _copy_pause_menu_button_style(sample_button, steam_host_button)
    steam_host_button.text = "Host Steam"
    steam_host_button.pressed.connect(host_steam_session)
    steam_buttons.add_child(steam_host_button)

    var steam_invite_button := Button.new()
    _copy_pause_menu_button_style(sample_button, steam_invite_button)
    steam_invite_button.text = "Invite"
    steam_invite_button.pressed.connect(_open_steam_invite_dialog)
    steam_buttons.add_child(steam_invite_button)

    var local_heading := Label.new()
    local_heading.text = "LOCAL"
    local_heading.add_theme_font_size_override("font_size", 11)
    column.add_child(local_heading)

    var local_hint := Label.new()
    local_hint.text = "Join another machine on your LAN with an IP and port"
    local_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    local_hint.add_theme_font_size_override("font_size", 10)
    column.add_child(local_hint)

    var local_join_row := HBoxContainer.new()
    local_join_row.add_theme_constant_override("separation", 8)
    column.add_child(local_join_row)

    pause_menu_coop_address_input = LineEdit.new()
    pause_menu_coop_address_input.placeholder_text = "192.168.x.x"
    pause_menu_coop_address_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    pause_menu_coop_address_input.custom_minimum_size = Vector2(0.0, max(24.0, sample_button.custom_minimum_size.y))
    pause_menu_coop_address_input.text_submitted.connect(_on_join_text_submitted)
    local_join_row.add_child(pause_menu_coop_address_input)

    pause_menu_coop_port_input = SpinBox.new()
    pause_menu_coop_port_input.min_value = 1
    pause_menu_coop_port_input.max_value = 65535
    pause_menu_coop_port_input.step = 1
    pause_menu_coop_port_input.rounded = true
    pause_menu_coop_port_input.custom_minimum_size = Vector2(88.0, max(24.0, sample_button.custom_minimum_size.y))
    local_join_row.add_child(pause_menu_coop_port_input)

    var local_buttons := HBoxContainer.new()
    local_buttons.add_theme_constant_override("separation", 8)
    column.add_child(local_buttons)

    var local_host_button := Button.new()
    _copy_pause_menu_button_style(sample_button, local_host_button)
    local_host_button.text = "Host Local"
    local_host_button.pressed.connect(host_session)
    local_buttons.add_child(local_host_button)

    var local_join_button := Button.new()
    _copy_pause_menu_button_style(sample_button, local_join_button)
    local_join_button.text = "Join Local"
    local_join_button.pressed.connect(join_session)
    local_buttons.add_child(local_join_button)

    pause_menu_coop_status_label = Label.new()
    pause_menu_coop_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    pause_menu_coop_status_label.custom_minimum_size = Vector2(0.0, 54.0)
    pause_menu_coop_status_label.add_theme_font_size_override("font_size", 10)
    column.add_child(pause_menu_coop_status_label)

    pause_menu_coop_players_section = VBoxContainer.new()
    pause_menu_coop_players_section.visible = false
    pause_menu_coop_players_section.add_theme_constant_override("separation", 6)
    column.add_child(pause_menu_coop_players_section)

    var players_heading := Label.new()
    players_heading.text = "PLAYERS"
    players_heading.add_theme_font_size_override("font_size", 11)
    pause_menu_coop_players_section.add_child(players_heading)

    pause_menu_coop_player_list = ItemList.new()
    pause_menu_coop_player_list.custom_minimum_size = Vector2(0.0, 110.0)
    pause_menu_coop_player_list.allow_reselect = true
    pause_menu_coop_player_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
    pause_menu_coop_player_list.add_theme_font_size_override("font_size", 10)
    pause_menu_coop_player_list.item_selected.connect(_on_pause_menu_player_selected)
    pause_menu_coop_player_list.item_activated.connect(_on_pause_menu_player_activated)
    pause_menu_coop_players_section.add_child(pause_menu_coop_player_list)

    pause_menu_coop_player_detail_label = Label.new()
    pause_menu_coop_player_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    pause_menu_coop_player_detail_label.custom_minimum_size = Vector2(0.0, 32.0)
    pause_menu_coop_player_detail_label.add_theme_font_size_override("font_size", 10)
    pause_menu_coop_players_section.add_child(pause_menu_coop_player_detail_label)

    var players_button_row := HBoxContainer.new()
    players_button_row.add_theme_constant_override("separation", 8)
    pause_menu_coop_players_section.add_child(players_button_row)

    pause_menu_coop_tp_button = Button.new()
    _copy_pause_menu_button_style(sample_button, pause_menu_coop_tp_button)
    pause_menu_coop_tp_button.text = "TP"
    pause_menu_coop_tp_button.pressed.connect(_teleport_to_selected_pause_menu_peer)
    players_button_row.add_child(pause_menu_coop_tp_button)

    pause_menu_coop_kick_button = Button.new()
    _copy_pause_menu_button_style(sample_button, pause_menu_coop_kick_button)
    pause_menu_coop_kick_button.text = "Kick"
    pause_menu_coop_kick_button.pressed.connect(_kick_selected_pause_menu_peer)
    players_button_row.add_child(pause_menu_coop_kick_button)

    var footer_buttons := HBoxContainer.new()
    footer_buttons.add_theme_constant_override("separation", 8)
    column.add_child(footer_buttons)

    var leave_button := Button.new()
    _copy_pause_menu_button_style(sample_button, leave_button)
    leave_button.text = "Leave Session"
    leave_button.pressed.connect(leave_session)
    footer_buttons.add_child(leave_button)

    return submenu_panel


func _ensure_pause_menu_coop_ui() -> void:
    var game_menu: Control = _get_game_menu_node()
    if game_menu == null or not game_menu.is_inside_tree():
        _clear_pause_menu_coop_ui()
        return

    if pause_menu_owner != null and pause_menu_owner != game_menu:
        _clear_pause_menu_coop_ui()

    var pause_container: Control = game_menu.find_child("PauseContainer", true, false) as Control
    var resume_button: Button = game_menu.find_child("ResumeButton", true, false) as Button
    if pause_container == null or resume_button == null:
        return

    pause_menu_owner = game_menu
    pause_menu_container = pause_container
    pause_menu_resume_button = resume_button

    if not is_instance_valid(pause_menu_coop_button):
        var button_parent: Node = resume_button.get_parent()
        if button_parent == null:
            return
        pause_menu_coop_button = Button.new()
        pause_menu_coop_button.name = "CoopPauseButton"
        _copy_pause_menu_button_style(resume_button, pause_menu_coop_button)
        pause_menu_coop_button.text = "Co-op"
        pause_menu_coop_button.pressed.connect(_open_pause_menu_coop_panel)
        button_parent.add_child(pause_menu_coop_button)
        button_parent.move_child(pause_menu_coop_button, resume_button.get_index() + 1)

    if not is_instance_valid(pause_menu_coop_panel):
        var title_label: Label = game_menu.find_child("PauseTitleLabel", true, false) as Label
        pause_menu_coop_panel = _build_pause_menu_coop_panel(resume_button, title_label, pause_container)
        var pause_parent: Node = _get_overlay_parent(game_menu)
        if pause_parent == null:
            return
        pause_parent.add_child(pause_menu_coop_panel)

    _sync_inputs_from_config()
    _refresh_pause_menu_coop_status()
    _refresh_overlay_layout()


func _is_pause_menu_coop_panel_open() -> bool:
    return is_instance_valid(pause_menu_coop_panel) and pause_menu_coop_panel.visible


func _open_pause_menu_coop_panel() -> void:
    _ensure_pause_menu_coop_ui()
    if not is_instance_valid(pause_menu_coop_panel):
        return
    _sync_inputs_from_config()
    _refresh_pause_menu_coop_status()
    _refresh_pause_menu_player_list(true)
    if is_instance_valid(pause_menu_container):
        pause_menu_container.visible = false
    pause_menu_coop_panel.visible = true
    pause_menu_coop_panel.move_to_front()
    _refresh_overlay_layout()
    if pause_menu_coop_address_input != null:
        pause_menu_coop_address_input.grab_focus()
        pause_menu_coop_address_input.caret_column = pause_menu_coop_address_input.text.length()


func _close_pause_menu_coop_panel() -> void:
    _apply_ui_to_config()
    if is_instance_valid(pause_menu_coop_panel):
        pause_menu_coop_panel.visible = false
    if is_instance_valid(pause_menu_container):
        pause_menu_container.visible = true
    get_viewport().gui_release_focus()


func _refresh_pause_menu_coop_status() -> void:
    if pause_menu_coop_status_label == null:
        return

    var mode: String = "offline"
    if _has_live_peer():
        mode = "host" if multiplayer.is_server() else "client"

    var steam_status: String = "ready" if _can_use_steam_sessions() else "unavailable"
    if active_steam_lobby_id > 0:
        steam_status = "lobby %s" % active_steam_lobby_id

    pause_menu_coop_status_label.text = "%s\nMode: %s  |  Transport: %s\nSteam: %s  |  LAN: %s" % [
        status_message,
        mode,
        active_session_transport,
        steam_status,
        _get_best_local_ipv4(),
    ]


func _sync_pause_menu_coop_panel_visibility() -> void:
    if not _is_pause_menu_coop_panel_open():
        return
    if pause_menu_owner == null or not is_instance_valid(pause_menu_owner) or not pause_menu_owner.visible:
        _close_pause_menu_coop_panel()
        return
    if is_instance_valid(Ref.game_menu) and int(Ref.game_menu.state) != 4:
        _close_pause_menu_coop_panel()


func _get_peer_display_name(peer_id: int, state: Dictionary = {}) -> String:
    if peer_id == multiplayer.get_unique_id():
        return _get_local_player_name()
    var resolved_state: Dictionary = state if not state.is_empty() else peer_states.get(peer_id, {})
    var display_name: String = str(resolved_state.get("name", "")).strip_edges()
    if display_name != "":
        return display_name
    return "Peer %s" % peer_id


func _get_session_player_entries() -> Array:
    var entries: Array = []
    if not _has_live_peer():
        return entries

    var local_entry: Dictionary = _capture_local_state()
    local_entry["peer_id"] = multiplayer.get_unique_id()
    local_entry["is_local"] = true
    if not _is_dedicated_peer_state(multiplayer.get_unique_id(), local_entry):
        entries.append(local_entry)

    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue
        var state: Dictionary = peer_states[peer_id]
        if state.is_empty():
            continue
        if _is_dedicated_peer_state(int_peer_id, state):
            continue
        var entry: Dictionary = state.duplicate(true)
        entry["peer_id"] = int_peer_id
        entry["is_local"] = false
        entries.append(entry)

    entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
        return int(a.get("peer_id", -1)) < int(b.get("peer_id", -1))
    )
    return entries


func _format_session_player_label(entry: Dictionary) -> String:
    var peer_id: int = int(entry.get("peer_id", -1))
    var label: String = _get_peer_display_name(peer_id, entry)
    if bool(entry.get("is_local", false)):
        label += " (You)"
    elif peer_id == 1:
        label += " (Host)"
    elif not bool(entry.get("active", false)):
        label += " (Connecting)"
    if bool(entry.get("downed", false)):
        label += " [Downed]"
    return label


func _is_dedicated_peer_state(peer_id: int, state: Dictionary = {}) -> bool:
    var resolved_state: Dictionary = state if not state.is_empty() else peer_states.get(peer_id, {})
    return peer_id == 1 and bool(resolved_state.get("dedicated_server", false))


func _get_session_player_signature(entries: Array) -> String:
    var parts: PackedStringArray = PackedStringArray()
    for entry in entries:
        if not (entry is Dictionary):
            continue
        parts.append("%s|%s|%s|%s" % [
            int(entry.get("peer_id", -1)),
            _format_session_player_label(entry),
            str(entry.get("dimension_instance_key", "")),
            bool(entry.get("active", false)),
        ])
    return "\n".join(parts)


func _set_player_list_overlay_visible(visible: bool) -> void:
    if player_list_overlay == null or player_list_overlay_label == null:
        return
    if visible and not _has_live_peer():
        return
    player_list_overlay.visible = visible
    if visible:
        _refresh_player_list_overlay()


func _refresh_player_list_overlay() -> void:
    if player_list_overlay == null or player_list_overlay_label == null:
        return
    var entries: Array = _get_session_player_entries()
    var lines: PackedStringArray = PackedStringArray()
    lines.append("Players")
    for entry in entries:
        if not (entry is Dictionary):
            continue
        lines.append(_format_session_player_label(entry))
    if entries.is_empty():
        lines.append("No players")
    player_list_overlay_label.text = "\n".join(lines)
    player_list_overlay.custom_minimum_size = Vector2(180.0, 18.0 + float(lines.size()) * 10.0)


func _get_selected_pause_menu_peer_id() -> int:
    if pause_menu_coop_player_list == null or pause_menu_coop_player_list.get_item_count() == 0:
        return -1
    var selected: PackedInt32Array = pause_menu_coop_player_list.get_selected_items()
    if selected.is_empty():
        return -1
    return int(pause_menu_coop_player_list.get_item_metadata(int(selected[0])))


func _refresh_pause_menu_player_actions() -> void:
    if pause_menu_coop_player_detail_label == null:
        return
    if not _has_live_peer():
        pause_menu_coop_player_detail_label.text = ""
        if pause_menu_coop_tp_button != null:
            pause_menu_coop_tp_button.disabled = true
        if pause_menu_coop_kick_button != null:
            pause_menu_coop_kick_button.disabled = true
            pause_menu_coop_kick_button.visible = false
        return

    var peer_id: int = _get_selected_pause_menu_peer_id()
    if peer_id <= 0:
        pause_menu_coop_player_detail_label.text = "Select a player to manage them."
        if pause_menu_coop_tp_button != null:
            pause_menu_coop_tp_button.disabled = true
        if pause_menu_coop_kick_button != null:
            pause_menu_coop_kick_button.disabled = true
            pause_menu_coop_kick_button.visible = multiplayer.is_server() and active_session_transport == SESSION_TRANSPORT_STEAM
        return

    var is_local: bool = peer_id == multiplayer.get_unique_id()
    var state: Dictionary = _capture_local_state() if is_local else peer_states.get(peer_id, {})
    pause_menu_coop_player_detail_label.text = "\n".join(_build_player_detail_lines(peer_id, state))

    if pause_menu_coop_tp_button != null:
        pause_menu_coop_tp_button.disabled = is_local or not _can_sample_player() or state.is_empty() or not bool(state.get("active", false))

    if pause_menu_coop_kick_button != null:
        pause_menu_coop_kick_button.visible = multiplayer.is_server() and active_session_transport == SESSION_TRANSPORT_STEAM
        pause_menu_coop_kick_button.disabled = not pause_menu_coop_kick_button.visible or is_local or state.is_empty()


func _build_player_detail_lines(peer_id: int, state: Dictionary) -> PackedStringArray:
    var is_local: bool = peer_id == multiplayer.get_unique_id()
    var same_dimension: bool = str(state.get("dimension_instance_key", "")) == get_active_dimension_instance_key()
    var detail_lines: PackedStringArray = PackedStringArray([
        _get_peer_display_name(peer_id, state),
        "Peer %s  |  %s" % [peer_id, "Same area" if same_dimension else "Different area"],
    ])
    if is_local:
        detail_lines.append("This is you.")
    elif peer_id == 1:
        detail_lines.append("Host player.")
    elif not bool(state.get("active", false)):
        detail_lines.append("Connecting to world...")
    if bool(state.get("downed", false)):
        detail_lines.append("Status: Downed")
    return detail_lines


func _refresh_pause_menu_player_list(force: bool = false) -> void:
    if pause_menu_coop_players_section == null or pause_menu_coop_player_list == null:
        return

    var session_active: bool = _has_live_peer()
    pause_menu_coop_players_section.visible = session_active
    if not session_active:
        pause_menu_coop_player_list.clear()
        pause_menu_coop_player_signature = ""
        _refresh_pause_menu_player_actions()
        return

    var entries: Array = _get_session_player_entries()
    var signature: String = _get_session_player_signature(entries)
    if force or signature != pause_menu_coop_player_signature:
        var previous_peer_id: int = _get_selected_pause_menu_peer_id()
        pause_menu_coop_player_list.clear()
        for entry in entries:
            var label: String = _format_session_player_label(entry)
            pause_menu_coop_player_list.add_item(label)
            var item_index: int = pause_menu_coop_player_list.get_item_count() - 1
            pause_menu_coop_player_list.set_item_metadata(item_index, int(entry.get("peer_id", -1)))

        if pause_menu_coop_player_list.get_item_count() > 0:
            var selected_index: int = -1
            for item_index in range(pause_menu_coop_player_list.get_item_count()):
                if int(pause_menu_coop_player_list.get_item_metadata(item_index)) == previous_peer_id:
                    selected_index = item_index
                    break
            if selected_index == -1:
                for item_index in range(pause_menu_coop_player_list.get_item_count()):
                    var peer_id: int = int(pause_menu_coop_player_list.get_item_metadata(item_index))
                    if peer_id != multiplayer.get_unique_id():
                        selected_index = item_index
                        break
            if selected_index == -1:
                selected_index = 0
            pause_menu_coop_player_list.select(selected_index)

        pause_menu_coop_player_signature = signature

    _refresh_pause_menu_player_actions()


func _get_selected_main_menu_peer_id() -> int:
    if main_menu_player_list == null or main_menu_player_list.get_item_count() == 0:
        return -1
    var selected: PackedInt32Array = main_menu_player_list.get_selected_items()
    if selected.is_empty():
        return -1
    return int(main_menu_player_list.get_item_metadata(int(selected[0])))


func _refresh_main_menu_player_actions() -> void:
    if main_menu_player_detail_label == null:
        return
    if not _has_live_peer():
        main_menu_player_detail_label.text = "No active multiplayer session."
        return

    var peer_id: int = _get_selected_main_menu_peer_id()
    if peer_id <= 0:
        main_menu_player_detail_label.text = "Select a player to inspect them."
        return

    var state: Dictionary = _capture_local_state() if peer_id == multiplayer.get_unique_id() else peer_states.get(peer_id, {})
    main_menu_player_detail_label.text = "\n".join(_build_player_detail_lines(peer_id, state))


func _refresh_main_menu_player_list(force: bool = false) -> void:
    if main_menu_player_list == null:
        return
    if not _has_live_peer():
        main_menu_player_list.clear()
        main_menu_player_signature = ""
        _refresh_main_menu_player_actions()
        return

    var entries: Array = _get_session_player_entries()
    var signature: String = _get_session_player_signature(entries)
    if force or signature != main_menu_player_signature:
        var previous_peer_id: int = _get_selected_main_menu_peer_id()
        main_menu_player_list.clear()
        for entry in entries:
            main_menu_player_list.add_item(_format_session_player_label(entry))
            var item_index: int = main_menu_player_list.get_item_count() - 1
            main_menu_player_list.set_item_metadata(item_index, int(entry.get("peer_id", -1)))

        if main_menu_player_list.get_item_count() > 0:
            var selected_index: int = 0
            for item_index in range(main_menu_player_list.get_item_count()):
                if int(main_menu_player_list.get_item_metadata(item_index)) == previous_peer_id:
                    selected_index = item_index
                    break
            main_menu_player_list.select(selected_index)

        main_menu_player_signature = signature

    _refresh_main_menu_player_actions()


func _on_main_menu_player_selected(_index: int) -> void:
    _refresh_main_menu_player_actions()


func _on_main_menu_player_activated(_index: int) -> void:
    var peer_id: int = _get_selected_main_menu_peer_id()
    if peer_id > 0:
        _teleport_to_peer(peer_id)


func _on_pause_menu_player_selected(_index: int) -> void:
    _refresh_pause_menu_player_actions()


func _on_pause_menu_player_activated(_index: int) -> void:
    _teleport_to_selected_pause_menu_peer()


func _teleport_to_peer(peer_id: int) -> void:
    if not _can_sample_player():
        return
    if peer_id == multiplayer.get_unique_id():
        status_message = "You are already on your own position"
        _update_status_text()
        return

    var target_state: Dictionary = peer_states.get(peer_id, {})
    if target_state.is_empty() or not bool(target_state.get("active", false)):
        status_message = "That player is not ready yet"
        _update_status_text()
        return

    if str(target_state.get("dimension_instance_key", "")) != get_active_dimension_instance_key():
        var target_key: String = str(target_state.get("dimension_instance_key", ""))
        if _open_dimension_instance_from_key(target_key):
            status_message = "Teleporting to %s's area" % _get_peer_display_name(peer_id, target_state)
            _update_status_text()
            return

    _teleport_local_player_near(target_state.get("position", Ref.player.global_position))
    status_message = "Teleported to %s" % _get_peer_display_name(peer_id, target_state)
    _update_status_text()


func _teleport_to_selected_pause_menu_peer() -> void:
    var peer_id: int = _get_selected_pause_menu_peer_id()
    if peer_id <= 0:
        return
    _teleport_to_peer(peer_id)


func _kick_selected_pause_menu_peer() -> void:
    var peer_id: int = _get_selected_pause_menu_peer_id()
    if peer_id <= 0:
        return
    _kick_connected_peer.call_deferred(peer_id)


func _kick_connected_peer(peer_id: int) -> void:
    if not multiplayer.is_server() or not _has_live_peer() or peer_id == multiplayer.get_unique_id():
        return

    var reason: String = "Removed by host"
    var peer_name: String = _get_peer_display_name(peer_id)
    host_session_ending.rpc_id(peer_id, false, reason)
    await get_tree().create_timer(0.15, true).timeout
    if multiplayer.multiplayer_peer != null and multiplayer.multiplayer_peer.has_method("disconnect_peer"):
        multiplayer.multiplayer_peer.call("disconnect_peer", peer_id)

    status_message = "Removed %s" % peer_name
    _update_status_text()


func _open_steam_friends_overlay() -> void:
    var steam_api: Object = _get_steam_api()
    if steam_api == null:
        status_message = "Steam overlay unavailable"
        _update_status_text()
        return
    if steam_api.has_method("activateGameOverlay"):
        steam_api.call("activateGameOverlay", "Friends")
        status_message = "Opened Steam friends overlay"
    elif steam_api.has_method("activate_game_overlay"):
        steam_api.call("activate_game_overlay", "Friends")
        status_message = "Opened Steam friends overlay"
    else:
        status_message = "Steam overlay unavailable"
    _update_status_text()


func _set_main_menu_coop_tab(tab_name: String) -> void:
    if tab_name == "players" or tab_name == "steam":
        tab_name = "servers"
    main_menu_selected_tab = tab_name
    if main_menu_servers_page != null:
        main_menu_servers_page.visible = tab_name == "servers"
    if main_menu_players_page != null:
        main_menu_players_page.visible = tab_name == "players"
    if main_menu_steam_page != null:
        main_menu_steam_page.visible = tab_name == "steam"
    if main_menu_direct_page != null:
        main_menu_direct_page.visible = tab_name == "direct"

    var tabs: Dictionary = {
        "servers": main_menu_server_tab_button,
        "players": main_menu_players_tab_button,
        "steam": main_menu_steam_tab_button,
        "direct": main_menu_direct_tab_button,
    }
    for key in tabs.keys():
        var tab_button: Button = tabs[key]
        if tab_button == null:
            continue
        tab_button.button_pressed = key == tab_name

    if tab_name == "servers" and not main_menu_server_card_buttons.is_empty() and main_menu_server_card_buttons[0].is_inside_tree():
        main_menu_server_card_buttons[0].grab_focus()
    elif tab_name == "players":
        _refresh_main_menu_player_list(true)
        if main_menu_player_list != null and main_menu_player_list.is_inside_tree():
            main_menu_player_list.grab_focus()
    elif tab_name == "steam" and main_menu_coop_steam_lobby_input != null and main_menu_coop_steam_lobby_input.is_inside_tree():
        main_menu_coop_steam_lobby_input.grab_focus()
    elif tab_name == "direct" and main_menu_coop_address_input != null and main_menu_coop_address_input.is_inside_tree():
        main_menu_coop_address_input.grab_focus()


func _build_main_menu_tab_button(sample_button: Button, text: String, tab_name: String) -> Button:
	var button := Button.new()
	_copy_pause_menu_button_style(sample_button, button)
	button.text = text
	button.toggle_mode = true
    button.custom_minimum_size = Vector2(140.0, max(24.0, minf(sample_button.custom_minimum_size.y, 30.0)))
    _apply_qualia_tab_button_style(button)
	button.pressed.connect(_set_main_menu_coop_tab.bind(tab_name))
	return button


func _get_menu_button_text(button: Button) -> String:
	if button == null:
		return ""
	return str(button.text).strip_edges().to_upper()


func _is_visible_menu_control(node: Node) -> bool:
	if not (node is Control):
		return false
	var control := node as Control
	return control.is_inside_tree() and control.is_visible_in_tree()


func _find_visible_menu_button(root: Node, labels: PackedStringArray) -> Button:
	if root == null:
		return null
	for node in root.find_children("*", "Button", true, false):
		if not (node is Button) or not _is_visible_menu_control(node):
			continue
		var button := node as Button
		if labels.has(_get_menu_button_text(button)):
			return button
	return null


func _has_visible_menu_button(root: Node, labels: PackedStringArray) -> bool:
	return _find_visible_menu_button(root, labels) != null


func _find_main_menu_button_group(qualia_button: Button) -> Control:
	if qualia_button == null:
		return null
	var current: Node = qualia_button.get_parent()
	var steps: int = 0
	while current != null and steps < 10:
		if current is Control and _is_visible_menu_control(current):
			var has_config: bool = _has_visible_menu_button(current, PackedStringArray(["CONFIG"]))
			var has_awaken: bool = _has_visible_menu_button(current, PackedStringArray(["AWAKEN"]))
			if has_config or has_awaken:
				return current as Control
		current = current.get_parent()
		steps += 1
	return qualia_button.get_parent() as Control


func _find_main_menu_from_visible_buttons(root: Node) -> Control:
	if root == null:
		return null
	var qualia_button: Button = _find_visible_menu_button(root, PackedStringArray(["QUALIA", "PLAY"]))
	if qualia_button == null:
		return null
	var group: Control = _find_main_menu_button_group(qualia_button)
	if group == null:
		return qualia_button.get_parent() as Control
	return group


func _find_main_menu_qualia_button(main_menu: Control) -> Button:
	if main_menu == null:
		return null
	var play_button: Button = main_menu.find_child("PlayButton", true, false) as Button
	if play_button != null and _is_visible_menu_control(play_button):
		return play_button
	for node in main_menu.find_children("*", "Button", true, false):
		if not (node is Button):
			continue
		var button := node as Button
		if not _is_visible_menu_control(button):
			continue
		var button_text: String = _get_menu_button_text(button)
		if button_text == "QUALIA" or button_text == "PLAY":
			return button
	return null


func _find_main_menu_insert_index(button_parent: Node, qualia_button: Button, moving_button: Button = null) -> int:
    if button_parent == null or qualia_button == null:
        return -1
    var qualia_index: int = qualia_button.get_index()
    var target_index: int = -1
    for child_index in range(button_parent.get_child_count()):
        var child := button_parent.get_child(child_index)
        if child is Button and str((child as Button).text).strip_edges().to_upper() == "AWAKEN":
            target_index = child_index
            break
    if target_index < 0:
        for child_index in range(button_parent.get_child_count()):
            var child := button_parent.get_child(child_index)
            if child is Button and str((child as Button).text).strip_edges().to_upper() == "CONFIG":
                target_index = child_index + 1
                break
    if target_index < 0:
        target_index = qualia_index + 1

    if moving_button != null and moving_button.get_parent() == button_parent:
        var moving_index: int = moving_button.get_index()
        if moving_index >= 0 and moving_index < target_index:
            target_index -= 1
    return target_index


func _build_main_menu_coop_panel(sample_button: Button) -> Control:
    var panel_root := Control.new()
    panel_root.visible = false
    panel_root.mouse_filter = Control.MOUSE_FILTER_STOP
    panel_root.focus_mode = Control.FOCUS_ALL
    panel_root.z_index = 100
    panel_root.set_anchors_preset(Control.PRESET_FULL_RECT)

    var fade := ColorRect.new()
    fade.set_anchors_preset(Control.PRESET_FULL_RECT)
    fade.color = Color(0.0, 0.0, 0.0, 0.52)
    panel_root.add_child(fade)

    main_menu_coop_shell = PanelContainer.new()
    main_menu_coop_shell.clip_contents = true
    main_menu_coop_shell.theme = sample_button.theme
    main_menu_coop_shell.set_anchor(SIDE_LEFT, 0.5)
    main_menu_coop_shell.set_anchor(SIDE_TOP, 0.5)
    main_menu_coop_shell.set_anchor(SIDE_RIGHT, 0.5)
    main_menu_coop_shell.set_anchor(SIDE_BOTTOM, 0.5)
    main_menu_coop_shell.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    main_menu_coop_shell.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    main_menu_coop_shell.add_theme_stylebox_override("panel", _make_qualia_menu_panel_style())
    panel_root.add_child(main_menu_coop_shell)

    var scroll := ScrollContainer.new()
    scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    scroll.follow_focus = true
    main_menu_coop_shell.add_child(scroll)

    var margin := MarginContainer.new()
    margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
    margin.add_theme_constant_override("margin_left", 12)
    margin.add_theme_constant_override("margin_right", 12)
    margin.add_theme_constant_override("margin_top", 8)
    margin.add_theme_constant_override("margin_bottom", 10)
    scroll.add_child(margin)

    var column := VBoxContainer.new()
    column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    column.add_theme_constant_override("separation", 5)
    margin.add_child(column)

    var title_row := HBoxContainer.new()
    title_row.add_theme_constant_override("separation", 6)
    column.add_child(title_row)

    var top_back_button := Button.new()
    _copy_pause_menu_button_style(sample_button, top_back_button)
    top_back_button.text = "<"
    top_back_button.custom_minimum_size = Vector2(22.0, 22.0)
    top_back_button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
    _apply_qualia_tab_button_style(top_back_button)
    top_back_button.add_theme_font_size_override("font_size", 11)
    top_back_button.pressed.connect(_close_main_menu_coop_panel)
    title_row.add_child(top_back_button)

    var title := Label.new()
    title.text = "CHOOSE AN AVAILABLE QUALIA"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
    title.add_theme_font_size_override("font_size", 8)
    title.add_theme_color_override("font_color", Color(0.96, 0.96, 0.98))
    title.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
    title.add_theme_constant_override("shadow_outline_size", 3)
    title_row.add_child(title)

    var title_spacer := Control.new()
    title_spacer.custom_minimum_size = Vector2(22.0, 22.0)
    title_row.add_child(title_spacer)

    var subtitle := Label.new()
    subtitle.text = "PUBLIC WORLDS CONNECT IMMEDIATELY"
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
    subtitle.add_theme_font_size_override("font_size", 6)
    subtitle.add_theme_color_override("font_color", Color(0.62, 0.62, 0.66))
    column.add_child(subtitle)

    var tab_row := HBoxContainer.new()
    tab_row.add_theme_constant_override("separation", 5)
    tab_row.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(tab_row)

    main_menu_server_tab_button = _build_main_menu_tab_button(sample_button, "SERVERS", "servers")
    tab_row.add_child(main_menu_server_tab_button)
    main_menu_players_tab_button = _build_main_menu_tab_button(sample_button, "PLAYERS", "players")
    main_menu_steam_tab_button = _build_main_menu_tab_button(sample_button, "STEAM", "steam")
    main_menu_direct_tab_button = _build_main_menu_tab_button(sample_button, "DIRECT", "direct")
    tab_row.add_child(main_menu_direct_tab_button)

    main_menu_servers_page = VBoxContainer.new()
    main_menu_servers_page.add_theme_constant_override("separation", 5)
    main_menu_servers_page.size_flags_vertical = Control.SIZE_EXPAND_FILL
    column.add_child(main_menu_servers_page)

    var server_heading := Label.new()
    server_heading.text = "AVAILABLE QUALIA"
    server_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
    server_heading.add_theme_font_size_override("font_size", 8)
    server_heading.add_theme_color_override("font_color", Color(0.96, 0.96, 0.98))
    server_heading.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.7))
    server_heading.add_theme_constant_override("shadow_outline_size", 2)
    main_menu_servers_page.add_child(server_heading)

    main_menu_server_cards_scroll = ScrollContainer.new()
    main_menu_server_cards_scroll.custom_minimum_size = Vector2(0.0, 108.0)
    main_menu_server_cards_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    main_menu_server_cards_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    main_menu_server_cards_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
    main_menu_server_cards_scroll.follow_focus = true
    main_menu_servers_page.add_child(main_menu_server_cards_scroll)

    main_menu_server_cards_container = VBoxContainer.new()
    main_menu_server_cards_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    main_menu_server_cards_container.add_theme_constant_override("separation", 3)
    main_menu_server_cards_scroll.add_child(main_menu_server_cards_container)

    main_menu_server_detail_label = Label.new()
    main_menu_server_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    main_menu_server_detail_label.custom_minimum_size = Vector2(0.0, 12.0)
    main_menu_server_detail_label.add_theme_font_size_override("font_size", 6)
    main_menu_server_detail_label.add_theme_color_override("font_color", Color(0.62, 0.62, 0.66))
    main_menu_servers_page.add_child(main_menu_server_detail_label)

    var server_buttons := HBoxContainer.new()
    server_buttons.add_theme_constant_override("separation", 5)
    main_menu_servers_page.add_child(server_buttons)

    main_menu_server_refresh_button = Button.new()
    _copy_pause_menu_button_style(sample_button, main_menu_server_refresh_button)
    main_menu_server_refresh_button.text = "Refresh"
    _apply_qualia_tab_button_style(main_menu_server_refresh_button)
    main_menu_server_refresh_button.pressed.connect(_request_server_browser_manual_refresh)
    main_menu_server_refresh_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    server_buttons.add_child(main_menu_server_refresh_button)

    main_menu_server_add_button = Button.new()
    _copy_pause_menu_button_style(sample_button, main_menu_server_add_button)
    main_menu_server_add_button.text = "Add Server"
    _apply_qualia_tab_button_style(main_menu_server_add_button)
    main_menu_server_add_button.pressed.connect(_open_main_menu_add_server)
    main_menu_server_add_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    server_buttons.add_child(main_menu_server_add_button)

    main_menu_players_page = VBoxContainer.new()
    main_menu_players_page.add_theme_constant_override("separation", 8)
    column.add_child(main_menu_players_page)

    var players_heading := Label.new()
    players_heading.text = "CONNECTED PLAYERS"
    players_heading.add_theme_font_size_override("font_size", 11)
    main_menu_players_page.add_child(players_heading)

    main_menu_player_list = ItemList.new()
    main_menu_player_list.custom_minimum_size = Vector2(0.0, 132.0)
    main_menu_player_list.allow_reselect = true
    main_menu_player_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
    main_menu_player_list.add_theme_font_size_override("font_size", 10)
    main_menu_player_list.item_selected.connect(_on_main_menu_player_selected)
    main_menu_player_list.item_activated.connect(_on_main_menu_player_activated)
    main_menu_players_page.add_child(main_menu_player_list)

    main_menu_player_detail_label = Label.new()
    main_menu_player_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    main_menu_player_detail_label.custom_minimum_size = Vector2(0.0, 44.0)
    main_menu_player_detail_label.add_theme_font_size_override("font_size", 10)
    main_menu_players_page.add_child(main_menu_player_detail_label)

    main_menu_steam_page = VBoxContainer.new()
    main_menu_steam_page.add_theme_constant_override("separation", 8)
    column.add_child(main_menu_steam_page)

    var steam_hint := Label.new()
    steam_hint.text = "Accept a Steam invite, or enter a lobby ID manually."
    steam_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    steam_hint.add_theme_font_size_override("font_size", 10)
    main_menu_steam_page.add_child(steam_hint)

    main_menu_coop_steam_lobby_input = LineEdit.new()
    main_menu_coop_steam_lobby_input.placeholder_text = "Steam lobby ID"
    main_menu_coop_steam_lobby_input.custom_minimum_size = Vector2(0.0, max(24.0, sample_button.custom_minimum_size.y))
    main_menu_coop_steam_lobby_input.text_submitted.connect(_on_main_menu_steam_lobby_submitted)
    main_menu_steam_page.add_child(main_menu_coop_steam_lobby_input)

    var steam_buttons := HBoxContainer.new()
    steam_buttons.add_theme_constant_override("separation", 8)
    main_menu_steam_page.add_child(steam_buttons)

    var join_steam_button := Button.new()
    _copy_pause_menu_button_style(sample_button, join_steam_button)
    join_steam_button.text = "Join Steam"
    join_steam_button.pressed.connect(_join_main_menu_steam_lobby)
    steam_buttons.add_child(join_steam_button)

    var open_steam_button := Button.new()
    _copy_pause_menu_button_style(sample_button, open_steam_button)
    open_steam_button.text = "Open Steam"
    open_steam_button.pressed.connect(_open_steam_friends_overlay)
    steam_buttons.add_child(open_steam_button)

    main_menu_direct_page = VBoxContainer.new()
    main_menu_direct_page.add_theme_constant_override("separation", 8)
    column.add_child(main_menu_direct_page)

    var local_hint := Label.new()
    local_hint.text = "Add or join any server by address: LAN, VPS, or domain."
    local_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    local_hint.add_theme_font_size_override("font_size", 10)
    main_menu_direct_page.add_child(local_hint)

    main_menu_coop_server_name_input = LineEdit.new()
    main_menu_coop_server_name_input.placeholder_text = "Server name (optional)"
    main_menu_coop_server_name_input.custom_minimum_size = Vector2(0.0, max(24.0, sample_button.custom_minimum_size.y))
    main_menu_direct_page.add_child(main_menu_coop_server_name_input)

    var local_join_row := HBoxContainer.new()
    local_join_row.add_theme_constant_override("separation", 8)
    main_menu_direct_page.add_child(local_join_row)

    main_menu_coop_address_input = LineEdit.new()
    main_menu_coop_address_input.placeholder_text = "127.0.0.1"
    main_menu_coop_address_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    main_menu_coop_address_input.custom_minimum_size = Vector2(0.0, max(24.0, sample_button.custom_minimum_size.y))
    main_menu_coop_address_input.text_submitted.connect(_on_join_text_submitted)
    local_join_row.add_child(main_menu_coop_address_input)

    main_menu_coop_port_input = SpinBox.new()
    main_menu_coop_port_input.min_value = 1
    main_menu_coop_port_input.max_value = 65535
    main_menu_coop_port_input.step = 1
    main_menu_coop_port_input.rounded = true
    main_menu_coop_port_input.custom_minimum_size = Vector2(88.0, max(24.0, sample_button.custom_minimum_size.y))
    local_join_row.add_child(main_menu_coop_port_input)

    var direct_buttons := HBoxContainer.new()
    direct_buttons.add_theme_constant_override("separation", 8)
    main_menu_direct_page.add_child(direct_buttons)

    var save_server_button := Button.new()
    _copy_pause_menu_button_style(sample_button, save_server_button)
    save_server_button.text = "Save Server"
    save_server_button.pressed.connect(_save_main_menu_direct_server)
    direct_buttons.add_child(save_server_button)

    var local_join_button := Button.new()
    _copy_pause_menu_button_style(sample_button, local_join_button)
    local_join_button.text = "Join Direct"
    local_join_button.pressed.connect(_join_main_menu_local_session)
    direct_buttons.add_child(local_join_button)

    main_menu_coop_status_label = Label.new()
    main_menu_coop_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    main_menu_coop_status_label.custom_minimum_size = Vector2(0.0, 48.0)
    main_menu_coop_status_label.add_theme_font_size_override("font_size", 10)
    column.add_child(main_menu_coop_status_label)

    _refresh_server_browser_entries()
    _set_main_menu_coop_tab(main_menu_selected_tab)

    return panel_root


func _ensure_main_menu_coop_ui() -> void:
    var main_menu: Control = _get_main_menu_node()
    if main_menu == null or not main_menu.is_inside_tree():
        _clear_main_menu_coop_ui()
        return

    if main_menu_owner != null and main_menu_owner != main_menu:
        _clear_main_menu_coop_ui()

    var play_button: Button = _find_main_menu_qualia_button(main_menu)
    if play_button == null:
        return

    main_menu_owner = main_menu

    if not is_instance_valid(main_menu_coop_button) or not main_menu_coop_button.is_inside_tree():
        var button_parent: Node = play_button.get_parent()
        if button_parent == null:
            return
        main_menu_coop_button = Button.new()
        main_menu_coop_button.name = "CoopMainMenuButton"
        _copy_pause_menu_button_style(play_button, main_menu_coop_button)
        main_menu_coop_button.text = "CO-OP"
        main_menu_coop_button.pressed.connect(_open_main_menu_coop_panel)
        button_parent.add_child(main_menu_coop_button)
        var insert_index: int = _find_main_menu_insert_index(button_parent, play_button, main_menu_coop_button)
        if insert_index >= 0:
            button_parent.move_child(main_menu_coop_button, clampi(insert_index, 0, button_parent.get_child_count() - 1))
    elif main_menu_coop_button.get_parent() == play_button.get_parent():
        var existing_parent: Node = main_menu_coop_button.get_parent()
        var existing_insert_index: int = _find_main_menu_insert_index(existing_parent, play_button, main_menu_coop_button)
        if existing_insert_index >= 0 and main_menu_coop_button.get_index() != existing_insert_index:
            existing_parent.move_child(main_menu_coop_button, clampi(existing_insert_index, 0, existing_parent.get_child_count() - 1))

    if not is_instance_valid(main_menu_coop_panel):
        main_menu_coop_panel = _build_main_menu_coop_panel(play_button)
        var panel_parent: Node = _get_overlay_parent(main_menu)
        if panel_parent == null:
            return
        panel_parent.add_child(main_menu_coop_panel)

    _sync_inputs_from_config()
    _refresh_main_menu_coop_status()
    _refresh_server_browser_entries()
    _refresh_overlay_layout()


func _is_main_menu_coop_panel_open() -> bool:
    return is_instance_valid(main_menu_coop_panel) and main_menu_coop_panel.visible


func _open_main_menu_coop_panel() -> void:
    _ensure_main_menu_coop_ui()
    if not is_instance_valid(main_menu_coop_panel):
        return
    _sync_inputs_from_config()
    _refresh_main_menu_coop_status()
    _refresh_server_browser_entries()
    main_menu_coop_panel.visible = true
    main_menu_coop_panel.move_to_front()
    _request_server_browser_refresh()
    _refresh_overlay_layout()
    _set_main_menu_coop_tab("servers")


func _close_main_menu_coop_panel(apply_ui_config: bool = true) -> void:
    if apply_ui_config:
        _apply_ui_to_config()
    if is_instance_valid(main_menu_coop_panel):
        main_menu_coop_panel.visible = false
    get_viewport().gui_release_focus()


func _refresh_main_menu_coop_status() -> void:
    if main_menu_coop_status_label == null:
        return
    main_menu_coop_status_label.text = status_message


func _ensure_server_browser_entries() -> void:
    if server_browser_entries.is_empty():
        _merge_server_browser_registry(DEFAULT_PUBLIC_SERVERS)
    _load_local_server_browser_registry()
    _load_cached_server_browser_registry()
    _request_remote_server_browser_registry()


func _make_server_browser_entry_key(entry: Dictionary) -> String:
    var endpoint_key: String = str(entry.get("endpoint_key", entry.get("hidden_endpoint_key", ""))).strip_edges()
    if endpoint_key != "":
        return "key:" + endpoint_key
    var address: String = str(entry.get("address", "")).strip_edges()
    var status_port: int = int(entry.get("status_port", int(entry.get("port", DEFAULT_PORT)) + DEFAULT_STATUS_PORT_OFFSET))
    if address != "":
        return "udp:%s:%s" % [address, status_port]
    return "name:" + str(entry.get("name", entry.get("world_title", "Server"))).strip_edges().to_lower()


func _normalize_server_browser_entry(raw_entry: Dictionary) -> Dictionary:
    var address: String = str(raw_entry.get("address", raw_entry.get("host", ""))).strip_edges()
    if address == "":
        return {}

    var port: int = int(raw_entry.get("port", DEFAULT_PORT))
    var status_port: int = int(raw_entry.get("status_port", port + DEFAULT_STATUS_PORT_OFFSET))
    var name: String = str(raw_entry.get("name", raw_entry.get("world_title", "Server"))).strip_edges()
    if name == "":
        name = "Server"

    var entry: Dictionary = raw_entry.duplicate(true)
    entry["name"] = name
    entry["world_title"] = str(entry.get("world_title", name))
    entry["address"] = address
    entry["port"] = clampi(port, 1, 65535)
    entry["status_port"] = clampi(status_port, 1, 65535)
    entry["region"] = str(entry.get("region", "public")).strip_edges()
    entry["status"] = str(entry.get("status", "unknown"))
    entry["players"] = int(entry.get("players", 0))
    entry["max_players"] = int(entry.get("max_players", MAX_CLIENTS))
    entry["message"] = str(entry.get("message", ""))
    entry["allow_status_endpoint_update"] = bool(entry.get(
        "allow_status_endpoint_update",
        raw_entry.has("endpoint_key") or raw_entry.has("status_port") or raw_entry.has("game_port")
    ))
    var file_color_1: Variant = entry.get("file_color_1", Color.from_hsv(0.58, 0.32, 0.95))
    var file_color_2: Variant = entry.get("file_color_2", Color.from_hsv(0.09, 0.62, 0.8))
    entry["file_color_1"] = file_color_1 if file_color_1 is Color else Color.from_hsv(0.58, 0.32, 0.95)
    entry["file_color_2"] = file_color_2 if file_color_2 is Color else Color.from_hsv(0.09, 0.62, 0.8)
    return entry


func _merge_server_browser_registry(raw_servers: Variant) -> bool:
    if not (raw_servers is Array):
        return false

    var changed: bool = false
    for raw_entry in raw_servers:
        if not (raw_entry is Dictionary):
            continue
        var entry: Dictionary = _normalize_server_browser_entry(raw_entry)
        if entry.is_empty():
            continue
        var entry_key: String = _make_server_browser_entry_key(entry)
        var existing_index: int = -1
        for index in range(server_browser_entries.size()):
            if _make_server_browser_entry_key(server_browser_entries[index]) == entry_key:
                existing_index = index
                break
        if existing_index >= 0:
            var merged_entry: Dictionary = server_browser_entries[existing_index]
            merged_entry.merge(entry, true)
            server_browser_entries[existing_index] = merged_entry
        else:
            server_browser_entries.append(entry)
        changed = true
    return changed


func _merge_server_browser_registry_data(data: Variant) -> bool:
    if data is Dictionary:
        return _merge_server_browser_registry(data.get("servers", []))
    if data is Array:
        return _merge_server_browser_registry(data)
    return false


func _load_local_server_browser_registry() -> void:
    if server_browser_local_registry_loaded:
        return
    server_browser_local_registry_loaded = true
    if not FileAccess.file_exists(SERVER_REGISTRY_PATH):
        return

    var file: FileAccess = FileAccess.open(SERVER_REGISTRY_PATH, FileAccess.READ)
    if file == null:
        return
    var data: Variant = JSON.parse_string(file.get_as_text())
    if _merge_server_browser_registry_data(data):
        print("[lucid-blocks-coop] loaded local server registry")


func _read_local_server_browser_registry_entries() -> Array:
    if not FileAccess.file_exists(SERVER_REGISTRY_PATH):
        return []

    var file: FileAccess = FileAccess.open(SERVER_REGISTRY_PATH, FileAccess.READ)
    if file == null:
        return []

    var data: Variant = JSON.parse_string(file.get_as_text())
    if data is Dictionary:
        var servers: Variant = data.get("servers", [])
        return servers.duplicate(true) if servers is Array else []
    if data is Array:
        return data.duplicate(true)
    return []


func _write_local_server_browser_registry_entries(entries: Array) -> bool:
    var file: FileAccess = FileAccess.open(SERVER_REGISTRY_PATH, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string(JSON.stringify({"servers": entries}, "\t"))
    return true


func _save_main_menu_direct_server() -> void:
    _apply_ui_to_config()

    var address: String = str(config.get("address", "127.0.0.1")).strip_edges()
    if address == "":
        address = "127.0.0.1"
    var port: int = clampi(int(config.get("port", DEFAULT_PORT)), 1, 65535)
    var server_name: String = ""
    if main_menu_coop_server_name_input != null:
        server_name = main_menu_coop_server_name_input.text.strip_edges()
    if server_name == "":
        server_name = "Private Server"

    var entry: Dictionary = {
        "name": server_name,
        "world_title": server_name,
        "address": address,
        "port": port,
        "status_port": clampi(port + DEFAULT_STATUS_PORT_OFFSET, 1, 65535),
        "region": "custom",
    }

    var entries: Array = _read_local_server_browser_registry_entries()
    var entry_key: String = _make_server_browser_entry_key(_normalize_server_browser_entry(entry))
    var replaced: bool = false
    for index in range(entries.size()):
        if not (entries[index] is Dictionary):
            continue
        var existing: Dictionary = _normalize_server_browser_entry(entries[index])
        if existing.is_empty():
            continue
        if _make_server_browser_entry_key(existing) == entry_key:
            entries[index] = entry
            replaced = true
            break
    if not replaced:
        entries.append(entry)

    if not _write_local_server_browser_registry_entries(entries):
        status_message = "Could not save server"
        _update_status_text()
        _refresh_main_menu_coop_status()
        return

    _merge_server_browser_registry([entry])
    _refresh_server_browser_entries()
    status_message = "Saved server %s" % server_name
    _update_status_text()
    _refresh_main_menu_coop_status()


func _load_cached_server_browser_registry() -> void:
    if server_browser_registry_cache_loaded:
        return
    server_browser_registry_cache_loaded = true
    if not FileAccess.file_exists(SERVER_REGISTRY_CACHE_PATH):
        return

    var file: FileAccess = FileAccess.open(SERVER_REGISTRY_CACHE_PATH, FileAccess.READ)
    if file == null:
        return
    var payload: Variant = JSON.parse_string(file.get_as_text())
    if not (payload is Dictionary):
        return

    var ttl_sec: int = int(config.get("server_registry_cache_ttl_sec", SERVER_REGISTRY_CACHE_TTL_SEC))
    var fetched_unix: int = int(payload.get("fetched_unix", 0))
    if ttl_sec > 0 and fetched_unix > 0 and Time.get_unix_time_from_system() - fetched_unix > ttl_sec:
        return

    if _merge_server_browser_registry_data(payload.get("data", {})):
        print("[lucid-blocks-coop] loaded cached server registry")


func _write_cached_server_browser_registry(data: Variant) -> void:
    var payload: Dictionary = {
        "fetched_unix": Time.get_unix_time_from_system(),
        "data": data,
    }
    var file: FileAccess = FileAccess.open(SERVER_REGISTRY_CACHE_PATH, FileAccess.WRITE)
    if file != null:
        file.store_string(JSON.stringify(payload, "\t"))


func _request_remote_server_browser_registry(force: bool = false) -> void:
    if force:
        server_browser_remote_registry_requested = false
    if server_browser_remote_registry_requested or server_browser_registry_request != null:
        return
    var registry_url: String = str(config.get("server_registry_url", "")).strip_edges()
    if registry_url == "":
        return
    if not (registry_url.begins_with("https://") or registry_url.begins_with("http://")):
        push_warning("[lucid-blocks-coop] Ignoring invalid server_registry_url")
        server_browser_remote_registry_requested = true
        return

    server_browser_remote_registry_requested = true
    server_browser_registry_request = HTTPRequest.new()
    server_browser_registry_request.timeout = 6.0
    server_browser_registry_request.request_completed.connect(_on_server_browser_registry_completed)
    add_child(server_browser_registry_request)
    var err: Error = server_browser_registry_request.request(registry_url)
    if err != OK:
        push_warning("[lucid-blocks-coop] Server registry request failed to start: %s" % err)
        server_browser_registry_request.queue_free()
        server_browser_registry_request = null


func _on_server_browser_registry_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
    if server_browser_registry_request != null:
        server_browser_registry_request.queue_free()
        server_browser_registry_request = null
    if response_code < 200 or response_code >= 300:
        push_warning("[lucid-blocks-coop] Server registry returned HTTP %s" % response_code)
        return

    var data: Variant = JSON.parse_string(body.get_string_from_utf8())
    if _merge_server_browser_registry_data(data):
        _write_cached_server_browser_registry(data)
        _refresh_server_browser_entries()
        _request_server_browser_refresh()


func _refresh_server_browser_entries() -> void:
    if main_menu_server_cards_container == null:
        return
    _ensure_server_browser_entries()

    for child in main_menu_server_cards_container.get_children():
        child.queue_free()
    main_menu_server_card_buttons.clear()

    for index in range(server_browser_entries.size()):
        var entry: Dictionary = server_browser_entries[index]
        var card := _build_main_menu_server_card(index, entry)
        main_menu_server_cards_container.add_child(card)
        main_menu_server_card_buttons.append(card)
    _refresh_main_menu_server_detail()


func _build_main_menu_server_card(index: int, entry: Dictionary) -> Control:
    var vanilla_card: Control = _try_build_vanilla_main_menu_server_card(index, entry)
    if vanilla_card != null:
        return vanilla_card

    var button := Button.new()
    _setup_qualia_card_button(button, entry, SERVER_BROWSER_CARD_HEIGHT)
    button.set_meta("coop_server_browser_entry", entry.duplicate(true))
    button.pressed.connect(_join_main_menu_server_entry.bind(entry.duplicate(true)))
    _add_qualia_card_backdrop(button, entry, 0.64)
    _bind_qualia_card_hover(button)

    var margin := MarginContainer.new()
    margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
    margin.set_anchors_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 28)
    margin.add_theme_constant_override("margin_right", 22)
    margin.add_theme_constant_override("margin_top", 7)
    margin.add_theme_constant_override("margin_bottom", 7)
    button.add_child(margin)

    var row := HBoxContainer.new()
    row.mouse_filter = Control.MOUSE_FILTER_IGNORE
    row.add_theme_constant_override("separation", 12)
    row.size_flags_vertical = Control.SIZE_EXPAND_FILL
    margin.add_child(row)

    _add_qualia_card_emblem(row, entry, 38.0)
    _add_qualia_card_swatch(row, entry)

    var text_column := VBoxContainer.new()
    text_column.mouse_filter = Control.MOUSE_FILTER_IGNORE
    text_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    text_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
    text_column.custom_minimum_size = Vector2.ZERO
    text_column.add_theme_constant_override("separation", 0)
    row.add_child(text_column)

    var title := _make_qualia_card_label(
        str(entry.get("world_title", entry.get("name", "Server"))).to_upper(),
        12,
        Color(0.98, 0.96, 0.88),
        18.0
    )
    text_column.add_child(title)

    var region := _make_qualia_card_label(_format_server_browser_region_line(entry), 8, Color(0.76, 0.78, 0.82), 12.0)
    text_column.add_child(region)

    var meta := _make_qualia_card_label(_format_server_browser_meta_line(entry), 8, Color(0.68, 0.7, 0.74), 12.0)
    text_column.add_child(meta)

    return button


func _format_server_browser_card_parts(entry: Dictionary) -> PackedStringArray:
    var status: String = str(entry.get("status", "unknown"))
    var region: String = str(entry.get("region", "public")).strip_edges()
    var region_text: String = region if region != "" else "public"
    if status == "online":
        var tps_text: String = "?"
        if entry.has("tps"):
            tps_text = str(int(round(float(entry.get("tps", 0.0)))))
        return PackedStringArray([
            "online",
            "%s/%s players" % [int(entry.get("players", 0)), int(entry.get("max_players", MAX_CLIENTS))],
            "%s tps" % tps_text,
            region_text,
        ])
    if status == "checking":
        return PackedStringArray(["checking", region_text])
    if status == "relay":
        return PackedStringArray(["relay", "waiting"])
    if status == "offline":
        return PackedStringArray(["offline", region_text])
    return PackedStringArray(["idle", region_text])


func _format_server_browser_entry(entry: Dictionary) -> String:
    var status: String = str(entry.get("status", "unknown"))
    var region: String = str(entry.get("region", "public")).strip_edges()
    var region_text: String = region if region != "" else "public"
    if status == "online":
        return " ".join(_format_server_browser_card_parts(entry))
    if status == "checking":
        return "checking   %s" % region_text
    if status == "relay":
        return "relay online   waiting"
    if status == "offline":
        return "offline   %s" % region_text
    return "not checked   %s" % region_text


func _refresh_main_menu_server_detail() -> void:
    if main_menu_server_detail_label == null:
        return
    if server_browser_entries.is_empty():
        main_menu_server_detail_label.text = "No public QUALIA servers registered."
        return

    var online_count: int = 0
    var checking_count: int = 0
    for entry in server_browser_entries:
        var status: String = str(entry.get("status", "unknown"))
        if status == "online":
            online_count += 1
        elif status == "checking" or status == "unknown":
            checking_count += 1

    if online_count > 0:
        main_menu_server_detail_label.text = "Click a QUALIA card to enter that server world."
    elif checking_count > 0:
        main_menu_server_detail_label.text = "Checking public QUALIA servers..."
    else:
        main_menu_server_detail_label.text = "No public QUALIA servers are reachable right now."


func _request_server_browser_refresh() -> void:
    if not server_browser_remote_registry_requested:
        _request_remote_server_browser_registry()
    _ensure_server_browser_entries()
    if server_browser_entries.is_empty():
        return

    if server_browser_udp != null:
        server_browser_udp.close()
        server_browser_udp = null

    server_browser_udp = PacketPeerUDP.new()
    var err: Error = server_browser_udp.bind(0, "0.0.0.0")
    if err != OK:
        server_browser_udp = null
        for index in range(server_browser_entries.size()):
            server_browser_entries[index]["status"] = "offline"
            server_browser_entries[index]["message"] = "Could not open UDP browser socket"
        _refresh_server_browser_entries()
        return

    server_browser_pending.clear()
    server_browser_deadline_msec = Time.get_ticks_msec() + SERVER_BROWSER_TIMEOUT_MSEC
    for index in range(server_browser_entries.size()):
        var entry: Dictionary = server_browser_entries[index]
        var address: String = str(entry.get("address", "127.0.0.1"))
        var status_port: int = int(entry.get("status_port", int(entry.get("port", DEFAULT_PORT)) + DEFAULT_STATUS_PORT_OFFSET))
        entry["status"] = "checking"
        entry["message"] = "Checking server status..."
        server_browser_entries[index] = entry
        server_browser_pending["%s:%s" % [address, status_port]] = index
        server_browser_udp.set_dest_address(address, status_port)
        server_browser_udp.put_packet("status".to_utf8_buffer())

    _refresh_server_browser_entries()


func _request_server_browser_manual_refresh() -> void:
    _request_remote_server_browser_registry(true)
    _request_server_browser_refresh()


func _tick_server_browser_udp(_delta: float) -> void:
    if server_browser_udp == null:
        return

    while server_browser_udp.get_available_packet_count() > 0:
        var packet: PackedByteArray = server_browser_udp.get_packet()
        var source_ip: String = server_browser_udp.get_packet_ip()
        var source_port: int = server_browser_udp.get_packet_port()
        var data: Variant = JSON.parse_string(packet.get_string_from_utf8())
        if not (data is Dictionary):
            continue
        var index: int = _find_server_browser_entry_index(source_ip, source_port)
        if index < 0:
            continue
        _apply_server_browser_status(index, data)

    if server_browser_deadline_msec > 0 and Time.get_ticks_msec() >= server_browser_deadline_msec:
        for pending_key in server_browser_pending.keys():
            var index: int = int(server_browser_pending[pending_key])
            if index >= 0 and index < server_browser_entries.size():
                var entry: Dictionary = server_browser_entries[index]
                if str(entry.get("status", "")) == "checking":
                    entry["status"] = "offline"
                    entry["message"] = "No status response"
                    server_browser_entries[index] = entry
        server_browser_pending.clear()
        server_browser_deadline_msec = 0
        server_browser_udp.close()
        server_browser_udp = null
        _refresh_server_browser_entries()


func _find_server_browser_entry_index(source_ip: String, source_port: int) -> int:
    var direct_key: String = "%s:%s" % [source_ip, source_port]
    if server_browser_pending.has(direct_key):
        return int(server_browser_pending[direct_key])
    for index in range(server_browser_entries.size()):
        var entry: Dictionary = server_browser_entries[index]
        if source_ip == str(entry.get("address", "")) and source_port == int(entry.get("status_port", DEFAULT_PORT + DEFAULT_STATUS_PORT_OFFSET)):
            return index
    return -1


func _apply_server_browser_status(index: int, data: Dictionary) -> void:
    if index < 0 or index >= server_browser_entries.size():
        return
    var entry: Dictionary = server_browser_entries[index]
    var remote_status: String = str(data.get("status", "")).strip_edges().to_lower()
    var protocol_info: Dictionary = _get_coop_protocol_info_from_status(data)
    var has_protocol_info: bool = not protocol_info.is_empty()
    if has_protocol_info:
        entry["coop_protocol"] = str(protocol_info.get("protocol", ""))
        entry["coop_protocol_version"] = int(protocol_info.get("version", 0))
        entry["coop_protocol_min"] = int(protocol_info.get("min", 0))
        entry["coop_protocol_features"] = protocol_info.get("features", [])
        entry["coop_protocol_required_features"] = protocol_info.get("required_features", [])
    if bool(data.get("ok", false)) and has_protocol_info and not _is_coop_protocol_compatible(protocol_info):
        entry["status"] = "incompatible"
        entry["message"] = "Server protocol is incompatible"
    elif bool(data.get("ok", false)):
        entry["status"] = "online"
        entry["message"] = str(data.get("message", "Server online"))
    elif remote_status == "starting" or remote_status == "waiting_main" or remote_status == "waiting_world" or remote_status == "loading_world" or remote_status == "starting_host" or remote_status == "replaying_journal":
        entry["status"] = "checking"
        entry["message"] = str(data.get("message", "Server is starting"))
    elif data.has("backend_connected") and not bool(data.get("backend_connected", false)):
        entry["status"] = "relay"
        entry["message"] = str(data.get("message", "Relay online, host is not connected"))
    else:
        entry["status"] = "offline"
        entry["message"] = str(data.get("message", "Server unavailable"))
    entry["players"] = int(data.get("players", entry.get("players", 0)))
    entry["max_players"] = int(data.get("max_players", entry.get("max_players", MAX_CLIENTS)))
    entry["world_title"] = str(data.get("world_title", entry.get("world_title", entry.get("name", "Server"))))
    if data.has("tps"):
        entry["tps"] = float(data.get("tps", entry.get("tps", 0.0)))
    if data.has("tps_health"):
        entry["tps_health"] = str(data.get("tps_health", entry.get("tps_health", "")))
    var allow_endpoint_update: bool = bool(entry.get("allow_status_endpoint_update", false))
    if allow_endpoint_update and int(data.get("game_port", 0)) > 0:
        entry["port"] = int(data.get("game_port", entry.get("port", DEFAULT_PORT)))
    if allow_endpoint_update and int(data.get("status_port", 0)) > 0:
        entry["status_port"] = int(data.get("status_port", entry.get("status_port", DEFAULT_PORT + DEFAULT_STATUS_PORT_OFFSET)))
    server_browser_entries[index] = entry
    server_browser_pending.erase("%s:%s" % [str(entry.get("address", "")), int(entry.get("status_port", DEFAULT_PORT + DEFAULT_STATUS_PORT_OFFSET))])
    _refresh_server_browser_entries()


func _sync_main_menu_coop_panel_visibility() -> void:
    if main_menu_owner == null or not is_instance_valid(main_menu_owner):
        _ensure_main_menu_coop_ui()
    elif main_menu_owner.visible and (not is_instance_valid(main_menu_coop_button) or not main_menu_coop_button.is_inside_tree()):
        _ensure_main_menu_coop_ui()
    if not _is_main_menu_coop_panel_open():
        return
    if main_menu_owner == null or not is_instance_valid(main_menu_owner) or not main_menu_owner.visible:
        _close_main_menu_coop_panel()
        return
    if main_menu_selected_tab == "players":
        _refresh_main_menu_player_list()


func _join_main_menu_local_session() -> void:
    _apply_ui_to_config()
    _close_main_menu_coop_panel()
    join_session(false)


func _open_main_menu_add_server() -> void:
    _set_main_menu_coop_tab("direct")
    status_message = "Add a server address, then save or join"
    _update_status_text()
    _refresh_main_menu_coop_status()
    if main_menu_coop_server_name_input != null:
        main_menu_coop_server_name_input.grab_focus()


func _join_main_menu_server_index(index: int) -> void:
    if index < 0 or index >= server_browser_entries.size():
        status_message = "Server is not available"
        _update_status_text()
        _refresh_main_menu_coop_status()
        return

    _join_main_menu_server_entry(server_browser_entries[index])


func _join_main_menu_server_entry(entry: Dictionary) -> void:
    if entry.is_empty():
        status_message = "Server is not available"
        _update_status_text()
        _refresh_main_menu_coop_status()
        return
    if str(entry.get("status", "")).strip_edges().to_lower() == "incompatible":
        status_message = "Server protocol is incompatible"
        _update_status_text()
        _refresh_main_menu_coop_status()
        return

    var selected_address: String = str(entry.get("address", "127.0.0.1")).strip_edges()
    var selected_port: int = int(entry.get("port", DEFAULT_PORT))
    if selected_address == "":
        status_message = "Server address is missing"
        _update_status_text()
        _refresh_main_menu_coop_status()
        return
    selected_port = clampi(selected_port, 1, 65535)
    config["address"] = selected_address
    config["port"] = selected_port
    _save_config()
    _sync_inputs_from_config()
    status_message = "Joining %s" % str(entry.get("name", selected_address))
    print("[lucid-blocks-coop] selected browser server name=%s port=%s status_port=%s status=%s" % [
        str(entry.get("name", "Server")),
        selected_port,
        int(entry.get("status_port", DEFAULT_PORT + DEFAULT_STATUS_PORT_OFFSET)),
        str(entry.get("status", "unknown")),
    ])
    _close_main_menu_coop_panel(false)
    config["address"] = selected_address
    config["port"] = selected_port
    _save_config()
    join_session(false)


func _join_selected_main_menu_server() -> void:
    _join_main_menu_server_index(0)


func _on_main_menu_steam_lobby_submitted(_new_text: String) -> void:
    _join_main_menu_steam_lobby()


func _join_main_menu_steam_lobby() -> void:
    if main_menu_coop_steam_lobby_input == null:
        return
    var lobby_text: String = main_menu_coop_steam_lobby_input.text.strip_edges()
    if not lobby_text.is_valid_int():
        status_message = "Enter a valid Steam lobby ID"
        _update_status_text()
        return
    _close_main_menu_coop_panel()
    _join_steam_lobby_by_id(int(lobby_text), true)


func _install_game_menu_quit_hook() -> void:
    if not is_instance_valid(Ref.main):
        return
    var game_menu = Ref.main.get_node_or_null("%GameMenu")
    if game_menu == null or not game_menu.has_signal("quit_requested"):
        return

    var original_callable := Callable(Ref.main, "_on_game_menu_quit_requested")
    var coop_callable := Callable(self, "_on_game_menu_quit_requested_coop")
    if game_menu.quit_requested.is_connected(original_callable):
        game_menu.quit_requested.disconnect(original_callable)
    if not game_menu.quit_requested.is_connected(coop_callable):
        game_menu.quit_requested.connect(coop_callable)


func _restore_game_menu_quit_hook() -> void:
    if not is_instance_valid(Ref.main):
        return
    var game_menu = Ref.main.get_node_or_null("%GameMenu")
    if game_menu == null or not game_menu.has_signal("quit_requested"):
        return

    var original_callable := Callable(Ref.main, "_on_game_menu_quit_requested")
    var coop_callable := Callable(self, "_on_game_menu_quit_requested_coop")
    if game_menu.quit_requested.is_connected(coop_callable):
        game_menu.quit_requested.disconnect(coop_callable)
    if not game_menu.quit_requested.is_connected(original_callable):
        game_menu.quit_requested.connect(original_callable)


func _on_game_menu_quit_requested_coop() -> void:
    if client_menu_kick_pending:
        print("[lucid-blocks-coop] leave already pending; forcing main menu fallback")
        _force_client_main_menu_kick.call_deferred("leave retry")
        return
    if local_quit_in_progress:
        print("[lucid-blocks-coop] leave already in progress")
        return
    if not _has_live_peer():
        if is_instance_valid(Ref.main) and Ref.main.has_method("_on_game_menu_quit_requested"):
            await Ref.main._on_game_menu_quit_requested()
        return

    if multiplayer.is_server():
        await _host_save_and_quit_to_main_menu()
        return

    await _guest_save_and_quit_to_main_menu("Left host session")


func _host_save_and_quit_to_main_menu() -> void:
    if not is_instance_valid(Ref.main):
        return
    if local_quit_in_progress:
        return

    local_quit_in_progress = true
    _set_quit_overlay_visible(true, "Saving world and closing host session...")
    if is_local_player_fake_dead():
        _abort_host_respawn(false, false)
    clear_fake_death_override_after_shutdown = true

    if _has_live_peer() and multiplayer.is_server():
        await _shutdown_host_session(false, "Host saved and quit")

    local_quit_in_progress = false
    await Ref.main._on_game_menu_quit_requested()
    _finish_leave_to_main_menu_state()


func _flush_guest_persistent_state_before_disconnect() -> void:
    if multiplayer.is_server() or not _has_live_peer() or not guest_persistent_ready:
        return

    _send_persistent_state_to_host(true)
    _send_local_authoritative_entities_to_host(true)
    multiplayer.poll()
    await get_tree().process_frame
    multiplayer.poll()
    await get_tree().create_timer(0.15, true).timeout


func _tick_server_only_save_menu_filter(delta: float) -> void:
    if dedicated_server_enabled or Ref.save_file_manager == null:
        return
    if is_instance_valid(Ref.main) and bool(Ref.main.loaded):
        return

    server_only_save_menu_filter_timer += delta
    if server_only_save_menu_filter_timer < 0.25:
        return
    server_only_save_menu_filter_timer = 0.0
    _filter_server_only_save_file_menus()


func _filter_server_only_save_file_menus() -> void:
    var registers: Array = Ref.save_file_manager.get_save_file_registers()
    var has_server_only_world: bool = false
    for save_register in registers:
        if save_register != null and bool(save_register.get_data(SERVER_WORLD_ONLY_KEY, false)):
            has_server_only_world = true
            break
    if not has_server_only_world:
        return

    var root := get_tree().get_root()
    if root == null:
        return

    for node in root.find_children("*", "", true, false):
        if not _is_save_file_menu_node(node):
            continue
        _hide_server_only_save_file_panels(node, registers)


func _hide_local_server_only_save_registers() -> void:
    if dedicated_server_enabled or Ref.save_file_manager == null:
        return
    var changed_count: int = 0
    for save_register in Ref.save_file_manager.get_save_file_registers():
        if save_register == null or not bool(save_register.get_data(SERVER_WORLD_ONLY_KEY, false)):
            continue
        if bool(save_register.get_data("deleted", false)):
            continue
        save_register.set_data("deleted", true, true)
        _write_save_register_to_disk(save_register)
        changed_count += 1
    if changed_count > 0:
        print("[lucid-blocks-coop] hid %s server-only local save cache entries" % changed_count)
        _filter_server_only_save_file_menus()


func _write_save_register_to_disk(save_register: SaveFileRegister) -> void:
    if save_register == null or Ref.save_file_manager == null:
        return
    var uuid: String = str(save_register.get_data("uuid", "")).strip_edges()
    if uuid == "":
        return
    var save_dir: String = "user://qualia/%s" % uuid
    if Ref.save_file_manager.has_method("get_save_file_directory"):
        save_dir = str(Ref.save_file_manager.get_save_file_directory(uuid))
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(save_dir))
    var file := FileAccess.open(save_dir.path_join("register.txt"), FileAccess.WRITE)
    if file == null:
        push_warning("[lucid-blocks-coop] could not write server-only register cache: %s" % save_dir)
        return
    file.store_string(var_to_str(JSON.from_native(save_register.data)))
    file.close()


func _is_save_file_menu_node(node: Node) -> bool:
    if node == null:
        return false
    if node.get_node_or_null("%SaveFileVBoxContainer") != null:
        return true
    return node.find_child("SaveFileVBoxContainer", true, false) != null


func _hide_server_only_save_file_panels(save_file_menu: Node, registers: Array) -> void:
    var container := save_file_menu.get_node_or_null("%SaveFileVBoxContainer")
    if container == null:
        container = save_file_menu.find_child("SaveFileVBoxContainer", true, false)
    if container == null:
        return

    var server_only_registers: Array = []
    for save_register in registers:
        if save_register != null and bool(save_register.get_data(SERVER_WORLD_ONLY_KEY, false)):
            server_only_registers.append(save_register)
    if server_only_registers.is_empty():
        return

    var children: Array = container.get_children()
    for child in children:
        if not (child is Node):
            continue
        var panel_node: Node = child as Node
        for save_register in server_only_registers:
            if _does_save_panel_match_register(panel_node, save_register):
                _hide_server_only_save_file_panel(panel_node)
                break

    # Vanilla fallback: first child is "new qualia", then one panel per SaveFileRegister.
    if children.size() >= registers.size() + 1:
        for index in range(registers.size()):
            var save_register = registers[index]
            if save_register == null or not bool(save_register.get_data(SERVER_WORLD_ONLY_KEY, false)):
                continue
            var ordered_panel: Node = children[index + 1] as Node
            if ordered_panel != null:
                _hide_server_only_save_file_panel(ordered_panel)


func _hide_server_only_save_file_panel(panel_node: Node) -> void:
    if panel_node == null:
        return
    panel_node.set_meta("coop_hidden_server_only_save", true)
    if panel_node is CanvasItem:
        (panel_node as CanvasItem).visible = false
    if panel_node is Control:
        var control := panel_node as Control
        control.mouse_filter = Control.MOUSE_FILTER_IGNORE
        control.focus_mode = Control.FOCUS_NONE
        control.custom_minimum_size = Vector2.ZERO


func _does_save_panel_match_register(panel_node: Node, save_register: SaveFileRegister) -> bool:
    if panel_node == null or save_register == null:
        return false
    var target_uuid: String = str(save_register.get_data("uuid", "")).strip_edges()
    var target_title: String = str(save_register.get_data("title", "")).strip_edges()
    var panel_register: Variant = _get_save_register_from_node(panel_node)
    if panel_register is SaveFileRegister:
        var panel_uuid: String = str((panel_register as SaveFileRegister).get_data("uuid", "")).strip_edges()
        if panel_uuid != "" and panel_uuid == target_uuid:
            return true
    if target_uuid != "" and _node_tree_has_meta_value(panel_node, "uuid", target_uuid):
        return true
    if target_title != "" and _node_tree_text_contains(panel_node, target_title):
        return true
    return false


func _get_save_register_from_node(root: Node) -> Variant:
    if root == null:
        return null
    for property_name in ["save_file_register", "file_register", "save_register", "register"]:
        if _object_has_property(root, property_name):
            var value: Variant = root.get(property_name)
            if value is SaveFileRegister:
                return value
    for child in root.get_children():
        if child is Node:
            var value: Variant = _get_save_register_from_node(child as Node)
            if value is SaveFileRegister:
                return value
    return null


func _node_tree_has_meta_value(root: Node, meta_name: String, expected: String) -> bool:
    if root == null or expected == "":
        return false
    if root.has_meta(meta_name) and str(root.get_meta(meta_name, "")).strip_edges() == expected:
        return true
    for child in root.get_children():
        if child is Node and _node_tree_has_meta_value(child as Node, meta_name, expected):
            return true
    return false


func _node_tree_text_contains(root: Node, needle: String) -> bool:
    if root == null or needle == "":
        return false
    if _object_has_property(root, "text"):
        var text: String = str(root.get("text")).strip_edges()
        if text != "" and text.findn(needle) != -1:
            return true
    for child in root.get_children():
        if child is Node and _node_tree_text_contains(child as Node, needle):
            return true
    return false


func _guest_save_and_quit_to_main_menu(reason: String = "Left host session") -> void:
    if not is_instance_valid(Ref.main):
        return
    if multiplayer.is_server() and _has_live_peer():
        return
    if client_menu_kick_pending:
        return

    reconnect_pending = false
    reconnect_attempt_count = 0
    reconnect_retry_timer = 0.0
    reconnect_reason = ""
    reconnect_steam_lobby_id = 0
    reconnect_steam_host_id = 0
    host_rehost_pending = false
    _set_reconnect_overlay_visible(false)

    local_quit_in_progress = true
    print("[lucid-blocks-coop] guest leave started")
    _set_quit_overlay_visible(true, "Uploading player state and leaving server...")
    if _has_live_peer():
        await _flush_guest_persistent_state_before_disconnect()

    disconnect_session(false)

    status_message = reason
    _update_status_text()
    client_menu_kick_pending = true
    await _force_client_main_menu_kick("guest leave")


func _finish_leave_to_main_menu_state() -> void:
    if not dedicated_server_enabled and multiplayer.multiplayer_peer != null:
        disconnect_session(false)
    reconnect_pending = false
    reconnect_attempt_count = 0
    reconnect_retry_timer = 0.0
    reconnect_reason = ""
    reconnect_steam_lobby_id = 0
    reconnect_steam_host_id = 0
    host_rehost_pending = false
    client_restore_in_progress = false
    receiving_host_world = false
    client_menu_kick_pending = false
    client_menu_kick_sequence += 1
    local_quit_in_progress = false
    if get_tree().paused:
        get_tree().paused = false
    _set_reconnect_overlay_visible(false)
    _set_quit_overlay_visible(false)
    _update_status_text()


func _should_use_canonical_guest_block_patch(block_position: Vector3i) -> bool:
    if multiplayer.is_server() or not _has_live_peer() or _is_local_world_authority():
        return false

    var active_instance_key: String = get_active_dimension_instance_key()
    var host_state: Dictionary = peer_states.get(1, {})
    if not _is_peer_state_same_instance(host_state, active_instance_key):
        return false

    var host_position: Vector3 = host_state.get("position", Vector3.ZERO)
    var host_load_radius: float = maxf(get_same_instance_base_load_radius(float(HOST_SESSION_MAX_LOAD_RADIUS)), float(HOST_SESSION_MAX_LOAD_RADIUS))
    var safe_radius: float = maxf(16.0, host_load_radius)
    var target_position: Vector3 = Vector3(block_position) + Vector3(0.5, 0.5, 0.5)
    return host_position.distance_squared_to(target_position) > safe_radius * safe_radius


func _capture_guest_block_action_patch(block_position: Vector3i) -> Dictionary:
    if SERVER_AUTHORITATIVE_WORLD:
        return {}
    if _should_use_canonical_guest_block_patch(block_position):
        return _capture_local_chunk_patch_for_world_positions([block_position])
    return _capture_local_runtime_chunk_patch_for_world_positions([block_position])


func _input(event: InputEvent) -> void:
    if not (event is InputEventKey):
        return
    if event.echo:
        return

    var focus_owner: Control = get_viewport().gui_get_focus_owner()
    var typing_in_field: bool = focus_owner is LineEdit or focus_owner is TextEdit
    if typing_in_field and event.keycode != KEY_ESCAPE:
        return

    if Ref.command_chat_manager != null and Ref.command_chat_manager.has_method("is_command_chat_open") and Ref.command_chat_manager.is_command_chat_open():
        return

    if event.keycode == KEY_TAB:
        _set_player_list_overlay_visible(event.pressed)
        get_viewport().set_input_as_handled()
        return

    if not event.pressed:
        return

    if _is_pause_menu_coop_panel_open():
        match event.keycode:
            KEY_ESCAPE:
                _close_pause_menu_coop_panel()
                get_viewport().set_input_as_handled()
        return

    if _is_main_menu_coop_panel_open():
        match event.keycode:
            KEY_ESCAPE:
                _close_main_menu_coop_panel()
                get_viewport().set_input_as_handled()
        return

    if char_select_overlay != null and char_select_overlay.visible:
        match event.keycode:
            KEY_ESCAPE:
                toggle_char_select(false)
                get_viewport().set_input_as_handled()
        return

    if spawn_browser_overlay != null and spawn_browser_overlay.visible:
        match event.keycode:
            KEY_ESCAPE, KEY_F10:
                toggle_spawn_browser(false)
                get_viewport().set_input_as_handled()
        return

    match event.keycode:
        KEY_ESCAPE:
            if panel_visible:
                toggle_panel(false)
        KEY_F10:
            toggle_spawn_browser()
        KEY_F6:
            host_session()
        KEY_F7:
            if event.shift_pressed:
                _load_config(true)
            else:
                join_session()
        KEY_F8:
            leave_session()
        KEY_F9:
            teleport_to_connected_player()


func _rebuild_tracked_root_runtime_lists() -> void:
    tracked_root_entities.clear()
    tracked_root_drops.clear()
    for child in get_tree().get_root().get_children():
        _register_root_runtime_node(child)


func _register_root_runtime_node(node: Node) -> void:
    if node is Entity and not (node is Player) and not is_remote_player_proxy(node):
        if not tracked_root_entities.has(node):
            tracked_root_entities.append(node)
    elif node is DroppedItem:
        if not tracked_root_drops.has(node):
            tracked_root_drops.append(node)


func _unregister_root_runtime_node(node: Node) -> void:
    tracked_root_entities.erase(node)
    tracked_root_drops.erase(node)


func _on_root_child_entered(node: Node) -> void:
    _register_root_runtime_node(node)
    if node is Control:
        call_deferred("_ensure_pause_menu_coop_ui")
        call_deferred("_ensure_main_menu_coop_ui")


func _on_root_child_exiting(node: Node) -> void:
    _unregister_root_runtime_node(node)
    if node == pause_menu_owner:
        _clear_pause_menu_coop_ui()
    if node == main_menu_owner:
        _clear_main_menu_coop_ui()


func _get_live_tracked_entities() -> Array:
    var live: Array = []
    for node in tracked_root_entities:
        if is_instance_valid(node) and node.is_inside_tree() and not is_remote_player_proxy(node):
            live.append(node)
    tracked_root_entities = live
    return tracked_root_entities


func _get_sync_scene_path(node: Node) -> String:
    if not is_instance_valid(node):
        return ""
    var scene_path: String = str(node.scene_file_path)
    if scene_path != "":
        return scene_path
    return str(node.get_meta("coop_source_scene_path", ""))


func _safe_network_text(text: String, max_length: int = CLIENT_SAFE_MAX_TEXT_LENGTH) -> String:
    var sanitized: String = text.strip_edges()
    if sanitized.length() > max_length:
        sanitized = sanitized.substr(0, max_length)
    return sanitized


func _is_safe_uuid_text(value: String) -> bool:
    var text: String = value.strip_edges()
    return text != "" and text.length() <= CLIENT_SAFE_MAX_UUID_LENGTH and not text.contains("/") and not text.contains("\\") and not text.contains("://")


func _is_safe_float(value: float) -> bool:
    return value == value and absf(value) <= CLIENT_SAFE_MAX_ABS_COORD


func _is_safe_vector3(value: Vector3) -> bool:
    return _is_safe_float(value.x) and _is_safe_float(value.y) and _is_safe_float(value.z)


func _is_safe_vector3i(value: Vector3i) -> bool:
    return abs(value.x) <= int(CLIENT_SAFE_MAX_ABS_COORD) and abs(value.y) <= int(CLIENT_SAFE_MAX_ABS_COORD) and abs(value.z) <= int(CLIENT_SAFE_MAX_ABS_COORD)


func _clamp_safe_vector3(value: Vector3, max_length: float = CLIENT_SAFE_MAX_KNOCKBACK) -> Vector3:
    if not _is_safe_vector3(value):
        return Vector3.ZERO
    var length: float = value.length()
    if length > max_length and length > 0.001:
        return value.normalized() * max_length
    return value


func _is_safe_resource_path(resource_path: String, allowed_prefixes: PackedStringArray, scene_only: bool = true) -> bool:
    var path: String = resource_path.strip_edges()
    if path == "" or path.length() > 240:
        return false
    if not path.begins_with("res://") or path.contains("..") or path.contains("\\"):
        return false
    if scene_only and not (path.ends_with(".tscn") or path.ends_with(".scn")):
        return false

    var allowed: bool = false
    for prefix in allowed_prefixes:
        if path.begins_with(prefix):
            allowed = true
            break
    if not allowed:
        return false
    if path.begins_with("res://main/entity/player/"):
        return false
    return ResourceLoader.exists(path)


func _is_safe_entity_scene_path(scene_path: String) -> bool:
    return _is_safe_resource_path(scene_path, CLIENT_SAFE_ENTITY_SCENE_PREFIXES, true)


func _is_safe_living_block_scene_path_for_block(block_id: int, scene_path: String) -> bool:
    if scene_path.strip_edges() == "":
        return true
    var expected_path: String = _get_living_block_scene_path(block_id)
    return expected_path != "" and scene_path == expected_path


func _is_safe_item_data(item_data: PackedInt32Array) -> bool:
    if item_data.is_empty() or item_data.size() > CLIENT_SAFE_MAX_ITEM_DATA_INTS:
        return false
    var item_id: int = int(item_data[0])
    return item_id > 0 and ItemMap.map(item_id) != null


func _is_safe_block_id(block_id: int) -> bool:
    return block_id >= 0 and (block_id == 0 or ItemMap.map(block_id) != null)


func _sanitize_network_save_data(value: Variant, depth: int = 0) -> Variant:
    if depth > 16:
        return null
    if value is Dictionary:
        var sanitized: Dictionary = {}
        for key in (value as Dictionary).keys():
            var key_text: String = str(key)
            var child: Variant = (value as Dictionary)[key]
            if key_text == "file_path" or key_text.ends_with("/file_path"):
                var path: String = str(child)
                if _is_safe_resource_path(path, CLIENT_SAFE_SAVE_SCENE_PREFIXES, true):
                    sanitized[key] = path
                continue
            sanitized[key] = _sanitize_network_save_data(child, depth + 1)
        return sanitized
    if value is Array:
        var sanitized_array: Array = []
        var source_array: Array = value
        var limit: int = mini(source_array.size(), CLIENT_SAFE_MAX_WORLD_CHANGES)
        for index in range(limit):
            sanitized_array.append(_sanitize_network_save_data(source_array[index], depth + 1))
        return sanitized_array
    if value is String:
        return _safe_network_text(value, 4096)
    if value is Vector3:
        return value if _is_safe_vector3(value) else Vector3.ZERO
    if value is Vector3i:
        return value if _is_safe_vector3i(value) else Vector3i.ZERO
    return value


func _is_syncable_entity_node(node: Node) -> bool:
    return node is Entity and not (node is Player) and not is_remote_player_proxy(node)


func _get_live_tracked_drops() -> Array:
    var live: Array = []
    for node in tracked_root_drops:
        if is_instance_valid(node) and node.is_inside_tree():
            live.append(node)
    tracked_root_drops = live
    return tracked_root_drops


func _enforce_coop_pause_override() -> void:
    if not _has_live_peer() or get_tree() == null or not get_tree().paused:
        return
    if Ref.game_menu == null:
        return
    if int(Ref.game_menu.state) != 4:
        return
    get_tree().paused = false


func _refresh_world_runtime_mode() -> void:
    if is_instance_valid(Ref.world) and Ref.world.has_method("refresh_multiplayer_runtime_mode"):
        Ref.world.refresh_multiplayer_runtime_mode()


func _install_native_multi_region_hooks_after_world_ready() -> void:
    if is_instance_valid(Ref.world) and Ref.world.has_method("install_coop_multi_region_hooks_after_world_load"):
        Ref.world.call("install_coop_multi_region_hooks_after_world_load")


var _bg_tick_log_timer: float = 0.0

func _enforce_host_background_frame_rate() -> void:
    if dedicated_server_enabled:
        _apply_dedicated_performance_profile()
        _bg_tick_log_timer = 0.0
        return
    if not _should_force_host_background_runtime():
        _bg_tick_log_timer = 0.0
        return
    if Engine.max_fps != 0:
        Engine.max_fps = 0
    if Engine.physics_ticks_per_second < 60:
        Engine.physics_ticks_per_second = 60
    _bg_tick_log_timer = 0.0


func _tick_dedicated_tps_monitor(delta: float) -> void:
    if not dedicated_server_enabled:
        return

    dedicated_tps_sample_elapsed += delta
    dedicated_tps_sample_frames += 1
    dedicated_last_delta_ms = delta * 1000.0
    dedicated_tps_warn_timer += delta
    if dedicated_tps_sample_elapsed < DEDICATED_TPS_SAMPLE_INTERVAL:
        return

    if dedicated_tps_sample_elapsed > 0.0:
        dedicated_current_tps = float(dedicated_tps_sample_frames) / dedicated_tps_sample_elapsed
        dedicated_min_tps = minf(dedicated_min_tps, dedicated_current_tps)
    dedicated_tps_sample_elapsed = 0.0
    dedicated_tps_sample_frames = 0

    if dedicated_current_tps < DEDICATED_TPS_SOFT_FLOOR and dedicated_tps_warn_timer >= DEDICATED_TPS_WARN_INTERVAL:
        dedicated_tps_warn_timer = 0.0
        print("[lucid-blocks-coop] Dedicated TPS %0.1f/%d health=%s net_backoff=%0.1f" % [
            dedicated_current_tps,
            DEDICATED_TARGET_TPS,
            _get_dedicated_tps_health(),
            _get_dedicated_net_backoff_multiplier(),
        ])


func _tick_dedicated_health_log(delta: float) -> void:
    if not dedicated_server_enabled or not multiplayer.is_server():
        return
    dedicated_health_log_timer += delta
    if dedicated_health_log_timer < DEDICATED_HEALTH_LOG_INTERVAL:
        return
    dedicated_health_log_timer = 0.0

    var metrics: Dictionary = _get_server_runtime_metrics()
    print("[lucid-blocks-coop] Dedicated health tps=%0.1f health=%s players=%d entities=%d drops=%d dirty_chunks=%d journal=%d packet_backlog=%d regions=%d native_regions=%d tickets=%d mem=%0.1fMB peak=%0.1fMB pending_world=%d pending_remote=%d block_actions=%d/%d deferred=%d block_cache=%d last_block_ms=%d item_actions=%d/%d item_cache=%d last_item_ms=%d autosave=%s" % [
        dedicated_current_tps,
        _get_dedicated_tps_health(),
        int(metrics.get("players", 0)),
        int(metrics.get("entity_count", 0)),
        int(metrics.get("drop_count", 0)),
        int(metrics.get("dirty_chunk_count", 0)),
        int(metrics.get("chunk_journal_sequence", 0)),
        int(metrics.get("packet_backlog", 0)),
        int(metrics.get("loaded_region_count", 0)),
        int(metrics.get("native_active_region_centers", 0)),
        int(metrics.get("chunk_ticket_count", 0)),
        float(metrics.get("memory_static_mb", 0.0)),
        float(metrics.get("memory_static_peak_mb", 0.0)),
        int(metrics.get("pending_world_patches", 0)),
        int(metrics.get("pending_remote_changes", 0)),
        dedicated_block_action_count,
        dedicated_block_action_fail_count,
        dedicated_block_action_deferred_count,
        int(metrics.get("server_recent_block_action_results", 0)),
        dedicated_block_action_last_latency_ms,
        dedicated_item_action_count,
        dedicated_item_action_fail_count,
        int(metrics.get("server_recent_item_action_results", 0)),
        dedicated_item_action_last_latency_ms,
        str(metrics.get("autosave_in_progress", false)),
    ])


func _tick_dedicated_world_load_focus(delta: float) -> void:
    if not dedicated_server_enabled or not multiplayer.is_server():
        dedicated_load_focus_valid = false
        dedicated_load_focus_peer_id = 0
        dedicated_load_focus_timer = 0.0
        server_chunk_tickets.clear()
        server_chunk_ticket_cleanup_timer = 0.0
        return

    if not dedicated_load_focus_valid:
        return

    dedicated_load_focus_timer -= delta
    if dedicated_load_focus_timer <= 0.0:
        dedicated_load_focus_valid = false
        dedicated_load_focus_peer_id = 0
        dedicated_load_focus_timer = 0.0


func _tick_server_chunk_tickets(delta: float) -> void:
    if not dedicated_server_enabled or not multiplayer.is_server():
        server_chunk_tickets.clear()
        server_chunk_ticket_cleanup_timer = 0.0
        return

    server_chunk_ticket_cleanup_timer += delta
    if server_chunk_ticket_cleanup_timer < DEDICATED_CHUNK_TICKET_CLEANUP_INTERVAL_SEC:
        return

    server_chunk_ticket_cleanup_timer = 0.0
    _cleanup_server_chunk_tickets()


func _tick_server_action_result_cleanup(delta: float) -> void:
    if not multiplayer.is_server() or (not dedicated_server_enabled and not _has_live_peer()):
        server_action_result_cleanup_timer = 0.0
        return

    server_action_result_cleanup_timer += delta
    if server_action_result_cleanup_timer < SERVER_ACTION_RESULT_CLEANUP_INTERVAL_SEC:
        return

    server_action_result_cleanup_timer = 0.0
    _cleanup_server_block_action_results()
    _cleanup_server_item_action_results()
    _cleanup_host_recent_drop_visibility()


func _tick_server_dirty_chunk_flush(delta: float) -> void:
    if not dedicated_server_enabled or not multiplayer.is_server():
        server_dirty_chunk_flush_timer = 0.0
        return
    if server_dirty_chunk_keys.is_empty():
        server_dirty_chunk_flush_timer = 0.0
        return
    if autosave_in_progress or local_fake_death_pending or handling_host_respawn or host_respawning or not _can_share_loaded_world():
        return

    server_dirty_chunk_flush_timer += delta
    if server_dirty_chunk_flush_timer < SERVER_DIRTY_CHUNK_FLUSH_INTERVAL_SEC:
        return

    server_dirty_chunk_flush_timer = 0.0
    _run_host_dirty_chunk_flush.call_deferred()


func _has_coop_runtime_work() -> bool:
    return dedicated_server_enabled \
        or _has_live_peer() \
        or _has_pending_peer_connection() \
        or reconnect_pending \
        or receiving_host_world \
        or client_restore_in_progress \
        or host_rehost_pending


func _restore_session_load_radius_if_needed() -> void:
    if not session_load_radius_applied or not is_instance_valid(Ref.world):
        return
    if session_previous_instance_radius > 0 and int(Ref.world.instance_radius) != session_previous_instance_radius:
        Ref.world.instance_radius = session_previous_instance_radius
        Ref.world.buffer_instance_radius = session_previous_buffer_instance_radius if session_previous_buffer_instance_radius > 0 else Ref.world.buffer_instance_radius
        Ref.world.force_reload()
    elif session_previous_buffer_instance_radius > 0 and int(Ref.world.buffer_instance_radius) != session_previous_buffer_instance_radius:
        Ref.world.buffer_instance_radius = session_previous_buffer_instance_radius
    session_load_radius_applied = false
    session_previous_instance_radius = -1
    session_previous_buffer_instance_radius = -1


func _restore_singleplayer_runtime_overrides() -> void:
    if is_instance_valid(Ref.world):
        Ref.world.simulate_enabled = true
    last_local_world_authority = true
    last_local_entity_authority = true
    _clear_host_entity_activity_override()
    _restore_session_load_radius_if_needed()


func _tick_singleplayer_shell(delta: float) -> void:
    _tick_server_browser_udp(delta)
    _tick_server_only_save_menu_filter(delta)
    _sync_pause_menu_coop_panel_visibility()
    var world_loaded: bool = is_instance_valid(Ref.main) and bool(Ref.main.loaded)
    if not world_loaded or _is_main_menu_coop_panel_open():
        _sync_main_menu_coop_panel_visibility()
    if _is_pause_menu_coop_panel_open():
        _refresh_pause_menu_player_list()
    _clear_pending_local_world_patch_state()
    if not markers.is_empty() or not remote_player_proxies.is_empty():
        _hide_all_markers()
    if not remote_break_outlines.is_empty():
        _clear_remote_break_outlines()
    _restore_singleplayer_runtime_overrides()


func _physics_process(delta: float) -> void:
    if not _has_coop_runtime_work():
        _tick_singleplayer_shell(delta)
        return

    _tick_dedicated_tps_monitor(delta)
    _tick_dedicated_health_log(delta)
    _enforce_dedicated_player_safety()
    _tick_dedicated_world_load_focus(delta)
    _tick_server_chunk_tickets(delta)
    _tick_server_action_result_cleanup(delta)
    _tick_server_dirty_chunk_flush(delta)
    _tick_dedicated_status_udp()
    _tick_dedicated_registry_heartbeat(delta)
    _tick_server_browser_udp(delta)
    _tick_server_only_save_menu_filter(delta)
    _tick_client_connection_timeout()
    _tick_join_protocol_timeout()
    _enforce_coop_pause_override()
    _sync_pause_menu_coop_panel_visibility()
    _sync_main_menu_coop_panel_visibility()
    _tick_builder_admin_runtime(delta)
    _enforce_host_background_frame_rate()
    if _is_pause_menu_coop_panel_open():
        _refresh_pause_menu_player_list()
    if player_list_overlay != null and player_list_overlay.visible:
        _refresh_player_list_overlay()
    _refresh_world_authority_mode()
    _refresh_host_entity_activity_override(delta)
    _refresh_session_load_radius()
    _flush_pending_remote_world_changes()
    _tick_entity_interpolation(delta)
    _tick_client_synced_entity_visuals(delta)
    _tick_local_downed_state(delta)
    _tick_revive_interaction(delta)
    _enforce_shared_bubble_tether(delta)
    _cleanup_client_prediction_state()

    if reconnect_pending:
        _tick_reconnect(delta)

    if not _has_live_peer():
        _clear_pending_local_world_patch_state()
        _hide_all_markers()
        _clear_remote_break_outlines()
        return

    send_timer += delta
    world_state_timer += delta
    water_sync_timer += delta
    persist_timer += delta
    guest_entity_state_timer += delta
    autosave_timer += delta
    client_state_heartbeat_timer += delta
    if not multiplayer.is_server() and not pending_local_world_patch_chunks.is_empty():
        local_world_patch_timer += delta
        _flush_pending_local_world_patch_to_host()
    else:
        local_world_patch_timer = 0.0
    var effective_world_state_interval: float = _get_effective_world_state_interval()
    if multiplayer.is_server() and (effective_world_state_interval <= 0.0 or world_state_timer >= effective_world_state_interval):
        world_state_timer = 0.0
        host_world_state_sequence += 1
        var interest_peer_count: int = 0
        var interest_drop_count: int = 0
        var interest_entity_count: int = 0
        var active_instance_key: String = get_active_dimension_instance_key()
        for peer_id in peer_states.keys():
            var int_peer_id: int = int(peer_id)
            if int_peer_id == 1:
                continue
            var peer_state: Dictionary = peer_states[peer_id]
            if not bool(peer_state.get("active", false)):
                continue
            if not _is_peer_state_same_instance(peer_state, active_instance_key):
                continue
            var focus_position: Vector3 = peer_state.get("position", Ref.player.global_position)
            var drop_snapshots: Array = _capture_host_drop_snapshots(focus_position, int_peer_id)
            var entity_snapshots: Array = _capture_host_entity_snapshots(focus_position, int_peer_id)
            interest_peer_count += 1
            interest_drop_count += drop_snapshots.size()
            interest_entity_count += entity_snapshots.size()
            server_world_state.rpc_id(
                int_peer_id,
                host_world_state_sequence,
                drop_snapshots,
                entity_snapshots
            )
        host_interest_last_peer_count = interest_peer_count
        host_interest_last_drop_count = interest_drop_count
        host_interest_last_entity_count = interest_entity_count
    var effective_water_sync_interval: float = _get_effective_water_sync_interval()
    if multiplayer.is_server() and (effective_water_sync_interval <= 0.0 or water_sync_timer >= effective_water_sync_interval):
        water_sync_timer = 0.0
        for peer_id in peer_states.keys():
            var water_peer_id: int = int(peer_id)
            if water_peer_id == 1:
                continue
            var water_peer_state: Dictionary = peer_states[peer_id]
            if not bool(water_peer_state.get("active", false)):
                continue
            _sync_host_water_state_for_peer(water_peer_id, water_peer_state)
            _sync_host_fire_state_for_peer(water_peer_id, water_peer_state)
    elif not multiplayer.is_server() and client_world_sync_ready and guest_persistent_ready and persist_timer >= PERSIST_INTERVAL:
        persist_timer = 0.0
        _send_persistent_state_to_host()

    if not multiplayer.is_server() and client_world_sync_ready and guest_persistent_ready and _has_local_guest_entity_authority() and (GUEST_ENTITY_STATE_INTERVAL <= 0.0 or guest_entity_state_timer >= GUEST_ENTITY_STATE_INTERVAL):
        guest_entity_state_timer = 0.0
        _send_local_authoritative_entities_to_host()
    elif multiplayer.is_server() or not _has_local_guest_entity_authority():
        guest_entity_state_timer = 0.0

    if multiplayer.is_server():
        if _should_defer_host_periodic_autosave():
            if autosave_timer >= AUTOSAVE_INTERVAL:
                autosave_timer = 0.0
                deferred_host_autosave_pending = true
        elif _has_pending_host_periodic_autosave() and _can_run_host_periodic_autosave_now():
            autosave_timer = 0.0
            deferred_host_autosave_pending = false
            _autosave_host_world_if_needed()

    if _has_host_timed_out():
        print("[lucid-blocks-coop] host heartbeat timed out")
        if not local_quit_in_progress:
            _begin_reconnect_flow("Connection timed out")
        return

    var effective_send_interval: float = _get_effective_send_interval()
    if send_timer < effective_send_interval:
        return
    send_timer = 0.0

    var local_state: Dictionary = _capture_local_state_for_send()
    if multiplayer.is_server():
        peer_states[1] = local_state
        _refresh_markers(peer_states, multiplayer.get_unique_id())
        host_snapshot_sequence += 1
        server_snapshot.rpc(host_snapshot_sequence, _serialize_peer_states())
    else:
        var state_hash: int = _hash_client_state(local_state)
        if state_hash != last_sent_client_state_hash or client_state_heartbeat_timer >= 0.25:
            last_sent_client_state_hash = state_hash
            client_state_heartbeat_timer = 0.0
            submit_client_state.rpc_id(
                1,
                int(local_state.get("sequence", 0)),
                local_state.get("active", false),
                bool(local_state.get("downed", false)),
                local_state.get("dimension", -1),
                str(local_state.get("dimension_instance_key", "")),
                str(local_state.get("pocket_owner_key", "")),
                local_state.get("position", Vector3.ZERO),
                local_state.get("yaw", 0.0),
                local_state.get("pitch", 0.0),
                local_state.get("crouching", false),
                local_state.get("grounded", true),
                local_state.get("move_speed", 0.0),
                bool(local_state.get("under_water", false)),
                local_state.get("held_item_id", -1),
                local_state.get("action_state", 0),
                str(local_state.get("name", "guest")),
                str(local_state.get("player_key", "")),
                str(local_state.get("avatar_id", DEFAULT_AVATAR_ID)),
                local_state.get("skin_color", Color.WHITE),
                bool(local_state.get("breaking", false)),
                local_state.get("break_position", Vector3i.ZERO),
                int(local_state.get("break_block_id", 0)),
                float(local_state.get("break_progress", 0.0))
            )


func toggle_panel(force_visible: Variant = null) -> void:
    var next_visible: bool = not panel_visible if force_visible == null else bool(force_visible)
    if next_visible == panel_visible:
        return

    panel_visible = next_visible
    panel.visible = panel_visible

    if panel_visible:
        _close_pause_menu_if_open()
        restore_capture_on_close = MouseHandler.captured
        MouseHandler.release()
        _refresh_local_ip_label()
        _sync_inputs_from_config()
        _refresh_overlay_layout()
        address_input.grab_focus()
        address_input.caret_column = address_input.text.length()
    else:
        _apply_ui_to_config()
        get_viewport().gui_release_focus()
        if restore_capture_on_close:
            MouseHandler.capture()

    _update_status_text()


func _refresh_overlay_layout() -> void:
    if get_viewport() == null:
        return

    var viewport_size: Vector2 = get_viewport().get_visible_rect().size
    if panel != null and panel_column != null:
        var panel_min_size: Vector2 = panel_column.get_combined_minimum_size() + Vector2(16.0, 16.0)
        var panel_width: float = clampf(maxf(PANEL_WIDTH, panel_min_size.x), 160.0, maxf(160.0, viewport_size.x - 12.0))
        var panel_height: float = clampf(panel_min_size.y, 96.0, maxf(96.0, viewport_size.y - 24.0))
        panel.offset_left = -panel_width * 0.5
        panel.offset_right = panel_width * 0.5
        panel.offset_top = 12.0
        panel.offset_bottom = 12.0 + panel_height

    if spawn_browser_panel != null:
        var browser_width: float = clampf(420.0, 180.0, maxf(180.0, viewport_size.x - 16.0))
        var browser_height: float = clampf(420.0, 160.0, maxf(160.0, viewport_size.y - 16.0))
        spawn_browser_panel.custom_minimum_size = Vector2(browser_width, browser_height)

    if pause_menu_coop_shell != null:
        var pause_width_target: float = viewport_size.x * 0.44
        var pause_height_target: float = viewport_size.y * 0.72
        if is_instance_valid(pause_menu_container) and pause_menu_container.size.x > 0.0 and pause_menu_container.size.y > 0.0:
            pause_width_target = pause_menu_container.size.x
            pause_height_target = pause_menu_container.size.y
        pause_menu_coop_shell.custom_minimum_size = Vector2(
            clampf(minf(pause_width_target, 560.0), 220.0, maxf(220.0, viewport_size.x - 48.0)),
            clampf(minf(pause_height_target, 620.0), 220.0, maxf(220.0, viewport_size.y - 60.0))
        )

    if main_menu_coop_shell != null:
        var coop_width: float = clampf(340.0, 320.0, maxf(320.0, viewport_size.x - 96.0))
        var coop_height: float = clampf(300.0, 240.0, maxf(240.0, viewport_size.y - 96.0))
        main_menu_coop_shell.custom_minimum_size = Vector2(coop_width, coop_height)
        main_menu_coop_shell.offset_left = -coop_width * 0.5
        main_menu_coop_shell.offset_right = coop_width * 0.5
        main_menu_coop_shell.offset_top = -coop_height * 0.5
        main_menu_coop_shell.offset_bottom = coop_height * 0.5
        main_menu_coop_shell.size = Vector2(coop_width, coop_height)


func _start_lan_host(port: int, dedicated_skip_ui_config: bool = false) -> bool:
	var can_share_world: bool = _can_share_dedicated_loaded_world() if dedicated_skip_ui_config else _can_share_loaded_world()
	if not can_share_world:
		status_message = "Open LAN from inside a loaded world"
		if dedicated_skip_ui_config:
			push_warning("[lucid-blocks-coop] dedicated host blocked: main=%s main_loaded=%s world=%s world_load=%s register=%s file=%s" % [
				str(is_instance_valid(Ref.main)),
				str(is_instance_valid(Ref.main) and bool(Ref.main.loaded)),
				str(is_instance_valid(Ref.world)),
				str(is_instance_valid(Ref.world) and bool(Ref.world.load_enabled)),
				str(Ref.save_file_manager.loaded_file_register != null),
				str(Ref.save_file_manager.loaded_file != null),
			])
		_update_status_text()
		return false

	pending_steam_action = ""
	pending_steam_open_invite_dialog = false
	reconnect_steam_lobby_id = 0
	reconnect_steam_host_id = 0
	if dedicated_skip_ui_config:
		config["port"] = port
	else:
		_apply_ui_to_config()
	_prepare_session_start_state(true)
	disconnect_session(false)

	var host_port: int = port if dedicated_skip_ui_config else int(config.get("port", DEFAULT_PORT))
	config["port"] = host_port
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	print("[lucid-blocks-coop] creating ENet host on port %s dedicated=%s" % [host_port, str(dedicated_skip_ui_config)])
	var err: Error = peer.create_server(host_port, MAX_CLIENTS)
	if err != OK:
		status_message = "Host failed (%s)" % err
		push_warning("[lucid-blocks-coop] host failed: %s" % err)
		_update_status_text()
		return false

	multiplayer.multiplayer_peer = peer
	peer_states.clear()
	active_session_transport = SESSION_TRANSPORT_LAN
	_install_player_death_hook()
	_install_game_menu_quit_hook()
	status_message = "Hosting local session"
	print("[lucid-blocks-coop] Hosting on port %s peer_status=%s is_server=%s" % [
		host_port,
		peer.get_connection_status(),
		str(multiplayer.is_server()),
	])
	_update_status_text()
	_refresh_world_runtime_mode()
	_install_native_multi_region_hooks_after_world_ready.call_deferred()
	return _has_live_peer() and multiplayer.is_server()


func host_session() -> void:
	_start_lan_host(int(config.get("port", DEFAULT_PORT)), false)


func join_session(apply_ui_config: bool = true) -> void:
    pending_steam_action = ""
    pending_steam_open_invite_dialog = false
    reconnect_steam_lobby_id = 0
    reconnect_steam_host_id = 0
    if apply_ui_config:
        _apply_ui_to_config()
    _prepare_session_start_state(false)
    disconnect_session(false)

    var address: String = str(config.get("address", "127.0.0.1")).strip_edges()
    var port: int = int(config.get("port", DEFAULT_PORT))
    reconnect_pending = false
    reconnect_attempt_count = 0
    reconnect_retry_timer = 0.0
    _set_reconnect_overlay_visible(false)
    var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
    print("[lucid-blocks-coop] joining ENet server address=%s port=%s" % [address, port])
	var err: Error = peer.create_client(address, port)
	if err != OK:
		_display_connection_status("Join failed before connecting (%s)" % err, true)
		push_warning("[lucid-blocks-coop] join failed: %s" % err)
		return

	multiplayer.multiplayer_peer = peer
    client_connection_deadline_msec = Time.get_ticks_msec() + SERVER_CONNECT_TIMEOUT_MSEC
    peer_states.clear()
	active_session_transport = SESSION_TRANSPORT_LAN
	_install_player_death_hook()
	_install_game_menu_quit_hook()
	_display_connection_status("Connecting to selected qualia...", true)


func disconnect_session(announce: bool = true) -> void:
    _restore_original_death_handler()
    _set_single_player_shutdown_world_pause_override(false)
    _reset_join_protocol_state()
    _clear_pending_local_world_patch_state()
    pending_guest_world_patch_flush_acks.clear()
    var local_fake_death_active: bool = local_fake_death_pending or handling_host_respawn or handling_client_respawn or host_respawning
    var local_downed_active: bool = local_downed
    var local_double_downed_active: bool = double_downed_recovery_pending
    if _has_live_peer() and not multiplayer.is_server() and guest_persistent_ready:
        _send_persistent_state_to_host()
        _send_local_authoritative_entities_to_host(true)
    if local_fake_death_active and local_fake_death_save_override.is_empty():
        local_fake_death_save_override = _build_local_fake_death_save_overrides()
    if handling_host_respawn or host_respawning:
        host_respawn_sequence += 1
    local_fake_death_pending = false
    handling_host_respawn = false
    handling_client_respawn = false
    host_respawning = false
    remote_host_respawning = false
    receiving_host_world = false
    client_restore_in_progress = false
    incoming_snapshot_register_json = ""
    incoming_snapshot_chunk_count = 0
    incoming_snapshot_chunks.clear()
    incoming_snapshot_host_position = Vector3.ZERO
    incoming_snapshot_follow_host_position = false
    last_received_host_snapshot_sequence = -1
    _set_death_overlay_visible(false)
    if is_instance_valid(Ref.player):
        if local_fake_death_active:
            _stabilize_local_player_after_fake_death()
        else:
            Ref.player.disabled = false
            Ref.player.invincible = bool(Ref.main.creative) if is_instance_valid(Ref.main) else false
            Ref.player.invincible_temporary = false
    if multiplayer.multiplayer_peer != null:
        multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
    _clear_active_steam_session_state()
    _refresh_world_runtime_mode()

    peer_states.clear()
    _clear_markers()
    _clear_remote_break_outlines()
    send_timer = 0.0
    world_state_timer = 0.0
    persist_timer = 0.0
    guest_entity_state_timer = 0.0
    autosave_timer = 0.0
    deferred_host_autosave_pending = false
    water_sync_timer = 0.0
    client_state_heartbeat_timer = 0.0
    host_entity_activity_refresh_timer = 0.0
    _clear_host_entity_activity_override()
    _restore_session_load_radius_if_needed()
    _restore_game_menu_quit_hook()
    _clear_client_world_entities_and_drops()
    if not local_quit_in_progress:
        _set_quit_overlay_visible(false)
    host_entity_last_sent.clear()
    host_entity_snapshot_last_sent.clear()
    host_entity_snapshot_last_state.clear()
    host_drop_snapshot_last_sent.clear()
    host_drop_snapshot_last_state.clear()
    host_recent_drop_visibility.clear()
    client_world_sync_ready = false
    guest_persistent_ready = false
    last_local_world_authority = true
    last_local_entity_authority = true
    client_menu_kick_pending = false
    last_host_contact_time = 0
    last_sent_client_state_hash = 0
    reconnect_retry_timer = 0.0
    active_server_command_policy = _get_local_server_command_policy()
    pending_remote_block_changes.clear()
    pending_remote_water_changes.clear()
    pending_remote_fire_changes.clear()
    pending_remote_storage_changes.clear()
    client_pending_block_actions.clear()
    client_pending_item_actions.clear()
    host_water_snapshot_cache.clear()
    host_fire_snapshot_cache.clear()
    guest_authoritative_entity_registry.clear()
    applying_remote_storage_positions.clear()
    _clear_local_downed_state()

    if announce:
        status_message = "Disconnected"
        print("[lucid-blocks-coop] disconnected")
    else:
        status_message = "Idle"

    _update_status_text()

    if local_downed_active and not local_double_downed_active and not local_quit_in_progress and is_instance_valid(Ref.main):
        Ref.main.player_death.call_deferred()


func leave_session() -> void:
    if client_menu_kick_pending:
        print("[lucid-blocks-coop] leave already pending; forcing main menu fallback")
        _force_client_main_menu_kick.call_deferred("leave retry")
        return
    if local_quit_in_progress:
        print("[lucid-blocks-coop] leave already in progress")
        return
    var should_kick_to_menu: bool = reconnect_pending or client_restore_in_progress or (reconnect_overlay != null and reconnect_overlay.visible)
    reconnect_pending = false
    reconnect_attempt_count = 0
    reconnect_retry_timer = 0.0
    reconnect_reason = ""
    reconnect_steam_lobby_id = 0
    reconnect_steam_host_id = 0
    host_rehost_pending = false
    _set_reconnect_overlay_visible(false)
    _close_pause_menu_if_open()

    if not _has_live_peer():
        if should_kick_to_menu:
            await _guest_save_and_quit_to_main_menu("Left host session")
            return
        disconnect_session()
        return

    local_quit_in_progress = true
    if multiplayer.is_server():
        if is_local_player_fake_dead():
            _abort_host_respawn(false, false)
        clear_fake_death_override_after_shutdown = true
        _shutdown_host_session.call_deferred(false, "Host ended the session")
        return

    await _guest_save_and_quit_to_main_menu("Left host session")


func _has_live_peer() -> bool:
    return multiplayer.multiplayer_peer != null and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED


func has_active_session() -> bool:
    return dedicated_server_enabled or _has_live_peer()


func is_death_override_active() -> bool:
    return has_active_session()


func request_player_death_intercept(_player: Entity = null) -> bool:
    if not is_death_override_active():
        return false
    local_quit_in_progress = false
    local_fake_death_save_override.clear()
    local_fake_death_respawn_target_valid = false
    clear_fake_death_override_after_shutdown = false
    local_fake_death_pending = false
    handling_client_respawn = false
    handling_host_respawn = false
    host_respawning = false
    remote_host_respawning = false
    local_downed = true
    local_downed_position_valid = false
    local_downed_started_msec = Time.get_ticks_msec()
    revive_hold_progress = 0.0
    revive_target_peer_id = -1
    revive_request_pending = false
    return true


func is_local_player_downed() -> bool:
    return local_downed


func _clear_local_downed_state() -> void:
    local_downed = false
    local_downed_position = Vector3.ZERO
    local_downed_position_valid = false
    local_downed_started_msec = 0
    double_downed_recovery_pending = false
    downed_respawn_key_down = false
    _set_local_player_combat_targetable(true)


func _set_local_player_combat_targetable(enabled: bool) -> void:
    if not _can_sample_player():
        return

    if not Ref.player.has_meta("coop_original_collision_layer"):
        Ref.player.set_meta("coop_original_collision_layer", int(Ref.player.collision_layer))
    if not Ref.player.has_meta("coop_original_collision_mask"):
        Ref.player.set_meta("coop_original_collision_mask", int(Ref.player.collision_mask))

    Ref.player.collision_layer = int(Ref.player.get_meta("coop_original_collision_layer", 2)) if enabled else 0
    Ref.player.collision_mask = int(Ref.player.get_meta("coop_original_collision_mask", int(Ref.player.collision_mask)))

    var interact_area: Area3D = Ref.player.get_node_or_null("%InteractArea3D") as Area3D
    if interact_area != null:
        if not interact_area.has_meta("coop_original_collision_layer"):
            interact_area.set_meta("coop_original_collision_layer", int(interact_area.collision_layer))
        if not interact_area.has_meta("coop_original_collision_mask"):
            interact_area.set_meta("coop_original_collision_mask", int(interact_area.collision_mask))
        interact_area.collision_layer = int(interact_area.get_meta("coop_original_collision_layer", 4098)) if enabled else 0
        interact_area.collision_mask = int(interact_area.get_meta("coop_original_collision_mask", int(interact_area.collision_mask)))
    revive_hold_progress = 0.0
    revive_target_peer_id = -1
    revive_request_pending = false
    if revive_prompt_label != null:
        revive_prompt_label.visible = false


func _resolve_local_downed_position() -> Vector3:
    if not _can_sample_player():
        return Vector3.ZERO

    var current_position: Vector3 = Ref.player.global_position
    var fallback_position: Vector3 = _resolve_default_respawn_fallback_position(current_position)
    if _has_live_peer():
        var remote_anchor: Vector3 = _get_remote_respawn_anchor(multiplayer.is_server(), fallback_position)
        fallback_position = _find_safe_respawn_position_near(remote_anchor, fallback_position)

    if current_position.y <= DOWNED_VOID_Y:
        return fallback_position

    var centered_current: Vector3 = current_position.floor() + Vector3(0.5, 0.0, 0.5)
    if _is_safe_respawn_position(centered_current):
        return centered_current
    return _find_safe_respawn_position_near(centered_current, fallback_position)


func _has_same_instance_reviver_available(ignore_peer_id: int = -1) -> bool:
    if not _has_live_peer() or not _can_sample_player():
        return false

    var active_instance_key: String = get_active_dimension_instance_key()
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == ignore_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if bool(state.get("downed", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != active_instance_key:
            continue
        return true
    return false


func _has_same_instance_downed_partner(ignore_peer_id: int = -1) -> bool:
    if not _has_live_peer() or not _can_sample_player():
        return false

    var active_instance_key: String = get_active_dimension_instance_key()
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == ignore_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != active_instance_key:
            continue
        if bool(state.get("downed", false)):
            return true
    return false


func _all_same_instance_partners_downed(ignore_peer_id: int = -1) -> bool:
    if not _has_live_peer() or not _can_sample_player():
        return false

    var active_instance_key: String = get_active_dimension_instance_key()
    var found_partner: bool = false
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == ignore_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != active_instance_key:
            continue
        found_partner = true
        if not bool(state.get("downed", false)):
            return false
    return found_partner


func _enter_local_downed_state() -> void:
    if not _can_sample_player():
        return

    local_downed = true
    local_downed_position_valid = false
    local_downed_started_msec = Time.get_ticks_msec()
    double_downed_recovery_pending = false
    revive_hold_progress = 0.0
    revive_target_peer_id = -1
    revive_request_pending = false
    _stop_local_player_actions()
    Ref.player.dead = false
    Ref.player.health = maxi(1, Ref.player.health)
    Ref.player.invincible = true
    Ref.player.invincible_temporary = true
    Ref.player.disabled = true
    _set_local_player_combat_targetable(false)
    if "flying" in Ref.player:
        Ref.player.flying = false

    local_downed_position = _resolve_local_downed_position()
    local_downed_position_valid = true
    _teleport_local_player_exact(local_downed_position)

    if panel_visible:
        toggle_panel(false)

    _set_death_overlay_visible(true, "Hold on. Your partner can revive you.", "DOWNED")
    status_message = "Downed - waiting for revive"
    _update_status_text()
    _broadcast_local_state_now()
    _try_begin_double_downed_recovery()


func _can_offer_manual_partner_respawn() -> bool:
    return local_downed \
        and _has_live_peer() \
        and _can_sample_player() \
        and _has_same_instance_reviver_available(multiplayer.get_unique_id()) \
        and _has_remote_respawn_anchor(false)


func _refresh_local_downed_overlay() -> void:
    if death_overlay == null or not death_overlay.visible or not local_downed:
        return

    var subtitle: String = "Hold on. Your partner can revive you."
    if _can_offer_manual_partner_respawn():
        subtitle += " Press R to respawn near them."
    _set_death_overlay_visible(true, subtitle, "DOWNED")


func _respawn_local_downed_near_partner() -> void:
    if not _can_offer_manual_partner_respawn() or not _can_sample_player():
        return

    var fallback_position: Vector3 = _resolve_default_respawn_fallback_position(local_downed_position if local_downed_position_valid else Ref.player.global_position)
    var remote_anchor: Vector3 = _get_remote_respawn_anchor(false, fallback_position)
    var respawn_position: Vector3 = _find_safe_respawn_position_near(remote_anchor, fallback_position)
    _finish_local_revive(respawn_position, "Respawn")
    status_message = "Respawned near partner"
    _update_status_text()


func _finish_local_revive(revive_position: Vector3, source_label: String = "Partner") -> void:
    if not _can_sample_player():
        return

    _clear_local_downed_state()
    Ref.player.revive()
    Ref.player.health = maxi(1, int(ceil(float(Ref.player.max_health) * 0.5)))
    Ref.player.dead = false
    Ref.player.disabled = false
    _set_local_player_combat_targetable(true)
    Ref.player.invincible = bool(Ref.main.creative)
    Ref.player.invincible_temporary = false
    Ref.player.make_invincible_temporary()
    _teleport_local_player_exact(revive_position)
    Ref.player.consume_actions()
    _set_death_overlay_visible(false)
    status_message = "%s revived you" % source_label
    _update_status_text()
    _broadcast_local_state_now()


func _commit_local_real_death(reason: String = "") -> void:
    _clear_local_downed_state()
    local_fake_death_pending = false
    handling_client_respawn = false
    handling_host_respawn = false
    host_respawning = false
    remote_host_respawning = false
    local_quit_in_progress = false
    if is_instance_valid(Ref.player):
        Ref.player.invincible = false
        Ref.player.invincible_temporary = false
        Ref.player.disabled = false
        Ref.player.dead = false
        _set_local_player_combat_targetable(true)
    if panel_visible:
        toggle_panel(false)
    _set_death_overlay_visible(false)
    if reason != "":
        status_message = reason
        _update_status_text()
    if is_instance_valid(Ref.main):
        Ref.main.player_death.call_deferred()


func _begin_double_downed_recovery() -> void:
    if double_downed_recovery_pending or not local_downed or not _can_sample_player() or not multiplayer.is_server():
        return

    double_downed_recovery_pending = true
    status_message = "Both downed - regrouping"
    _update_status_text()
    _broadcast_local_state_now()

    var host_respawn_position: Vector3 = _resolve_double_downed_host_respawn_position()
    if host_respawn_position == Vector3.ZERO and not _can_sample_player():
        double_downed_recovery_pending = false
        return

    _finish_local_revive(host_respawn_position, "Recovery")

    var guest_respawn_position: Vector3 = _find_safe_respawn_position_near(host_respawn_position, host_respawn_position)
    var active_instance_key: String = get_active_dimension_instance_key()
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != active_instance_key:
            continue
        if not bool(state.get("downed", false)):
            continue
        force_peer_revive.rpc_id(int_peer_id, guest_respawn_position, "Recovery")

    double_downed_recovery_pending = false
    status_message = "Both downed - regrouped"
    _update_status_text()
    _broadcast_local_state_now()


func _tick_local_downed_state(_delta: float) -> void:
    if not local_downed or not _can_sample_player():
        return

    if local_downed_position_valid:
        Ref.player.global_position = local_downed_position
    _reset_local_player_motion()
    Ref.player.dead = false
    Ref.player.disabled = true
    _set_local_player_combat_targetable(false)
    _refresh_local_downed_overlay()

    var respawn_key_pressed: bool = Input.is_physical_key_pressed(KEY_R)
    if _can_offer_manual_partner_respawn() and respawn_key_pressed and not downed_respawn_key_down:
        downed_respawn_key_down = true
        _respawn_local_downed_near_partner()
        return
    if not respawn_key_pressed:
        downed_respawn_key_down = false

    var grace_active: bool = local_downed_started_msec > 0 and (Time.get_ticks_msec() - local_downed_started_msec) < int(DOWNED_REVIVER_GRACE_SEC * 1000.0)
    if _has_live_peer() and not grace_active and not _has_same_instance_reviver_available(multiplayer.get_unique_id()):
        if _all_same_instance_partners_downed(multiplayer.get_unique_id()):
            if multiplayer.is_server():
                _try_begin_double_downed_recovery()
            elif _has_same_instance_downed_partner(multiplayer.get_unique_id()):
                double_downed_recovery_pending = true
                status_message = "Both downed - waiting for host regroup"
                _update_status_text()
            return
        
        # If there are live peers elsewhere, just teleport us to safety (home or overworld) instead of game-overing
        var other_peers_alive = false
        for p in peer_states.keys():
            if int(p) != multiplayer.get_unique_id() and bool(peer_states[p].get("active", false)) and not bool(peer_states[p].get("downed", false)):
                other_peers_alive = true
                break
                
        other_peers_alive = false
        for p in peer_states.keys():
            var p_state: Dictionary = peer_states[p]
            if int(p) != multiplayer.get_unique_id() and bool(p_state.get("active", false)) and not bool(p_state.get("downed", false)):
                other_peers_alive = true
                break
                
        if other_peers_alive:
            status_message = "No partner in dimension. Returning..."
            _update_status_text()
            _clear_local_downed_state()
            
            if is_instance_valid(Ref.player):
                Ref.player.health = maxi(int(Ref.player.max_health) / 4, 3)
                Ref.player.dead = false
                Ref.player.disabled = false
                Ref.player.invincible = false
                Ref.player.invincible_temporary = false
                
            if int(Ref.world.current_dimension) == int(LucidBlocksWorld.Dimension.POCKET):
                open_dimension_instance(0, "")
            else:
                open_dimension_instance(int(LucidBlocksWorld.Dimension.POCKET), "")
        else:
            _commit_local_real_death("No partner available to revive you")


func _get_revivable_peer_state() -> Dictionary:
    if not _has_live_peer() or not _can_sample_player() or is_local_player_downed():
        return {}

    var active_instance_key: String = get_active_dimension_instance_key()
    var nearest_state: Dictionary = {}
    var nearest_peer_id: int = -1
    var nearest_distance_squared: float = REVIVE_RADIUS * REVIVE_RADIUS
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if not bool(state.get("downed", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != active_instance_key:
            continue
        var peer_position: Vector3 = state.get("position", Ref.player.global_position)
        var distance_squared: float = Ref.player.global_position.distance_squared_to(peer_position)
        if distance_squared > nearest_distance_squared:
            continue
        nearest_distance_squared = distance_squared
        nearest_state = state.duplicate(true)
        nearest_peer_id = int_peer_id
    if nearest_peer_id == -1:
        return {}
    nearest_state["peer_id"] = nearest_peer_id
    return nearest_state


func _tick_revive_interaction(delta: float) -> void:
    if revive_prompt_label == null:
        return

    revive_prompt_label.visible = false
    if revive_request_pending or not _can_sample_player() or panel_visible or is_local_player_downed() or Ref.player.dead or Ref.player.disabled:
        revive_hold_progress = 0.0
        revive_target_peer_id = -1
        return

    var revive_state: Dictionary = _get_revivable_peer_state()
    if revive_state.is_empty():
        revive_hold_progress = 0.0
        revive_target_peer_id = -1
        return

    var target_peer_id: int = int(revive_state.get("peer_id", -1))
    if target_peer_id != revive_target_peer_id:
        revive_target_peer_id = target_peer_id
        revive_hold_progress = 0.0

    var target_name: String = str(revive_state.get("name", "Partner"))
    var revive_pressed: bool = Input.is_physical_key_pressed(KEY_F)
    if revive_pressed:
        revive_hold_progress = minf(REVIVE_HOLD_TIME, revive_hold_progress + delta)
    else:
        revive_hold_progress = maxf(0.0, revive_hold_progress - delta * 1.5)

    revive_prompt_label.visible = true
    revive_prompt_label.text = "Hold F to revive %s (%d%%)" % [target_name, int(round((revive_hold_progress / REVIVE_HOLD_TIME) * 100.0))]

    if revive_hold_progress < REVIVE_HOLD_TIME:
        return

    revive_hold_progress = 0.0
    revive_request_pending = true
    if multiplayer.is_server():
        _host_attempt_revive(multiplayer.get_unique_id(), target_peer_id)
    else:
        request_revive_peer.rpc_id(1, target_peer_id)


func _get_peer_state_for_revive(peer_id: int) -> Dictionary:
    if peer_id == 1 and multiplayer.is_server():
        return _capture_local_state()
    return peer_states.get(peer_id, {})


func _get_peer_revive_position(peer_id: int, state: Dictionary) -> Vector3:
    if peer_id == 1 and multiplayer.is_server() and local_downed_position_valid:
        return local_downed_position
    return state.get("position", Ref.player.global_position if _can_sample_player() else Vector3.ZERO)


func _resolve_peer_revive_position(peer_id: int, state: Dictionary) -> Vector3:
    var anchor_position: Vector3 = _get_peer_revive_position(peer_id, state)
    return _find_safe_respawn_position_near(anchor_position, anchor_position)


func _host_attempt_revive(sender_id: int, target_peer_id: int) -> void:
    if not multiplayer.is_server() or target_peer_id <= 0:
        return

    var sender_state: Dictionary = _get_peer_state_for_revive(sender_id)
    var target_state: Dictionary = _get_peer_state_for_revive(target_peer_id)
    if sender_state.is_empty() or target_state.is_empty():
        _send_revive_feedback(sender_id, "Revive failed")
        return

    var sender_instance_key: String = str(sender_state.get("dimension_instance_key", ""))
    if sender_instance_key == "" or sender_instance_key != str(target_state.get("dimension_instance_key", "")):
        _send_revive_feedback(sender_id, "Revive failed: not in the same area")
        return

    if bool(sender_state.get("downed", false)):
        _send_revive_feedback(sender_id, "Revive failed: you are downed")
        return
    if not bool(target_state.get("downed", false)):
        _send_revive_feedback(sender_id, "Revive failed: target is already up")
        return

    var sender_position: Vector3 = _get_peer_revive_position(sender_id, sender_state)
    var target_position: Vector3 = _get_peer_revive_position(target_peer_id, target_state)
    if sender_position.distance_squared_to(target_position) > REVIVE_RADIUS * REVIVE_RADIUS:
        _send_revive_feedback(sender_id, "Revive failed: get closer")
        return

    var reviver_name: String = str(sender_state.get("name", "Partner"))
    var revive_position: Vector3 = _resolve_peer_revive_position(target_peer_id, target_state)
    if target_peer_id == 1:
        _finish_local_revive(revive_position, reviver_name)
    else:
        force_peer_revive.rpc_id(target_peer_id, revive_position, reviver_name)

    _send_revive_feedback(sender_id, "Revived %s" % str(target_state.get("name", "partner")))


func _send_revive_feedback(peer_id: int, message: String) -> void:
    if peer_id == multiplayer.get_unique_id():
        revive_request_pending = false
        status_message = message
        _update_status_text()
        return
    receive_revive_feedback.rpc_id(peer_id, message)


@rpc("any_peer", "call_remote", "reliable")
func request_revive_peer(target_peer_id: int) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    _host_attempt_revive(sender_id, target_peer_id)


@rpc("authority", "call_remote", "reliable")
func force_peer_revive(revive_position: Vector3, reviver_name: String) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if not _is_safe_vector3(revive_position):
        return
    reviver_name = _safe_network_text(reviver_name, 64)
    _finish_local_revive(revive_position, reviver_name)


@rpc("authority", "call_remote", "reliable")
func receive_revive_feedback(message: String) -> void:
    revive_request_pending = false
    revive_hold_progress = 0.0
    revive_target_peer_id = -1
    status_message = _safe_network_text(message, CLIENT_SAFE_MAX_COMMAND_RESPONSE_LENGTH)
    _update_status_text()


func open_dimension_instance(target_dimension: int, target_pocket_owner_key: String = "") -> void:
    _open_dimension_instance_async.call_deferred(target_dimension, target_pocket_owner_key)


func travel_group_to_dimension(target_dimension: int, immediate: bool = false, white_close: bool = false, target_pocket_owner_key: String = "") -> void:
    _travel_group_to_dimension_async.call_deferred(target_dimension, immediate, white_close, target_pocket_owner_key)


func _is_private_instance_dimension(dimension: int) -> bool:
    return dimension == int(LucidBlocksWorld.Dimension.POCKET) or dimension == int(LucidBlocksWorld.Dimension.FIRMAMENT)


func _resolve_target_pocket_owner_key(target_dimension: int, target_pocket_owner_key: String = "") -> String:
    var pocket_owner_key: String = target_pocket_owner_key.strip_edges()
    if _is_private_instance_dimension(target_dimension) and pocket_owner_key == "":
        pocket_owner_key = _get_local_player_key()
    _migrate_legacy_pocket_save_to_owner_if_needed(target_dimension, pocket_owner_key)
    return pocket_owner_key


func _travel_group_to_dimension_async(target_dimension: int, immediate: bool = false, white_close: bool = false, target_pocket_owner_key: String = "") -> void:
    if not _can_sample_player() or group_dimension_transfer_in_progress:
        return

    _flush_pending_local_world_patch_to_host(true)
    _persist_current_owned_pocket_variants_if_needed()
    var pocket_owner_key: String = _resolve_target_pocket_owner_key(target_dimension, target_pocket_owner_key)
    if not _has_live_peer():
        _set_loaded_dimension_instance(target_dimension, pocket_owner_key)
        suppress_local_game_quit_session_shutdown = true
        await Ref.main.teleport_to_dimension(target_dimension, immediate, white_close)
        suppress_local_game_quit_session_shutdown = false
        return

    if not multiplayer.is_server():
        _send_persistent_state_to_host()
        request_group_dimension_travel.rpc_id(1, target_dimension, pocket_owner_key, immediate, white_close)
        status_message = "Waiting for host teleport"
        _update_status_text()
        return

    group_dimension_transfer_in_progress = true
    status_message = "Opening dimension %s" % target_dimension
    _update_status_text()
    _set_loaded_dimension_instance(target_dimension, pocket_owner_key)
    suppress_local_game_quit_session_shutdown = true
    await Ref.main.teleport_to_dimension(target_dimension, immediate, white_close)
    suppress_local_game_quit_session_shutdown = false

    if not multiplayer.is_server() or not _has_live_peer() or not _can_share_loaded_world():
        group_dimension_transfer_in_progress = false
        return

    await get_tree().process_frame
    _broadcast_local_state_now()
    for peer_id in multiplayer.get_peers():
        _send_world_snapshot_to_peer.call_deferred(int(peer_id), target_dimension, pocket_owner_key, false)

    group_dimension_transfer_in_progress = false
    status_message = "Dimension synced"
    _update_status_text()


func _open_dimension_instance_async(target_dimension: int, target_pocket_owner_key: String = "") -> void:
    if not _can_sample_player():
        return

    _flush_pending_local_world_patch_to_host(true)
    _persist_current_owned_pocket_variants_if_needed()
    var source_dimension: int = int(Ref.world.current_dimension)
    var pocket_owner_key: String = _resolve_target_pocket_owner_key(target_dimension, target_pocket_owner_key)
    var local_player_key: String = _get_local_player_key()
    var visiting_remote_private_instance: bool = _is_private_instance_dimension(target_dimension) and pocket_owner_key != "" and pocket_owner_key != local_player_key
    var target_instance_key: String = get_dimension_instance_key(target_dimension, pocket_owner_key)

    var host_in_target = false
    if _has_live_peer() and not multiplayer.is_server():
        var host_state = peer_states.get(1, {})
        if str(host_state.get("dimension_instance_key", "")) == target_instance_key:
            host_in_target = true
            
        # Remote private instances must come from the host cache so visitors see the owner's saved pocket state.
        if host_in_target or visiting_remote_private_instance:
            _send_persistent_state_to_host()
            request_dimension_world_snapshot.rpc_id(1, target_dimension, pocket_owner_key)
            status_message = "Requesting world sync"
            _update_status_text()
            return

    if multiplayer.is_server() and _has_live_peer() and target_instance_key != get_active_dimension_instance_key():
        await _await_guest_world_patch_flush_for_instance(target_instance_key)
            
    # Load locally!
    _set_loaded_dimension_instance(target_dimension, pocket_owner_key)
    suppress_local_game_quit_session_shutdown = true
    await Ref.main.teleport_to_dimension(target_dimension, false, false)
    suppress_local_game_quit_session_shutdown = false
    if _has_live_peer():
        _broadcast_local_state_now()
        if not multiplayer.is_server() and _is_private_instance_dimension(target_dimension) and pocket_owner_key == local_player_key:
            _send_full_local_world_patch_to_host()

    await _position_local_player_after_dimension_open(source_dimension, target_dimension)


func _set_loaded_dimension_instance(target_dimension: int, target_pocket_owner_key: String = "") -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file_register == null:
        return

    Ref.save_file_manager.loaded_file_register.set_data("dimension", target_dimension, true)
    if _is_private_instance_dimension(target_dimension):
        Ref.save_file_manager.loaded_file_register.set_data("pocket_owner_key", target_pocket_owner_key, true)
    else:
        Ref.save_file_manager.loaded_file_register.set_data("pocket_owner_key", "", true)


func _find_active_peer_position_in_instance(instance_key: String) -> Dictionary:
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue

        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != instance_key:
            continue

        return {
            "found": true,
            "peer_id": int_peer_id,
            "position": state.get("position", Vector3.ZERO),
        }

    return {"found": false}


func _position_local_player_after_dimension_open(source_dimension: int, target_dimension: int) -> void:
    if not is_instance_valid(Ref.player):
        return

    if target_dimension == int(LucidBlocksWorld.Dimension.NARAKA):
        if source_dimension == int(LucidBlocksWorld.Dimension.FIRMAMENT):
            await get_tree().process_frame
            if is_instance_valid(Ref.world) and is_instance_valid(Ref.world.spawn_tester):
                var found_spawn: bool = await Ref.world.spawn_tester.find_spawn_position(Vector3.ZERO, Ref.world.current_dimension, 1.0)
                if found_spawn and is_instance_valid(Ref.player):
                    if _has_live_peer():
                        _broadcast_local_state_now()
                    status_message = "Returned to spawn"
                    _update_status_text()
                    return

            _teleport_local_player_exact(_resolve_default_respawn_fallback_position(Vector3.ZERO))
            status_message = "Returned to spawn"
            _update_status_text()
            return


func _parse_dimension_instance_key(target_key: String) -> Dictionary:
    var instance_key: String = target_key.strip_edges()
    if instance_key == "":
        return {}
    if instance_key.begins_with("pocket:"):
        return {
            "dimension": int(LucidBlocksWorld.Dimension.POCKET),
            "owner_key": instance_key.substr(7),
        }
    if not instance_key.begins_with("dimension:"):
        return {}

    var payload: String = instance_key.substr(10)
    if payload == "":
        return {}
    var separator_index: int = payload.find(":")
    if separator_index == -1:
        return {
            "dimension": int(payload),
            "owner_key": "",
        }

    return {
        "dimension": int(payload.substr(0, separator_index)),
        "owner_key": payload.substr(separator_index + 1),
    }


func _open_dimension_instance_from_key(target_key: String) -> bool:
    var parsed_key: Dictionary = _parse_dimension_instance_key(target_key)
    if parsed_key.is_empty():
        return false

    open_dimension_instance(int(parsed_key.get("dimension", -1)), str(parsed_key.get("owner_key", "")))
    return true


func teleport_to_connected_player() -> void:
    if not _can_sample_player():
        return

    var target_peer_id: int = -1
    var target_state: Dictionary = {}
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue

        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != get_active_dimension_instance_key():
            continue

        target_peer_id = int_peer_id
        target_state = state
        break

    if target_peer_id == -1:
        for peer_id in peer_states.keys():
            var int_peer_id: int = int(peer_id)
            if int_peer_id == multiplayer.get_unique_id():
                continue
            var state: Dictionary = peer_states[peer_id]
            if not bool(state.get("active", false)):
                continue
            target_peer_id = int_peer_id
            target_state = state
            break

    if target_peer_id == -1:
        status_message = "No connected player to teleport to"
        _update_status_text()
        return

    if str(target_state.get("dimension_instance_key", "")) != get_active_dimension_instance_key():
        var target_key = str(target_state.get("dimension_instance_key", ""))
        if _open_dimension_instance_from_key(target_key):
            status_message = "Teleporting to peer dimension"
            _update_status_text()
            return

    _teleport_local_player_near(target_state.get("position", Ref.player.global_position))
    status_message = "Teleported to peer %s" % target_peer_id
    _update_status_text()


func execute_command(raw_text: String) -> void:
    var text: String = raw_text.lstrip(" \t\r\n")
    if text == "":
        return

    var parts: PackedStringArray = text.split(" ", false)
    var command: String = parts[0].to_lower()
    var local_is_admin: bool = _is_local_command_admin()
    if _is_admin_builder_command(command):
        _execute_admin_builder_command(text, parts)
        return
    if not local_is_admin and not _is_command_allowed_by_server_policy(command):
        _reject_command_by_server_policy(command)
        return
    if _is_core_debug_command(command) and not (_are_console_debug_commands_enabled() or local_is_admin):
        _reject_core_debug_command(command)
        return

    match command:
        "/help":
            _execute_help_command()
        "/whoami":
            _execute_whoami_command()
        "/ping":
            _execute_ping_command()
        "/coords", "/pos", "/position":
            _execute_coords_command()
        "/server-commands", "/server_commands", "/command-policy", "/command_policy":
            _execute_server_commands_command(parts)
        "/time":
            _execute_time_command(parts)
        "/weather":
            _execute_weather_command(parts)
        "/kill":
            _execute_kill_command(parts)
        "/list":
            _execute_list_command()
        "/home":
            _execute_home_command()
        "/give":
            _execute_give_command(parts)
        "/tp":
            _execute_tp_command(parts)
        "/gamemode", "/gm":
            _execute_gamemode_command(parts)
        "/spawn":
            _execute_spawn_command(parts)
        "/spawnlist":
            _execute_spawnlist_command()
        "/spawnmenu", "/mobs":
            _execute_spawnmenu_command(parts)
        "/pocket":
            status_message = "Pocket dimensions are disabled in tonight's stable build"
            _update_status_text()
        "/visit":
            status_message = "Pocket visits are disabled in tonight's stable build"
            _update_status_text()
        "/host", "/lan":
            if parts.size() >= 2 and parts[1].is_valid_int():
                config["port"] = clampi(int(parts[1]), 1, 65535)
                _sync_inputs_from_config()
            host_session()
        "/join":
            if parts.size() >= 2:
                config["address"] = parts[1]
            if parts.size() >= 3 and parts[2].is_valid_int():
                config["port"] = clampi(int(parts[2]), 1, 65535)
            _sync_inputs_from_config()
            join_session()
        "/steam_host", "/steam-host":
            host_steam_session()
        "/steam_invite", "/steam-invite", "/invite":
            _open_steam_invite_dialog()
        "/steam_join", "/steam-join":
            if parts.size() < 2 or not parts[1].is_valid_int():
                status_message = "Usage: /steam_join <lobby_id>"
                _update_status_text()
            else:
                _join_steam_lobby_by_id(int(parts[1]), true)
        "/avatar":
            if not is_avatar_alias_command_enabled():
                status_message = "/avatar is in the optional avatar/debug mod; use /char-select"
            elif parts.size() < 2:
                status_message = "Usage: /avatar <id>"
            else:
                _set_local_avatar_id_from_command(parts[1], "Avatar set to %s")
            _update_status_text()
        "/char-select", "/charselect", "/characters":
            if parts.size() >= 2:
                _set_local_avatar_id_from_command(parts[1], "Switched to %s")
                _update_status_text()
            else:
                toggle_char_select(true)
        "/default", "/default_blocky", "/white":
            _set_local_avatar_id_from_command(DEFAULT_AVATAR_ID, "Switched to %s")
            _update_status_text()
        "/fly":
            if is_instance_valid(Ref.player):
                Ref.player.fly_enabled = not Ref.player.fly_enabled
                Ref.player.flying = Ref.player.fly_enabled
                status_message = "Fly mode: %s (double-tap space to toggle mid-air)" % ("ON" if Ref.player.fly_enabled else "OFF")
            else:
                status_message = "No player"
            _update_status_text()
        _:
            status_message = "Unknown command: %s" % text
            _update_status_text()





func _are_console_debug_commands_enabled() -> bool:
    return bool(config.get("enable_debug_console_commands", ENABLE_DEBUG_CONSOLE_COMMANDS_DEFAULT))


func _normalize_server_command_name(raw_command: String) -> String:
    var name: String = raw_command.strip_edges().to_lower()
    while name.begins_with("/"):
        name = name.substr(1)
    name = name.replace("-", "_")
    if name == "gm":
        return "gamemode"
    if name == "mobs":
        return "spawnmenu"
    return name


func _normalize_server_command_policy(raw_policy: Variant) -> Dictionary:
    var policy: Dictionary = DEFAULT_SERVER_COMMAND_POLICY.duplicate(true)
    if raw_policy is Dictionary:
        for key in raw_policy.keys():
            var command_name: String = _normalize_server_command_name(str(key))
            if command_name == "":
                continue
            policy[command_name] = bool(raw_policy[key])
    policy["gm"] = bool(policy.get("gamemode", false))
    policy["mobs"] = bool(policy.get("spawnmenu", false))
    return policy


func _get_local_server_command_policy() -> Dictionary:
    var policy: Dictionary = _normalize_server_command_policy(config.get("server_command_policy", DEFAULT_SERVER_COMMAND_POLICY))
    config["server_command_policy"] = policy.duplicate(true)
    return policy


func _get_effective_server_command_policy() -> Dictionary:
    if multiplayer.is_server() or not _has_live_peer():
        return _get_local_server_command_policy()
    return _normalize_server_command_policy(active_server_command_policy)


func _is_server_command_policy_controlled(command: String) -> bool:
    var command_name: String = _normalize_server_command_name(command)
    return DEFAULT_SERVER_COMMAND_POLICY.has(command_name)


func _is_command_allowed_by_server_policy(command: String) -> bool:
    if not _is_server_command_policy_controlled(command):
        return true
    var command_name: String = _normalize_server_command_name(command)
    var policy: Dictionary = _get_effective_server_command_policy()
    return bool(policy.get(command_name, DEFAULT_SERVER_COMMAND_POLICY.get(command_name, true)))


func _reject_command_by_server_policy(command: String) -> void:
    status_message = "%s is disabled by server command policy" % command
    _update_status_text()


func _set_server_command_policy_value(raw_command: String, allowed: bool) -> void:
    var command_name: String = _normalize_server_command_name(raw_command)
    if command_name == "":
        return
    var policy: Dictionary = _get_local_server_command_policy()
    policy[command_name] = allowed
    if command_name == "gamemode":
        policy["gm"] = allowed
    elif command_name == "gm":
        policy["gamemode"] = allowed
    elif command_name == "spawnmenu":
        policy["mobs"] = allowed
    elif command_name == "mobs":
        policy["spawnmenu"] = allowed
    config["server_command_policy"] = _normalize_server_command_policy(policy)
    active_server_command_policy = config["server_command_policy"].duplicate(true)
    _save_config()
    _broadcast_server_command_policy()


func _broadcast_server_command_policy() -> void:
    if not multiplayer.is_server() or not _has_live_peer():
        return
    var policy: Dictionary = _get_local_server_command_policy()
    for peer_id in multiplayer.get_peers():
        sync_server_command_policy.rpc_id(int(peer_id), policy)


func _execute_server_commands_command(parts: PackedStringArray) -> void:
    var policy: Dictionary = _get_effective_server_command_policy()
    if parts.size() <= 1:
        var labels: PackedStringArray = PackedStringArray()
        for command_name in DEFAULT_SERVER_COMMAND_POLICY.keys():
            labels.append("%s=%s" % [str(command_name), "on" if bool(policy.get(command_name, false)) else "off"])
        status_message = "Server command policy: %s" % ", ".join(labels)
        _update_status_text()
        return

    if _has_live_peer() and not multiplayer.is_server():
        status_message = "Only the server can change command policy"
        _update_status_text()
        return

    var action: String = str(parts[1]).to_lower()
    if action == "reset":
        config["server_command_policy"] = DEFAULT_SERVER_COMMAND_POLICY.duplicate(true)
        active_server_command_policy = config["server_command_policy"].duplicate(true)
        _save_config()
        _broadcast_server_command_policy()
        status_message = "Server command policy reset"
        _update_status_text()
        return

    if parts.size() < 3 or not ["allow", "deny", "on", "off", "enable", "disable"].has(action):
        status_message = "Usage: /server-commands [allow|deny|reset] <command>"
        _update_status_text()
        return

    var allowed: bool = ["allow", "on", "enable"].has(action)
    _set_server_command_policy_value(parts[2], allowed)
    status_message = "Command %s: %s" % [_normalize_server_command_name(parts[2]), "allowed" if allowed else "denied"]
    _update_status_text()


func _get_configured_admin_keys() -> PackedStringArray:
    return _parse_server_admin_keys(config.get("server_admin_keys", []))


func _get_peer_player_key_for_admin(peer_id: int) -> String:
    if peer_id == multiplayer.get_unique_id():
        return _get_local_player_key()
    var state: Dictionary = _get_server_peer_state_for_command(peer_id)
    return str(state.get("player_key", "")).strip_edges()


func _is_peer_admin(peer_id: int) -> bool:
    if peer_id == multiplayer.get_unique_id() and (multiplayer.is_server() or not _has_live_peer()):
        return true
    var player_key: String = _get_peer_player_key_for_admin(peer_id)
    if player_key == "":
        return false
    return _get_configured_admin_keys().has(player_key)


func _is_local_command_admin() -> bool:
    if multiplayer.is_server() or not _has_live_peer():
        return true
    return _get_configured_admin_keys().has(_get_local_player_key())


func _is_admin_builder_command(command: String) -> bool:
    return ADMIN_BUILDER_COMMAND_NAMES.has(_normalize_server_command_name(command))


func _execute_admin_builder_command(raw_text: String, parts: PackedStringArray) -> void:
    var command_name: String = _normalize_server_command_name(parts[0] if parts.size() > 0 else "")
    if not _is_admin_builder_command(command_name):
        return

    var target_position: Vector3i = Vector3i.ZERO
    var has_target_position: bool = false
    if command_name == "pos1" or command_name == "pos2":
        var target: Variant = _get_admin_builder_target_block_position()
        if target is Vector3i:
            target_position = target
            has_target_position = true

    if multiplayer.is_server() or not _has_live_peer():
        _execute_admin_builder_command_authoritative(raw_text, multiplayer.get_unique_id(), target_position, has_target_position)
        return

    request_admin_builder_command.rpc_id(1, raw_text, target_position, has_target_position)
    status_message = "Requesting admin builder command..."
    _update_status_text()


func _execute_admin_builder_command_authoritative(raw_text: String, sender_id: int, target_position: Vector3i, has_target_position: bool) -> void:
    if not _is_peer_admin(sender_id):
        _respond_builder_command(sender_id, "Admin role required")
        return

    var text: String = raw_text.lstrip(" \t\r\n")
    var parts: PackedStringArray = text.split(" ", false)
    if parts.is_empty():
        return
    var command_name: String = _normalize_server_command_name(parts[0])
    match command_name:
        "wand":
            _respond_builder_command(sender_id, "Builder wand: /pos1, /pos2, /fill <block>, /clear [water], /floor <block>, /flat, /border")
        "pos1", "pos2":
            _execute_builder_position_command(parts, sender_id, 1 if command_name == "pos1" else 2, target_position, has_target_position)
        "sel":
            _execute_builder_selection_info_command(sender_id)
        "fill":
            _execute_builder_fill_command(parts, sender_id)
        "clear":
            _execute_builder_clear_command(parts, sender_id)
        "floor":
            _execute_builder_floor_command(parts, sender_id)
        "flat":
            _execute_builder_flat_command(parts, sender_id)
        "border":
            _execute_builder_border_command(parts, sender_id)
        "peaceful":
            _execute_builder_peaceful_command(parts, sender_id)
        "daylock":
            _execute_builder_daylock_command(parts, sender_id)
        "builder_setup":
            _execute_builder_setup_command(parts, sender_id)
        _:
            _respond_builder_command(sender_id, "Unknown builder command: %s" % parts[0])


func _respond_builder_command(peer_id: int, message: String) -> void:
    _send_command_response(peer_id, message)


func _execute_builder_position_command(parts: PackedStringArray, peer_id: int, slot: int, target_position: Vector3i, has_target_position: bool) -> void:
    var position: Variant = null
    if parts.size() >= 4:
        position = _parse_builder_vector3i_parts(parts, 1)
    elif has_target_position:
        position = target_position
    else:
        position = _get_builder_peer_block_position(peer_id)

    if not (position is Vector3i) or not _is_safe_vector3i(position):
        _respond_builder_command(peer_id, "Usage: /pos%s [x y z] or look at a block" % slot)
        return

    _set_builder_selection_position(peer_id, slot, position)
    _respond_builder_command(peer_id, "Position %s set to %s" % [slot, _format_builder_vector3i(position)])


func _execute_builder_selection_info_command(peer_id: int) -> void:
    if not _has_builder_selection(peer_id):
        _respond_builder_command(peer_id, "No selection. Use /pos1 and /pos2 first.")
        return
    var bounds: Dictionary = _get_builder_selection_bounds(peer_id)
    var min_pos: Vector3i = bounds["min"]
    var max_pos: Vector3i = bounds["max"]
    var size: Vector3i = max_pos - min_pos + Vector3i.ONE
    _respond_builder_command(peer_id, "Selection %s -> %s (%dx%dx%d, %d blocks)" % [
        _format_builder_vector3i(min_pos),
        _format_builder_vector3i(max_pos),
        size.x,
        size.y,
        size.z,
        int(size.x * size.y * size.z),
    ])


func _execute_builder_fill_command(parts: PackedStringArray, peer_id: int) -> void:
    if not _has_builder_selection(peer_id):
        _respond_builder_command(peer_id, "No selection. Use /pos1 and /pos2 first.")
        return
    if parts.size() < 2:
        _respond_builder_command(peer_id, "Usage: /fill <block_name_or_id>")
        return
    var block_result: Dictionary = _resolve_builder_block_query(" ".join(parts.slice(1)).strip_edges())
    if block_result.has("error"):
        _respond_builder_command(peer_id, str(block_result.get("error")))
        return
    var bounds: Dictionary = _get_builder_selection_bounds(peer_id)
    var result: Dictionary = _builder_fill_box(bounds["min"], bounds["max"], block_result.get("block", null), false)
    _respond_builder_command(peer_id, "Filled %d blocks with %s%s" % [
        int(result.get("changed", 0)),
        str(block_result.get("display_name", "block")),
        " (%d skipped)" % int(result.get("skipped", 0)) if int(result.get("skipped", 0)) > 0 else "",
    ])


func _execute_builder_clear_command(parts: PackedStringArray, peer_id: int) -> void:
    if not _has_builder_selection(peer_id):
        _respond_builder_command(peer_id, "No selection. Use /pos1 and /pos2 first.")
        return
    var clear_water: bool = parts.size() >= 2 and str(parts[1]).to_lower() == "water"
    var bounds: Dictionary = _get_builder_selection_bounds(peer_id)
    var result: Dictionary = _builder_fill_box(bounds["min"], bounds["max"], null, clear_water)
    _respond_builder_command(peer_id, "Cleared %d blocks%s" % [
        int(result.get("changed", 0)),
        " and water/fire" if clear_water else "",
    ])


func _execute_builder_floor_command(parts: PackedStringArray, peer_id: int) -> void:
    if not _has_builder_selection(peer_id):
        _respond_builder_command(peer_id, "No selection. Use /pos1 and /pos2 first.")
        return
    if parts.size() < 2:
        _respond_builder_command(peer_id, "Usage: /floor <block_name_or_id> [y]")
        return
    var bounds: Dictionary = _get_builder_selection_bounds(peer_id)
    var y: int = bounds["min"].y
    var block_query_end: int = parts.size()
    if parts.size() >= 3 and str(parts[parts.size() - 1]).is_valid_int():
        y = int(parts[parts.size() - 1])
        block_query_end = parts.size() - 1
    var block_result: Dictionary = _resolve_builder_block_query(" ".join(parts.slice(1, block_query_end)).strip_edges())
    if block_result.has("error"):
        _respond_builder_command(peer_id, str(block_result.get("error")))
        return
    var min_pos: Vector3i = bounds["min"]
    var max_pos: Vector3i = bounds["max"]
    min_pos.y = y
    max_pos.y = y
    var result: Dictionary = _builder_fill_box(min_pos, max_pos, block_result.get("block", null), false)
    _respond_builder_command(peer_id, "Floored %d blocks at y=%d with %s" % [int(result.get("changed", 0)), y, str(block_result.get("display_name", "block"))])


func _execute_builder_flat_command(parts: PackedStringArray, peer_id: int) -> void:
    var peer_position: Vector3 = _get_builder_peer_position(peer_id)
    var radius_chunks: int = 2
    var floor_y: int = int(floor(peer_position.y)) - 1
    var block_query: String = "grass"
    if parts.size() >= 2 and str(parts[1]).is_valid_int():
        radius_chunks = clampi(int(parts[1]), 0, 8)
    if parts.size() >= 3:
        block_query = str(parts[2])
    if parts.size() >= 4 and str(parts[3]).is_valid_int():
        floor_y = int(parts[3])
    var block_result: Dictionary = _resolve_builder_block_query(block_query)
    if block_result.has("error"):
        block_result = _get_builder_fallback_solid_block()
    var area: Dictionary = _get_builder_chunk_square_around_position(peer_position, radius_chunks)
    var result: Dictionary = _builder_make_flat_area(area["min"], area["max"], floor_y, block_result.get("block", null), WORLD_EDIT_DEFAULT_CLEAR_HEIGHT)
    _respond_builder_command(peer_id, "Flat area: %d changed, radius=%d chunks, y=%d" % [int(result.get("changed", 0)), radius_chunks, floor_y])


func _execute_builder_border_command(parts: PackedStringArray, peer_id: int) -> void:
    var block_query: String = "stone"
    var border_height: int = WORLD_EDIT_DEFAULT_BORDER_HEIGHT
    var min_pos: Vector3i
    var max_pos: Vector3i
    if parts.size() >= 2 and str(parts[1]).is_valid_int():
        var radius_chunks: int = clampi(int(parts[1]), 0, 12)
        var area: Dictionary = _get_builder_chunk_square_around_position(_get_builder_peer_position(peer_id), radius_chunks)
        min_pos = area["min"]
        max_pos = area["max"]
        if parts.size() >= 3:
            block_query = str(parts[2])
        if parts.size() >= 4 and str(parts[3]).is_valid_int():
            border_height = clampi(int(parts[3]), 1, 32)
    else:
        if not _has_builder_selection(peer_id):
            _respond_builder_command(peer_id, "Usage: /border <radius_chunks> [block] [height] or select /pos1 /pos2 first")
            return
        var bounds: Dictionary = _get_builder_selection_bounds(peer_id)
        min_pos = bounds["min"]
        max_pos = bounds["max"]
        if parts.size() >= 2:
            block_query = str(parts[1])
        if parts.size() >= 3 and str(parts[2]).is_valid_int():
            border_height = clampi(int(parts[2]), 1, 32)
    var block_result: Dictionary = _resolve_builder_block_query(block_query)
    if block_result.has("error"):
        block_result = _get_builder_fallback_solid_block()
    var base_y: int = int(floor(_get_builder_peer_position(peer_id).y))
    var result: Dictionary = _builder_build_border(min_pos, max_pos, base_y, border_height, block_result.get("block", null))
    _respond_builder_command(peer_id, "Border built: %d blocks, height=%d" % [int(result.get("changed", 0)), border_height])


func _execute_builder_peaceful_command(parts: PackedStringArray, peer_id: int) -> void:
    var enabled: bool = true
    if parts.size() >= 2:
        enabled = _parse_builder_on_off(str(parts[1]), builder_peaceful_enabled)
    builder_peaceful_enabled = enabled
    if enabled:
        _apply_builder_peaceful_runtime()
    _respond_builder_command(peer_id, "Peaceful builder mode: %s" % ("ON" if enabled else "OFF"))


func _execute_builder_daylock_command(parts: PackedStringArray, peer_id: int) -> void:
    var enabled: bool = true
    if parts.size() >= 2:
        enabled = _parse_builder_on_off(str(parts[1]), builder_day_lock_enabled)
    builder_day_lock_enabled = enabled
    if enabled:
        _set_builder_day_time(false)
    _respond_builder_command(peer_id, "Day lock: %s" % ("ON" if enabled else "OFF"))


func _execute_builder_setup_command(parts: PackedStringArray, peer_id: int) -> void:
    var peer_position: Vector3 = _get_builder_peer_position(peer_id)
    var radius_chunks: int = 2
    var floor_y: int = int(floor(peer_position.y)) - 1
    var block_query: String = "grass"
    if parts.size() >= 2 and str(parts[1]).is_valid_int():
        radius_chunks = clampi(int(parts[1]), 0, 8)
    if parts.size() >= 3:
        block_query = str(parts[2])
    if parts.size() >= 4 and str(parts[3]).is_valid_int():
        floor_y = int(parts[3])
    if peer_id == multiplayer.get_unique_id() and is_instance_valid(Ref.player):
        _set_session_creative_mode(true)
        Ref.player.fly_enabled = true
        Ref.player.flying = true
    builder_peaceful_enabled = true
    builder_day_lock_enabled = true
    _apply_builder_peaceful_runtime()
    _set_builder_day_time(false)
    if is_instance_valid(Ref.weather) and Ref.weather.has_method("set_target_intensity"):
        Ref.weather.set_target_intensity(0.0)
    var block_result: Dictionary = _resolve_builder_block_query(block_query)
    if block_result.has("error"):
        block_result = _get_builder_fallback_solid_block()
    var area: Dictionary = _get_builder_chunk_square_around_position(peer_position, radius_chunks)
    var flat_result: Dictionary = _builder_make_flat_area(area["min"], area["max"], floor_y, block_result.get("block", null), WORLD_EDIT_DEFAULT_CLEAR_HEIGHT)
    var border_result: Dictionary = _builder_build_border(area["min"], area["max"], floor_y + 1, WORLD_EDIT_DEFAULT_BORDER_HEIGHT, block_result.get("block", null))
    _respond_builder_command(peer_id, "Builder setup ready: flat=%d border=%d radius=%d chunks" % [
        int(flat_result.get("changed", 0)),
        int(border_result.get("changed", 0)),
        radius_chunks,
    ])


func _parse_builder_vector3i_parts(parts: PackedStringArray, start_index: int) -> Variant:
    if parts.size() < start_index + 3:
        return null
    for offset in range(3):
        if not str(parts[start_index + offset]).is_valid_int():
            return null
    return Vector3i(int(parts[start_index]), int(parts[start_index + 1]), int(parts[start_index + 2]))


func _get_admin_builder_target_block_position() -> Variant:
    if not is_instance_valid(Ref.player):
        return null
    var origin: Vector3
    var direction: Vector3
    if is_instance_valid(Ref.player_camera):
        origin = Ref.player_camera.global_position
        direction = -Ref.player_camera.global_basis.z
    else:
        origin = Ref.player.global_position + Vector3(0.0, 1.5, 0.0)
        direction = Ref.player.get_look_direction() if Ref.player.has_method("get_look_direction") else -Ref.player.global_basis.z
    if direction.length_squared() <= 0.0001:
        direction = Vector3.FORWARD
    var query := PhysicsRayQueryParameters3D.create(origin, origin + direction.normalized() * 96.0)
    query.collide_with_areas = false
    query.collide_with_bodies = true
    var hit: Dictionary = Ref.player.get_world_3d().direct_space_state.intersect_ray(query)
    if hit.has("position"):
        var hit_position: Vector3 = hit["position"]
        var hit_normal: Vector3 = hit.get("normal", Vector3.ZERO)
        return Vector3i(floor(hit_position.x - hit_normal.x * 0.02), floor(hit_position.y - hit_normal.y * 0.02), floor(hit_position.z - hit_normal.z * 0.02))
    var fallback: Vector3 = Ref.player.global_position.floor()
    return Vector3i(int(fallback.x), int(fallback.y), int(fallback.z))


func _get_builder_peer_block_position(peer_id: int) -> Variant:
    var position: Vector3 = _get_builder_peer_position(peer_id).floor()
    return Vector3i(int(position.x), int(position.y), int(position.z))


func _get_builder_peer_position(peer_id: int) -> Vector3:
    if peer_id == multiplayer.get_unique_id() and is_instance_valid(Ref.player):
        return Ref.player.global_position
    var state: Dictionary = _get_server_peer_state_for_command(peer_id)
    if state.has("position") and state["position"] is Vector3:
        return state["position"]
    return Ref.player.global_position if is_instance_valid(Ref.player) else Vector3.ZERO


func _get_builder_selection_record(peer_id: int) -> Dictionary:
    if peer_id == multiplayer.get_unique_id():
        return {"pos1": world_edit_pos1, "pos2": world_edit_pos2}
    return server_world_edit_selections.get(peer_id, {})


func _set_builder_selection_position(peer_id: int, slot: int, position: Vector3i) -> void:
    if peer_id == multiplayer.get_unique_id():
        if slot == 1:
            world_edit_pos1 = position
        else:
            world_edit_pos2 = position
        return
    var record: Dictionary = server_world_edit_selections.get(peer_id, {})
    record["pos%s" % slot] = position
    server_world_edit_selections[peer_id] = record


func _has_builder_selection(peer_id: int) -> bool:
    var record: Dictionary = _get_builder_selection_record(peer_id)
    return record.get("pos1", null) is Vector3i and record.get("pos2", null) is Vector3i


func _get_builder_selection_bounds(peer_id: int) -> Dictionary:
    var record: Dictionary = _get_builder_selection_record(peer_id)
    var a: Vector3i = record["pos1"]
    var b: Vector3i = record["pos2"]
    return {
        "min": Vector3i(mini(a.x, b.x), mini(a.y, b.y), mini(a.z, b.z)),
        "max": Vector3i(maxi(a.x, b.x), maxi(a.y, b.y), maxi(a.z, b.z)),
    }


func _format_builder_vector3i(position: Vector3i) -> String:
    return "%d %d %d" % [position.x, position.y, position.z]


func _get_builder_item_property(item, property_name: String, default_value: Variant = null) -> Variant:
    if item == null or not is_instance_valid(item):
        return default_value
    if _object_has_property(item, property_name):
        return item.get(property_name)
    return default_value


func _get_builder_item_display_name(item, fallback: String = "block") -> String:
    var internal_name: String = str(_get_builder_item_property(item, "internal_name", fallback))
    return str(_get_builder_item_property(item, "display_name", internal_name))


func _get_item_aliases(item) -> PackedStringArray:
    var aliases: PackedStringArray = PackedStringArray()
    for raw_name in [
        _get_builder_item_display_name(item, ""),
        str(_get_builder_item_property(item, "internal_name", "")),
    ]:
        var alias: String = _slugify_string(str(raw_name))
        if alias != "" and not aliases.has(alias):
            aliases.append(alias)
    return aliases


func _resolve_builder_block_query(block_query: String) -> Dictionary:
    var query: String = block_query.strip_edges()
    if query == "":
        return {"error": "Usage: <block_name_or_id>"}
    if ["air", "empty", "0"].has(query.to_lower()):
        return {"block": null, "display_name": "air"}
    var item_map = get_tree().root.get_node_or_null("ItemMap")
    if not is_instance_valid(item_map) or not "id_to_resource" in item_map:
        return {"error": "Item map is unavailable right now"}
    if query.is_valid_int():
        var numeric_id: int = int(query)
        if item_map.id_to_resource.has(numeric_id) and item_map.id_to_resource[numeric_id] is Block:
            var numeric_block: Block = item_map.id_to_resource[numeric_id]
            return {"block": numeric_block, "display_name": _get_builder_item_display_name(numeric_block, query)}
        return {"error": "Unknown block id: %d" % numeric_id}

    var normalized_query: String = _slugify_string(query)
    var partial_matches: Array = []
    for item_id in item_map.id_to_resource.keys():
        var item = item_map.id_to_resource[item_id]
        if not (item is Block):
            continue
        for alias in _get_item_aliases(item):
            if alias == normalized_query:
                return {"block": item, "display_name": _get_builder_item_display_name(item, query)}
            if alias.contains(normalized_query):
                partial_matches.append(item)
                break
    if partial_matches.size() == 1:
        var block: Block = partial_matches[0]
        return {"block": block, "display_name": _get_builder_item_display_name(block, query)}
    if partial_matches.size() > 1:
        var labels: PackedStringArray = PackedStringArray()
        for index in range(mini(5, partial_matches.size())):
            var match_block: Block = partial_matches[index]
            labels.append(_get_builder_item_display_name(match_block, "block"))
        return {"error": "Multiple blocks match: %s" % ", ".join(labels)}
    return {"error": "Block not found: %s" % query}


func _get_builder_fallback_solid_block() -> Dictionary:
    var item_map = get_tree().root.get_node_or_null("ItemMap")
    if is_instance_valid(item_map) and "id_to_resource" in item_map:
        for preferred in ["grass", "dirt", "stone"]:
            var resolved: Dictionary = _resolve_builder_block_query(preferred)
            if not resolved.has("error"):
                return resolved
        for item_id in item_map.id_to_resource.keys():
            var item = item_map.id_to_resource[item_id]
            if item is Block and not bool(_get_builder_item_property(item, "foliage", false)) and not bool(_get_builder_item_property(item, "textureless", false)):
                return {"block": item, "display_name": _get_builder_item_display_name(item, "block")}
    return {"block": null, "display_name": "air"}


func _builder_count_box_blocks(min_pos: Vector3i, max_pos: Vector3i) -> int:
    return maxi(0, max_pos.x - min_pos.x + 1) * maxi(0, max_pos.y - min_pos.y + 1) * maxi(0, max_pos.z - min_pos.z + 1)


func _builder_fill_box(min_pos: Vector3i, max_pos: Vector3i, block, clear_liquids: bool) -> Dictionary:
    var planned: int = _builder_count_box_blocks(min_pos, max_pos)
    if planned > WORLD_EDIT_MAX_BLOCK_OPS:
        return {"changed": 0, "skipped": planned, "error": "selection_too_large"}
    var changed: int = 0
    var skipped: int = 0
    var changed_chunks: Dictionary = {}
    for y in range(min_pos.y, max_pos.y + 1):
        for z in range(min_pos.z, max_pos.z + 1):
            for x in range(min_pos.x, max_pos.x + 1):
                var position := Vector3i(x, y, z)
                if not _builder_set_world_block(position, block, clear_liquids):
                    skipped += 1
                else:
                    changed += 1
                    _remember_builder_changed_chunk(position, changed_chunks)
    _notify_builder_world_changed(changed_chunks)
    return {"changed": changed, "skipped": skipped}


func _builder_set_world_block(position: Vector3i, block, clear_liquids: bool = false) -> bool:
    if not is_instance_valid(Ref.world) or not Ref.world.has_method("is_position_loaded") or not Ref.world.is_position_loaded(position):
        return false
    if clear_liquids:
        if Ref.world.has_method("place_water_at"):
            Ref.world.place_water_at(position, 0)
        if Ref.world.has_method("place_fire_at"):
            Ref.world.place_fire_at(position, 0)
    if block == null:
        var current_block = Ref.world.get_block_type_at(position)
        if current_block == null or int(current_block.id) == 0:
            return true
        Ref.world.break_block_at(position, false, true)
        return true
    if not (block is Block):
        return false
    Ref.world.place_block_at(position, block, false, false)
    return true


func _builder_make_flat_area(min_area: Vector3i, max_area: Vector3i, floor_y: int, block, clear_height: int) -> Dictionary:
    var floor_min := Vector3i(min_area.x, floor_y, min_area.z)
    var floor_max := Vector3i(max_area.x, floor_y, max_area.z)
    var clear_min := Vector3i(min_area.x, floor_y + 1, min_area.z)
    var clear_max := Vector3i(max_area.x, floor_y + clear_height, max_area.z)
    var clear_result: Dictionary = _builder_fill_box(clear_min, clear_max, null, true)
    var floor_result: Dictionary = _builder_fill_box(floor_min, floor_max, block, true)
    return {
        "changed": int(clear_result.get("changed", 0)) + int(floor_result.get("changed", 0)),
        "skipped": int(clear_result.get("skipped", 0)) + int(floor_result.get("skipped", 0)),
    }


func _builder_build_border(min_area: Vector3i, max_area: Vector3i, base_y: int, height: int, block) -> Dictionary:
    var perimeter_count: int = max(0, (max_area.x - min_area.x + 1) * 2 + (max_area.z - min_area.z - 1) * 2) * height
    if perimeter_count > WORLD_EDIT_MAX_BLOCK_OPS:
        return {"changed": 0, "skipped": perimeter_count, "error": "border_too_large"}
    var changed: int = 0
    var skipped: int = 0
    var changed_chunks: Dictionary = {}
    for y in range(base_y, base_y + height):
        for x in range(min_area.x, max_area.x + 1):
            for z in [min_area.z, max_area.z]:
                var edge_z_position := Vector3i(x, y, z)
                if _builder_set_world_block(edge_z_position, block, false):
                    changed += 1
                    _remember_builder_changed_chunk(edge_z_position, changed_chunks)
                else:
                    skipped += 1
        for z in range(min_area.z + 1, max_area.z):
            for x in [min_area.x, max_area.x]:
                var edge_x_position := Vector3i(x, y, z)
                if _builder_set_world_block(edge_x_position, block, false):
                    changed += 1
                    _remember_builder_changed_chunk(edge_x_position, changed_chunks)
                else:
                    skipped += 1
    _notify_builder_world_changed(changed_chunks)
    return {"changed": changed, "skipped": skipped}


func _get_builder_chunk_square_around_position(position: Vector3, radius_chunks: int) -> Dictionary:
    var center_chunk: Vector3i = Ref.world.snap_to_chunk(position) if is_instance_valid(Ref.world) and Ref.world.has_method("snap_to_chunk") else Vector3i.ZERO
    var min_x: int = center_chunk.x - radius_chunks * WORLD_EDIT_CHUNK_SIZE_X
    var min_z: int = center_chunk.z - radius_chunks * WORLD_EDIT_CHUNK_SIZE_Z
    var max_x: int = center_chunk.x + (radius_chunks + 1) * WORLD_EDIT_CHUNK_SIZE_X - 1
    var max_z: int = center_chunk.z + (radius_chunks + 1) * WORLD_EDIT_CHUNK_SIZE_Z - 1
    return {
        "min": Vector3i(min_x, 0, min_z),
        "max": Vector3i(max_x, 0, max_z),
    }


func _remember_builder_changed_chunk(position: Vector3i, changed_chunks: Dictionary) -> void:
    if not is_instance_valid(Ref.world) or not Ref.world.has_method("snap_to_chunk"):
        changed_chunks[position] = true
        return
    changed_chunks[Ref.world.snap_to_chunk(Vector3(position))] = true


func _notify_builder_world_changed(changed_chunks: Dictionary) -> void:
    if changed_chunks.is_empty():
        return
    notify_local_world_state_dirty(changed_chunks.keys())


func _tick_builder_admin_runtime(delta: float) -> void:
    if _has_live_peer() and not multiplayer.is_server():
        return
    if builder_day_lock_enabled:
        _set_builder_day_time(false)
    if builder_peaceful_enabled:
        builder_peaceful_sweep_timer -= delta
        if builder_peaceful_sweep_timer <= 0.0:
            builder_peaceful_sweep_timer = 1.0
            _apply_builder_peaceful_runtime()


func _apply_builder_peaceful_runtime() -> void:
    if is_instance_valid(Ref.entity_spawner):
        if Ref.entity_spawner.has_method("stop_spawning"):
            Ref.entity_spawner.stop_spawning()
        if "can_spawn" in Ref.entity_spawner:
            Ref.entity_spawner.can_spawn = false
    var root := get_tree().get_root()
    if root == null:
        return
    for node in root.find_children("*", "", true, false):
        if node == Ref.player:
            continue
        if node is Entity and is_instance_valid(node):
            node.queue_free()


func _set_builder_day_time(report: bool) -> void:
    if is_instance_valid(Ref.world) and Ref.world.get("time_of_day") != null:
        Ref.world.time_of_day = 0.25
        if report:
            _display_command_response("Time locked to day")


func _parse_builder_on_off(value: String, current: bool) -> bool:
    var normalized: String = value.strip_edges().to_lower()
    if ["on", "1", "true", "yes", "enable", "enabled"].has(normalized):
        return true
    if ["off", "0", "false", "no", "disable", "disabled"].has(normalized):
        return false
    return not current


func _set_local_avatar_id_from_command(raw_avatar_id: String, success_template: String) -> void:
    var target_id: String = _normalize_avatar_id(raw_avatar_id)
    if target_id != DEFAULT_AVATAR_ID and not is_avatar_customization_enabled():
        status_message = "Optional avatar pack is disabled; using %s" % DEFAULT_AVATAR_ID
        target_id = DEFAULT_AVATAR_ID
    config["avatar_id"] = target_id
    _save_config()
    _refresh_local_hand_color()
    _refresh_local_avatar_sounds()
    status_message = success_template % target_id


func _is_core_debug_command(command: String) -> bool:
    var normalized: String = command.strip_edges().to_lower()
    for debug_command in CORE_DEBUG_COMMAND_NAMES:
        if normalized == str(debug_command):
            return true
    return false


func _is_core_debug_autocomplete_command(command_body: String) -> bool:
    return _is_core_debug_command("/" + command_body.strip_edges().to_lower())


func _reject_core_debug_command(command: String) -> void:
    status_message = "%s is in the optional console/debug mod" % command
    _update_status_text()


func _execute_home_command() -> void:
    if not is_instance_valid(Ref.player):
        return
        
    if not str(get_active_dimension_instance_key()).begins_with("pocket:"):
        prompt_pocket_dimension_choice(false)
    else:
        status_message = "Already in pocket dimension"
        _update_status_text()

func prompt_pocket_dimension_choice(is_group_travel: bool) -> void:
    var canvas = CanvasLayer.new()
    canvas.layer = 100
    add_child(canvas)
    
    var popup = PopupMenu.new()
    canvas.add_child(popup)
    
    popup.add_theme_font_size_override("font_size", 8)
    popup.add_item("My Pocket Dimension", 0)
    
    var peer_keys = []
    var item_id = 1
    
    for peer_id in peer_states.keys():
        if int(peer_id) == multiplayer.get_unique_id():
            continue
        var state = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        var peer_name = str(state.get("name", "Peer " + str(peer_id)))
        var player_key = str(state.get("player_key", "")).strip_edges()
        if player_key != "":
            popup.add_item(peer_name + "'s Pocket Dimension", item_id)
            peer_keys.append(player_key)
            item_id += 1
            
    var was_captured = false
    if MouseHandler.captured:
        was_captured = true
        MouseHandler.release()
        
    popup.id_pressed.connect(func(id: int):
        var target_key = ""
        if id > 0:
            target_key = peer_keys[id - 1]
            
        status_message = "Teleporting to pocket dimension..."
        _update_status_text()
        
        if is_group_travel:
            travel_group_to_dimension(int(LucidBlocksWorld.Dimension.POCKET), false, false, target_key)
        else:
            open_dimension_instance(int(LucidBlocksWorld.Dimension.POCKET), target_key)
    )
    
    popup.popup_hide.connect(func():
        if was_captured:
            MouseHandler.capture()
        canvas.queue_free()
    )
    
    popup.popup_centered()

func _get_debug_give_inventories() -> Array:
    var inventories: Array = []
    for inventory in [Ref.player_hotbar, Ref.player_inventory]:
        if inventory != null and is_instance_valid(inventory) and not inventories.has(inventory):
            inventories.append(inventory)

    if is_instance_valid(Ref.player):
        for fallback_path in ["%Hotbar", "%Inventory"]:
            var inventory = Ref.player.get_node_or_null(fallback_path)
            if inventory != null and is_instance_valid(inventory) and not inventories.has(inventory):
                inventories.append(inventory)

    return inventories


func _get_item_command_aliases(item) -> PackedStringArray:
    var aliases: PackedStringArray = PackedStringArray()
    for raw_name in [
        _get_builder_item_display_name(item, ""),
        str(_get_builder_item_property(item, "internal_name", "")),
    ]:
        var alias: String = _slugify_string(raw_name)
        if alias != "" and not aliases.has(alias):
            aliases.append(alias)
    return aliases


func _resolve_debug_item_query(item_query: String) -> Dictionary:
    var item_map = get_tree().root.get_node_or_null("ItemMap")
    if not is_instance_valid(item_map) or not "id_to_resource" in item_map:
        return {"error": "Item map is unavailable right now"}

    if item_query.is_valid_int():
        var numeric_item_id: int = int(item_query)
        if item_map.id_to_resource.has(numeric_item_id):
            var numeric_item = item_map.id_to_resource[numeric_item_id]
            return {
                "item_id": numeric_item_id,
                "item": numeric_item,
                "display_name": _get_builder_item_display_name(numeric_item, item_query),
            }
        return {"error": "Unknown item id: %d" % numeric_item_id}

    var normalized_query: String = _slugify_string(item_query)
    if normalized_query == "":
        return {"error": "Usage: /give [amount] <item_name_or_id>"}

    var partial_matches: Array = []
    for item_id in item_map.id_to_resource.keys():
        var item = item_map.id_to_resource[item_id]
        var aliases: PackedStringArray = _get_item_command_aliases(item)
        for alias in aliases:
            if alias == normalized_query:
                return {
                    "item_id": int(item_id),
                    "item": item,
                    "display_name": _get_builder_item_display_name(item, normalized_query),
                }
            if alias.contains(normalized_query):
                partial_matches.append({
                    "item_id": int(item_id),
                    "item": item,
                    "display_name": _get_builder_item_display_name(item, normalized_query),
                })
                break

    if partial_matches.size() == 1:
        return partial_matches[0]

    if partial_matches.size() > 1:
        var labels: PackedStringArray = PackedStringArray()
        for index in range(mini(5, partial_matches.size())):
            var match: Dictionary = partial_matches[index]
            labels.append("%s (%s)" % [str(match.get("display_name", "item")), str(match.get("item_id", -1))])
        return {"error": "Multiple items match: %s" % ", ".join(labels)}

    return {"error": "Item not found: %s" % item_query}


func _give_local_item_for_testing(item, amount: int) -> Dictionary:
    var inventories: Array = _get_debug_give_inventories()
    if inventories.is_empty():
        return {"given": 0, "remaining": amount}

    var remaining: int = amount
    var stack_size: int = maxi(1, int(item.stack_size))
    for inventory in inventories:
        while remaining > 0:
            var new_item_state := ItemState.new()
            new_item_state.initialize(item)
            new_item_state.count = mini(remaining, stack_size)

            var requested_count: int = int(new_item_state.count)
            var leftover = inventory.accept(new_item_state)
            var leftover_count: int = int(leftover.count) if leftover != null else 0
            var inserted_count: int = requested_count - leftover_count
            remaining -= inserted_count
            if inserted_count <= 0:
                break

    if is_instance_valid(Ref.player) and Ref.player.has_method("hold_item"):
        Ref.player.hold_item(int(Ref.player.held_item_index))

    if is_instance_valid(Ref.game_menu) and Ref.game_menu.has_method("update_inventory_screen") and Ref.game_menu.is_inventory_open():
        Ref.game_menu.update_inventory_screen(int(Ref.game_menu.inventory_screen))

    if _has_live_peer():
        _broadcast_local_state_now()
        if not multiplayer.is_server():
            _send_persistent_state_to_host(true)

    return {"given": amount - remaining, "remaining": remaining}


func _execute_give_command(parts: PackedStringArray) -> void:
    if parts.size() < 2:
        status_message = "Usage: /give [amount] <item_name_or_id>"
        _update_status_text()
        return

    var amount: int = 1
    var item_part_index: int = 1
    if parts[1].is_valid_int():
        amount = int(parts[1])
        item_part_index = 2

    if amount <= 0 or parts.size() <= item_part_index:
        status_message = "Usage: /give [amount] <item_name_or_id>"
        _update_status_text()
        return

    if not is_instance_valid(Ref.player):
        status_message = "Cannot give items right now"
        _update_status_text()
        return

    var item_str: String = " ".join(parts.slice(item_part_index, parts.size())).strip_edges()
    var resolved: Dictionary = _resolve_debug_item_query(item_str)
    if resolved.has("error"):
        status_message = str(resolved.get("error", "Item not found"))
        _update_status_text()
        return

    var item = resolved.get("item", null)
    if item == null:
        status_message = "Item not found: %s" % item_str
        _update_status_text()
        return

    var give_result: Dictionary = _give_local_item_for_testing(item, amount)
    var given: int = int(give_result.get("given", 0))
    var remaining: int = int(give_result.get("remaining", amount))
    var actual_name: String = str(resolved.get("display_name", item_str))

    if given <= 0:
        status_message = "No room for %s" % actual_name
    elif remaining > 0:
        status_message = "Gave %s x%d (%d could not fit)" % [actual_name, given, remaining]
    else:
        status_message = "Gave %s x%d" % [actual_name, given]

    _update_status_text()
func _execute_list_command() -> void:
    var count = 1
    var msg = _get_local_player_name() + " (You)"
    for peer_id in peer_states.keys():
        if int(peer_id) == multiplayer.get_unique_id():
            continue
        count += 1
        msg += ", " + str(peer_states[peer_id].get("name", "Peer " + str(peer_id)))
    status_message = "%d players connected\n%s" % [count, msg]
    _update_status_text()


func _format_command_vector3(value: Vector3) -> String:
    return "%0.2f, %0.2f, %0.2f" % [value.x, value.y, value.z]


func _display_connection_status(message: String, show_in_command_console: bool = true) -> void:
    status_message = message
    print("[lucid-blocks-coop] %s" % message)
    _update_status_text()
    if show_in_command_console and Ref.command_chat_manager != null and Ref.command_chat_manager.has_method("display_system_message"):
        Ref.command_chat_manager.display_system_message(message)


func _display_command_response(message: String) -> void:
    status_message = message
    _update_status_text()
    if Ref.command_chat_manager != null and Ref.command_chat_manager.has_method("display_system_message"):
        Ref.command_chat_manager.display_system_message(message)


func _send_command_response(peer_id: int, message: String) -> void:
    if peer_id == multiplayer.get_unique_id():
        _display_command_response(message)
        return
    receive_command_response.rpc_id(peer_id, message)


func _get_server_peer_state_for_command(peer_id: int) -> Dictionary:
    if peer_id == multiplayer.get_unique_id():
        return _capture_local_state()
    var state: Dictionary = peer_states.get(peer_id, {})
    if state.is_empty() and peer_states.has(str(peer_id)):
        state = peer_states[str(peer_id)]
    return state


func _build_server_whoami_report(peer_id: int) -> String:
    var state: Dictionary = _get_server_peer_state_for_command(peer_id)
    var local_state: Dictionary = _capture_local_state()
    var runtime: Dictionary = _get_server_runtime_metrics() if multiplayer.is_server() else {}
    var position: Vector3 = state.get("position", Vector3.ZERO)
    var active_text: String = "yes" if bool(state.get("active", false)) else "no"
    var downed_text: String = "yes" if bool(state.get("downed", false)) else "no"
    var player_key: String = str(state.get("player_key", ""))
    var role_text: String = "admin" if _is_peer_admin(peer_id) else "player"
    var lines: PackedStringArray = PackedStringArray()
    lines.append("whoami(server)")
    lines.append("peer=%s name=%s active=%s downed=%s" % [peer_id, str(state.get("name", "Peer %s" % peer_id)), active_text, downed_text])
    lines.append("role=%s player_key=%s" % [role_text, player_key])
    lines.append("dimension=%s instance=%s pocket_owner=%s" % [int(state.get("dimension", -1)), str(state.get("dimension_instance_key", "")), str(state.get("pocket_owner_key", ""))])
    lines.append("position=%s yaw=%0.1f pitch=%0.1f grounded=%s underwater=%s" % [
        _format_command_vector3(position),
        rad_to_deg(float(state.get("yaw", 0.0))),
        rad_to_deg(float(state.get("pitch", 0.0))),
        "yes" if bool(state.get("grounded", true)) else "no",
        "yes" if bool(state.get("under_water", false)) else "no",
    ])
    lines.append("move_speed=%0.2f held_item_id=%s avatar=%s key=%s" % [
        float(state.get("move_speed", 0.0)),
        int(state.get("held_item_id", -1)),
        str(state.get("avatar_id", DEFAULT_AVATAR_ID)),
        player_key.substr(0, 12) if player_key != "" else "",
    ])
    if not runtime.is_empty():
        lines.append("server players=%s tps=%s health=%s entities=%s drops=%s" % [
            int(runtime.get("players", 0)),
            snappedf(dedicated_current_tps if dedicated_server_enabled else 60.0, 0.1),
            _get_dedicated_tps_health() if dedicated_server_enabled else "host",
            int(runtime.get("entity_count", 0)),
            int(runtime.get("drop_count", 0)),
        ])
    if peer_id == multiplayer.get_unique_id() and not local_state.is_empty():
        lines.append("local_position=%s" % _format_command_vector3(local_state.get("position", Vector3.ZERO)))
    return "\n".join(lines)


func _execute_whoami_command() -> void:
    if multiplayer.is_server() or not _has_live_peer():
        _display_command_response(_build_server_whoami_report(multiplayer.get_unique_id()))
        return
    request_command_whoami.rpc_id(1)
    status_message = "Requesting server player info..."
    _update_status_text()


func _build_coords_report(peer_id: int = 0) -> String:
    var local_position: Vector3 = Ref.player.global_position if is_instance_valid(Ref.player) else Vector3.ZERO
    var lines: PackedStringArray = PackedStringArray()
    lines.append("coords local=%s" % _format_command_vector3(local_position))
    if is_instance_valid(Ref.world):
        lines.append("dimension=%s instance=%s" % [int(Ref.world.current_dimension), get_active_dimension_instance_key()])
    if peer_id > 0:
        var state: Dictionary = _get_server_peer_state_for_command(peer_id)
        if not state.is_empty():
            lines.append("server=%s" % _format_command_vector3(state.get("position", Vector3.ZERO)))
    return "\n".join(lines)


func _execute_coords_command() -> void:
    if multiplayer.is_server() or not _has_live_peer():
        _display_command_response(_build_coords_report(multiplayer.get_unique_id()))
        return
    _display_command_response(_build_coords_report())
    request_command_coords.rpc_id(1)


func _execute_ping_command() -> void:
    if multiplayer.is_server() or not _has_live_peer():
        var health: String = _get_dedicated_tps_health() if dedicated_server_enabled else "host"
        _display_command_response("ping local-server rtt=0ms tps=%0.1f health=%s" % [
            dedicated_current_tps if dedicated_server_enabled else 60.0,
            health,
        ])
        return
    request_command_ping.rpc_id(1, Time.get_ticks_msec())
    status_message = "Pinging server..."
    _update_status_text()


func send_chat_message(text: String) -> void:
    text = _safe_network_text(text)
    if text == "":
        return
    if not multiplayer.has_multiplayer_peer() or multiplayer.get_peers().is_empty():
        # Play singleplayer, just show locally
        if Ref.command_chat_manager != null and Ref.command_chat_manager.has_method("receive_chat_message"):
            Ref.command_chat_manager.receive_chat_message("You", text)
        return

    if multiplayer.is_server():
        _receive_chat_message.rpc(1, text)
    else:
        _request_send_chat_message.rpc_id(1, text)

@rpc("any_peer", "call_remote", "reliable")
func _request_send_chat_message(text: String) -> void:
    if not multiplayer.is_server():
        return
    text = _safe_network_text(text)
    if text == "":
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    _receive_chat_message.rpc(sender_id, text)

@rpc("authority", "call_local", "reliable")
func _receive_chat_message(sender_id: int, text: String) -> void:
    if Ref.command_chat_manager != null and Ref.command_chat_manager.has_method("receive_chat_message"):
        text = _safe_network_text(text)
        if text == "":
            return
        var sender_name: String = str(sender_id)
        if sender_id == multiplayer.get_unique_id():
            sender_name = "You"
        elif peer_states.has(sender_id):
            sender_name = _safe_network_text(str(peer_states[sender_id].get("name", "Peer " + str(sender_id))), 64)
        elif peer_states.has(str(sender_id)):
            sender_name = _safe_network_text(str(peer_states[str(sender_id)].get("name", "Peer " + str(sender_id))), 64)
        elif sender_id == 1:
            sender_name = "Host"
        Ref.command_chat_manager.receive_chat_message(sender_name, text)


@rpc("authority", "call_remote", "reliable")
func sync_server_command_policy(policy: Dictionary) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    active_server_command_policy = _normalize_server_command_policy(policy)


@rpc("authority", "call_remote", "reliable")
func receive_command_response(message: String) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    _display_command_response(_safe_network_text(message, CLIENT_SAFE_MAX_COMMAND_RESPONSE_LENGTH))


@rpc("any_peer", "call_remote", "reliable")
func request_command_whoami() -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    _send_command_response(sender_id, _build_server_whoami_report(sender_id))


@rpc("any_peer", "call_remote", "reliable")
func request_command_coords() -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    _send_command_response(sender_id, _build_coords_report(sender_id))


@rpc("any_peer", "call_remote", "reliable")
func request_command_ping(client_sent_msec: int) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    receive_command_ping.rpc_id(
        sender_id,
        client_sent_msec,
        Time.get_ticks_msec(),
        dedicated_current_tps if dedicated_server_enabled else 60.0,
        _get_dedicated_tps_health() if dedicated_server_enabled else "host"
    )


@rpc("any_peer", "call_remote", "reliable")
func request_admin_builder_command(raw_text: String, target_position: Vector3i, has_target_position: bool) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    _execute_admin_builder_command_authoritative(_safe_network_text(raw_text, CLIENT_SAFE_MAX_COMMAND_RESPONSE_LENGTH), sender_id, target_position, has_target_position)


@rpc("authority", "call_remote", "reliable")
func receive_command_ping(client_sent_msec: int, server_msec: int, server_tps: float, server_health: String) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    server_health = _safe_network_text(server_health, 64)
    server_tps = clampf(server_tps, 0.0, 240.0)
    var now_msec: int = Time.get_ticks_msec()
    var rtt_msec: int = maxi(0, now_msec - client_sent_msec)
    var clock_delta_msec: int = server_msec - client_sent_msec
    _display_command_response("ping server rtt=%dms clock_delta=%dms tps=%0.1f health=%s" % [
        rtt_msec,
        clock_delta_msec,
        server_tps,
        server_health,
    ])


func get_command_autocomplete_entries(raw_text: String) -> Array:
    var text: String = raw_text.lstrip(" \t\r\n")
    var entries: Array = []
    if not text.begins_with("/"):
        return entries

    if text == "/":
        return _get_root_command_autocomplete_entries("")

    var body: String = text.substr(1)
    var has_space: bool = body.contains(" ")
    var command_body: String = body.get_slice(" ", 0).to_lower()
    var argument_body: String = ""
    if has_space:
        argument_body = body.substr(command_body.length() + 1).lstrip(" \t\r\n")

    if not has_space:
        if command_body == "tp":
            return _get_tp_command_autocomplete_entries("")
        if (command_body == "spawnmenu" or command_body == "mobs") and _are_console_debug_commands_enabled():
            return [_make_command_autocomplete_entry("/spawnmenu", "/spawnmenu", "Open the mob spawn browser")]
        return _get_root_command_autocomplete_entries(command_body)

    if _is_core_debug_autocomplete_command(command_body) and not (_are_console_debug_commands_enabled() or _is_local_command_admin()):
        return entries

    match command_body:
        "give":
            return _get_give_command_autocomplete_entries(argument_body)
        "time":
            return _get_time_command_autocomplete_entries(argument_body)
        "weather":
            return _get_weather_command_autocomplete_entries(argument_body)
        "tp":
            return _get_tp_command_autocomplete_entries(argument_body)
        "server-commands", "server_commands", "command-policy", "command_policy":
            return _get_server_commands_autocomplete_entries(argument_body)
        "gamemode", "gm":
            return _get_gamemode_command_autocomplete_entries(argument_body)
        "spawn":
            return _get_spawn_command_autocomplete_entries(argument_body)
        "spawnmenu", "mobs":
            entries.append(_make_command_autocomplete_entry("/spawnmenu", "/spawnmenu", "Open the mob spawn browser"))
        "fill", "floor", "flat", "border", "builder_setup":
            return _get_builder_block_command_autocomplete_entries(command_body, argument_body)
        "peaceful", "daylock":
            return _get_builder_on_off_command_autocomplete_entries(command_body, argument_body)
        "host", "lan":
            entries.append(_make_command_autocomplete_entry(text, text, "Host on the current LAN port"))
        "join":
            entries.append(_make_command_autocomplete_entry(text, text, "Join `ip [port]`"))
        "avatar":
            entries.append(_make_command_autocomplete_entry(text, text, "Set your avatar id"))
    return entries




func _get_give_command_autocomplete_entries(query: String) -> Array:
    var entries = []
    
    var tokens = query.split(" ", false)
    var is_second_arg = tokens.size() > 1 or (tokens.size() == 1 and query.ends_with(" "))
    
    if is_second_arg:
        var amount_str = tokens[0]
        var item_query = ""
        if tokens.size() > 1:
            item_query = tokens[1].to_lower()
            
        var item_map = get_tree().root.get_node_or_null("ItemMap")
        if is_instance_valid(item_map) and "id_to_resource" in item_map:
            for item_id in item_map.id_to_resource.keys():
                var item = item_map.id_to_resource[item_id]
                var raw_name = _get_builder_item_display_name(item, "Unknown")
                var item_name = raw_name.to_lower().replace(" ", "_")
                if item_query == "" or item_name.contains(item_query) or str(item_id).begins_with(item_query):
                    entries.append(_make_command_autocomplete_entry("/give %s %s " % [amount_str, item_name], item_name, raw_name))
                    
            if entries.is_empty() and item_query == "":
                entries.append(_make_command_autocomplete_entry("/give %s " % amount_str, "/give %s <item_name>" % amount_str, "Give an item by name or id"))
        else:
            entries.append(_make_command_autocomplete_entry("/give %s " % amount_str, "/give %s <item_id>" % amount_str, "Give an item"))
        return entries
        
    var lowered_query: String = query.to_lower()
    
    var amounts = ["1", "16", "32", "64", "99"]
    for amt in amounts:
        if lowered_query == "" or amt.begins_with(lowered_query):
            entries.append(_make_command_autocomplete_entry("/give %s " % amt, amt, "Amount"))
            
    if entries.is_empty() and lowered_query == "":
        entries.append(_make_command_autocomplete_entry("/give ", "/give <amount> <item_name>", "Give amount of items"))
    
    return entries
func _get_time_command_autocomplete_entries(query: String) -> Array:
    var options = ["set", "add", "query"]
    if query.to_lower().begins_with("set "):
        options = ["day", "noon", "night", "midnight"]
        var sub_query = query.substr(4).to_lower()
        var entries = []
        for opt in options:
            if opt.begins_with(sub_query):
                entries.append(_make_command_autocomplete_entry("/time set " + opt, opt, "Time target"))
        return entries
        
    var entries = []
    for opt in options:
        if opt.begins_with(query.to_lower()):
            entries.append(_make_command_autocomplete_entry("/time " + opt, opt, "Time action"))
    return entries

func _get_weather_command_autocomplete_entries(query: String) -> Array:
    var options = ["clear", "rain", "thunder"]
    var entries = []
    for opt in options:
        if opt.begins_with(query.to_lower()):
            entries.append(_make_command_autocomplete_entry("/weather " + opt, opt, "Weather type"))
    return entries
func _get_root_command_autocomplete_entries(query: String) -> Array:
    var commands: Array = [
        {"command": "/help", "hint": "List all commands"},
        {"command": "/whoami", "hint": "Show your server-side player state"},
        {"command": "/ping", "hint": "Ping the server"},
        {"command": "/coords", "hint": "Show local and server coordinates"},
        {"command": "/host", "hint": "Host a LAN session"},
        {"command": "/join", "hint": "Join `ip [port]`"},
        {"command": "/steam_host", "hint": "Host through Steam"},
        {"command": "/steam_invite", "hint": "Open Steam invite dialog"},
        {"command": "/steam_join", "hint": "Join `lobby_id` through Steam"},
        {"command": "/tp", "hint": "Teleport to a connected player"},
        {"command": "/char-select", "hint": "Open character select menu"},
        {"command": "/default", "hint": "Use the default white avatar"},
        {"command": "/list", "hint": "List connected players"},
        {"command": "/home", "hint": "Teleport to pocket dimension"},
        {"command": "/server-commands", "hint": "Show or edit server command policy"},
    ]
    if is_avatar_alias_command_enabled():
        commands.append({"command": "/avatar", "hint": "Set your avatar id"})
    if _are_console_debug_commands_enabled() or _is_local_command_admin():
        commands.append_array([
            {"command": "/gamemode", "hint": "Session-only creative or survival"},
            {"command": "/spawn", "hint": "Spawn a mob for testing"},
            {"command": "/spawnmenu", "hint": "Open the mob spawn browser"},
            {"command": "/spawnlist", "hint": "List spawnable mob ids"},
            {"command": "/time", "hint": "Change world time"},
            {"command": "/weather", "hint": "Change world weather"},
            {"command": "/kill", "hint": "Kill yourself"},
            {"command": "/give", "hint": "Give yourself an item"},
            {"command": "/fly", "hint": "Toggle fly mode"},
        ])
    if _is_local_command_admin():
        commands.append_array([
            {"command": "/wand", "hint": "Show builder wand usage"},
            {"command": "/pos1", "hint": "Set builder position 1"},
            {"command": "/pos2", "hint": "Set builder position 2"},
            {"command": "/sel", "hint": "Show current selection"},
            {"command": "/fill", "hint": "Fill selection with a block"},
            {"command": "/clear", "hint": "Clear selection"},
            {"command": "/floor", "hint": "Make a floor in selection"},
            {"command": "/flat", "hint": "Flatten loaded chunks around you"},
            {"command": "/border", "hint": "Build a chunk border wall"},
            {"command": "/peaceful", "hint": "Disable spawning and remove mobs"},
            {"command": "/daylock", "hint": "Keep the world in daytime"},
            {"command": "/builder_setup", "hint": "Creative, peaceful, day, flat spawn"},
        ])
    var lowered_query: String = query.to_lower()
    var entries: Array = []
    for command_entry in commands:
        var command_text: String = str(command_entry.get("command", ""))
        if lowered_query != "" and not command_text.substr(1).to_lower().begins_with(lowered_query):
            continue
        entries.append(_make_command_autocomplete_entry(command_text, command_text, str(command_entry.get("hint", ""))))
    return entries


func _get_tp_command_autocomplete_entries(query: String) -> Array:
    var entries: Array = []
    for target in get_teleport_target_entries(query):
        var label: String = str(target.get("label", target.get("insert", "")))
        var hint: String = str(target.get("hint", "Teleport"))
        entries.append(_make_command_autocomplete_entry("/tp %s" % str(target.get("insert", "")), label, hint))
    if entries.is_empty():
        entries.append(_make_command_autocomplete_entry("/tp ", "/tp <player|x y z>", "Teleport to a player or coordinates"))
    return entries


func _get_server_commands_autocomplete_entries(query: String) -> Array:
    var entries: Array = []
    var tokens: PackedStringArray = query.split(" ", false)
    var actions: PackedStringArray = PackedStringArray(["allow", "deny", "reset"])
    if tokens.size() <= 1 and not query.ends_with(" "):
        var lowered_query: String = query.to_lower()
        for action in actions:
            if lowered_query == "" or action.begins_with(lowered_query):
                entries.append(_make_command_autocomplete_entry("/server-commands %s " % action, action, "Command policy action"))
        return entries
    var action_text: String = tokens[0].to_lower() if tokens.size() > 0 else "allow"
    var command_query: String = tokens[1].to_lower() if tokens.size() > 1 else ""
    if action_text == "reset":
        entries.append(_make_command_autocomplete_entry("/server-commands reset", "reset", "Reset command policy"))
        return entries
    for command_name in DEFAULT_SERVER_COMMAND_POLICY.keys():
        var command_text: String = str(command_name)
        if command_query == "" or command_text.begins_with(command_query):
            entries.append(_make_command_autocomplete_entry("/server-commands %s %s" % [action_text, command_text], command_text, "Set command policy"))
    return entries


func _get_gamemode_command_autocomplete_entries(query: String) -> Array:
    var modes: Array = [
        {"insert": "/gamemode c", "display": "/gamemode c", "hint": "Session creative"},
        {"insert": "/gamemode s", "display": "/gamemode s", "hint": "Session survival"},
    ]
    var lowered_query: String = query.to_lower()
    var entries: Array = []
    for mode_entry in modes:
        var command_text: String = str(mode_entry.get("insert", ""))
        if lowered_query != "" and not command_text.to_lower().contains(lowered_query):
            continue
        entries.append(_make_command_autocomplete_entry(command_text, str(mode_entry.get("display", command_text)), str(mode_entry.get("hint", ""))))
    return entries


func _get_spawn_command_autocomplete_entries(query: String) -> Array:
    var entries: Array = []
    var lowered_query: String = _normalize_debug_spawn_id(query)
    for spawn_id in _get_debug_spawn_ids():
        var spawn_text: String = str(spawn_id)
        if lowered_query != "" and not spawn_text.contains(lowered_query):
            continue
        entries.append(_make_command_autocomplete_entry("/spawn %s" % spawn_text, "/spawn %s" % spawn_text, "Spawn mob"))
    if entries.is_empty():
        entries.append(_make_command_autocomplete_entry("/spawn ", "/spawn <mob_id>", "Use `/spawnlist` for ids"))
    return entries


func _get_builder_block_command_autocomplete_entries(command_body: String, query: String) -> Array:
    var prefix: String = "/" + command_body
    if ["flat", "border", "builder_setup"].has(command_body):
        var tokens: PackedStringArray = query.split(" ", false)
        if tokens.size() <= 1 and not query.ends_with(" "):
            var entries: Array = []
            for radius in ["1", "2", "3", "4"]:
                if query == "" or radius.begins_with(query):
                    entries.append(_make_command_autocomplete_entry("%s %s " % [prefix, radius], radius, "Chunk radius"))
            return entries
        var radius_text: String = tokens[0] if tokens.size() > 0 else "2"
        var block_query: String = tokens[1] if tokens.size() > 1 else ""
        return _get_builder_block_name_suggestions("%s %s " % [prefix, radius_text], block_query)
    return _get_builder_block_name_suggestions(prefix + " ", query)


func _get_builder_block_name_suggestions(prefix: String, query: String) -> Array:
    var entries: Array = []
    var item_map = get_tree().root.get_node_or_null("ItemMap")
    if not is_instance_valid(item_map) or not "id_to_resource" in item_map:
        return entries
    var lowered_query: String = _slugify_string(query)
    for item_id in item_map.id_to_resource.keys():
        var item = item_map.id_to_resource[item_id]
        if not (item is Block):
            continue
        var raw_name: String = _get_builder_item_display_name(item, "Block")
        var block_name: String = _slugify_string(raw_name)
        if lowered_query == "" or block_name.contains(lowered_query) or str(item_id).begins_with(lowered_query):
            entries.append(_make_command_autocomplete_entry("%s%s" % [prefix, block_name], block_name, raw_name))
            if entries.size() >= 32:
                break
    return entries


func _get_builder_on_off_command_autocomplete_entries(command_body: String, query: String) -> Array:
    var entries: Array = []
    for option in ["on", "off"]:
        if query == "" or option.begins_with(query.to_lower()):
            entries.append(_make_command_autocomplete_entry("/%s %s" % [command_body, option], option, "Toggle"))
    return entries


func _make_command_autocomplete_entry(insert_text: String, display_text: String, hint_text: String = "") -> Dictionary:
    return {
        "insert": insert_text,
        "display": display_text,
        "hint": hint_text,
    }


func get_teleport_target_entries(query: String = "") -> Array:
    var lowered_query: String = query.strip_edges().to_lower()
    var entries: Array = []
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        var peer_name: String = str(state.get("name", "Peer %s" % int_peer_id))
        var alias: String = "host" if int_peer_id == 1 else "p%s" % int_peer_id
        var matches_query: bool = lowered_query == "" \
            or alias.to_lower().contains(lowered_query) \
            or str(int_peer_id) == lowered_query \
            or peer_name.to_lower().contains(lowered_query)
        if not matches_query:
            continue
        var same_instance: bool = str(state.get("dimension_instance_key", "")) == get_active_dimension_instance_key()
        entries.append({
            "insert": alias,
            "label": "%s (%s)" % [peer_name, alias],
            "hint": "Teleport %s" % ("now" if same_instance else "after resync"),
            "peer_id": int_peer_id,
        })
    entries.sort_custom(Callable(self, "_sort_peer_autocomplete_entries"))
    return entries


func _sort_peer_autocomplete_entries(a: Dictionary, b: Dictionary) -> bool:
    return int(a.get("peer_id", 0)) < int(b.get("peer_id", 0))


func _execute_gamemode_command(parts: PackedStringArray) -> void:
    if parts.size() < 2:
        status_message = "Usage: /gamemode <c|s>"
        _update_status_text()
        return

    var mode: String = str(parts[1]).strip_edges().to_lower()
    match mode:
        "c", "creative", "1":
            _set_session_creative_mode(true)
        "s", "survival", "0":
            _set_session_creative_mode(false)
        _:
            status_message = "Usage: /gamemode <c|s>"
            _update_status_text()


func _set_session_creative_mode(enabled: bool) -> void:
    if not _can_sample_player() or not is_instance_valid(Ref.main):
        status_message = "Creative mode is unavailable right now"
        _update_status_text()
        return

    Ref.main.creative = enabled
    Ref.player.invincible = enabled
    Ref.player.invincible_temporary = false
    if enabled:
        Ref.player.health = Ref.player.max_health
    else:
        Ref.player.flying = false

    if is_instance_valid(Ref.game_menu) and Ref.game_menu.has_method("update_inventory_screen") and Ref.game_menu.is_inventory_open():
        Ref.game_menu.update_inventory_screen(int(Ref.game_menu.inventory_screen))

    status_message = "Session gamemode: %s" % ("creative" if enabled else "survival")
    _update_status_text()


func _execute_spawn_command(parts: PackedStringArray) -> void:
    if parts.size() < 2:
        status_message = "Usage: /spawn <mob_id>"
        _update_status_text()
        return

    if not _can_sample_player():
        status_message = "Player not ready for spawning"
        _update_status_text()
        return

    var spawn_id: String = _normalize_debug_spawn_id(" ".join(parts.slice(1)).strip_edges())
    if spawn_id == "":
        status_message = "Usage: /spawn <mob_id>"
        _update_status_text()
        return

    var spawn_origin: Vector3 = Ref.player.global_position
    var look_direction: Vector3 = Ref.player.get_look_direction() if Ref.player.has_method("get_look_direction") else -Ref.player.global_basis.z

    if not _has_live_peer() or multiplayer.is_server() or _has_local_guest_entity_authority():
        status_message = _spawn_debug_entity_from_id(spawn_id, spawn_origin, look_direction)
        _update_status_text()
        return

    request_debug_spawn.rpc_id(1, spawn_id, get_active_dimension_instance_key(), spawn_origin, look_direction)
    status_message = "Requested spawn: %s" % spawn_id
    _update_status_text()


func _execute_spawnlist_command() -> void:
    var ids: PackedStringArray = _get_debug_spawn_ids()
    if ids.is_empty():
        status_message = "No spawn ids found"
        _update_status_text()
        return

    var preview_count: int = mini(ids.size(), 10)
    var preview: PackedStringArray = PackedStringArray()
    for i in range(preview_count):
        preview.append(ids[i])
    print("[lucid-blocks-coop-creative] spawn ids: %s" % ", ".join(ids))
    status_message = "Spawn ids (%d): %s%s" % [ids.size(), ", ".join(preview), " ..." if ids.size() > preview_count else ""]
    _update_status_text()


func _execute_spawnmenu_command(parts: PackedStringArray) -> void:
    var initial_query: String = " ".join(parts.slice(1)).strip_edges() if parts.size() > 1 else ""
    toggle_spawn_browser(true, initial_query)


func _normalize_debug_spawn_id(value: String) -> String:
    var normalized: String = value.strip_edges().to_lower().replace("-", "_").replace(" ", "_")
    while normalized.contains("__"):
        normalized = normalized.replace("__", "_")
    return normalized.trim_prefix("_").trim_suffix("_")


func _get_debug_spawn_catalog() -> Dictionary:
    if not debug_spawn_catalog.is_empty():
        return debug_spawn_catalog

    var dir: DirAccess = DirAccess.open(DEBUG_SPAWN_RESOURCE_DIR)
    if dir != null:
        dir.list_dir_begin()
        var file_name: String = dir.get_next()
        while file_name != "":
            if not dir.current_is_dir() and file_name.ends_with(".tres"):
                _register_debug_spawn_resource(file_name)
            file_name = dir.get_next()
        dir.list_dir_end()

    if debug_spawn_catalog.is_empty():
        for spawn_id in DEBUG_SPAWN_FALLBACK_IDS:
            _register_debug_spawn_resource("%s_spawner.tres" % str(spawn_id))
    return debug_spawn_catalog


func _register_debug_spawn_resource(file_name: String) -> void:
    var basename: String = file_name.trim_suffix(".tres")
    if basename.ends_with("_spawner"):
        basename = basename.substr(0, basename.length() - 8)
    elif basename.ends_with("_capsule"):
        basename = basename.substr(0, basename.length() - 8)
    var primary_id: String = _normalize_debug_spawn_id(basename)
    if primary_id == "" or debug_spawn_catalog.has(primary_id):
        return
    var resource_path: String = "%s/%s" % [DEBUG_SPAWN_RESOURCE_DIR, file_name]
    if not ResourceLoader.exists(resource_path):
        var capsule_file_name: String = "%s_capsule.tres" % primary_id
        var capsule_resource_path: String = "%s/%s" % [DEBUG_SPAWN_RESOURCE_DIR, capsule_file_name]
        if ResourceLoader.exists(capsule_resource_path):
            resource_path = capsule_resource_path
        else:
            return
    var resource = load(resource_path)
    if primary_id != "" and resource is Spawner and str(resource.entity_path) != "":
        debug_spawn_catalog[primary_id] = {
            "resource_path": resource_path,
            "scene_path": str(resource.entity_path),
        }


func _get_debug_spawn_ids() -> PackedStringArray:
    var ids: PackedStringArray = PackedStringArray(_get_debug_spawn_catalog().keys())
    ids.sort()
    return ids


func _resolve_debug_spawn_entry(query: String) -> Dictionary:
    var catalog: Dictionary = _get_debug_spawn_catalog()
    if catalog.has(query):
        return catalog[query]

    var matches: Array[String] = []
    for spawn_id in catalog.keys():
        var id_text: String = str(spawn_id)
        if id_text.contains(query):
            matches.append(id_text)
    matches.sort()
    if matches.size() == 1:
        return catalog[matches[0]]
    return {}


func _spawn_debug_entity_from_id(spawn_id: String, spawn_origin: Vector3, look_direction: Vector3) -> String:
    var entry: Dictionary = _resolve_debug_spawn_entry(spawn_id)
    if entry.is_empty():
        return "Unknown spawn id: %s" % spawn_id

    var scene = load(str(entry.get("scene_path", "")))
    if not (scene is PackedScene):
        return "Spawn scene missing for %s" % spawn_id

    var entity = scene.instantiate()
    if not (entity is Entity):
        if entity != null:
            entity.queue_free()
        return "Spawn scene is not an entity: %s" % spawn_id

    var spawn_direction: Vector3 = look_direction
    if spawn_direction.length_squared() <= 0.0001:
        spawn_direction = Vector3.FORWARD
    spawn_direction = spawn_direction.normalized()
    if not entity.spawn_in_water:
        spawn_direction.y = 0.0
        if spawn_direction.length_squared() <= 0.0001:
            spawn_direction = Vector3.FORWARD
        spawn_direction = spawn_direction.normalized()

    var spawn_position: Vector3 = spawn_origin + Vector3(0, 1.25, 0) + spawn_direction * DEBUG_SPAWN_DISTANCE
    if is_instance_valid(Ref.world) and Ref.world.is_position_loaded(spawn_position):
        var attempts: int = 0
        while attempts < 10 and Ref.world.get_block_type_at(spawn_position.floor()).id != 0:
            spawn_position.y += 1.0
            attempts += 1

    entity.global_position = spawn_position
    entity.set_meta("coop_runtime_spawned", true)
    if not multiplayer.is_server():
        entity.set_meta("coop_guest_local_authority", true)
    get_tree().get_root().add_child(entity)
    ensure_runtime_entity_uuid(entity)
    if entity.has_method("allow_swarm"):
        entity.allow_swarm()
    if multiplayer.is_server():
        _assign_sync_uuid(entity)
    return "Spawned %s" % spawn_id


func _execute_tp_command(parts: PackedStringArray) -> void:
    if parts.size() < 2:
        status_message = "Usage: /tp host, /tp <peer>, or /tp <x> <y> <z>"
        _update_status_text()
        return

    if parts.size() >= 4 and parts[1].is_valid_float() and parts[2].is_valid_float() and parts[3].is_valid_float():
        _teleport_local_player_to_coordinates(Vector3(float(parts[1]), float(parts[2]), float(parts[3])))
        return

    var query: String = " ".join(parts.slice(1)).strip_edges()
    var target_peer_id: int = -1
    var target_state: Dictionary = {}

    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue

        var state: Dictionary = peer_states[peer_id]
        var peer_name: String = str(state.get("name", "Peer %s" % int_peer_id))
        if query.to_lower() == "host" and int_peer_id == 1:
            target_peer_id = int_peer_id
            target_state = state
            break
        if query.to_lower() == ("p%s" % int_peer_id).to_lower() or query == str(int_peer_id) or peer_name.to_lower() == query.to_lower() or peer_name.to_lower().contains(query.to_lower()):
            target_peer_id = int_peer_id
            target_state = state
            break

    if target_peer_id == -1:
        status_message = "Peer not found: %s" % query
        _update_status_text()
        return

    if str(target_state.get("dimension_instance_key", "")) != get_active_dimension_instance_key():
        var target_key = str(target_state.get("dimension_instance_key", ""))
        if _open_dimension_instance_from_key(target_key):
            status_message = "Teleporting to peer dimension"
            _update_status_text()
            return

    _teleport_local_player_near(target_state.get("position", Ref.player.global_position))
    status_message = "Teleported to %s" % str(target_state.get("name", "peer %s" % target_peer_id))
    _update_status_text()


func _teleport_local_player_to_coordinates(target_position: Vector3) -> void:
    if not is_instance_valid(Ref.player):
        status_message = "No player"
        _update_status_text()
        return
    Ref.player.global_position = target_position
    if "velocity" in Ref.player:
        Ref.player.velocity = Vector3.ZERO
    if "movement_velocity" in Ref.player:
        Ref.player.movement_velocity = Vector3.ZERO
    if "gravity_velocity" in Ref.player:
        Ref.player.gravity_velocity = Vector3.ZERO
    if "knockback_velocity" in Ref.player:
        Ref.player.knockback_velocity = Vector3.ZERO
    _broadcast_local_state_now()
    if not multiplayer.is_server() and _has_live_peer():
        _send_persistent_state_to_host(true)
    status_message = "Teleported to %s" % _format_command_vector3(target_position)
    _update_status_text()


func _execute_visit_command(parts: PackedStringArray) -> void:
    if parts.size() < 2:
        status_message = "Usage: /visit <peer>"
        _update_status_text()
        return

    var target_state: Dictionary = _find_peer_state_by_query(" ".join(parts.slice(1)).strip_edges())
    if target_state.is_empty():
        status_message = "Peer not found"
        _update_status_text()
        return

    var target_player_key: String = str(target_state.get("player_key", "")).strip_edges()
    if target_player_key == "":
        status_message = "That player has no pocket id yet"
        _update_status_text()
        return

    open_dimension_instance(int(LucidBlocksWorld.Dimension.POCKET), target_player_key)


func _find_peer_state_by_query(query: String) -> Dictionary:
    var lowered_query: String = query.to_lower()
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        var state: Dictionary = peer_states[peer_id]
        var peer_name: String = str(state.get("name", "Peer %s" % int_peer_id))
        if lowered_query == "host" and int_peer_id == 1:
            return state
        if lowered_query == ("p%s" % int_peer_id).to_lower() or lowered_query == str(int_peer_id) or peer_name.to_lower() == lowered_query or peer_name.to_lower().contains(lowered_query):
            return state
    return {}


func _is_client_gameplay_locked() -> bool:
    return not multiplayer.is_server() and (reconnect_pending or client_restore_in_progress or receiving_host_world or not guest_persistent_ready or is_local_player_fake_dead() or is_local_player_downed())


func _next_client_block_action_id() -> int:
    client_block_action_sequence += 1
    if client_block_action_sequence >= 2147480000:
        client_block_action_sequence = 1
    return client_block_action_sequence


func _remember_client_block_action(request_id: int, action: String, block_position: Vector3i, block_id: int = 0, inventory = null, inventory_index: int = -1, inventory_snapshot: Dictionary = {}) -> void:
    if request_id <= 0:
        return
    client_pending_block_actions[request_id] = {
        "action": action,
        "position": block_position,
        "block_id": block_id,
        "inventory": inventory,
        "inventory_index": inventory_index,
        "inventory_snapshot": inventory_snapshot,
        "created_ms": Time.get_ticks_msec(),
    }


func _forget_client_block_action(request_id: int) -> Dictionary:
    var action: Dictionary = client_pending_block_actions.get(request_id, {})
    client_pending_block_actions.erase(request_id)
    return action


func _rollback_client_block_action(request_id: int, action_name: String, block_position: Vector3i, block_id: int) -> void:
    var pending_action: Dictionary = _forget_client_block_action(request_id)
    if action_name == "place":
        if is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position):
            var current_block = Ref.world.get_block_type_at(block_position)
            if current_block != null and int(current_block.id) == block_id:
                _apply_network_break(block_position)
        _restore_inventory_snapshot(pending_action.get("inventory_snapshot", {}))
        _request_authoritative_block_resync(block_position)
        return
    elif action_name == "break" or action_name == "foliage":
        if block_id > 0 and is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position):
            _apply_network_place(block_position, block_id)
        _request_authoritative_block_resync(block_position)

    # Keep block rollback local. Full world snapshot reloads are too disruptive during live play.


func _request_authoritative_block_resync(block_position: Vector3i) -> void:
    if multiplayer.is_server() or not _has_live_peer():
        return
    request_block_resync.rpc_id(1, get_active_dimension_instance_key(), block_position)


func _commit_client_block_action(request_id: int, action_name: String) -> void:
    var pending_action: Dictionary = _forget_client_block_action(request_id)
    if pending_action.is_empty():
        return
    if action_name != "place":
        return
    if not pending_action.get("inventory_snapshot", {}).is_empty():
        return
    var inventory = pending_action.get("inventory", null)
    var inventory_index: int = int(pending_action.get("inventory_index", -1))
    var block_id: int = int(pending_action.get("block_id", 0))
    if inventory == null or inventory_index < 0 or not is_instance_valid(inventory):
        return
    if inventory_index >= inventory.items.size():
        return
    var item_state = inventory.items[inventory_index]
    if item_state == null or int(item_state.id) != block_id or int(item_state.count) <= 0:
        return
    inventory.change_amount(inventory_index, -1)


func _get_pending_block_place_reservations(inventory, inventory_index: int, block_id: int) -> int:
    if inventory == null or inventory_index < 0:
        return 0
    var count: int = 0
    for pending_action in client_pending_block_actions.values():
        if not (pending_action is Dictionary):
            continue
        if str(pending_action.get("action", "")) != "place":
            continue
        if pending_action.get("inventory", null) != inventory:
            continue
        if int(pending_action.get("inventory_index", -1)) != inventory_index:
            continue
        if int(pending_action.get("block_id", 0)) != block_id:
            continue
        count += 1
    return count


func _can_reserve_client_block_place(inventory, inventory_index: int, block_id: int) -> bool:
    if inventory == null or inventory_index < 0 or not is_instance_valid(inventory):
        return false
    if inventory_index >= inventory.items.size():
        return false
    var item_state = inventory.items[inventory_index]
    if item_state == null or int(item_state.id) != block_id:
        return false
    var available_count: int = int(item_state.count) - _get_pending_block_place_reservations(inventory, inventory_index, block_id)
    return available_count > 0


func _next_client_item_action_id() -> int:
    client_item_action_sequence += 1
    if client_item_action_sequence >= 2147480000:
        client_item_action_sequence = 1
    return client_item_action_sequence


func _remember_client_item_action(request_id: int, action: String, item_signature: String = "", item_uuid: String = "", inventory_snapshot: Dictionary = {}, inventory_snapshots: Array = [], drop_snapshot: Dictionary = {}, predicted_drop = null) -> void:
    if request_id <= 0:
        return
    client_pending_item_actions[request_id] = {
        "action": action,
        "item_signature": item_signature,
        "item_uuid": item_uuid,
        "inventory_snapshot": inventory_snapshot,
        "inventory_snapshots": inventory_snapshots,
        "drop_snapshot": drop_snapshot,
        "predicted_drop": predicted_drop,
        "created_ms": Time.get_ticks_msec(),
    }


func _forget_client_item_action(request_id: int) -> Dictionary:
    var action: Dictionary = client_pending_item_actions.get(request_id, {})
    client_pending_item_actions.erase(request_id)
    return action


func capture_inventory_snapshot(inventory) -> Dictionary:
    return _snapshot_inventory(inventory)


func _snapshot_inventory(inventory) -> Dictionary:
    if inventory == null or not is_instance_valid(inventory):
        return {}
    return {
        "inventory": inventory,
        "capacity": int(inventory.capacity),
        "items": _serialize_inventory_items(inventory),
    }


func _restore_inventory_snapshot(snapshot: Dictionary) -> void:
    if snapshot.is_empty():
        return
    var inventory = snapshot.get("inventory", null)
    if inventory == null or not is_instance_valid(inventory):
        return
    var capacity: int = int(snapshot.get("capacity", inventory.capacity))
    if capacity > 0 and inventory.capacity != capacity:
        inventory.capacity = capacity
    var serialized_items: Array = snapshot.get("items", [])
    _apply_serialized_inventory_items(inventory, serialized_items)


func _restore_inventory_snapshots(snapshots: Array) -> void:
    for snapshot in snapshots:
        if snapshot is Dictionary:
            _restore_inventory_snapshot(snapshot)


func _snapshot_pickup_inventories(pickup_behavior) -> Array:
    var snapshots: Array = []
    if pickup_behavior == null or not is_instance_valid(pickup_behavior):
        return snapshots
    var inventory_priority = pickup_behavior.inventory_priority
    if inventory_priority != null and is_instance_valid(inventory_priority):
        snapshots.append(_snapshot_inventory(inventory_priority))
    var inventory_secondary = pickup_behavior.inventory_secondary
    if inventory_secondary != null and is_instance_valid(inventory_secondary) and inventory_secondary != inventory_priority:
        snapshots.append(_snapshot_inventory(inventory_secondary))
    return snapshots


func _remove_pending_pickup_receipt_signature(signature: String) -> void:
    if signature == "":
        return
    for index in range(pending_pickup_receipts.size() - 1, -1, -1):
        var receipt = pending_pickup_receipts[index]
        if receipt is Dictionary and str(receipt.get("signature", "")) == signature:
            pending_pickup_receipts.remove_at(index)


func _restore_failed_pickup_drop(pending_action: Dictionary, item_uuid: String) -> void:
    var drop_snapshot: Dictionary = pending_action.get("drop_snapshot", {})
    if drop_snapshot.is_empty():
        return
    if item_uuid != "":
        var live_drop = synced_dropped_items.get(item_uuid, null)
        if is_instance_valid(live_drop):
            if live_drop.has_meta("coop_pickup_pending_request"):
                live_drop.set_meta("coop_pickup_pending_request", false)
            return

    var item_data: PackedInt32Array = drop_snapshot.get("item_data", PackedInt32Array())
    var item_state = _deserialize_item_state(item_data)
    if item_state == null:
        return
    var position: Vector3 = drop_snapshot.get("position", Vector3.ZERO)
    var velocity: Vector3 = drop_snapshot.get("velocity", Vector3.ZERO)
    _spawn_client_predicted_drop(item_state, position, velocity, true, false)


func _rollback_client_item_action(request_id: int, action_name: String, item_uuid: String = "") -> void:
    var pending_action: Dictionary = _forget_client_item_action(request_id)
    if pending_action.is_empty():
        return
    var signature: String = str(pending_action.get("item_signature", ""))
    if action_name == "drop":
        _restore_inventory_snapshot(pending_action.get("inventory_snapshot", {}))
        var predicted_drop = pending_action.get("predicted_drop", null)
        if is_instance_valid(predicted_drop):
            predicted_drop.queue_free()
    elif action_name == "pickup":
        _restore_inventory_snapshots(pending_action.get("inventory_snapshots", []))
        _remove_pending_pickup_receipt_signature(signature)
        var effective_uuid: String = item_uuid
        if effective_uuid == "":
            effective_uuid = str(pending_action.get("item_uuid", ""))
        if effective_uuid != "":
            client_collected_drop_uuids.erase(effective_uuid)
        _restore_failed_pickup_drop(pending_action, effective_uuid)


func sync_local_block_place(block_position: Vector3i, block_id: int, inventory, inventory_index: int) -> bool:
    if not _has_live_peer():
        return false

    if multiplayer.is_server():
        _apply_network_place(block_position, block_id)
        _record_server_block_journal(multiplayer.get_unique_id(), 0, "place", get_active_dimension_instance_key(), block_position, block_id)
        if inventory != null:
            inventory.change_amount(inventory_index, -1)
        sync_place_block.rpc(get_active_dimension_instance_key(), block_position, block_id, _get_living_block_scene_path(block_id))
        return true

    if _is_local_world_authority():
        return false
    if _is_client_gameplay_locked():
        return false
    if not _can_reserve_client_block_place(inventory, inventory_index, block_id):
        status_message = "No block available"
        _update_status_text()
        return true

    var request_id: int = _next_client_block_action_id()
    var inventory_snapshot: Dictionary = _snapshot_inventory(inventory)
    inventory.change_amount(inventory_index, -1)
    _apply_network_place(block_position, block_id)
    _remember_client_block_action(request_id, "place", block_position, block_id, inventory, inventory_index, inventory_snapshot)
    request_place_block.rpc_id(
        1,
        get_active_dimension_instance_key(),
        block_position,
        block_id,
        _capture_guest_block_action_patch(block_position),
        request_id
    )
    return true


func sync_local_block_break(break_behavior, block_position: Vector3i) -> bool:
    if not _has_live_peer():
        return false
    if break_behavior == null or break_behavior.entity != Ref.player:
        return false
    if _is_local_world_authority():
        return false
    if multiplayer.is_server():
        return false
    if _is_client_gameplay_locked():
        return false

    var broken_block = break_behavior.block
    if broken_block == null and is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position):
        broken_block = Ref.world.get_block_type_at(block_position)
    _apply_client_break_feedback(break_behavior, block_position)
    _predict_client_break_drops_for_block(
        broken_block,
        block_position,
        bool(break_behavior.pickaxe),
        bool(break_behavior.axe),
        bool(break_behavior.shovel),
        bool(break_behavior.meat),
        bool(break_behavior.plant)
    )
    _apply_network_break(block_position)
    var request_id: int = _next_client_block_action_id()
    _remember_client_block_action(request_id, "break", block_position, broken_block.id if broken_block != null else 0)
    request_break_block.rpc_id(
        1,
        get_active_dimension_instance_key(),
        block_position,
        broken_block.id if broken_block != null else 0,
        bool(break_behavior.pickaxe),
        bool(break_behavior.axe),
        bool(break_behavior.shovel),
        bool(break_behavior.meat),
        bool(break_behavior.plant),
        _capture_guest_block_action_patch(block_position),
        request_id
    )
    return true


func broadcast_host_block_break(block_position: Vector3i, broken_block_id: int = 0) -> void:
    if not _has_live_peer() or not multiplayer.is_server():
        return
    _record_server_block_journal(multiplayer.get_unique_id(), 0, "break", get_active_dimension_instance_key(), block_position, broken_block_id)
    sync_break_block.rpc(
        get_active_dimension_instance_key(),
        block_position,
        _is_living_block_id(broken_block_id) or _find_saved_preserve_uuid_at_block_position(block_position) != ""
    )


func broadcast_host_world_changes(block_changes: Array, fire_changes: Array) -> void:
    if not _has_live_peer() or not multiplayer.is_server():
        return
    if block_changes.is_empty() and fire_changes.is_empty():
        return

    var dimension_instance_key: String = get_active_dimension_instance_key()
    for entry in block_changes:
        if not (entry is Array) or entry.size() < 2:
            continue
        var block_position: Vector3i = entry[0]
        var block_id: int = int(entry[1])
        _record_server_block_journal(multiplayer.get_unique_id(), 0, "place" if block_id > 0 else "break", dimension_instance_key, block_position, block_id)
    for entry in fire_changes:
        if not (entry is Array) or entry.size() < 2:
            continue
        _record_server_world_cell_journal(multiplayer.get_unique_id(), 0, "fire", dimension_instance_key, entry[0], {"fire_level": int(entry[1])})

    sync_world_changes.rpc(get_active_dimension_instance_key(), block_changes, fire_changes)


func sync_host_attack_on_remote_player(attacker: Entity, target, damage_position: Vector3, damage: int, knockback_strength: float, fly_strength: float, fire_aspect: bool) -> bool:
    if not multiplayer.is_server() or not _has_live_peer() or not is_remote_player_proxy(target):
        return false

    var peer_id: int = get_remote_player_proxy_peer_id(target)
    if peer_id <= 1:
        return false

    receive_remote_player_attack.rpc_id(
        peer_id,
        _get_sync_uuid(attacker) if is_instance_valid(attacker) else "",
        _get_safe_node3d_global_position(attacker, Vector3.ZERO),
        get_attack_impulse_velocity(attacker) if is_instance_valid(attacker) else Vector3.ZERO,
        damage_position,
        maxi(1, damage),
        knockback_strength,
        fly_strength,
        fire_aspect
    )
    return true


func _begin_target_direct_damage_cooldown(target, duration: float = CLIENT_ENTITY_HIT_COOLDOWN_SEC) -> void:
    if target == null or not is_instance_valid(target):
        return
    if target.has_method("begin_direct_damage_cooldown"):
        target.begin_direct_damage_cooldown(duration)
        return
    if _object_has_property(target, "direct_damage_cooldown"):
        target.set("direct_damage_cooldown", true)
    var direct_damage_timer := target.get_node_or_null("DirectDamageTimer") as Timer
    if direct_damage_timer != null:
        direct_damage_timer.start(duration)


func sync_host_direct_hit_on_remote_player(attacker: Entity, target, damage_position: Vector3, damage: int, knockback_delta: Vector3, fire_aspect: bool = false) -> bool:
    if not multiplayer.is_server() or not _has_live_peer() or not is_remote_player_proxy(target):
        return false
    if damage == 0:
        return false

    var peer_id: int = get_remote_player_proxy_peer_id(target)
    if peer_id <= 1:
        return false

    _begin_target_direct_damage_cooldown(target)

    receive_remote_player_direct_hit.rpc_id(
        peer_id,
        _get_sync_uuid(attacker) if is_instance_valid(attacker) else "",
        _get_safe_node3d_global_position(attacker, Vector3.ZERO),
        knockback_delta,
        damage_position,
        damage,
        fire_aspect
    )
    return true


func sync_local_attack_on_remote_player(attacker: Entity, target, damage_position: Vector3, damage: int, knockback_strength: float, fly_strength: float, fire_aspect: bool) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or attacker == null or not is_instance_valid(attacker) or target == null or not is_instance_valid(target):
        return false
    if _is_local_world_authority() or _is_client_gameplay_locked() or not is_remote_player_proxy(target):
        return false

    var target_peer_id: int = get_remote_player_proxy_peer_id(target)
    if target_peer_id <= 0:
        return false

    _begin_target_direct_damage_cooldown(target)
    request_player_attack.rpc_id(1, target_peer_id, damage_position, maxi(1, damage), knockback_strength, fly_strength, fire_aspect)
    return true


func sync_local_attack_on_entity(attacker: Entity, target, damage_position: Vector3, damage: int, knockback_strength: float, fly_strength: float, fire_aspect: bool) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or attacker == null or not is_instance_valid(attacker) or target == null or not is_instance_valid(target):
        return false
    if _is_local_world_authority() or _is_client_gameplay_locked():
        return false
    if not (target is Entity) or target is Player or is_remote_player_proxy(target):
        return false

    var target_uuid: String = _get_sync_uuid(target)
    if target_uuid == "":
        target_uuid = ensure_runtime_entity_uuid(target)
    if target_uuid == "":
        return false

    var actual_damage: int = maxi(1, damage)
    var predicted_attacker_velocity: Vector3 = Vector3.ZERO
    var knockback_velocity: Vector3 = calculate_attack_knockback_velocity(target, attacker.global_position, predicted_attacker_velocity, knockback_strength, fly_strength)
    _predict_client_entity_knockback(target_uuid, target, knockback_velocity)
    _play_client_entity_hit_feedback(target, attacker, damage_position, actual_damage)

    if attacker.held_item != null and attacker.held_item.item is Tool:
        attacker.decrease_held_item_durability(1)

    request_entity_attack.rpc_id(1, target_uuid, damage_position, actual_damage, knockback_strength, fly_strength, fire_aspect)
    return true


func sync_local_drop_item(item_state, spawn_position: Vector3, launch_velocity: Vector3, inventory_snapshot: Dictionary = {}) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or item_state == null:
        return false
    if _is_local_world_authority():
        return false
    if _is_client_gameplay_locked():
        return false

    var item_data: PackedInt32Array = _serialize_item_state(item_state)
    var request_id: int = _next_client_item_action_id()
    _remember_client_item_action(
        request_id,
        "drop",
        _item_data_signature(item_data),
        "",
        inventory_snapshot,
        [],
        {},
        null
    )
    request_drop_item.rpc_id(1, item_data, spawn_position, launch_velocity, request_id)
    return true


func sync_local_pickup_item(dropped_item) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or dropped_item == null:
        return false
    if _is_local_world_authority():
        return false
    if _is_client_gameplay_locked():
        return false

    if is_instance_valid(dropped_item) and not dropped_item.can_collect:
        return true

    var item_uuid: String = _get_sync_uuid(dropped_item)
    if item_uuid == "":
        if bool(dropped_item.get_meta("coop_predicted_drop", false)):
            # Wait for the server-spawned drop UUID before allowing pickup.
            # Otherwise a predicted local drop can be collected and then arrive again from the host.
            if is_instance_valid(dropped_item):
                dropped_item.can_collect = false
            return true
        return false

    var item_state = dropped_item.item.duplicate() if dropped_item.item != null else null
    var request_id: int = _next_client_item_action_id()
    var inventory_snapshots: Array = []
    var drop_snapshot: Dictionary = {
        "item_data": _serialize_item_state(item_state),
        "position": dropped_item.global_position if is_instance_valid(dropped_item) else Vector3.ZERO,
        "velocity": dropped_item.velocity if is_instance_valid(dropped_item) and dropped_item is DroppedItem else Vector3.ZERO,
    }
    _remember_client_item_action(
        request_id,
        "pickup",
        _item_state_signature(item_state),
        item_uuid,
        {},
        inventory_snapshots,
        drop_snapshot
    )

    if is_instance_valid(dropped_item) and dropped_item.can_collect:
        dropped_item.set_meta("coop_pickup_pending_request", true)
        synced_dropped_items.erase(item_uuid)
        client_collected_drop_uuids[item_uuid] = Time.get_ticks_msec()
        _begin_client_drop_collect_animation(dropped_item)

    request_pickup_drop.rpc_id(1, item_uuid, request_id)
    return true


func play_local_host_drop_collect_animation(collector, dropped_item) -> bool:
    if not multiplayer.is_server() or not _has_live_peer():
        return false
    if collector == null or dropped_item == null or not is_instance_valid(dropped_item):
        return false
    if not _can_sample_player() or collector != Ref.player:
        return false
    if bool(dropped_item.get_meta("coop_collect_anim_started", false)):
        return true
    if dropped_item is DroppedItem and dropped_item.state == DroppedItem.COLLECTED:
        return true

    dropped_item.set_meta("coop_pickup_pending_request", true)
    _begin_client_drop_collect_animation(dropped_item)
    return true


func sync_local_water_cells(changes: Array) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or _is_local_world_authority() or changes.is_empty():
        return false
    if _is_client_gameplay_locked():
        return false
    var changed_positions: Array = []
    for entry in changes:
        if entry is Array and entry.size() >= 1:
            changed_positions.append(entry[0])
    request_water_cells.rpc_id(
        1,
        get_active_dimension_instance_key(),
        changes,
        _capture_local_chunk_patch_for_world_positions(changed_positions)
    )
    return true


func sync_local_fire_cell(block_position: Vector3i, fire_level: int) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or _is_local_world_authority():
        return false
    if _is_client_gameplay_locked():
        return false
    request_fire_cell.rpc_id(
        1,
        get_active_dimension_instance_key(),
        block_position,
        fire_level,
        _capture_local_chunk_patch_for_world_positions([block_position])
    )
    return true


func sync_local_ignite_entity(target) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or _is_local_world_authority():
        return false
    if _is_client_gameplay_locked() or target == null or not is_instance_valid(target):
        return false
    if is_remote_player_proxy(target):
        return false
    if not target.has_node("%Burn"):
        return false

    var target_uuid: String = _get_sync_uuid(target)
    if target_uuid == "":
        return false

    target.get_node("%Burn").ignite()
    request_ignite_entity.rpc_id(1, target_uuid)
    return true


func sync_local_bolt_throw(start_position: Vector3, direction: Vector3) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or _is_local_world_authority():
        return false
    if _is_client_gameplay_locked():
        return false

    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return false

    _spawn_client_visual_bolt(start_position, normalized_direction)
    request_guest_bolt_throw.rpc_id(1, start_position, normalized_direction)
    return true


func sync_local_explosive_throw(scene_path: String, start_position: Vector3, linear_velocity: Vector3) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or _is_local_world_authority():
        return false
    if _is_client_gameplay_locked():
        return false

    var normalized_path: String = scene_path.strip_edges()
    if normalized_path == "":
        return false

    request_guest_explosive_throw.rpc_id(1, normalized_path, start_position, linear_velocity)
    return true


func sync_local_capsule_throw(item_id: int, start_position: Vector3, linear_velocity: Vector3) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or _is_local_world_authority():
        return false
    if _is_client_gameplay_locked():
        return false
    if item_id <= 0:
        return false

    request_guest_capsule_throw.rpc_id(1, item_id, start_position, linear_velocity)
    return true


func sync_local_foliage_break(block_position: Vector3i) -> bool:
    if not _has_live_peer() or multiplayer.is_server() or _is_local_world_authority():
        return false
    if _is_client_gameplay_locked():
        return false

    var block: Block = Ref.world.get_block_type_at(block_position)
    _apply_network_break(block_position)
    var request_id: int = _next_client_block_action_id()
    _remember_client_block_action(request_id, "foliage", block_position, block.id if block != null else 0)
    request_foliage_break.rpc_id(
        1,
        get_active_dimension_instance_key(),
        block_position,
        block.id if block != null else 0,
        _capture_local_chunk_patch_for_world_positions([block_position]),
        request_id
    )
    return true


func _cleanup_client_prediction_state() -> void:
    if multiplayer.is_server():
        return

    var now_ms: int = Time.get_ticks_msec()

    for request_id in client_pending_block_actions.keys().duplicate():
        var pending_action: Dictionary = client_pending_block_actions.get(request_id, {})
        var created_ms: int = int(pending_action.get("created_ms", 0))
        if created_ms > 0 and now_ms - created_ms > 30000:
            print("[lucid-blocks-coop] Block action %s timed out; rolling back local reservation." % request_id)
            _rollback_client_block_action(
                request_id,
                str(pending_action.get("action", "")),
                pending_action.get("position", Vector3i.ZERO),
                int(pending_action.get("block_id", 0))
            )

    for request_id in client_pending_item_actions.keys().duplicate():
        var pending_item_action: Dictionary = client_pending_item_actions.get(request_id, {})
        var created_item_ms: int = int(pending_item_action.get("created_ms", 0))
        if created_item_ms > 0 and now_ms - created_item_ms > 10000:
            print("[lucid-blocks-coop] Item action %s timed out; rolling back local prediction." % request_id)
            _rollback_client_item_action(request_id, str(pending_item_action.get("action", "")), str(pending_item_action.get("item_uuid", "")))

    for uuid in client_collected_drop_uuids.keys().duplicate():
        if now_ms - int(client_collected_drop_uuids[uuid]) > 10000:
            client_collected_drop_uuids.erase(uuid)
    for child in _get_live_tracked_drops():
        if not (child is DroppedItem):
            continue
        if not bool(child.get_meta("coop_predicted_drop", false)):
            continue
        var created_ms: int = int(child.get_meta("coop_predicted_created_ms", 0))
        if created_ms > 0 and now_ms - created_ms > int(CLIENT_PREDICTED_DROP_LIFETIME * 1000.0):
            child.call_deferred("queue_free")

    if not pending_pickup_receipts.is_empty():
        var live_receipts: Array = []
        for receipt in pending_pickup_receipts:
            if not (receipt is Dictionary):
                continue
            var created_ms: int = int(receipt.get("created_ms", 0))
            if created_ms <= 0 or now_ms - created_ms <= int(CLIENT_PENDING_PICKUP_LIFETIME * 1000.0):
                live_receipts.append(receipt)
        pending_pickup_receipts = live_receipts

    for child in _get_live_tracked_entities():
        if not is_client_synced_entity(child):
            continue
        var cooldown_until_ms: int = int(child.get_meta("coop_predicted_direct_damage_until_ms", 0))
        if cooldown_until_ms > 0 and cooldown_until_ms <= now_ms:
            child.remove_meta("coop_predicted_direct_damage_until_ms")
            if _object_has_property(child, "direct_damage_cooldown"):
                child.set("direct_damage_cooldown", false)


func _queue_pending_pickup_receipt(item_state) -> void:
    var signature: String = _item_state_signature(item_state)
    if signature == "":
        return
    pending_pickup_receipts.append({
        "signature": signature,
        "created_ms": Time.get_ticks_msec(),
    })


func _consume_pending_pickup_receipt(item_state) -> bool:
    var signature: String = _item_state_signature(item_state)
    if signature == "":
        return false

    for index in range(pending_pickup_receipts.size()):
        var receipt: Dictionary = pending_pickup_receipts[index]
        if str(receipt.get("signature", "")) != signature:
            continue
        pending_pickup_receipts.remove_at(index)
        return true
    return false


func _item_data_signature(item_data: PackedInt32Array) -> String:
    if item_data.is_empty():
        return ""

    var signature: String = ""
    for index in range(item_data.size()):
        if index > 0:
            signature += ":"
        signature += str(int(item_data[index]))
    return signature


func _item_state_signature(item_state) -> String:
    return _item_data_signature(_serialize_item_state(item_state))


func _drop_matches_pending_pickup_receipt(dropped_item) -> bool:
    if dropped_item == null or not is_instance_valid(dropped_item) or not (dropped_item is DroppedItem) or dropped_item.item == null:
        return false

    var signature: String = _item_state_signature(dropped_item.item)
    if signature == "":
        return false

    for receipt in pending_pickup_receipts:
        if str(receipt.get("signature", "")) == signature:
            return true
    return false


func _get_client_pickup_target_position() -> Vector3:
    if not _can_sample_player():
        return Vector3.ZERO
    if is_instance_valid(Ref.player.head):
        return Ref.player.head.global_position - Vector3(0.0, 0.35, 0.0)
    return Ref.player.global_position + CLIENT_PICKUP_PULL_OFFSET


func _begin_client_drop_collect_animation(dropped_item) -> void:
    if dropped_item == null or not is_instance_valid(dropped_item):
        return
    if bool(dropped_item.get_meta("coop_collect_anim_started", false)):
        return
    dropped_item.set_meta("coop_collect_anim_started", true)
    _play_client_drop_collect_animation.call_deferred(dropped_item)


func _play_client_drop_collect_animation(dropped_item) -> void:
    if dropped_item == null or not is_instance_valid(dropped_item):
        return
    if dropped_item is DroppedItem and dropped_item.state == DroppedItem.COLLECTED:
        return

    var target_position: Vector3 = _get_client_pickup_target_position()
    if dropped_item is DroppedItem:
        dropped_item.can_collect = false
        dropped_item.can_merge = false
        dropped_item.disabled = false
        dropped_item.velocity = Vector3.ZERO
        dropped_item.toggle_physics(false)

    var tween: Tween = get_tree().create_tween()
    tween.tween_property(dropped_item, "global_position", target_position, CLIENT_PICKUP_PULL_ANIMATION_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    await tween.finished

    if dropped_item == null or not is_instance_valid(dropped_item):
        return
    if dropped_item is DroppedItem and dropped_item.state == DroppedItem.COLLECTED:
        return
    if dropped_item.has_method("collect"):
        dropped_item.collect()
        return
    dropped_item.queue_free()


func _animate_client_drop_collect_removal(dropped_item) -> void:
    if dropped_item == null or not is_instance_valid(dropped_item):
        return

    dropped_item.set_meta("coop_merge_cleanup_pending", true)
    if dropped_item is DroppedItem:
        if dropped_item.state == DroppedItem.COLLECTED:
            return
        _begin_client_drop_collect_animation(dropped_item)
        return
    dropped_item.queue_free()


func _mark_client_predicted_drop(dropped_item, item_state) -> void:
    if dropped_item == null:
        return

    dropped_item.set_meta("coop_predicted_drop", true)
    dropped_item.set_meta("coop_predicted_created_ms", Time.get_ticks_msec())
    dropped_item.set_meta("coop_predicted_item_signature", _item_state_signature(item_state))
    dropped_item.set_meta("coop_drop_snapshot_initialized", true)
    dropped_item.set_meta("coop_pickup_pending_request", false)
    if dropped_item is DroppedItem:
        dropped_item.can_collect = false
        dropped_item.can_merge = false
        dropped_item.disabled = false
        dropped_item.is_collect_delayed = false
        dropped_item.is_merge_delayed = false
        dropped_item.set_physics_process(true)


func _spawn_client_predicted_drop(item_state, spawn_position: Vector3, launch_velocity: Vector3 = Vector3.ZERO, use_launch_velocity: bool = false, delay_collect: bool = false, initialize_existing: bool = false):
    if item_state == null:
        return null

    var scene = load(DROPPED_ITEM_SCENE_PATH)
    if not (scene is PackedScene):
        return null

    var dropped_item = scene.instantiate()
    if dropped_item == null:
        return null

    get_tree().get_root().add_child(dropped_item)
    if delay_collect and dropped_item.has_method("delay_collect"):
        dropped_item.delay_collect()
    dropped_item.global_position = spawn_position + (Vector3(0.5, 0.5, 0.5) if initialize_existing else Vector3.ZERO)
    dropped_item.initialize(item_state, initialize_existing)
    if use_launch_velocity:
        dropped_item.global_position = spawn_position + Vector3(0.5, 0.5, 0.5)
        dropped_item.velocity = launch_velocity
    elif initialize_existing and dropped_item is DroppedItem:
        dropped_item.velocity = Vector3.ZERO
        dropped_item.state = DroppedItem.IDLE
        dropped_item.toggle_physics(true)
    _mark_client_predicted_drop(dropped_item, item_state)
    return dropped_item


func _predict_client_break_drops_for_block(block, block_position: Vector3i, pickaxe: bool, axe: bool, shovel: bool, meat: bool, plant: bool) -> void:
    if block == null:
        return
    if block.pickaxe_required and not pickaxe:
        return
    if block.axe_required and not axe:
        return
    if block.drop_loot != null:
        return

    var to_drop: Array[ItemState] = []
    if block.drop_item == null:
        if not block.can_drop:
            return
        var default_state := ItemState.new()
        default_state.initialize(block)
        default_state.count = 1
        to_drop.append(default_state)
    else:
        var explicit_state := ItemState.new()
        explicit_state.initialize(block.drop_item)
        explicit_state.count = 1
        to_drop.append(explicit_state)

    for dropped_state in to_drop:
        _spawn_client_predicted_drop(dropped_state, Vector3(block_position), Vector3.ZERO, false, false, true)


func _find_matching_predicted_drop(item_state, drop_position: Vector3, match_distance: float = CLIENT_PREDICTED_DROP_MATCH_DISTANCE):
    var signature: String = _item_state_signature(item_state)
    if signature == "":
        return null

    var nearest = null
    var nearest_distance_squared: float = match_distance * match_distance
    for child in _get_live_tracked_drops():
        if not (child is DroppedItem):
            continue
        if not bool(child.get_meta("coop_predicted_drop", false)):
            continue
        if str(child.get_meta("coop_predicted_item_signature", "")) != signature:
            continue

        var distance_squared: float = child.global_position.distance_squared_to(drop_position)
        if distance_squared > nearest_distance_squared:
            continue
        nearest = child
        nearest_distance_squared = distance_squared
    return nearest


func _is_client_drop_within_pickup_radius(dropped_item) -> bool:
    if not _can_sample_player() or dropped_item == null or not is_instance_valid(dropped_item):
        return false
    if Ref.player.dead or Ref.player.disabled:
        return false
    return dropped_item.global_position.distance_squared_to(Ref.player.global_position) <= CLIENT_AUTO_PICKUP_RADIUS * CLIENT_AUTO_PICKUP_RADIUS


func _attempt_client_auto_pickup_drop(dropped_item) -> void:
    if multiplayer.is_server() or dropped_item == null or not is_instance_valid(dropped_item):
        return
    if not dropped_item.can_collect:
        return
    if bool(dropped_item.get_meta("coop_pickup_pending_request", false)):
        return
    if not _is_client_drop_within_pickup_radius(dropped_item):
        return

    sync_local_pickup_item(dropped_item)


func _find_client_drop_merge_target(dropped_item):
    if dropped_item == null or not is_instance_valid(dropped_item) or dropped_item.item == null:
        return null

    var nearest = null
    var nearest_distance_squared: float = CLIENT_DROP_MERGE_ANIMATION_DISTANCE * CLIENT_DROP_MERGE_ANIMATION_DISTANCE
    for other in _get_live_tracked_drops():
        if other == dropped_item or not (other is DroppedItem) or not is_instance_valid(other):
            continue
        if other.item == null or other.state == DroppedItem.COLLECTED:
            continue
        if other.item.id != dropped_item.item.id:
            continue
        var distance_squared: float = dropped_item.global_position.distance_squared_to(other.global_position)
        if distance_squared > nearest_distance_squared:
            continue
        nearest = other
        nearest_distance_squared = distance_squared
    return nearest


func _animate_client_drop_merge_removal(dropped_item) -> void:
    if dropped_item == null or not is_instance_valid(dropped_item):
        return
    var merge_target = _find_client_drop_merge_target(dropped_item)
    if merge_target == null or not is_instance_valid(merge_target):
        dropped_item.queue_free()
        return

    dropped_item.set_meta("coop_merge_cleanup_pending", true)
    if dropped_item is DroppedItem:
        dropped_item.disabled = true
        dropped_item.can_collect = false
        dropped_item.can_merge = false
        dropped_item.toggle_collision(false)
    var tween: Tween = get_tree().create_tween()
    tween.tween_property(dropped_item, "global_position", merge_target.global_position, CLIENT_DROP_MERGE_ANIMATION_TIME)
    await tween.finished
    if is_instance_valid(dropped_item):
        dropped_item.queue_free()


func _should_keep_client_entity_area_active(area: Area3D) -> bool:
    return area != null and ((int(area.collision_layer) & 16) != 0 or str(area.name) == "InteractArea3D")


func _can_share_loaded_world() -> bool:
    if dedicated_server_enabled:
        return _can_share_dedicated_loaded_world()
    return is_instance_valid(Ref.main) and is_instance_valid(Ref.world) and Ref.main.loaded and Ref.world.load_enabled and Ref.save_file_manager.loaded_file_register != null and Ref.save_file_manager.loaded_file != null


func _can_share_dedicated_loaded_world() -> bool:
	return dedicated_server_enabled and is_instance_valid(Ref.world) and Ref.world.load_enabled and Ref.save_file_manager.loaded_file_register != null and Ref.save_file_manager.loaded_file != null


func _mark_host_contact() -> void:
    last_host_contact_time = Time.get_ticks_msec()


func _has_host_timed_out() -> bool:
    if multiplayer.is_server() or not _has_live_peer() or local_quit_in_progress:
        return false
    if last_host_contact_time <= 0:
        return false
    var timeout_seconds: float = HOST_TIMEOUT_SECONDS * (3.0 if (receiving_host_world or client_restore_in_progress) else 1.0)
    return (Time.get_ticks_msec() - last_host_contact_time) > int(timeout_seconds * 1000.0)


func _has_pending_host_periodic_autosave() -> bool:
    return deferred_host_autosave_pending or autosave_timer >= AUTOSAVE_INTERVAL


func _should_defer_host_periodic_autosave() -> bool:
    # Full world saves serialize a lot of scene state and hitch active co-op sessions.
    return has_connected_remote_peers()


func _get_host_autosave_manager():
    if not is_instance_valid(Ref.main):
        return null
    return Ref.main.get_node_or_null("%AutosaveManager")


func _can_run_host_periodic_autosave_now() -> bool:
    if autosave_in_progress or not multiplayer.is_server() or _should_defer_host_periodic_autosave():
        return false
    if not _has_pending_host_periodic_autosave():
        return false

    var autosave_manager = _get_host_autosave_manager()
    if autosave_manager != null and autosave_manager.has_method("can_save"):
        return bool(autosave_manager.call("can_save"))

    if get_tree() == null or get_tree().paused or not _can_share_loaded_world() or not _can_sample_player():
        return false
    return not Ref.player.is_interacting() and not Ref.player.disabled and not Ref.player.dead


func _autosave_host_world_if_needed() -> void:
    if autosave_in_progress or local_fake_death_pending or handling_host_respawn or host_respawning or not multiplayer.is_server() or not _can_share_loaded_world():
        return
    _run_host_autosave.call_deferred()


func _flush_pending_remote_world_changes() -> void:
    if multiplayer.is_server() or not _has_live_peer() or not _can_sample_player() or not is_instance_valid(Ref.world):
        return

    for block_position in pending_remote_block_changes.keys().duplicate():
        if not Ref.world.is_position_loaded(block_position):
            continue
        var block_id: int = int(pending_remote_block_changes[block_position])
        pending_remote_block_changes.erase(block_position)
        if block_id <= 0:
            _apply_loaded_network_break(block_position)
        else:
            _apply_loaded_network_place(block_position, block_id)

    for block_position in pending_remote_water_changes.keys().duplicate():
        if not Ref.world.is_position_loaded(block_position):
            continue
        var water_level: int = int(pending_remote_water_changes[block_position])
        pending_remote_water_changes.erase(block_position)
        Ref.world.place_water_at(block_position, water_level)
        if Ref.world.has_method("queue_coop_dynamic_visual_refresh"):
            Ref.world.queue_coop_dynamic_visual_refresh(1)

    for block_position in pending_remote_fire_changes.keys().duplicate():
        if not Ref.world.is_position_loaded(block_position):
            continue
        var fire_level: int = int(pending_remote_fire_changes[block_position])
        pending_remote_fire_changes.erase(block_position)
        Ref.world.place_fire_at(block_position, fire_level)
        if Ref.world.has_method("queue_coop_dynamic_visual_refresh"):
            Ref.world.queue_coop_dynamic_visual_refresh(1)

    for block_position in pending_remote_storage_changes.keys().duplicate():
        if not Ref.world.is_position_loaded(block_position):
            continue
        var serialized_items: Array = pending_remote_storage_changes[block_position]
        pending_remote_storage_changes.erase(block_position)
        _apply_storage_inventory_snapshot(block_position, serialized_items)


func _run_host_autosave() -> void:
    if autosave_in_progress or local_fake_death_pending or handling_host_respawn or host_respawning or not multiplayer.is_server() or not _can_share_loaded_world():
        return

    autosave_in_progress = true
    var autosave_started_msec: int = Time.get_ticks_msec()
    if dedicated_server_enabled:
        print("[lucid-blocks-coop] Dedicated autosave started.")
    await Ref.save_file_manager.save_file(true)
    if dedicated_server_enabled:
        _compact_server_chunk_journal_after_save()
        _seal_loaded_server_world_if_needed()
    autosave_in_progress = false
    var autosave_elapsed_msec: int = Time.get_ticks_msec() - autosave_started_msec
    if dedicated_server_enabled:
        print("[lucid-blocks-coop] Dedicated autosave finished in %d ms." % autosave_elapsed_msec)
    elif autosave_elapsed_msec >= 150:
        print("[lucid-blocks-coop] host autosave took %d ms" % autosave_elapsed_msec)


func _run_host_dirty_chunk_flush() -> void:
    if not dedicated_server_enabled or server_dirty_chunk_keys.is_empty():
        return
    if autosave_in_progress or local_fake_death_pending or handling_host_respawn or host_respawning or not multiplayer.is_server() or not _can_share_loaded_world():
        return

    autosave_in_progress = true
    var dirty_count: int = server_dirty_chunk_keys.size()
    var started_msec: int = Time.get_ticks_msec()
    print("[lucid-blocks-coop] Dedicated dirty chunk flush started dirty_chunks=%d journal_seq=%d." % [
        dirty_count,
        server_chunk_journal_sequence,
    ])
    await Ref.save_file_manager.save_file(true)
    _compact_server_chunk_journal_after_save()
    _seal_loaded_server_world_if_needed()
    autosave_in_progress = false
    print("[lucid-blocks-coop] Dedicated dirty chunk flush finished in %d ms." % (Time.get_ticks_msec() - started_msec))


func _flush_dedicated_dirty_chunks_before_snapshot(reason: String = "snapshot") -> void:
    if not dedicated_server_enabled or not multiplayer.is_server() or server_dirty_chunk_keys.is_empty():
        return
    var deadline_msec: int = Time.get_ticks_msec() + 5000
    while autosave_in_progress and Time.get_ticks_msec() < deadline_msec:
        await get_tree().process_frame
    if autosave_in_progress or server_dirty_chunk_keys.is_empty():
        return
    print("[lucid-blocks-coop] Dedicated dirty chunk flush requested before %s dirty_chunks=%d" % [
        reason,
        server_dirty_chunk_keys.size(),
    ])
    await _run_host_dirty_chunk_flush()


func _capture_local_state() -> Dictionary:
    var state: Dictionary = {
        "active": false,
        "downed": false,
        "dimension": -1,
        "position": Vector3.ZERO,
        "yaw": 0.0,
        "pitch": 0.0,
        "crouching": false,
        "grounded": true,
        "move_speed": 0.0,
        "held_item_id": -1,
        "under_water": false,
        "action_state": 0,
        "name": _get_local_player_name(),
        "player_key": _get_local_player_key(),
        "avatar_id": _normalize_avatar_id(str(config.get("avatar_id", DEFAULT_AVATAR_ID))),
        "skin_color": _get_local_skin_color(),
        "pocket_owner_key": "",
        "dimension_instance_key": "",
        "breaking": false,
        "break_position": Vector3i.ZERO,
        "break_block_id": 0,
        "break_progress": 0.0,
        "dedicated_server": dedicated_server_enabled,
    }

    if not _can_sample_player():
        return state

    if dedicated_server_enabled:
        state["name"] = "Dedicated Server"
        state["active"] = false
        state["dimension"] = int(Ref.world.current_dimension) if is_instance_valid(Ref.world) else -1
        state["pocket_owner_key"] = get_active_pocket_owner_key()
        state["dimension_instance_key"] = get_active_dimension_instance_key()
        state["position"] = get_world_load_center(Ref.player.global_position)
        state["avatar_id"] = "server"
        return state

    var rotation_pivot: Node3D = _get_rotation_pivot()
    var camera: Camera3D = Ref.player.get_node_or_null("%Camera3D") as Camera3D
    state["downed"] = local_downed
    if multiplayer.is_server():
        state["active"] = not (local_fake_death_pending or host_respawning)
    else:
        state["active"] = guest_persistent_ready and not receiving_host_world and not is_local_player_fake_dead()
    if local_downed:
        state["active"] = true
    state["dimension"] = int(Ref.world.current_dimension)
    state["pocket_owner_key"] = get_active_pocket_owner_key()
    state["dimension_instance_key"] = get_active_dimension_instance_key()
    state["position"] = Ref.player.global_position
    state["yaw"] = rotation_pivot.rotation.y if rotation_pivot != null else Ref.player.rotation.y
    state["pitch"] = camera.rotation.x if camera != null else 0.0
    state["crouching"] = Ref.player.is_crouching
    state["grounded"] = not Ref.player.in_air
    state["move_speed"] = Vector3(Ref.player.velocity.x, 0.0, Ref.player.velocity.z).length()
    state["under_water"] = Ref.player.under_water
    var held_item_state = Ref.player.held_item_inventory.items[Ref.player.held_item_index]
    state["held_item_id"] = held_item_state.id if held_item_state != null else -1
    state["action_state"] = _get_local_action_state()
    state.merge(_get_local_break_state(), true)
    return state


func _capture_local_state_for_send() -> Dictionary:
    var state: Dictionary = _capture_local_state()
    local_state_sequence += 1
    state["sequence"] = local_state_sequence
    return state


func get_local_avatar_id() -> String:
    if not is_avatar_customization_enabled():
        return DEFAULT_AVATAR_ID
    return _normalize_avatar_id(str(config.get("avatar_id", DEFAULT_AVATAR_ID)))


func _refresh_local_hand_color() -> void:
    if not is_instance_valid(Ref.player):
        return
    var hand_node: Node = Ref.player.get_node_or_null("%PlayerHand")
    if hand_node != null and hand_node.has_method("set_hand_color"):
        hand_node.call("set_hand_color")


func _refresh_local_avatar_sounds() -> void:
    if not is_instance_valid(Ref.player):
        return
    if Ref.player.has_method("_apply_avatar_sound_overrides"):
        Ref.player.call("_apply_avatar_sound_overrides")


func _normalize_avatar_id(raw_avatar_id: String) -> String:
    var normalized: String = raw_avatar_id.strip_edges().to_lower()
    return normalized if normalized != "" else DEFAULT_AVATAR_ID


func _get_local_player_name() -> String:
    var steam_name: String = str(Steamworks.get_username())
    if steam_name.strip_edges() != "":
        return steam_name
    var configured_name: String = str(config.get("mock_player_name", "")).strip_edges()
    if configured_name != "":
        return configured_name
    return "Peer %s" % multiplayer.get_unique_id()


func _get_local_player_key_suffix() -> String:
    var raw_suffix: String = ""
    if OS is Object:
        raw_suffix = str(OS.get_environment("COOP_PLAYER_KEY_SUFFIX")).strip_edges()
        if raw_suffix == "":
            var compat_data_path: String = str(OS.get_environment("STEAM_COMPAT_DATA_PATH")).strip_edges().to_lower()
            if compat_data_path.ends_with("/lucid-blocks-coop-second"):
                raw_suffix = "second"

    return _slugify_string(raw_suffix)


func _get_local_player_key() -> String:
    var suffix: String = _get_local_player_key_suffix()
    var steam_id: int = _get_local_steam_id()
    if steam_id > 0:
        var steam_key: String = "steam_%s" % steam_id
        return "%s__%s" % [steam_key, suffix] if suffix != "" else steam_key

    var mock_key: String = "mock_%s" % _get_or_create_mock_player_id()
    print("[lucid-blocks-coop] Steam id unavailable, using mock player key %s" % mock_key)
    return "%s__%s" % [mock_key, suffix] if suffix != "" else mock_key


func _get_or_create_mock_player_id() -> String:
    var existing: String = _slugify_string(str(config.get("mock_player_id", "")))
    if existing != "":
        return existing

    var generated: String = _slugify_string(UUID.v4())
    if generated == "":
        generated = "peer_%s_%s" % [multiplayer.get_unique_id(), Time.get_unix_time_from_system()]
        generated = _slugify_string(generated)

    config["mock_player_id"] = generated
    _save_config()
    return generated


func _slugify_string(raw_text: String) -> String:
    var normalized: String = raw_text.strip_edges().to_lower()
    var output: PackedStringArray = []
    for character in normalized:
        var unicode_value: int = character.unicode_at(0)
        var is_digit: bool = unicode_value >= 48 and unicode_value <= 57
        var is_lower: bool = unicode_value >= 97 and unicode_value <= 122
        if is_digit or is_lower:
            output.append(character)
        elif output.is_empty() or output[-1] != "_":
            output.append("_")

    var slug: String = "".join(output).strip_edges()
    return slug.trim_prefix("_").trim_suffix("_")


func _get_loaded_register_pocket_owner_key() -> String:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file_register == null:
        return ""
    return str(Ref.save_file_manager.loaded_file_register.get_data("pocket_owner_key", "")).strip_edges()


func _copy_world_namespace_between_save_data(source_save_data: Dictionary, target_save_data: Dictionary, source_prefix: String, target_prefix: String) -> bool:
    var source_root: Variant = source_save_data.get(source_prefix + "world", null)
    if not (source_root is Dictionary):
        return false

    var source_world: Dictionary = source_root
    if source_world.is_empty():
        return false

    var target_world: Dictionary = {}
    for suffix in ["chunk_block", "chunk_water", "chunk_water_awake", "chunk_fire"]:
        var source_key: String = source_prefix + suffix
        if not source_world.has(source_key):
            continue
        var target_key: String = target_prefix + suffix
        var entry: Variant = source_world[source_key]
        target_world[target_key] = entry.duplicate(true)

    if target_world.is_empty():
        return false

    target_save_data[target_prefix + "world"] = target_world
    return true


func _duplicate_world_namespace(save_data: Dictionary, source_prefix: String, target_prefix: String) -> bool:
    return _copy_world_namespace_between_save_data(save_data, save_data, source_prefix, target_prefix)


func _migrate_legacy_pocket_save_to_owner_if_needed(target_dimension: int, target_pocket_owner_key: String) -> void:
    if target_dimension != int(LucidBlocksWorld.Dimension.POCKET):
        return
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null:
        return
    if _has_live_peer() and not multiplayer.is_server():
        return

    var local_player_key: String = _get_local_player_key()
    var target_owner_key: String = target_pocket_owner_key.strip_edges()
    if target_owner_key == "" or target_owner_key != local_player_key:
        return

    var legacy_prefix: String = _resolve_dimension_namespace(int(LucidBlocksWorld.Dimension.POCKET), "") + "_"
    var owned_prefix: String = _resolve_dimension_namespace(int(LucidBlocksWorld.Dimension.POCKET), target_owner_key) + "_"
    var save_data: Dictionary = Ref.save_file_manager.loaded_file.data
    if save_data.has(owned_prefix + "world"):
        return
    if not _duplicate_world_namespace(save_data, legacy_prefix, owned_prefix):
        return

    var legacy_respawns: Variant = Ref.save_file_manager.loaded_file.get_data("%s/respawn_positions" % _resolve_dimension_namespace(int(LucidBlocksWorld.Dimension.POCKET), ""), null)
    if legacy_respawns != null:
        SaveFile._set_data(save_data, "%s/respawn_positions" % _resolve_dimension_namespace(int(LucidBlocksWorld.Dimension.POCKET), target_owner_key), legacy_respawns.duplicate(true))


func _migrate_loaded_legacy_pocket_to_local_owner_if_needed() -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null or Ref.save_file_manager.loaded_file_register == null:
        return
    if not is_instance_valid(Ref.world) or int(Ref.world.current_dimension) != int(LucidBlocksWorld.Dimension.POCKET):
        return
    if _get_loaded_register_pocket_owner_key() != "":
        return
    if _has_live_peer() and not multiplayer.is_server():
        return

    var local_player_key: String = _get_local_player_key()
    if local_player_key == "":
        return

    _migrate_legacy_pocket_save_to_owner_if_needed(int(LucidBlocksWorld.Dimension.POCKET), local_player_key)
    Ref.save_file_manager.loaded_file_register.set_data("pocket_owner_key", local_player_key, true)
    if _has_live_peer():
        call_deferred("_broadcast_local_state_now")


func _persist_current_owned_pocket_variants_if_needed() -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null:
        return
    if not is_instance_valid(Ref.world) or int(Ref.world.current_dimension) != int(LucidBlocksWorld.Dimension.POCKET):
        return

    var owner_key: String = _get_loaded_register_pocket_owner_key()
    var local_player_key: String = _get_local_player_key()
    if owner_key == "" or local_player_key == "" or owner_key != local_player_key:
        return

    var save_data: Dictionary = Ref.save_file_manager.loaded_file.data
    var owned_namespace: String = _resolve_dimension_namespace(int(LucidBlocksWorld.Dimension.POCKET), owner_key)
    var legacy_namespace: String = _resolve_dimension_namespace(int(LucidBlocksWorld.Dimension.POCKET), "")
    Ref.world.save_data(save_data, owned_namespace + "_")
    Ref.world.save_data(save_data, legacy_namespace + "_")
    SaveFile._set_data(save_data, owned_namespace + "/respawn_positions", Ref.world.respawn_positions.duplicate(true))
    SaveFile._set_data(save_data, legacy_namespace + "/respawn_positions", Ref.world.respawn_positions.duplicate(true))


func get_active_pocket_owner_key() -> String:
    if not _can_sample_player() or not _is_private_instance_dimension(int(Ref.world.current_dimension)):
        return ""

    var owner_key: String = _get_loaded_register_pocket_owner_key()
    return owner_key


func get_dimension_instance_key(dimension: int, pocket_owner_key: String = "") -> String:
    if dimension == int(LucidBlocksWorld.Dimension.POCKET):
        var owner_key: String = pocket_owner_key.strip_edges()
        return "pocket:%s" % (owner_key if owner_key != "" else "legacy")
    if _is_private_instance_dimension(dimension):
        var owner_key: String = pocket_owner_key.strip_edges()
        if owner_key != "":
            return "dimension:%s:%s" % [dimension, owner_key]
    return "dimension:%s" % dimension


func _resolve_dimension_namespace(dimension: int, pocket_owner_key: String = "") -> String:
    var dimension_namespace: String = SaveFile.DIMENSION_MAP.get(dimension, "unknown")
    if _is_private_instance_dimension(dimension) and pocket_owner_key.strip_edges() != "":
        dimension_namespace = "%s__%s" % [dimension_namespace, pocket_owner_key.strip_edges()]
    return dimension_namespace


func get_active_dimension_instance_key() -> String:
    if not _can_sample_player():
        return ""
    return get_dimension_instance_key(int(Ref.world.current_dimension), get_active_pocket_owner_key())


func _get_host_dimension_instance_key() -> String:
    if peer_states.has(1):
        return str(peer_states[1].get("dimension_instance_key", ""))
    return ""


func _can_push_local_world_state_to_host() -> bool:
    if SERVER_AUTHORITATIVE_WORLD:
        return false
    return not multiplayer.is_server() and _has_live_peer() and _can_sample_player() and _is_local_world_authority()


func _can_transmit_pending_local_world_patch_to_host() -> bool:
    if SERVER_AUTHORITATIVE_WORLD:
        return false
    return not multiplayer.is_server() and _has_live_peer() and _can_sample_player()


func _clear_pending_local_world_patch_state() -> void:
    local_world_patch_timer = 0.0
    pending_local_world_patch_chunks.clear()
    pending_local_world_patch_dimension = -1
    pending_local_world_patch_pocket_owner_key = ""
    pending_local_world_patch_instance_key = ""


func notify_local_world_state_dirty(world_positions: Array = []) -> void:
    if world_positions.is_empty():
        if _can_push_local_world_state_to_host():
            _flush_pending_local_world_patch_to_host(true)
        return

    if multiplayer.is_server() and (dedicated_server_enabled or _has_live_peer()):
        var dimension_instance_key: String = get_active_dimension_instance_key()
        for world_position in world_positions:
            if world_position is Vector3i:
                _record_server_current_cell_journal(multiplayer.get_unique_id(), dimension_instance_key, world_position)
            elif world_position is Vector3:
                _record_server_current_cell_journal(multiplayer.get_unique_id(), dimension_instance_key, Vector3i(world_position))
        return

    _queue_local_world_patch_for_world_positions(world_positions)


func _queue_local_world_patch_for_world_positions(world_positions: Array) -> void:
    if not _can_push_local_world_state_to_host():
        return

    var chunk_positions: Array = _get_unique_chunk_positions_for_world_positions(world_positions)
    _queue_local_world_patch_for_chunk_positions(chunk_positions)


func _queue_local_world_patch_for_chunk_positions(chunk_positions: Array) -> void:
    if not _can_push_local_world_state_to_host() or chunk_positions.is_empty():
        return

    var dimension: int = int(Ref.world.current_dimension)
    var pocket_owner_key: String = get_active_pocket_owner_key()
    var dimension_instance_key: String = get_dimension_instance_key(dimension, pocket_owner_key)
    if pending_local_world_patch_instance_key != "" and pending_local_world_patch_instance_key != dimension_instance_key:
        _flush_pending_local_world_patch_to_host(true)

    if pending_local_world_patch_instance_key != dimension_instance_key:
        pending_local_world_patch_dimension = dimension
        pending_local_world_patch_pocket_owner_key = pocket_owner_key
        pending_local_world_patch_instance_key = dimension_instance_key

    for chunk_position in chunk_positions:
        pending_local_world_patch_chunks[chunk_position] = true

    local_world_patch_timer = 0.0


func _flush_pending_local_world_patch_to_host(force_immediate: bool = false) -> void:
    if pending_local_world_patch_chunks.is_empty():
        local_world_patch_timer = 0.0
        return
    if not _can_transmit_pending_local_world_patch_to_host():
        return
    if not force_immediate and local_world_patch_timer < LOCAL_WORLD_PATCH_FLUSH_INTERVAL:
        return

    var chunk_positions: Array = pending_local_world_patch_chunks.keys()
    var world_patch: Dictionary = _capture_local_chunk_patch_for_chunk_positions(chunk_positions, true)
    _clear_pending_local_world_patch_state()
    if world_patch.is_empty():
        return

    submit_guest_world_patch.rpc_id(1, world_patch)


func _send_full_local_world_patch_to_host() -> void:
    if not _can_transmit_pending_local_world_patch_to_host():
        return

    _clear_pending_local_world_patch_state()
    var world_patch: Dictionary = _capture_local_world_patch()
    if world_patch.is_empty():
        return

    submit_guest_world_patch.rpc_id(1, world_patch)


func _get_peer_ids_in_instance(instance_key: String) -> Array:
    var peer_ids: Array = []
    if instance_key == "":
        return peer_ids

    for peer_id in multiplayer.get_peers():
        var int_peer_id: int = int(peer_id)
        var state: Dictionary = peer_states.get(int_peer_id, {})
        if _is_peer_state_same_instance(state, instance_key):
            peer_ids.append(int_peer_id)

    return peer_ids


func _await_guest_world_patch_flush_for_instance(instance_key: String) -> void:
    if not multiplayer.is_server() or not _has_live_peer() or instance_key == "":
        return

    var peer_ids: Array = _get_peer_ids_in_instance(instance_key)
    if peer_ids.is_empty():
        return

    guest_world_patch_flush_request_counter += 1
    var request_id: int = guest_world_patch_flush_request_counter
    var pending_acks: Dictionary = {}
    pending_guest_world_patch_flush_acks[request_id] = pending_acks
    for peer_id in peer_ids:
        pending_acks[int(peer_id)] = true
        request_guest_world_patch_flush.rpc_id(int(peer_id), request_id, instance_key)

    var deadline_ms: int = Time.get_ticks_msec() + int(GUEST_WORLD_PATCH_FLUSH_TIMEOUT_SEC * 1000.0)
    while pending_guest_world_patch_flush_acks.has(request_id) and Time.get_ticks_msec() < deadline_ms:
        await get_tree().process_frame

    pending_guest_world_patch_flush_acks.erase(request_id)


func _send_requested_dimension_world_snapshot(sender_id: int, target_dimension: int, target_pocket_owner_key: String) -> void:
    if sender_id <= 0:
        return

    var target_instance_key: String = get_dimension_instance_key(target_dimension, target_pocket_owner_key)
    if multiplayer.is_server() and _has_live_peer() and target_instance_key != get_active_dimension_instance_key():
        await _await_guest_world_patch_flush_for_instance(target_instance_key)

    _send_world_snapshot_to_peer.call_deferred(sender_id, target_dimension, target_pocket_owner_key, false)


func _is_local_world_authority() -> bool:
    if multiplayer.is_server():
        return true
    if reconnect_pending or client_restore_in_progress:
        return false
    if not _has_live_peer():
        return true
        
    var host_state = peer_states.get(1, {})
    if not host_state.is_empty() and not _does_peer_state_match_instance(host_state, get_active_dimension_instance_key()):
        return true
        
    return false


func _get_nearest_other_same_instance_player_distance(fallback_distance: float = INF) -> float:
    if not _can_sample_player() or not _has_live_peer():
        return fallback_distance

    var active_instance_key: String = get_active_dimension_instance_key()
    var nearest_distance: float = INF
    var local_peer_id: int = multiplayer.get_unique_id()
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == local_peer_id:
            continue
        var state: Dictionary = peer_states.get(int_peer_id, {})
        if not _is_peer_state_same_instance(state, active_instance_key):
            continue
        var peer_position: Vector3 = state.get("position", Vector3.ZERO)
        nearest_distance = minf(nearest_distance, Ref.player.global_position.distance_to(peer_position))

    return nearest_distance if nearest_distance < INF else fallback_distance


func _has_local_guest_entity_authority() -> bool:
    if multiplayer.is_server() or reconnect_pending or client_restore_in_progress:
        return false
    if not _can_sample_player() or not _has_live_peer() or is_local_player_fake_dead() or is_local_player_downed():
        return false

    var nearest_other_player_distance: float = _get_nearest_other_same_instance_player_distance()
    if nearest_other_player_distance >= INF:
        return false

    var required_distance: float = GUEST_LOCAL_ENTITY_AUTHORITY_DISTANCE
    if last_local_entity_authority and not _is_local_world_authority():
        required_distance = GUEST_LOCAL_ENTITY_RELEASE_DISTANCE

    return nearest_other_player_distance > required_distance


func _has_local_entity_authority() -> bool:
    return _is_local_world_authority() or _has_local_guest_entity_authority()


func has_local_entity_authority() -> bool:
    return _has_local_entity_authority()


func can_use_same_instance_load_proxies() -> bool:
    return multiplayer.is_server() \
        and is_instance_valid(Ref.world) \
        and Ref.world.has_method("uses_coop_multi_region_loading") \
        and bool(Ref.world.call("uses_coop_multi_region_loading"))


func has_connected_remote_peers() -> bool:
    if multiplayer.multiplayer_peer == null:
        return false
    if multiplayer.is_server():
        return multiplayer.multiplayer_peer.get_peers().size() > 0
    return _has_live_peer()


func _refresh_world_authority_mode() -> void:
    if not _can_sample_player():
        return
    var has_world_authority: bool = _is_local_world_authority()
    var has_entity_authority: bool = _has_local_entity_authority()
    if not multiplayer.is_server() and last_local_world_authority and not has_world_authority:
        _flush_pending_local_world_patch_to_host(true)
    Ref.world.simulate_enabled = has_world_authority

    if not multiplayer.is_server() and has_entity_authority != last_local_entity_authority:
        client_world_sync_ready = false
        if has_entity_authority:
            _promote_host_synced_entities_to_local_authority()
        else:
            _send_local_authoritative_entities_to_host(true)
            _clear_local_guest_authoritative_runtime()

    if not multiplayer.is_server() and is_instance_valid(Ref.entity_spawner) and has_entity_authority != last_local_entity_authority:
        if has_entity_authority:
            Ref.entity_spawner.start_spawning()
        else:
            Ref.entity_spawner.stop_spawning()

    last_local_world_authority = has_world_authority
    last_local_entity_authority = has_entity_authority


func _set_host_runtime_process_mode(node: Node, active: bool) -> void:
    if node == null or not is_instance_valid(node):
        return

    if active:
        if not node.has_meta("coop_host_original_process_mode"):
            node.set_meta("coop_host_original_process_mode", int(node.process_mode))
        node.process_mode = Node.PROCESS_MODE_ALWAYS
    elif node.has_meta("coop_host_original_process_mode"):
        node.process_mode = int(node.get_meta("coop_host_original_process_mode", int(Node.PROCESS_MODE_INHERIT)))
        node.remove_meta("coop_host_original_process_mode")

    if node is Timer:
        var timer := node as Timer
        if active:
            if not timer.has_meta("coop_host_original_timer_process_callback"):
                timer.set_meta("coop_host_original_timer_process_callback", int(timer.process_callback))
            timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
        elif timer.has_meta("coop_host_original_timer_process_callback"):
            timer.process_callback = int(timer.get_meta("coop_host_original_timer_process_callback", int(Timer.TIMER_PROCESS_IDLE)))
            timer.remove_meta("coop_host_original_timer_process_callback")

    for child in node.get_children():
        _set_host_runtime_process_mode(child, active)


func _set_host_background_runtime_node(node: Node, active: bool) -> void:
    if node == null or not is_instance_valid(node) or not node.is_inside_tree():
        return

    _set_host_runtime_process_mode(node, active)
    if active:
        node.set_process(true)
        node.set_physics_process(true)


func _should_force_host_background_runtime() -> bool:
    return multiplayer.is_server() \
        and _has_live_peer() \
        and (dedicated_server_enabled or not DisplayServer.window_is_focused())


func _set_host_entity_activity_override(entity: Entity, active: bool) -> void:
    if entity == null or not is_instance_valid(entity) or not entity.is_inside_tree():
        return

    if _object_has_property(entity, "disabled_by_visibility"):
        if active:
            if not entity.has_meta("coop_host_original_disabled_by_visibility"):
                entity.set_meta("coop_host_original_disabled_by_visibility", bool(entity.get("disabled_by_visibility")))
            entity.set("disabled_by_visibility", false)
        elif entity.has_meta("coop_host_original_disabled_by_visibility"):
            entity.set("disabled_by_visibility", bool(entity.get_meta("coop_host_original_disabled_by_visibility", true)))
            entity.remove_meta("coop_host_original_disabled_by_visibility")

    _set_host_runtime_process_mode(entity, active)

    var visible_enabler: VisibleOnScreenEnabler3D = entity.get_node_or_null("%VisibleOnScreenEnabler3D") as VisibleOnScreenEnabler3D
    if visible_enabler != null:
        if active:
            if not visible_enabler.has_meta("coop_host_original_enable_node_path"):
                visible_enabler.set_meta("coop_host_original_enable_node_path", str(visible_enabler.enable_node_path))
            if not visible_enabler.has_meta("coop_host_original_process_mode"):
                visible_enabler.set_meta("coop_host_original_process_mode", int(visible_enabler.process_mode))
            visible_enabler.enable_node_path = ""
            visible_enabler.process_mode = Node.PROCESS_MODE_DISABLED
        else:
            visible_enabler.enable_node_path = str(visible_enabler.get_meta("coop_host_original_enable_node_path", ".."))
            visible_enabler.process_mode = int(visible_enabler.get_meta("coop_host_original_process_mode", int(Node.PROCESS_MODE_INHERIT)))
            visible_enabler.remove_meta("coop_host_original_enable_node_path")
            visible_enabler.remove_meta("coop_host_original_process_mode")

    if active:
        entity.disabled = false
        entity.set_process(true)
        entity.set_physics_process(true)
    elif entity.has_method("distance_process_check"):
        entity.call("distance_process_check")

    if entity.has_method("_refresh_visibility_enabler_target"):
        entity.call("_refresh_visibility_enabler_target")

    var distance_timer: Timer = entity.get_node_or_null("%DistanceCheckTimer") as Timer
    if distance_timer != null:
        if active:
            if not distance_timer.has_meta("coop_host_original_process_mode"):
                distance_timer.set_meta("coop_host_original_process_mode", int(distance_timer.process_mode))
            distance_timer.process_mode = Node.PROCESS_MODE_ALWAYS
            if distance_timer.is_stopped():
                distance_timer.start()
        elif distance_timer.has_meta("coop_host_original_process_mode"):
            distance_timer.process_mode = int(distance_timer.get_meta("coop_host_original_process_mode", int(Node.PROCESS_MODE_INHERIT)))
            distance_timer.remove_meta("coop_host_original_process_mode")


func _clear_host_entity_activity_override() -> void:
    if not host_entity_activity_override_active:
        return
    for child in _get_live_tracked_entities():
        if not (child is Entity) or child is Player or is_remote_player_proxy(child):
            continue
        _set_host_entity_activity_override(child as Entity, false)
    _set_host_background_runtime_node(Ref.entity_spawner, false)
    _set_host_background_runtime_node(Ref.sun, false)
    host_entity_activity_override_active = false


func _refresh_host_entity_activity_override(delta: float) -> void:
    if not _should_force_host_background_runtime():
        host_entity_activity_refresh_timer = 0.0
        _clear_host_entity_activity_override()
        return

    host_entity_activity_refresh_timer += delta
    if host_entity_activity_refresh_timer < 0.05:
        return
    host_entity_activity_refresh_timer = 0.0

    var session_positions: Array = _get_same_instance_session_positions()
    session_positions.append_array(_get_active_server_chunk_ticket_positions(DEDICATED_MAX_WORLD_LOAD_TICKET_CENTERS, true))
    var simulation_radius_sq: float = pow(get_server_entity_simulation_radius(), 2.0)
    for child in _get_live_tracked_entities():
        if not (child is Entity) or child is Player or is_remote_player_proxy(child):
            continue
        var entity := child as Entity
        if entity == null or not is_instance_valid(entity) or not entity.is_inside_tree():
            continue
        _set_host_entity_activity_override(entity, _is_position_within_any_session_position(entity.global_position, session_positions, simulation_radius_sq))
    _set_host_background_runtime_node(Ref.entity_spawner, true)
    _set_host_background_runtime_node(Ref.sun, true)
    host_entity_activity_override_active = true


func _is_position_within_any_session_position(world_position: Vector3, session_positions: Array, radius_sq: float) -> bool:
    if session_positions.is_empty():
        return false
    for session_position in session_positions:
        if session_position is Vector3 and world_position.distance_squared_to(session_position) <= radius_sq:
            return true
    return false


func _get_same_instance_session_positions() -> Array:
    var positions: Array = []
    if not _can_sample_player():
        return positions

    if _is_local_session_player_active():
        positions.append(Ref.player.global_position)
    if not _has_live_peer():
        return positions

    var local_peer_id: int = multiplayer.get_unique_id()
    var active_instance_key: String = get_active_dimension_instance_key()
    for peer_id in peer_states.keys():
        if int(peer_id) == local_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if str(state.get("dimension_instance_key", "")) != active_instance_key:
            continue
        positions.append(state.get("position", Ref.player.global_position))

    return positions


func get_same_instance_session_positions() -> Array:
    return _get_same_instance_session_positions().duplicate()


func get_same_instance_session_player_count() -> int:
    return _get_same_instance_session_positions().size()


func get_same_instance_base_load_radius(default_radius: float = 0.0) -> float:
    var base_radius: float = default_radius
    if Ref.save_file_manager != null and Ref.save_file_manager.settings_file != null:
        base_radius = maxf(base_radius, float(Ref.save_file_manager.settings_file.get_data("render_distance", 80.0)))
    if multiplayer.is_server() and session_load_radius_applied and session_previous_instance_radius > 0:
        base_radius = float(session_previous_instance_radius)
    return maxf(base_radius, 16.0)


func get_same_instance_activity_radius(default_radius: float = 0.0) -> float:
    var activity_radius: float = maxf(get_same_instance_base_load_radius(default_radius) - 16.0, 16.0)
    if _supports_multi_region_world_loading():
        return activity_radius
    if not multiplayer.is_server() or not _has_live_peer() or not _can_sample_player() or not is_instance_valid(Ref.world):
        return activity_radius

    var positions: Array = _get_same_instance_session_positions()
    if positions.size() <= 1:
        return activity_radius

    var load_center: Vector3 = get_world_load_center(Ref.player.global_position)
    var load_radius: float = maxf(
        float(Ref.world.instance_radius),
        float(get_world_load_radius_target(int(round(get_same_instance_base_load_radius(default_radius)))))
    )
    var farthest_player_distance: float = 0.0
    for position in positions:
        farthest_player_distance = maxf(farthest_player_distance, load_center.distance_to(position))

    var safe_activity_radius: float = maxf(16.0, load_radius - farthest_player_distance - 16.0)
    return minf(activity_radius, safe_activity_radius)


func get_nearest_session_player_distance(world_position: Vector3, fallback_distance: float = INF) -> float:
    var positions: Array = _get_same_instance_session_positions()
    if positions.is_empty():
        return fallback_distance
    var nearest_distance: float = INF
    for position in positions:
        nearest_distance = minf(nearest_distance, world_position.distance_to(position))
    return nearest_distance


func get_nearest_session_player_position(world_position: Vector3, fallback_position: Vector3 = Vector3.ZERO) -> Vector3:
    var nearest_position: Vector3 = fallback_position
    var nearest_distance_squared: float = INF

    if _is_local_session_player_targetable():
        nearest_position = Ref.player.global_position
        nearest_distance_squared = world_position.distance_squared_to(nearest_position)

    if not _has_live_peer():
        return nearest_position

    var active_instance_key: String = get_active_dimension_instance_key()
    for peer_id in remote_player_proxies.keys():
        if not _is_remote_session_player_targetable(int(peer_id), active_instance_key):
            continue
        var proxy = remote_player_proxies[peer_id]
        var proxy_position: Vector3 = proxy.global_position
        var distance_squared: float = world_position.distance_squared_to(proxy_position)
        if distance_squared >= nearest_distance_squared:
            continue
        nearest_distance_squared = distance_squared
        nearest_position = proxy_position

    return nearest_position


func _does_peer_state_match_instance(state: Dictionary, active_instance_key: String, require_active: bool = false) -> bool:
    if state.is_empty():
        return false
    if require_active and not bool(state.get("active", false)):
        return false

    var state_key: String = str(state.get("dimension_instance_key", "")).strip_edges()
    if state_key != "" and state_key == active_instance_key:
        return true

    if not _can_sample_player():
        return state_key == active_instance_key

    var local_dimension: int = int(Ref.world.current_dimension)
    var state_dimension: int = int(state.get("dimension", -1))
    if state_dimension != local_dimension:
        return false

    if _is_private_instance_dimension(local_dimension):
        return str(state.get("pocket_owner_key", "")).strip_edges() == get_active_pocket_owner_key()

    return active_instance_key == get_dimension_instance_key(local_dimension)


func _is_peer_state_same_instance(state: Dictionary, active_instance_key: String) -> bool:
    return _does_peer_state_match_instance(state, active_instance_key, true)


func _is_local_session_player_active() -> bool:
    if dedicated_server_enabled:
        return false
    return _can_sample_player() and not Ref.player.dead and (not Ref.player.disabled or is_local_player_downed()) and not is_local_player_fake_dead() and Ref.player.is_inside_tree()


func _is_local_session_player_targetable() -> bool:
    if dedicated_server_enabled:
        return false
    return _can_sample_player() and not Ref.player.dead and not Ref.player.disabled and not is_local_player_fake_dead() and Ref.player.is_inside_tree()


func _is_remote_session_player_targetable(peer_id: int, active_instance_key: String) -> bool:
    var state: Dictionary = peer_states.get(peer_id, {})
    if not _is_peer_state_same_instance(state, active_instance_key):
        return false
    if bool(state.get("downed", false)):
        return false
    var proxy = get_remote_player_proxy(peer_id)
    return is_instance_valid(proxy) and proxy.is_inside_tree() and not proxy.dead and not proxy.disabled


func _is_preferred_session_player_targetable(preferred_target, active_instance_key: String) -> bool:
    if not is_instance_valid(preferred_target):
        return false
    if preferred_target == Ref.player:
        return _is_local_session_player_targetable()
    if not is_remote_player_proxy(preferred_target):
        return false
    return _is_remote_session_player_targetable(get_remote_player_proxy_peer_id(preferred_target), active_instance_key)


func _get_safe_node3d_global_position(node, fallback_position: Vector3 = Vector3.ZERO) -> Vector3:
    if node == null or not is_instance_valid(node) or not (node is Node3D) or not node.is_inside_tree():
        return fallback_position
    return (node as Node3D).global_position


func _get_session_player_head_position(target, fallback_position: Vector3) -> Vector3:
    if target == null or not is_instance_valid(target):
        return fallback_position
    var base_position: Vector3 = _get_safe_node3d_global_position(target, fallback_position)
    if target == Ref.player:
        return _get_safe_node3d_global_position(Ref.player.head, base_position + Vector3(0.0, 1.45, 0.0))
    var head_node = target.get("head") if _object_has_property(target, "head") else null
    return _get_safe_node3d_global_position(head_node, base_position + Vector3(0.0, 1.45, 0.0))


func _should_keep_preferred_session_player(world_position: Vector3, preferred_target, active_instance_key: String) -> bool:
    if not _is_preferred_session_player_targetable(preferred_target, active_instance_key):
        return false

    var preferred_position: Vector3 = _get_safe_node3d_global_position(preferred_target, world_position)
    var nearest_position: Vector3 = get_nearest_session_player_position(world_position, preferred_position)
    var preferred_distance: float = world_position.distance_to(preferred_position)
    var nearest_distance: float = world_position.distance_to(nearest_position)
    return preferred_distance <= nearest_distance + SESSION_TARGET_STICK_DISTANCE


func get_preferred_session_player_position(world_position: Vector3, preferred_target = null, fallback_position: Vector3 = Vector3.ZERO) -> Vector3:
    if not _has_live_peer() and not _is_local_world_authority():
        return fallback_position
    var active_instance_key: String = get_active_dimension_instance_key()
    if _should_keep_preferred_session_player(world_position, preferred_target, active_instance_key):
        return _get_safe_node3d_global_position(preferred_target, fallback_position)
    return get_nearest_session_player_position(world_position, fallback_position)


func get_preferred_session_player_head_position(world_position: Vector3, preferred_target = null, fallback_position: Vector3 = Vector3.ZERO) -> Vector3:
    if not _has_live_peer() and not _is_local_world_authority():
        return fallback_position
    var active_instance_key: String = get_active_dimension_instance_key()
    if _should_keep_preferred_session_player(world_position, preferred_target, active_instance_key):
        return _get_session_player_head_position(preferred_target, fallback_position)
    return get_nearest_session_player_head_position(world_position, fallback_position)


func get_preferred_session_player_entity(world_position: Vector3, preferred_target = null, fallback = null):
    if not _has_live_peer() and not _is_local_world_authority():
        return fallback
    var active_instance_key: String = get_active_dimension_instance_key()
    if _should_keep_preferred_session_player(world_position, preferred_target, active_instance_key):
        return preferred_target
    return get_nearest_session_player_entity(world_position, fallback)


func get_nearest_session_player_head_position(world_position: Vector3, fallback_position: Vector3 = Vector3.ZERO) -> Vector3:
    var nearest_head_position: Vector3 = fallback_position
    var nearest_distance_squared: float = INF

    if _is_local_session_player_targetable():
        var local_head: Vector3 = _get_session_player_head_position(Ref.player, Ref.player.global_position + Vector3(0, 1.45, 0))
        nearest_head_position = local_head
        nearest_distance_squared = world_position.distance_squared_to(Ref.player.global_position)

    if not _has_live_peer():
        return nearest_head_position

    var local_peer_id: int = multiplayer.get_unique_id()
    var active_instance_key: String = get_active_dimension_instance_key()
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == local_peer_id:
            continue
        if not _is_remote_session_player_targetable(int_peer_id, active_instance_key):
            continue
        var proxy = get_remote_player_proxy(int_peer_id)
        var peer_position: Vector3 = proxy.global_position
        var distance_squared: float = world_position.distance_squared_to(peer_position)
        if distance_squared >= nearest_distance_squared:
            continue
        nearest_distance_squared = distance_squared
        nearest_head_position = _get_session_player_head_position(proxy, peer_position + Vector3(0, 1.45, 0))

    return nearest_head_position


func is_position_near_same_instance_player(world_position: Vector3, radius: float) -> bool:
    return _is_near_any_session_position(world_position, _get_same_instance_session_positions(), radius)


func get_next_same_instance_spawn_anchor(default_position: Vector3) -> Vector3:
    var positions: Array = _get_same_instance_session_positions()
    if positions.is_empty():
        return default_position
    spawn_anchor_index = posmod(spawn_anchor_index, positions.size())
    var anchor: Vector3 = positions[spawn_anchor_index]
    spawn_anchor_index = (spawn_anchor_index + 1) % positions.size()
    return anchor


func get_nearest_session_player_entity(world_position: Vector3, fallback = null):
    var nearest = fallback
    var nearest_distance_squared: float = INF

    if _is_local_session_player_targetable():
        nearest = Ref.player
        nearest_distance_squared = world_position.distance_squared_to(Ref.player.global_position)

    if not _has_live_peer():
        return nearest

    var active_instance_key: String = get_active_dimension_instance_key()
    for peer_id in remote_player_proxies.keys():
        if not _is_remote_session_player_targetable(int(peer_id), active_instance_key):
            continue
        var proxy = remote_player_proxies[peer_id]
        var distance_squared: float = world_position.distance_squared_to(proxy.global_position)
        if distance_squared >= nearest_distance_squared:
            continue
        nearest = proxy
        nearest_distance_squared = distance_squared

    return nearest


func is_remote_player_proxy(node) -> bool:
    return is_instance_valid(node) and node.has_meta("coop_remote_player_proxy")


func get_remote_player_proxy_peer_id(node) -> int:
    if not is_remote_player_proxy(node):
        return -1
    return int(node.get_meta("coop_remote_player_proxy_peer_id", -1))


func get_remote_player_proxy(peer_id: int):
    if not remote_player_proxies.has(peer_id):
        return null
    var proxy = remote_player_proxies[peer_id]
    return proxy if is_instance_valid(proxy) else null


func is_client_synced_entity(node) -> bool:
    return is_instance_valid(node) and bool(node.get_meta("coop_synced_entity", false))


func push_client_entity_authoritative_change(node) -> void:
    return


func pop_client_entity_authoritative_change(node) -> void:
    return


func is_client_entity_authoritative_change_active(node) -> bool:
    return false


func get_world_load_center(default_center: Vector3) -> Vector3:
    if dedicated_server_enabled:
        if multiplayer.is_server():
            return _get_dedicated_world_load_center(default_center)
        return default_center
    if not multiplayer.is_server() or not _has_live_peer():
        return default_center
    return default_center


func _get_dedicated_world_load_center(default_center: Vector3) -> Vector3:
    if dedicated_load_focus_valid:
        return dedicated_load_focus_position

    var ticket_positions: Array = _get_active_server_chunk_ticket_positions(1, false)
    if not ticket_positions.is_empty() and ticket_positions[0] is Vector3:
        return ticket_positions[0]

    var active_instance_key: String = get_active_dimension_instance_key()
    var first_active_position: Variant = null
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        if not _is_peer_state_same_instance(state, active_instance_key):
            continue
        if bool(state.get("breaking", false)):
            var break_position: Vector3i = state.get("break_position", Vector3i.ZERO)
            return Vector3(break_position) + Vector3(0.5, 0.5, 0.5)
        if first_active_position == null:
            first_active_position = state.get("position", default_center)

    if first_active_position is Vector3:
        return first_active_position
    return default_center


func _focus_dedicated_world_load(peer_id: int, target_position: Vector3) -> void:
    if not dedicated_server_enabled or not multiplayer.is_server():
        return
    dedicated_load_focus_valid = true
    dedicated_load_focus_peer_id = peer_id
    dedicated_load_focus_position = target_position
    dedicated_load_focus_timer = DEDICATED_LOAD_FOCUS_HOLD_SEC


func _focus_dedicated_world_load_on_block(peer_id: int, block_position: Vector3i) -> void:
    _focus_dedicated_world_load(peer_id, Vector3(block_position) + Vector3(0.5, 0.5, 0.5))
    _remember_server_chunk_ticket("load_focus", peer_id, get_active_dimension_instance_key(), block_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 10)


func _can_defer_dedicated_world_action(sender_id: int, dimension_instance_key: String) -> bool:
    return dedicated_server_enabled \
        and multiplayer.is_server() \
        and SERVER_AUTHORITATIVE_WORLD \
        and sender_id > 0 \
        and dimension_instance_key == get_active_dimension_instance_key()


func _is_dedicated_sender_still_valid(sender_id: int, dimension_instance_key: String) -> bool:
    if not _can_defer_dedicated_world_action(sender_id, dimension_instance_key):
        return false
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    return _is_peer_state_same_instance(sender_state, dimension_instance_key)


func _await_dedicated_block_loaded(sender_id: int, dimension_instance_key: String, block_position: Vector3i) -> bool:
    if not _is_dedicated_sender_still_valid(sender_id, dimension_instance_key):
        return false

    _focus_dedicated_world_load_on_block(sender_id, block_position)
    var deadline_msec: int = Time.get_ticks_msec() + int(DEDICATED_ACTION_LOAD_TIMEOUT_SEC * 1000.0)
    while Time.get_ticks_msec() < deadline_msec:
        if not _is_dedicated_sender_still_valid(sender_id, dimension_instance_key):
            return false
        if is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position):
            return true
        _focus_dedicated_world_load_on_block(sender_id, block_position)
        await get_tree().physics_frame

    return is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position)


func _server_journal_world_id() -> String:
    if Ref.save_file_manager != null and Ref.save_file_manager.loaded_file_register != null:
        var uuid: String = str(Ref.save_file_manager.loaded_file_register.get_data("uuid", "")).strip_edges()
        if uuid != "":
            return uuid
    return "active"


func _server_chunk_journal_path() -> String:
    return "user://lucid_blocks_coop_chunk_journal_%s.jsonl" % _server_journal_world_id().replace("/", "_").replace("\\", "_")


func _server_chunk_key(dimension_instance_key: String, chunk_position: Vector3i) -> String:
    return "%s:%s:%s:%s" % [dimension_instance_key, chunk_position.x, chunk_position.y, chunk_position.z]


func _server_chunk_ticket_key(kind: String, owner_peer_id: int, dimension_instance_key: String, chunk_position: Vector3i) -> String:
    return "%s:%s:%s:%s" % [_server_chunk_key(dimension_instance_key, chunk_position), kind, owner_peer_id]


func _server_journal_array_to_vector3i(value: Variant) -> Vector3i:
    if value is Vector3i:
        return value
    if value is Vector3:
        return Vector3i(value)
    if value is Array and value.size() >= 3:
        return Vector3i(int(value[0]), int(value[1]), int(value[2]))
    return Vector3i.ZERO


func _server_journal_vector3i_to_array(value: Vector3i) -> Array:
    return [value.x, value.y, value.z]


func _server_journal_storage_items_to_json(serialized_items: Array) -> Array:
    var result: Array = []
    for item_data in serialized_items:
        if item_data is PackedInt32Array:
            var values: Array = []
            for raw_value in item_data:
                values.append(int(raw_value))
            result.append(values)
        elif item_data is Array:
            var values_from_array: Array = []
            for raw_value in item_data:
                values_from_array.append(int(raw_value))
            result.append(values_from_array)
        else:
            result.append([])
    return result


func _server_journal_storage_items_from_json(value: Variant) -> Array:
    var result: Array = []
    if not (value is Array):
        return result
    for item_entry in value:
        var item_data: PackedInt32Array = PackedInt32Array()
        if item_entry is Array:
            for raw_value in item_entry:
                item_data.append(int(raw_value))
        elif item_entry is PackedInt32Array:
            item_data = item_entry
        result.append(item_data)
    return result


func _remember_server_dirty_chunk(dimension_instance_key: String, chunk_position: Vector3i) -> void:
    if dimension_instance_key == "":
        return
    server_dirty_chunk_keys[_server_chunk_key(dimension_instance_key, chunk_position)] = Time.get_ticks_msec()


func _remember_server_chunk_ticket(kind: String, owner_peer_id: int, dimension_instance_key: String, world_position: Variant, hold_sec: float = DEDICATED_CHUNK_TICKET_HOLD_SEC, simulation_enabled: bool = true, priority: int = 0) -> void:
    if not dedicated_server_enabled or not multiplayer.is_server():
        return
    if dimension_instance_key == "" or dimension_instance_key != get_active_dimension_instance_key():
        return
    if not is_instance_valid(Ref.world):
        return
    if not (world_position is Vector3i or world_position is Vector3):
        return

    var world_vector: Vector3 = Vector3(world_position) if world_position is Vector3i else world_position
    var chunk_position: Vector3i = Ref.world.snap_to_chunk(world_vector)
    var chunk_center: Vector3 = Vector3(chunk_position) + Vector3(8.0, 8.0, 8.0)
    var key: String = _server_chunk_ticket_key(kind, owner_peer_id, dimension_instance_key, chunk_position)
    var expires_at_msec: int = Time.get_ticks_msec() + int(maxf(hold_sec, 0.25) * 1000.0)
    var existing: Dictionary = server_chunk_tickets.get(key, {})
    if not existing.is_empty():
        expires_at_msec = maxi(expires_at_msec, int(existing.get("expires_at_msec", 0)))
        priority = maxi(priority, int(existing.get("priority", priority)))
        simulation_enabled = simulation_enabled or bool(existing.get("simulation_enabled", false))

    server_chunk_tickets[key] = {
        "kind": kind,
        "owner_peer_id": owner_peer_id,
        "dimension_instance_key": dimension_instance_key,
        "chunk": chunk_position,
        "center": chunk_center,
        "expires_at_msec": expires_at_msec,
        "simulation_enabled": simulation_enabled,
        "priority": priority,
    }


func _cleanup_server_chunk_tickets() -> void:
    if server_chunk_tickets.is_empty():
        return

    var now_msec: int = Time.get_ticks_msec()
    var active_instance_key: String = get_active_dimension_instance_key()
    for key in server_chunk_tickets.keys():
        var ticket: Dictionary = server_chunk_tickets.get(key, {})
        if ticket.is_empty() \
            or int(ticket.get("expires_at_msec", 0)) <= now_msec \
            or str(ticket.get("dimension_instance_key", "")) != active_instance_key:
            server_chunk_tickets.erase(key)


func _get_active_server_chunk_ticket_positions(max_count: int = DEDICATED_MAX_WORLD_LOAD_TICKET_CENTERS, require_simulation: bool = false) -> Array:
    if not dedicated_server_enabled or not multiplayer.is_server():
        return []

    _cleanup_server_chunk_tickets()
    if server_chunk_tickets.is_empty():
        return []

    var active_instance_key: String = get_active_dimension_instance_key()
    var records: Array = []
    for ticket in server_chunk_tickets.values():
        if not (ticket is Dictionary):
            continue
        if str(ticket.get("dimension_instance_key", "")) != active_instance_key:
            continue
        if require_simulation and not bool(ticket.get("simulation_enabled", false)):
            continue
        var center: Variant = ticket.get("center", null)
        if center is Vector3:
            records.append(ticket)

    records.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
        var priority_a: int = int(a.get("priority", 0))
        var priority_b: int = int(b.get("priority", 0))
        if priority_a != priority_b:
            return priority_a > priority_b
        return int(a.get("expires_at_msec", 0)) > int(b.get("expires_at_msec", 0))
    )

    var positions: Array = []
    var seen_chunks: Dictionary = {}
    for ticket in records:
        if positions.size() >= max_count:
            break
        var chunk_position: Vector3i = ticket.get("chunk", Vector3i.ZERO)
        if seen_chunks.has(chunk_position):
            continue
        seen_chunks[chunk_position] = true
        positions.append(ticket.get("center", Vector3.ZERO))
    return positions


func get_active_world_load_ticket_positions(max_count: int = DEDICATED_MAX_WORLD_LOAD_TICKET_CENTERS) -> Array:
    return _get_active_server_chunk_ticket_positions(max_count, false)


func _mark_server_dirty_chunks_for_world_positions(dimension_instance_key: String, world_positions: Array) -> void:
    if not multiplayer.is_server() or not is_instance_valid(Ref.world) or dimension_instance_key == "":
        return
    for world_position in world_positions:
        if not (world_position is Vector3i or world_position is Vector3):
            continue
        var world_vec: Vector3 = Vector3(world_position) if world_position is Vector3i else world_position
        var chunk_position: Vector3i = Ref.world.snap_to_chunk(world_vec)
        _remember_server_dirty_chunk(dimension_instance_key, chunk_position)


func _await_dedicated_journal_block_loaded(block_position: Vector3i) -> bool:
    if not dedicated_server_enabled or not multiplayer.is_server() or not is_instance_valid(Ref.world):
        return false
    if Ref.world.is_position_loaded(block_position):
        return true

    _focus_dedicated_world_load_on_block(0, block_position)
    var deadline_msec: int = Time.get_ticks_msec() + int(DEDICATED_ACTION_LOAD_TIMEOUT_SEC * 1000.0)
    while Time.get_ticks_msec() < deadline_msec:
        if not is_instance_valid(Ref.world):
            return false
        if Ref.world.is_position_loaded(block_position):
            return true
        _focus_dedicated_world_load_on_block(0, block_position)
        await get_tree().physics_frame

    return is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position)


func _replay_server_chunk_journal_record(record: Dictionary) -> bool:
    var dimension_instance_key: String = str(record.get("dimension_instance_key", ""))
    if dimension_instance_key == "" or dimension_instance_key != get_active_dimension_instance_key():
        return false

    var block_position: Vector3i = _server_journal_array_to_vector3i(record.get("block", []))
    var chunk_position: Vector3i = _server_journal_array_to_vector3i(record.get("chunk", []))
    if chunk_position == Vector3i.ZERO and is_instance_valid(Ref.world):
        chunk_position = Ref.world.snap_to_chunk(Vector3(block_position))
    _remember_server_dirty_chunk(dimension_instance_key, chunk_position)

    var loaded: bool = await _await_dedicated_journal_block_loaded(block_position)
    if not loaded:
        return false

    var action: String = str(record.get("action", ""))
    match action:
        "place":
            var block_id: int = int(record.get("block_id", 0))
            if block_id <= 0:
                return false
            _apply_loaded_network_place(block_position, block_id)
            return true
        "break", "foliage":
            _apply_loaded_network_break(block_position)
            return true
        "water":
            Ref.world.place_water_at(block_position, _clamp_chunk_byte_value(record.get("water_level", 0)))
            if Ref.world.has_method("queue_coop_dynamic_visual_refresh"):
                Ref.world.queue_coop_dynamic_visual_refresh(1)
            return true
        "fire":
            Ref.world.place_fire_at(block_position, _clamp_chunk_byte_value(record.get("fire_level", 0)))
            if Ref.world.has_method("queue_coop_dynamic_visual_refresh"):
                Ref.world.queue_coop_dynamic_visual_refresh(1)
            return true
        "storage":
            var serialized_items: Array = _server_journal_storage_items_from_json(record.get("items", []))
            if serialized_items.is_empty() and not (record.get("items", []) is Array):
                return false
            _apply_storage_inventory_snapshot(block_position, serialized_items)
            if pending_remote_storage_changes.has(block_position):
                _store_remote_storage_inventory_snapshot_in_save(block_position, serialized_items)
            return true
        "cell_state":
            var cell_block_id: int = int(record.get("block_id", 0))
            if cell_block_id > 0:
                _apply_loaded_network_place(block_position, cell_block_id)
            else:
                _apply_loaded_network_break(block_position)
            Ref.world.place_water_at(block_position, _clamp_chunk_byte_value(record.get("water_level", 0)))
            Ref.world.place_fire_at(block_position, _clamp_chunk_byte_value(record.get("fire_level", 0)))
            if Ref.world.has_method("queue_coop_dynamic_visual_refresh"):
                Ref.world.queue_coop_dynamic_visual_refresh(1)
            return true
        _:
            return false


func _replay_server_chunk_journal() -> void:
    if not dedicated_server_enabled or not multiplayer.is_server():
        return

    var path: String = _server_chunk_journal_path()
    if not FileAccess.file_exists(path):
        return

    var file: FileAccess = FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_warning("[lucid-blocks-coop] Could not read chunk journal: %s" % path)
        return

    var total_count: int = 0
    var applied_count: int = 0
    var skipped_count: int = 0
    var max_sequence: int = server_chunk_journal_sequence
    while not file.eof_reached():
        var line: String = file.get_line().strip_edges()
        if line == "":
            continue
        var parsed: Variant = JSON.parse_string(line)
        if not (parsed is Dictionary):
            skipped_count += 1
            continue
        var record: Dictionary = parsed
        total_count += 1
        max_sequence = maxi(max_sequence, int(record.get("seq", 0)))
        if str(record.get("world", _server_journal_world_id())) != _server_journal_world_id():
            skipped_count += 1
            continue
        var applied: bool = await _replay_server_chunk_journal_record(record)
        if applied:
            applied_count += 1
        else:
            skipped_count += 1

    file.close()
    server_chunk_journal_sequence = max_sequence
    dedicated_load_focus_valid = false
    dedicated_load_focus_peer_id = 0
    dedicated_load_focus_timer = 0.0
    print("[lucid-blocks-coop] Dedicated chunk_journal replay total=%d applied=%d skipped=%d dirty_chunks=%d seq=%d" % [
        total_count,
        applied_count,
        skipped_count,
        server_dirty_chunk_keys.size(),
        server_chunk_journal_sequence,
    ])


func _compact_server_chunk_journal_after_save() -> void:
    if not dedicated_server_enabled:
        return
    var dirty_count: int = server_dirty_chunk_keys.size()
    if dirty_count <= 0:
        return

    var path: String = _server_chunk_journal_path()
    var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        push_warning("[lucid-blocks-coop] Could not compact chunk journal: %s" % path)
        return

    file.close()
    server_dirty_chunk_keys.clear()
    server_dirty_chunk_flush_timer = 0.0
    print("[lucid-blocks-coop] Dedicated chunk_journal compacted dirty_chunks=%d seq=%d." % [
        dirty_count,
        server_chunk_journal_sequence,
    ])


func _record_server_block_journal(sender_id: int, request_id: int, action: String, dimension_instance_key: String, block_position: Vector3i, block_id: int) -> void:
    _record_server_world_cell_journal(sender_id, request_id, action, dimension_instance_key, block_position, {"block_id": block_id})


func _record_server_current_cell_journal(sender_id: int, dimension_instance_key: String, block_position: Vector3i) -> void:
    if not multiplayer.is_server() or not is_instance_valid(Ref.world) or dimension_instance_key == "":
        return
    if not Ref.world.is_position_loaded(block_position):
        _remember_server_dirty_chunk(dimension_instance_key, Ref.world.snap_to_chunk(Vector3(block_position)))
        return

    var block = Ref.world.get_block_type_at(block_position)
    _record_server_world_cell_journal(sender_id, 0, "cell_state", dimension_instance_key, block_position, {
        "block_id": int(block.id) if block != null else 0,
        "water_level": _clamp_chunk_byte_value(Ref.world.get_water_level_at(block_position)),
        "fire_level": _clamp_chunk_byte_value(Ref.world.get_fire_at(block_position)),
    })


func _record_server_world_cell_journal(sender_id: int, request_id: int, action: String, dimension_instance_key: String, block_position: Vector3i, payload: Dictionary = {}) -> void:
    if not multiplayer.is_server() or not is_instance_valid(Ref.world):
        return
    if action == "" or dimension_instance_key == "":
        return

    var chunk_position: Vector3i = Ref.world.snap_to_chunk(Vector3(block_position))
    _remember_server_dirty_chunk(dimension_instance_key, chunk_position)
    server_chunk_journal_sequence += 1

    var record: Dictionary = {
        "seq": server_chunk_journal_sequence,
        "time_ms": Time.get_ticks_msec(),
        "world": _server_journal_world_id(),
        "dimension_instance_key": dimension_instance_key,
        "chunk": _server_journal_vector3i_to_array(chunk_position),
        "block": _server_journal_vector3i_to_array(block_position),
        "action": action,
        "peer": sender_id,
        "request_id": request_id,
    }
    for key in payload.keys():
        var value: Variant = payload[key]
        if key == "items" and value is Array:
            record[key] = _server_journal_storage_items_to_json(value)
        else:
            record[key] = value

    var path: String = _server_chunk_journal_path()
    var file: FileAccess = FileAccess.open(path, FileAccess.READ_WRITE) if FileAccess.file_exists(path) else FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        push_warning("[lucid-blocks-coop] Could not open chunk journal: %s" % path)
        return
    file.seek_end()
    file.store_line(JSON.stringify(record))
    file.close()


func _ack_block_action(sender_id: int, request_id: int, action: String, success: bool, dimension_instance_key: String, block_position: Vector3i, block_id: int = 0, reason: String = "", started_msec: int = 0) -> void:
    var action_key: String = _server_block_action_key(sender_id, request_id, action)
    var duplicate_result: bool = action_key != "" and server_recent_block_action_results.has(action_key)
    if success and not duplicate_result:
        _record_server_block_journal(sender_id, request_id, action, dimension_instance_key, block_position, block_id)
    _remember_server_block_action_result(sender_id, request_id, action, success, dimension_instance_key, block_position, block_id, reason)
    if request_id > 0 and sender_id > 0 and sender_id != multiplayer.get_unique_id():
        receive_block_action_result.rpc_id(sender_id, request_id, action, success, dimension_instance_key, block_position, block_id, reason)

    if dedicated_server_enabled and multiplayer.is_server():
        dedicated_block_action_count += 1
        if not success:
            dedicated_block_action_fail_count += 1
        if started_msec > 0:
            dedicated_block_action_last_latency_ms = Time.get_ticks_msec() - started_msec
        print("[lucid-blocks-coop] Dedicated block_action action=%s request=%s peer=%s success=%s reason=%s pos=%s latency_ms=%s" % [
            action,
            request_id,
            sender_id,
            str(success),
            reason,
            str(block_position),
            dedicated_block_action_last_latency_ms,
        ])


func _server_block_action_key(sender_id: int, request_id: int, action: String) -> String:
    if sender_id <= 0 or request_id <= 0 or action == "":
        return ""
    return "%s:%s:%s" % [sender_id, request_id, action]


func _remember_server_block_action_result(sender_id: int, request_id: int, action: String, success: bool, dimension_instance_key: String, block_position: Vector3i, block_id: int, reason: String) -> void:
    var key: String = _server_block_action_key(sender_id, request_id, action)
    if key == "":
        return
    server_recent_block_action_results[key] = {
        "success": success,
        "dimension_instance_key": dimension_instance_key,
        "block_position": block_position,
        "block_id": block_id,
        "reason": reason,
        "created_ms": Time.get_ticks_msec(),
    }
    _cleanup_server_block_action_results()


func _cleanup_server_block_action_results() -> void:
    var now_msec: int = Time.get_ticks_msec()
    for key in server_recent_block_action_results.keys().duplicate():
        var result: Dictionary = server_recent_block_action_results.get(key, {})
        if now_msec - int(result.get("created_ms", now_msec)) > SERVER_ACTION_RESULT_TTL_MSEC:
            server_recent_block_action_results.erase(key)


func _ack_duplicate_block_action_if_seen(sender_id: int, request_id: int, action: String, started_msec: int) -> bool:
    var key: String = _server_block_action_key(sender_id, request_id, action)
    if key == "" or not server_recent_block_action_results.has(key):
        return false
    var result: Dictionary = server_recent_block_action_results.get(key, {})
    _ack_block_action(
        sender_id,
        request_id,
        action,
        bool(result.get("success", false)),
        str(result.get("dimension_instance_key", get_active_dimension_instance_key())),
        result.get("block_position", Vector3i.ZERO),
        int(result.get("block_id", 0)),
        str(result.get("reason", "duplicate_request")),
        started_msec
    )
    return true


@rpc("authority", "call_remote", "reliable")
func receive_block_action_result(request_id: int, action: String, success: bool, dimension_instance_key: String, block_position: Vector3i, block_id: int, reason: String = "") -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if request_id <= 0:
        return
    action = _safe_network_text(action, 32)
    reason = _safe_network_text(reason, 160)
    if not _is_safe_vector3i(block_position) or not _is_safe_block_id(block_id):
        return
    if success:
        if action == "place" and dimension_instance_key == get_active_dimension_instance_key():
            _apply_network_place(block_position, block_id)
        elif (action == "break" or action == "foliage") and dimension_instance_key == get_active_dimension_instance_key():
            _apply_network_break(block_position)
        _commit_client_block_action(request_id, action)
        return

    print("[lucid-blocks-coop] Block action failed request=%s action=%s reason=%s" % [request_id, action, reason])
    status_message = "Block action failed: %s" % reason
    _update_status_text()
    if dimension_instance_key == get_active_dimension_instance_key():
        _rollback_client_block_action(request_id, action, block_position, block_id)
    else:
        _forget_client_block_action(request_id)


func _ack_item_action(sender_id: int, request_id: int, action: String, success: bool, item_uuid: String = "", reason: String = "", started_msec: int = 0) -> void:
    _remember_server_item_action_result(sender_id, request_id, action, success, item_uuid, reason)
    if request_id > 0 and sender_id > 0 and sender_id != multiplayer.get_unique_id():
        receive_item_action_result.rpc_id(sender_id, request_id, action, success, item_uuid, reason)

    if dedicated_server_enabled and multiplayer.is_server():
        dedicated_item_action_count += 1
        if not success:
            dedicated_item_action_fail_count += 1
        if started_msec > 0:
            dedicated_item_action_last_latency_ms = Time.get_ticks_msec() - started_msec
        print("[lucid-blocks-coop] Dedicated item_action action=%s request=%s peer=%s success=%s reason=%s item=%s latency_ms=%s" % [
            action,
            request_id,
            sender_id,
            str(success),
            reason,
            item_uuid,
            dedicated_item_action_last_latency_ms,
        ])


func _server_item_action_key(sender_id: int, request_id: int, action: String) -> String:
    if sender_id <= 0 or request_id <= 0 or action == "":
        return ""
    return "%s:%s:%s" % [sender_id, request_id, action]


func _remember_server_item_action_result(sender_id: int, request_id: int, action: String, success: bool, item_uuid: String, reason: String) -> void:
    var key: String = _server_item_action_key(sender_id, request_id, action)
    if key == "":
        return
    server_recent_item_action_results[key] = {
        "success": success,
        "item_uuid": item_uuid,
        "reason": reason,
        "created_ms": Time.get_ticks_msec(),
    }
    _cleanup_server_item_action_results()


func _cleanup_server_item_action_results() -> void:
    var now_msec: int = Time.get_ticks_msec()
    for key in server_recent_item_action_results.keys().duplicate():
        var result: Dictionary = server_recent_item_action_results.get(key, {})
        if now_msec - int(result.get("created_ms", now_msec)) > SERVER_ACTION_RESULT_TTL_MSEC:
            server_recent_item_action_results.erase(key)


func _ack_duplicate_item_action_if_seen(sender_id: int, request_id: int, action: String, started_msec: int) -> bool:
    var key: String = _server_item_action_key(sender_id, request_id, action)
    if key == "" or not server_recent_item_action_results.has(key):
        return false
    var result: Dictionary = server_recent_item_action_results.get(key, {})
    _ack_item_action(
        sender_id,
        request_id,
        action,
        bool(result.get("success", false)),
        str(result.get("item_uuid", "")),
        str(result.get("reason", "duplicate_request")),
        started_msec
    )
    return true


@rpc("authority", "call_remote", "reliable")
func receive_item_action_result(request_id: int, action: String, success: bool, item_uuid: String = "", reason: String = "") -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if request_id <= 0:
        return
    action = _safe_network_text(action, 32)
    item_uuid = _safe_network_text(item_uuid, CLIENT_SAFE_MAX_UUID_LENGTH)
    reason = _safe_network_text(reason, 160)
    if item_uuid != "" and not _is_safe_uuid_text(item_uuid):
        return
    if success:
        _forget_client_item_action(request_id)
        return

    print("[lucid-blocks-coop] Item action failed request=%s action=%s reason=%s" % [request_id, action, reason])
    status_message = "Item action failed: %s" % reason
    _update_status_text()
    _rollback_client_item_action(request_id, action, item_uuid)


func _snap_world_stream_position(position: Vector3) -> Vector3:
    return Vector3(
        floor(position.x / 16.0) * 16.0 + 8.0,
        floor(position.y / 16.0) * 16.0 + 8.0,
        floor(position.z / 16.0) * 16.0 + 8.0
    )


func _is_near_any_session_position(world_position: Vector3, positions: Array, radius: float) -> bool:
    var radius_squared: float = radius * radius
    for position in positions:
        if world_position.distance_squared_to(position) <= radius_squared:
            return true
    return false


func get_world_load_radius_target(default_radius: int) -> int:
    var target_radius: int = maxi(default_radius, HOST_SESSION_MIN_LOAD_RADIUS)
    if _supports_multi_region_world_loading():
        return mini(default_radius, HOST_SESSION_MAX_LOAD_RADIUS)
    if not multiplayer.is_server() or not _has_live_peer():
        return mini(target_radius, HOST_SESSION_MAX_LOAD_RADIUS)

    var positions: Array = _get_same_instance_session_positions()
    if positions.size() <= 1:
        return target_radius

    var center: Vector3 = get_world_load_center(Ref.player.global_position)
    var farthest_distance: float = 0.0
    for position in positions:
        farthest_distance = maxf(farthest_distance, center.distance_to(position))

    var snapped_radius: int = int(ceil((farthest_distance + HOST_SESSION_EDGE_BUFFER) / float(HOST_SESSION_RADIUS_STEP))) * HOST_SESSION_RADIUS_STEP
    return mini(maxi(target_radius, snapped_radius), HOST_SESSION_MAX_LOAD_RADIUS)


func _refresh_session_load_radius() -> void:
    if not _can_sample_player() or not is_instance_valid(Ref.world):
        return

    if dedicated_server_enabled and multiplayer.is_server():
        if not session_load_radius_applied:
            session_previous_instance_radius = int(Ref.world.instance_radius)
            session_previous_buffer_instance_radius = int(Ref.world.buffer_instance_radius)
            session_load_radius_applied = true

        var dedicated_target_radius: int = get_dedicated_load_radius()
        var dedicated_target_buffer_radius: int = get_dedicated_buffer_radius(dedicated_target_radius)
        if int(Ref.world.instance_radius) != dedicated_target_radius:
            Ref.world.instance_radius = dedicated_target_radius
            Ref.world.buffer_instance_radius = dedicated_target_buffer_radius
            Ref.world.force_reload()
        elif int(Ref.world.buffer_instance_radius) != dedicated_target_buffer_radius:
            Ref.world.buffer_instance_radius = dedicated_target_buffer_radius
        return

    if _supports_multi_region_world_loading():
        if session_load_radius_applied:
            if session_previous_instance_radius > 0 and int(Ref.world.instance_radius) != session_previous_instance_radius:
                Ref.world.instance_radius = session_previous_instance_radius
                Ref.world.buffer_instance_radius = session_previous_buffer_instance_radius if session_previous_buffer_instance_radius > 0 else Ref.world.buffer_instance_radius
                Ref.world.force_reload()
            elif session_previous_buffer_instance_radius > 0 and int(Ref.world.buffer_instance_radius) != session_previous_buffer_instance_radius:
                Ref.world.buffer_instance_radius = session_previous_buffer_instance_radius
            session_load_radius_applied = false
            session_previous_instance_radius = -1
            session_previous_buffer_instance_radius = -1
        return

    if _has_live_peer() and multiplayer.is_server():
        if not session_load_radius_applied:
            session_previous_instance_radius = int(Ref.world.instance_radius)
            session_previous_buffer_instance_radius = int(Ref.world.buffer_instance_radius)
            session_load_radius_applied = true

        var target_radius: int = get_world_load_radius_target(session_previous_instance_radius)

        var target_buffer_radius: int = maxi(session_previous_buffer_instance_radius, target_radius + 256)

        if int(Ref.world.instance_radius) != target_radius:
            Ref.world.instance_radius = target_radius
            Ref.world.buffer_instance_radius = target_buffer_radius
            Ref.world.force_reload()
        elif int(Ref.world.buffer_instance_radius) != target_buffer_radius:
            Ref.world.buffer_instance_radius = target_buffer_radius
    elif session_load_radius_applied:
        if session_previous_instance_radius > 0 and int(Ref.world.instance_radius) != session_previous_instance_radius:
            Ref.world.instance_radius = session_previous_instance_radius
            Ref.world.buffer_instance_radius = session_previous_buffer_instance_radius if session_previous_buffer_instance_radius > 0 else Ref.world.buffer_instance_radius
            Ref.world.force_reload()
        elif session_previous_buffer_instance_radius > 0 and int(Ref.world.buffer_instance_radius) != session_previous_buffer_instance_radius:
            Ref.world.buffer_instance_radius = session_previous_buffer_instance_radius
        session_load_radius_applied = false
        session_previous_instance_radius = -1
        session_previous_buffer_instance_radius = -1


func _get_nearest_connected_peer_state() -> Dictionary:
    if not _has_live_peer() or not _can_sample_player():
        return {}
    var active_instance_key: String = get_active_dimension_instance_key()
    var nearest_state: Dictionary = {}
    var nearest_distance_squared: float = INF
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue
        var state: Dictionary = peer_states[peer_id]
        if not _is_peer_state_same_instance(state, active_instance_key):
            continue
        var peer_position: Vector3 = state.get("position", Vector3.ZERO)
        var distance_squared: float = Ref.player.global_position.distance_squared_to(peer_position)
        if distance_squared < nearest_distance_squared:
            nearest_distance_squared = distance_squared
            nearest_state = state
    return nearest_state


func _supports_multi_region_world_loading() -> bool:
    return is_instance_valid(Ref.world) \
        and Ref.world.has_method("supports_coop_multi_region_loading") \
        and bool(Ref.world.call("supports_coop_multi_region_loading"))


func _enforce_shared_bubble_tether(delta: float) -> void:
    return


func _get_local_skin_color() -> Color:
    if get_local_avatar_id() == DEFAULT_AVATAR_ID:
        return Color.WHITE
    if Ref.save_file_manager == null or Ref.save_file_manager.settings_file == null:
        return Color.WHITE
    return Ref.save_file_manager.settings_file.get_data("skin_modulate", Color.WHITE)


func _get_local_action_state() -> int:
    var player_hand = Ref.player.get_node_or_null("%PlayerHand")
    if player_hand == null or player_hand.current_hand == null:
        return 0
    return int(player_hand.current_hand.state)


func _get_local_break_state() -> Dictionary:
    var state: Dictionary = {
        "breaking": false,
        "break_position": Vector3i.ZERO,
        "break_block_id": 0,
        "break_progress": 0.0,
    }

    var break_behavior = Ref.player.get_node_or_null("%BreakBlocks")
    if break_behavior == null or not break_behavior.breaking or break_behavior.block == null:
        return state

    var break_goal: float = maxf(float(break_behavior.progress_goal), 0.001)
    state["breaking"] = true
    state["break_position"] = Vector3i(break_behavior.active_position)
    state["break_block_id"] = int(break_behavior.block.id)
    state["break_progress"] = clampf(float(break_behavior.progress) / break_goal, 0.0, 1.0)
    return state


func _hash_client_state(local_state: Dictionary) -> int:
    var position: Vector3 = local_state.get("position", Vector3.ZERO)
    var break_position: Vector3i = local_state.get("break_position", Vector3i.ZERO)
    return hash([
        bool(local_state.get("active", false)),
        bool(local_state.get("downed", false)),
        int(local_state.get("dimension", -1)),
        str(local_state.get("dimension_instance_key", "")),
        int(round(position.x * 20.0)),
        int(round(position.y * 20.0)),
        int(round(position.z * 20.0)),
        int(round(float(local_state.get("yaw", 0.0)) * 100.0)),
        int(round(float(local_state.get("pitch", 0.0)) * 100.0)),
        bool(local_state.get("crouching", false)),
        bool(local_state.get("grounded", true)),
        int(round(float(local_state.get("move_speed", 0.0)) * 20.0)),
        int(local_state.get("held_item_id", -1)),
        int(local_state.get("action_state", 0)),
        bool(local_state.get("breaking", false)),
        break_position.x,
        break_position.y,
        break_position.z,
        int(local_state.get("break_block_id", 0)),
        int(round(float(local_state.get("break_progress", 0.0)) * 50.0)),
    ])


func _get_local_attack_damage() -> int:
    var attack_behavior = Ref.player.get_node_or_null("%Attack")
    if attack_behavior == null:
        return 1
    return maxi(1, int(round(float(attack_behavior.damage) * float(attack_behavior.damage_modifier))))


func _get_local_attack_fire_aspect() -> bool:
    var attack_behavior = Ref.player.get_node_or_null("%Attack")
    return attack_behavior != null and bool(attack_behavior.fire_aspect)


func _serialize_item_state(item_state) -> PackedInt32Array:
    if item_state == null:
        return PackedInt32Array()
    return item_state.get_save_data()


func _deserialize_item_state(item_data: PackedInt32Array):
    if not _is_safe_item_data(item_data):
        return null
    var item_state = ItemState.new()
    item_state.load_from_save_data(item_data)
    return item_state


func _serialize_inventory_items(inventory: Inventory) -> Array:
    var serialized_items: Array = []
    if inventory == null or not is_instance_valid(inventory):
        return serialized_items

    for i in range(inventory.capacity):
        serialized_items.append(_serialize_item_state(inventory.items[i]))
    return serialized_items


func _apply_serialized_inventory_items(inventory: Inventory, serialized_items: Array) -> void:
    if inventory == null or not is_instance_valid(inventory):
        return

    for i in range(inventory.capacity):
        var item_data: PackedInt32Array = PackedInt32Array()
        if i < serialized_items.size() and serialized_items[i] is PackedInt32Array:
            item_data = serialized_items[i]
        inventory.set_item(i, _deserialize_item_state(item_data))


func _resolve_storage_inventory(block_position: Vector3i) -> Inventory:
    if not is_instance_valid(Ref.world):
        return null

    var living_block = Ref.world.get_living_block_at(block_position)
    if living_block == null or not is_instance_valid(living_block):
        return null
    return living_block.get_node_or_null("%Inventory") as Inventory


func _get_saved_chunk_to_uuid_map() -> Dictionary:
    if Ref.preserve_node_manager != null:
        return Ref.preserve_node_manager.chunk_to_uuid_map
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null:
        return {}
    return Ref.save_file_manager.loaded_file.get_data("world/chunk_to_uuid_map", {}).duplicate(true)


func _store_saved_chunk_to_uuid_map(chunk_to_uuid_map: Dictionary) -> void:
    if Ref.preserve_node_manager != null:
        Ref.preserve_node_manager.chunk_to_uuid_map = chunk_to_uuid_map.duplicate(true)
    if Ref.save_file_manager != null and Ref.save_file_manager.loaded_file != null:
        Ref.save_file_manager.loaded_file.set_data("world/chunk_to_uuid_map", chunk_to_uuid_map.duplicate(true))


func _find_saved_preserve_uuid_at_block_position(block_position: Vector3i) -> String:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null or not is_instance_valid(Ref.world):
        return ""

    var chunk_to_uuid_map: Dictionary = _get_saved_chunk_to_uuid_map()
    var chunk_position: Vector3i = Ref.world.snap_to_chunk(block_position)
    if not chunk_to_uuid_map.has(chunk_position):
        return ""

    var uuids: PackedStringArray = chunk_to_uuid_map[chunk_position]
    for uuid in uuids:
        var saved_position: Variant = Ref.save_file_manager.loaded_file.get_data("node/%s/global_position" % uuid, null)
        if saved_position is Vector3 and Vector3i(saved_position) == block_position:
            return uuid
    return ""


func _remove_saved_preserve_node_at_position(block_position: Vector3i) -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null or not is_instance_valid(Ref.world):
        return

    var uuid: String = _find_saved_preserve_uuid_at_block_position(block_position)
    if uuid == "":
        return

    var chunk_to_uuid_map: Dictionary = _get_saved_chunk_to_uuid_map()
    var chunk_position: Vector3i = Ref.world.snap_to_chunk(block_position)
    var uuids: PackedStringArray = chunk_to_uuid_map.get(chunk_position, PackedStringArray())
    var updated_uuids: PackedStringArray = PackedStringArray()
    for existing_uuid in uuids:
        if existing_uuid != uuid:
            updated_uuids.append(existing_uuid)

    if updated_uuids.is_empty():
        chunk_to_uuid_map.erase(chunk_position)
    else:
        chunk_to_uuid_map[chunk_position] = updated_uuids
    _store_saved_chunk_to_uuid_map(chunk_to_uuid_map)

    Ref.save_file_manager.loaded_file.erase_data("node/%s" % uuid)


func _upsert_saved_living_block_at_position(block_position: Vector3i, block_id: int) -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null or not is_instance_valid(Ref.world):
        return

    var block: Block = ItemMap.map(block_id)
    if block == null or str(block.living_block_scene_path) == "":
        return

    var uuid: String = _find_saved_preserve_uuid_at_block_position(block_position)
    if uuid == "":
        uuid = UUID.v4()
        var chunk_to_uuid_map: Dictionary = _get_saved_chunk_to_uuid_map()
        var chunk_position: Vector3i = Ref.world.snap_to_chunk(block_position)
        var uuids: PackedStringArray = chunk_to_uuid_map.get(chunk_position, PackedStringArray())
        uuids.append(uuid)
        chunk_to_uuid_map[chunk_position] = uuids
        _store_saved_chunk_to_uuid_map(chunk_to_uuid_map)

    Ref.save_file_manager.loaded_file.set_data("node/%s/global_position" % uuid, Vector3(block_position))
    Ref.save_file_manager.loaded_file.set_data("node/%s/file_path" % uuid, str(block.living_block_scene_path))


func _get_living_block_scene_path(block_id: int) -> String:
    var block: Block = ItemMap.map(block_id)
    if block == null:
        return ""
    return str(block.living_block_scene_path)


func _is_living_block_id(block_id: int) -> bool:
    return _get_living_block_scene_path(block_id) != ""


func _serialize_storage_items_for_preserve_save(serialized_items: Array) -> Array:
    var preserved_items: Array = []
    for item_data in serialized_items:
        if item_data is PackedInt32Array and item_data.size() > 0:
            preserved_items.append(item_data)
        else:
            preserved_items.append(PackedInt32Array())
        preserved_items.append(Vector3i.ZERO)
    return preserved_items


func _store_remote_storage_inventory_snapshot_in_save(block_position: Vector3i, serialized_items: Array) -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null:
        return

    var uuid: String = _find_saved_preserve_uuid_at_block_position(block_position)
    if uuid == "":
        return

    Ref.save_file_manager.loaded_file.set_data(
        "node/%s/Inventory/items" % uuid,
        _serialize_storage_items_for_preserve_save(serialized_items),
        false
    )
    Ref.save_file_manager.loaded_file.set_data("node/%s/Inventory/capacity" % uuid, serialized_items.size(), false)


func _bind_sync_uuid(node: Node, uuid: String) -> void:
    if node == null or not is_instance_valid(node) or uuid == "":
        return
    node.set_meta("coop_uuid", uuid)
    if Ref.preserve_node_manager != null:
        Ref.preserve_node_manager.node_to_uuid_map[node] = uuid


func _capture_entity_save_bundle(entity, uuid: String = "") -> Dictionary:
    if entity == null or not is_instance_valid(entity) or not (entity is Entity):
        return {}

    var resolved_uuid: String = uuid if uuid != "" else _assign_sync_uuid(entity)
    var scene_path: String = _get_sync_scene_path(entity)
    if resolved_uuid == "" or scene_path == "":
        return {}

    var temp_file := SaveFile.new()
    entity.preserve_save(temp_file, resolved_uuid)
    temp_file.set_data("node/%s/file_path" % resolved_uuid, scene_path, false)
    return {
        "uuid": resolved_uuid,
        "scene_path": scene_path,
        "position": entity.global_position,
        "save_data": temp_file.data.duplicate_deep(),
    }


func _remove_uuid_from_chunk_map(chunk_to_uuid_map: Dictionary, chunk_position: Vector3i, uuid: String) -> void:
    if uuid == "" or not chunk_to_uuid_map.has(chunk_position):
        return

    var uuids: PackedStringArray = chunk_to_uuid_map.get(chunk_position, PackedStringArray())
    var index: int = uuids.find(uuid)
    if index >= 0:
        uuids.remove_at(index)
    if uuids.is_empty():
        chunk_to_uuid_map.erase(chunk_position)
    else:
        chunk_to_uuid_map[chunk_position] = uuids


func _add_uuid_to_chunk_map(chunk_to_uuid_map: Dictionary, chunk_position: Vector3i, uuid: String) -> void:
    if uuid == "":
        return

    var uuids: PackedStringArray = chunk_to_uuid_map.get(chunk_position, PackedStringArray())
    if uuids.find(uuid) < 0:
        uuids.append(uuid)
    chunk_to_uuid_map[chunk_position] = uuids


func _merge_save_data_into_loaded_file(save_data: Dictionary) -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null:
        return

    for key in save_data.keys():
        var source_value: Variant = save_data[key]
        if source_value is Dictionary and Ref.save_file_manager.loaded_file.data.get(key, null) is Dictionary:
            Ref.save_file_manager.loaded_file.data[key] = _merge_patch_dictionary(Ref.save_file_manager.loaded_file.data.get(key, {}), source_value)
        else:
            Ref.save_file_manager.loaded_file.data[key] = source_value.duplicate(true) if (source_value is Dictionary or source_value is Array) else source_value


func _materialize_entity_from_save_bundle(bundle: Dictionary, guest_local_authority: bool = false):
    var uuid: String = str(bundle.get("uuid", ""))
    var scene_path: String = str(bundle.get("scene_path", ""))
    var save_data: Variant = bundle.get("save_data", {})
    if uuid == "" or scene_path == "" or not (save_data is Dictionary):
        return null

    var existing = _find_existing_entity_by_uuid(uuid)
    if is_instance_valid(existing) and bool(existing.get_meta("coop_synced_entity", false)):
        var existing_parent: Node = existing.get_parent()
        if existing_parent != null:
            existing_parent.remove_child(existing)
        existing.queue_free()
        existing = null

    var entity = existing
    if not is_instance_valid(entity):
        var scene = load(scene_path)
        if not (scene is PackedScene):
            return null
        entity = scene.instantiate()
        if entity == null or not (entity is Entity):
            if entity != null:
                entity.queue_free()
            return null
        entity.set_meta("coop_source_scene_path", scene_path)
        get_tree().get_root().add_child(entity)

    _bind_sync_uuid(entity, uuid)
    entity.remove_meta("coop_synced_entity")
    entity.remove_meta("coop_candidate_existing")
    entity.remove_meta("coop_client_runtime_configured")
    entity.remove_meta("coop_entity_snapshot_initialized")
    entity.remove_meta("coop_client_authoritative_dead")
    entity.remove_meta("coop_client_death_visual_played")
    if guest_local_authority:
        entity.set_meta("coop_guest_local_authority", true)
    else:
        entity.remove_meta("coop_guest_local_authority")

    var temp_file := SaveFile.new()
    temp_file.data = save_data.duplicate_deep()
    entity.preserve_load(temp_file, uuid)

    if entity is Entity:
        entity.disabled = false
        entity.disabled_by_visibility = false
        entity.invincible = false
        entity.invincible_temporary = false

    return entity


func _remove_saved_entity_uuid(uuid: String) -> void:
    if uuid == "" or Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null or not is_instance_valid(Ref.world):
        return

    var previous_position: Variant = Ref.save_file_manager.loaded_file.get_data("node/%s/global_position" % uuid, null, false)
    var chunk_to_uuid_map: Dictionary = _get_saved_chunk_to_uuid_map()
    if previous_position is Vector3:
        _remove_uuid_from_chunk_map(chunk_to_uuid_map, Ref.world.snap_to_chunk(previous_position), uuid)
        _store_saved_chunk_to_uuid_map(chunk_to_uuid_map)

    Ref.save_file_manager.loaded_file.erase_data("node/%s" % uuid)

    var existing = _find_existing_entity_by_uuid(uuid)
    if is_instance_valid(existing) and not is_remote_player_proxy(existing):
        existing.queue_free()


func _upsert_saved_entity_bundle(bundle: Dictionary) -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null or not is_instance_valid(Ref.world):
        return

    var uuid: String = str(bundle.get("uuid", ""))
    var scene_path: String = str(bundle.get("scene_path", ""))
    var save_data: Variant = bundle.get("save_data", {})
    var position: Variant = bundle.get("position", Vector3.ZERO)
    if uuid == "" or scene_path == "" or not (save_data is Dictionary) or not (position is Vector3):
        return

    var chunk_to_uuid_map: Dictionary = _get_saved_chunk_to_uuid_map()
    var previous_position: Variant = Ref.save_file_manager.loaded_file.get_data("node/%s/global_position" % uuid, null, false)
    if previous_position is Vector3:
        _remove_uuid_from_chunk_map(chunk_to_uuid_map, Ref.world.snap_to_chunk(previous_position), uuid)
    var chunk_position: Vector3i = Ref.world.snap_to_chunk(position)
    _add_uuid_to_chunk_map(chunk_to_uuid_map, chunk_position, uuid)

    _merge_save_data_into_loaded_file(save_data)
    Ref.save_file_manager.loaded_file.set_data("node/%s/file_path" % uuid, scene_path, false)

    if Ref.world.is_position_loaded(position):
        _remove_uuid_from_chunk_map(chunk_to_uuid_map, chunk_position, uuid)
        _store_saved_chunk_to_uuid_map(chunk_to_uuid_map)
        _materialize_entity_from_save_bundle(bundle)
    else:
        _store_saved_chunk_to_uuid_map(chunk_to_uuid_map)


func _guest_entity_registry_key(player_key: String, dimension_instance_key: String) -> String:
    return "%s|%s" % [player_key, dimension_instance_key]


func _store_guest_authoritative_entities(player_key: String, dimension_instance_key: String, entity_bundles: Array) -> void:
    if not _can_share_loaded_world() or player_key == "" or dimension_instance_key == "":
        return

    var registry_key: String = _guest_entity_registry_key(player_key, dimension_instance_key)
    var previous_uuids: PackedStringArray = guest_authoritative_entity_registry.get(registry_key, PackedStringArray())
    var current_uuids: PackedStringArray = PackedStringArray()

    for bundle in entity_bundles:
        if not (bundle is Dictionary):
            continue
        var entity_bundle: Dictionary = bundle
        if str(entity_bundle.get("dimension_instance_key", dimension_instance_key)) != dimension_instance_key:
            continue
        var uuid: String = str(entity_bundle.get("uuid", ""))
        if uuid == "":
            continue
        if current_uuids.find(uuid) < 0:
            current_uuids.append(uuid)
        _upsert_saved_entity_bundle(entity_bundle)

    for previous_uuid in previous_uuids:
        if current_uuids.find(previous_uuid) >= 0:
            continue
        _remove_saved_entity_uuid(previous_uuid)

    guest_authoritative_entity_registry[registry_key] = current_uuids


func is_applying_remote_storage_sync(block_position: Vector3i) -> bool:
    return applying_remote_storage_positions.has(block_position)


func notify_local_storage_inventory_changed(block_position: Vector3i, inventory: Inventory) -> void:
    if inventory == null or not is_instance_valid(inventory):
        return
    if is_applying_remote_storage_sync(block_position):
        return
    if is_instance_valid(Ref.world):
        Ref.world.modify_chunk(block_position)

    var serialized_items: Array = _serialize_inventory_items(inventory)
    var dimension_instance_key: String = get_active_dimension_instance_key()
    if multiplayer.is_server():
        _record_server_world_cell_journal(multiplayer.get_unique_id(), 0, "storage", dimension_instance_key, block_position, {"items": serialized_items})
        if _has_live_peer():
            sync_storage_inventory.rpc(dimension_instance_key, block_position, serialized_items)
        return

    if not _has_live_peer():
        return
    if _is_local_world_authority():
        notify_local_world_state_dirty([block_position])
        return
    if _is_client_gameplay_locked():
        return
    request_storage_inventory.rpc_id(1, dimension_instance_key, block_position, serialized_items)


func _apply_storage_inventory_snapshot(block_position: Vector3i, serialized_items: Array) -> void:
    if not is_instance_valid(Ref.world) or not Ref.world.is_position_loaded(block_position):
        pending_remote_storage_changes[block_position] = serialized_items.duplicate(true)
        return

    var inventory: Inventory = _resolve_storage_inventory(block_position)
    if inventory == null or not is_instance_valid(inventory):
        pending_remote_storage_changes[block_position] = serialized_items.duplicate(true)
        return

    if is_instance_valid(Ref.world):
        Ref.world.modify_chunk(block_position)

    applying_remote_storage_positions[block_position] = true
    _apply_serialized_inventory_items(inventory, serialized_items)
    applying_remote_storage_positions.erase(block_position)


func _invalidate_host_dynamic_cell_caches() -> void:
    if not multiplayer.is_server():
        return
    host_water_snapshot_cache.clear()
    host_fire_snapshot_cache.clear()


func _get_water_sync_bucket(center: Vector3) -> Vector3i:
    return Vector3i(
        int(floor(center.x / WATER_SYNC_BUCKET_SIZE)),
        int(floor(center.y / WATER_SYNC_BUCKET_SIZE)),
        int(floor(center.z / WATER_SYNC_BUCKET_SIZE))
    )


func _capture_host_water_changes(peer_id: int, center_position: Vector3, dimension_instance_key: String) -> Array:
    var cache: Dictionary = host_water_snapshot_cache.get(peer_id, {})
    var bucket: Vector3i = _get_water_sync_bucket(center_position)
    var previous_levels: Dictionary = cache.get("levels", {})
    var force_full_sync: bool = cache.is_empty() or str(cache.get("dimension_instance_key", "")) != dimension_instance_key
    if str(cache.get("dimension_instance_key", "")) != dimension_instance_key:
        previous_levels = {}
    elif _can_skip_host_dynamic_cell_rescan(cache, bucket):
        return []

    var current_levels: Dictionary = {}
    var changes: Array = []
    var base_position: Vector3i = Vector3i(center_position.floor())
    for y in range(base_position.y - WATER_SYNC_VERTICAL_RADIUS, base_position.y + WATER_SYNC_VERTICAL_RADIUS + 1):
        for x in range(base_position.x - WATER_SYNC_HORIZONTAL_RADIUS, base_position.x + WATER_SYNC_HORIZONTAL_RADIUS + 1):
            for z in range(base_position.z - WATER_SYNC_HORIZONTAL_RADIUS, base_position.z + WATER_SYNC_HORIZONTAL_RADIUS + 1):
                var cell_position: Vector3i = Vector3i(x, y, z)
                if not Ref.world.is_position_loaded(cell_position):
                    continue
                var water_level: int = int(Ref.world.get_water_level_at(cell_position))
                if force_full_sync and water_level > 0:
                    changes.append([cell_position, water_level])
                if water_level > 0:
                    current_levels[cell_position] = water_level

    if not force_full_sync:
        for cell_position in current_levels.keys():
            var water_level: int = int(current_levels[cell_position])
            if int(previous_levels.get(cell_position, -1)) != water_level:
                changes.append([cell_position, water_level])

        for cell_position in previous_levels.keys():
            if not current_levels.has(cell_position):
                changes.append([cell_position, 0])

    host_water_snapshot_cache[peer_id] = {
        "dimension_instance_key": dimension_instance_key,
        "bucket": bucket,
        "last_scan_msec": Time.get_ticks_msec(),
        "levels": current_levels,
    }
    return changes


func _capture_host_fire_changes(peer_id: int, center_position: Vector3, dimension_instance_key: String) -> Array:
    var cache: Dictionary = host_fire_snapshot_cache.get(peer_id, {})
    var bucket: Vector3i = _get_water_sync_bucket(center_position)
    var previous_levels: Dictionary = cache.get("levels", {})
    var force_full_sync: bool = cache.is_empty() or str(cache.get("dimension_instance_key", "")) != dimension_instance_key
    if str(cache.get("dimension_instance_key", "")) != dimension_instance_key:
        previous_levels = {}
    elif _can_skip_host_dynamic_cell_rescan(cache, bucket):
        return []

    var current_levels: Dictionary = {}
    var changes: Array = []
    var base_position: Vector3i = Vector3i(center_position.floor())
    for y in range(base_position.y - WATER_SYNC_VERTICAL_RADIUS, base_position.y + WATER_SYNC_VERTICAL_RADIUS + 1):
        for x in range(base_position.x - WATER_SYNC_HORIZONTAL_RADIUS, base_position.x + WATER_SYNC_HORIZONTAL_RADIUS + 1):
            for z in range(base_position.z - WATER_SYNC_HORIZONTAL_RADIUS, base_position.z + WATER_SYNC_HORIZONTAL_RADIUS + 1):
                var cell_position: Vector3i = Vector3i(x, y, z)
                if not Ref.world.is_position_loaded(cell_position):
                    continue
                var fire_level: int = int(Ref.world.get_fire_at(cell_position))
                if force_full_sync and fire_level > 0:
                    changes.append([cell_position, fire_level])
                if fire_level > 0:
                    current_levels[cell_position] = fire_level

    if not force_full_sync:
        for cell_position in current_levels.keys():
            var fire_level: int = int(current_levels[cell_position])
            if int(previous_levels.get(cell_position, -1)) != fire_level:
                changes.append([cell_position, fire_level])

        for cell_position in previous_levels.keys():
            if not current_levels.has(cell_position):
                changes.append([cell_position, 0])

    host_fire_snapshot_cache[peer_id] = {
        "dimension_instance_key": dimension_instance_key,
        "bucket": bucket,
        "last_scan_msec": Time.get_ticks_msec(),
        "levels": current_levels,
    }
    return changes


func _can_skip_host_dynamic_cell_rescan(cache: Dictionary, bucket: Vector3i) -> bool:
    if cache.is_empty() or cache.get("bucket", Vector3i.ZERO) != bucket:
        return false
    var last_scan_msec: int = int(cache.get("last_scan_msec", 0))
    if last_scan_msec <= 0:
        return false
    return (Time.get_ticks_msec() - last_scan_msec) < int(HOST_DYNAMIC_CELL_RESAMPLE_INTERVAL_SEC * 1000.0)


func _sync_host_water_state_for_peer(peer_id: int, peer_state: Dictionary) -> void:
    if not multiplayer.is_server() or peer_id <= 1 or not is_instance_valid(Ref.world):
        return

    var dimension_instance_key: String = get_active_dimension_instance_key()
    if not _is_peer_state_same_instance(peer_state, dimension_instance_key):
        return

    var center_position: Vector3 = peer_state.get("position", Ref.player.global_position)
    var changes: Array = _capture_host_water_changes(peer_id, center_position, dimension_instance_key)
    if changes.is_empty():
        return
    sync_water_cells.rpc_id(peer_id, dimension_instance_key, changes)


func _sync_host_fire_state_for_peer(peer_id: int, peer_state: Dictionary) -> void:
    if not multiplayer.is_server() or peer_id <= 1 or not is_instance_valid(Ref.world):
        return

    var dimension_instance_key: String = get_active_dimension_instance_key()
    if not _is_peer_state_same_instance(peer_state, dimension_instance_key):
        return

    var center_position: Vector3 = peer_state.get("position", Ref.player.global_position)
    var changes: Array = _capture_host_fire_changes(peer_id, center_position, dimension_instance_key)
    if changes.is_empty():
        return
    sync_fire_cells.rpc_id(peer_id, dimension_instance_key, changes)


func _capture_local_persistent_state() -> Dictionary:
    if not _can_sample_player():
        return {}

    var temp_file := SaveFile.new()
    var player = Ref.player
    var uuid: String = "player"
    var multidimensional: bool = true

    temp_file.set_data("node/%s/held_item_index" % uuid, player.held_item_index, multidimensional)
    temp_file.set_data("node/%s/in_air" % uuid, player.in_air, false)
    temp_file.set_data("node/%s/global_position" % uuid, player.global_position, false)
    temp_file.set_data("node/%s/movement_velocity" % uuid, player.movement_velocity, false)
    temp_file.set_data("node/%s/gravity_velocity" % uuid, player.gravity_velocity, false)
    temp_file.set_data("node/%s/knockback_velocity" % uuid, player.knockback_velocity, false)
    temp_file.set_data("node/%s/rope_velocity" % uuid, player.rope_velocity, false)
    temp_file.set_data("node/%s/health" % uuid, player.health, multidimensional)
    temp_file.set_data("node/%s/max_health" % uuid, player.max_health, multidimensional)
    temp_file.set_data("node/%s/hate" % uuid, player.hate, multidimensional)
    temp_file.set_data("node/%s/faith" % uuid, player.faith, multidimensional)
    temp_file.set_data("node/%s/lust" % uuid, player.lust, multidimensional)
    temp_file.set_data("node/%s/rotation_pivot" % uuid, player.get_node("%RotationPivot").rotation.y, false)
    temp_file.set_data("node/%s/nickname" % uuid, player.nickname, multidimensional)
    temp_file.set_data("node/%s/has_endure" % uuid, player.has_endure, multidimensional)

    for child in player.find_children("*"):
        if "preserve_save" in child and child != player:
            child.preserve_save(temp_file, uuid)

    return temp_file.data.duplicate_deep()


func _send_persistent_state_to_host(force_send: bool = false) -> void:
    if multiplayer.is_server() or not _has_live_peer() or not _can_sample_player():
        return
    if not force_send and not guest_persistent_ready:
        return

    var state: Dictionary = _capture_local_persistent_state()
    if state.is_empty():
        return

    submit_guest_persistent_state.rpc_id(
        1,
        _get_local_player_key(),
        _get_local_player_name(),
        state
    )


func _send_local_authoritative_entities_to_host(force_send: bool = false) -> void:
    if multiplayer.is_server() or not _has_live_peer() or not _can_sample_player():
        return
    var has_live_guest_entity_authority: bool = _has_local_guest_entity_authority()
    if not force_send:
        if not guest_persistent_ready or _is_client_gameplay_locked() or not has_live_guest_entity_authority:
            return

    var entity_bundles: Array = []
    var dimension_instance_key: String = get_active_dimension_instance_key()
    for child in _get_live_tracked_entities():
        if not _is_syncable_entity_node(child):
            continue
        if bool(child.get_meta("coop_synced_entity", false)):
            continue
        if not has_live_guest_entity_authority and not bool(child.get_meta("coop_guest_local_authority", false)):
            continue
        if child.dead:
            continue

        var uuid: String = _assign_sync_uuid(child)
        if uuid == "":
            continue
        child.set_meta("coop_guest_local_authority", true)

        var bundle: Dictionary = _capture_entity_save_bundle(child, uuid)
        if bundle.is_empty():
            continue
        bundle["dimension_instance_key"] = dimension_instance_key
        entity_bundles.append(bundle)

    if entity_bundles.is_empty() and not has_live_guest_entity_authority:
        return

    submit_guest_authoritative_entities.rpc_id(1, _get_local_player_key(), dimension_instance_key, entity_bundles)


func _merge_guest_private_instance_cache_into_loaded_save(player_key: String, save_data: Dictionary) -> void:
    if not _can_share_loaded_world() or player_key == "" or save_data.is_empty():
        return

    var target_save_data: Dictionary = Ref.save_file_manager.loaded_file.data
    for dimension in [int(LucidBlocksWorld.Dimension.POCKET), int(LucidBlocksWorld.Dimension.FIRMAMENT)]:
        var dimension_namespace: String = _resolve_dimension_namespace(dimension, player_key)
        var prefix: String = dimension_namespace + "_"
        if _copy_world_namespace_between_save_data(save_data, target_save_data, prefix, prefix):
            var respawn_positions: Variant = SaveFile._get_data(save_data, "%s/respawn_positions" % dimension_namespace, null)
            if respawn_positions != null:
                SaveFile._set_data(target_save_data, "%s/respawn_positions" % dimension_namespace, respawn_positions.duplicate(true))


func _store_guest_persistent_state(player_key: String, player_name: String, save_data: Dictionary) -> void:
    if not _can_share_loaded_world() or player_key == "" or save_data.is_empty():
        return

    Ref.save_file_manager.loaded_file.set_data("coop/players/%s/name" % player_key, player_name, true)
    Ref.save_file_manager.loaded_file.set_data("coop/players/%s/save_data" % player_key, save_data.duplicate_deep(), true)
    _merge_guest_private_instance_cache_into_loaded_save(player_key, save_data)


func _store_guest_exit_position_from_peer_state(peer_id: int, peer_state: Dictionary) -> void:
    if not multiplayer.is_server() or not _can_share_loaded_world() or peer_state.is_empty():
        return

    var player_key: String = str(peer_state.get("player_key", "")).strip_edges()
    if player_key == "":
        return

    var position_value: Variant = peer_state.get("position", null)
    if not (position_value is Vector3):
        return

    var save_data: Dictionary = _get_guest_persistent_state(player_key)
    if save_data.is_empty():
        save_data = {}

    var position: Vector3 = position_value
    var zero_velocity := Vector3.ZERO
    var yaw: float = float(peer_state.get("yaw", 0.0))
    var dimension: int = int(peer_state.get("dimension", -1))
    var dimension_namespace: String = str(SaveFile.DIMENSION_MAP.get(dimension, ""))
    var player_paths: Array[String] = ["node/player"]
    if dimension_namespace != "":
        player_paths.append("%s/node/player" % dimension_namespace)

    for player_path in player_paths:
        SaveFile._set_data(save_data, "%s/global_position" % player_path, position)
        SaveFile._set_data(save_data, "%s/in_air" % player_path, false)
        SaveFile._set_data(save_data, "%s/movement_velocity" % player_path, zero_velocity)
        SaveFile._set_data(save_data, "%s/gravity_velocity" % player_path, zero_velocity)
        SaveFile._set_data(save_data, "%s/knockback_velocity" % player_path, zero_velocity)
        SaveFile._set_data(save_data, "%s/rope_velocity" % player_path, zero_velocity)
        SaveFile._set_data(save_data, "%s/rotation_pivot" % player_path, yaw)

    var player_name: String = str(peer_state.get("name", "Peer %s" % peer_id)).strip_edges()
    _store_guest_persistent_state(player_key, player_name, save_data)
    if dedicated_server_enabled:
        print("[lucid-blocks-coop] Saved exit position for peer=%s player_key=%s" % [peer_id, player_key])
    _autosave_host_world_if_needed()


func _get_guest_persistent_state(player_key: String) -> Dictionary:
    if not _can_share_loaded_world() or player_key == "":
        return {}
    var guest_data: Variant = Ref.save_file_manager.loaded_file.get_data("coop/players/%s/save_data" % player_key, {}, true)
    return guest_data.duplicate_deep() if guest_data is Dictionary else {}


func _get_guest_persistent_position_for_dimension(player_key: String, dimension: int) -> Variant:
    var guest_data: Dictionary = _get_guest_persistent_state(player_key)
    if guest_data.is_empty():
        return null

    var dimension_namespace: String = str(SaveFile.DIMENSION_MAP.get(dimension, ""))
    if dimension_namespace != "":
        var dimension_position: Variant = SaveFile._get_data(guest_data, "%s/node/player/global_position" % dimension_namespace, null)
        if dimension_position is Vector3:
            return dimension_position

    var global_position: Variant = SaveFile._get_data(guest_data, "node/player/global_position", null)
    return global_position if global_position is Vector3 else null


func _finish_guest_character_restore() -> void:
    _clear_local_downed_state()
    local_fake_death_pending = false
    local_fake_death_save_override.clear()
    local_fake_death_respawn_target_valid = false
    clear_fake_death_override_after_shutdown = false
    handling_client_respawn = false
    remote_host_respawning = false
    client_restore_in_progress = false
    guest_persistent_ready = true
    if is_instance_valid(Ref.player):
        Ref.player.dead = false
        Ref.player.disabled = false
        Ref.player.make_invincible_temporary()
    _set_death_overlay_visible(false)
    if not multiplayer.is_server():
        reconnect_pending = false
        reconnect_attempt_count = 0
        reconnect_retry_timer = 0.0
        reconnect_reason = ""
        _set_reconnect_overlay_visible(false)
        status_message = "Joined host world"
        _update_status_text()
        _force_local_guest_gameplay_unlock("persistent_restore")
    _send_persistent_state_to_host(true)


func _force_local_guest_gameplay_unlock(reason: String = "") -> void:
    if multiplayer.is_server():
        return
    if get_tree() != null:
        get_tree().paused = false
    if is_instance_valid(Ref.player):
        Ref.player.dead = false
        Ref.player.disabled = false
        Ref.player.movement_enabled = true
        Ref.player.set_process(true)
        Ref.player.set_physics_process(true)
        Ref.player.set_process_input(true)
        Ref.player.set_process_unhandled_input(true)
        Ref.player.make_invincible_temporary()
    call_deferred("_recapture_mouse_for_guest_gameplay", reason)


func _recapture_mouse_for_guest_gameplay(reason: String = "") -> void:
    if multiplayer.is_server() or not _has_live_peer() or not guest_persistent_ready:
        return
    if not is_instance_valid(Ref.main) or not Ref.main.loaded:
        return
    MouseHandler.capture()
    print("[lucid-blocks-coop] guest gameplay unlocked reason=%s disabled=%s movement=%s captured=%s full=%s" % [
        reason,
        str(Ref.player.disabled if is_instance_valid(Ref.player) else true),
        str(Ref.player.movement_enabled if is_instance_valid(Ref.player) else false),
        str(MouseHandler.captured),
        str(MouseHandler.fully_captured),
    ])


func _watch_guest_character_restore_timeout() -> void:
    await get_tree().create_timer(CLIENT_GUEST_RESTORE_TIMEOUT_SEC, false).timeout
    if multiplayer.is_server() or not _has_live_peer():
        return
    if not client_restore_in_progress or guest_persistent_ready or receiving_host_world:
        return
    if not _can_sample_player():
        return
    print("[lucid-blocks-coop] guest persistent state timed out; enabling snapshot player")
    _finish_guest_character_restore()


func _apply_received_guest_state(save_data: Dictionary) -> void:
    if save_data.is_empty() or not _can_sample_player():
        return

    _clear_local_downed_state()
    var temp_file := SaveFile.new()
    temp_file.data = save_data.duplicate_deep()
    if client_restore_in_progress and incoming_snapshot_follow_host_position and not multiplayer.is_server() and is_instance_valid(Ref.world):
        var dimension_namespace: String = str(SaveFile.DIMENSION_MAP.get(Ref.world.current_dimension, ""))
        if dimension_namespace != "":
            # Keep the freshly synced spawn point instead of restoring stale or missing per-dimension motion data.
            SaveFile._set_data(temp_file.data, "%s/node/player/global_position" % dimension_namespace, Ref.player.global_position)
            SaveFile._set_data(temp_file.data, "%s/node/player/in_air" % dimension_namespace, Ref.player.in_air)
            SaveFile._set_data(temp_file.data, "%s/node/player/movement_velocity" % dimension_namespace, Ref.player.movement_velocity)
            SaveFile._set_data(temp_file.data, "%s/node/player/gravity_velocity" % dimension_namespace, Ref.player.gravity_velocity)
            SaveFile._set_data(temp_file.data, "%s/node/player/knockback_velocity" % dimension_namespace, Ref.player.knockback_velocity)
            SaveFile._set_data(temp_file.data, "%s/node/player/rope_velocity" % dimension_namespace, Ref.player.rope_velocity)
            SaveFile._set_data(temp_file.data, "%s/node/player/rotation_pivot" % dimension_namespace, Ref.player.get_node("%RotationPivot").rotation.y)
    Ref.player.load_file(temp_file)
    Ref.player.dead = false
    Ref.player.disabled = false
    Ref.player.make_invincible_temporary()
    _finish_guest_character_restore()


func _initialize_new_guest_profile() -> void:
    if not _can_sample_player():
        return

    _clear_local_downed_state()
    var spawn_position: Vector3 = Ref.player.global_position
    var camera_angle: float = Ref.player.get_node_or_null("%Camera3D").rotation.x if Ref.player.get_node_or_null("%Camera3D") != null else 0.0
    Ref.player._on_new_game()
    var inventories: Array = [
        Ref.player_hotbar,
        Ref.player_inventory,
        Ref.player_equipment,
        Ref.player_fusion_source,
        Ref.player_fusion_result,
    ]
    for inventory in inventories:
        _clear_inventory_contents(inventory)

    Ref.player.held_item_index = 0
    Ref.player.dead = false
    Ref.player.disabled = false
    Ref.player.revive()
    Ref.player.global_position = spawn_position
    var camera: Camera3D = Ref.player.get_node_or_null("%Camera3D") as Camera3D
    if camera != null:
        camera.rotation.x = camera_angle
    Ref.player.make_invincible_temporary()
    _finish_guest_character_restore()


func _clear_inventory_contents(inventory) -> void:
    if inventory == null:
        return
    for index in range(inventory.capacity):
        inventory.set_item(index, null)


func _set_death_overlay_visible(visible: bool, subtitle: String = "Respawning...", title: String = "YOU DIED") -> void:
    if death_overlay == null:
        return
    death_overlay.visible = visible
    if visible and death_overlay_title != null:
        death_overlay_title.text = title
    if visible and death_overlay_subtitle != null:
        death_overlay_subtitle.text = subtitle


func is_local_player_fake_dead() -> bool:
    return local_fake_death_pending or handling_host_respawn or handling_client_respawn or host_respawning


func has_local_fake_death_save_override() -> bool:
    return not local_fake_death_save_override.is_empty()


func should_apply_local_fake_death_save_override() -> bool:
    return is_local_player_fake_dead() or (has_local_fake_death_save_override() and local_quit_in_progress)


func _get_local_fake_death_save_position() -> Vector3:
    if not _can_sample_player():
        return Vector3.ZERO
    if local_fake_death_respawn_target_valid:
        return local_fake_death_respawn_target

    var fallback_position: Vector3 = Ref.player.global_position
    if not Ref.player.wandering_spirit and not Ref.world.respawn_positions.is_empty():
        fallback_position = _resolve_default_respawn_fallback_position(Ref.player.global_position)

    if not _has_live_peer():
        return fallback_position

    if multiplayer.is_server():
        if _has_remote_respawn_anchor(false):
            return _find_safe_respawn_position_near(_get_remote_respawn_anchor(false, fallback_position), fallback_position)
        return fallback_position

    if _has_remote_respawn_anchor(true):
        return _find_safe_respawn_position_near(_get_remote_respawn_anchor(true, fallback_position), fallback_position)
    return fallback_position


func _build_local_fake_death_save_overrides() -> Dictionary:
    if not _can_sample_player():
        return {}

    return {
        "in_air": false,
        "global_position": _get_local_fake_death_save_position(),
        "movement_velocity": Vector3.ZERO,
        "gravity_velocity": Vector3.ZERO,
        "knockback_velocity": Vector3.ZERO,
        "rope_velocity": Vector3.ZERO,
        "health": maxi(1, Ref.player.max_health),
    }


func get_local_fake_death_save_overrides() -> Dictionary:
    if has_local_fake_death_save_override():
        return local_fake_death_save_override.duplicate(true)
    if not is_local_player_fake_dead():
        return {}
    return _build_local_fake_death_save_overrides()


func _stabilize_local_player_after_fake_death(restore_control: bool = true) -> void:
    if not is_instance_valid(Ref.player):
        return

    if Ref.player.health <= 0:
        Ref.player.health = maxi(1, Ref.player.max_health)
    Ref.player.dead = false
    _reset_local_player_motion()
    if restore_control:
        Ref.player.disabled = false


func _abort_host_respawn(sync_remote_state: bool = false, broadcast_state: bool = false) -> void:
    var had_host_respawn: bool = handling_host_respawn or host_respawning
    if had_host_respawn:
        host_respawn_sequence += 1

    if not local_fake_death_respawn_target_valid:
        local_fake_death_respawn_target = _get_local_fake_death_save_position()
        local_fake_death_respawn_target_valid = true
    if local_fake_death_save_override.is_empty():
        local_fake_death_save_override = _build_local_fake_death_save_overrides()
    if local_fake_death_respawn_target_valid and _can_sample_player():
        _teleport_local_player_exact(local_fake_death_respawn_target)
    local_fake_death_pending = false
    handling_host_respawn = false
    host_respawning = false
    _set_death_overlay_visible(false)
    _stabilize_local_player_after_fake_death()

    if sync_remote_state and _has_live_peer():
        sync_host_respawn_state.rpc(false)
    if broadcast_state and _has_live_peer():
        _broadcast_local_state_now()


func _stop_local_player_actions() -> void:
    if not _can_sample_player():
        return

    var break_behavior = Ref.player.get_node_or_null("%BreakBlocks")
    if break_behavior != null:
        break_behavior.break_block_stop()

    if is_instance_valid(Ref.player.held_item):
        Ref.player.held_item.interact_end()


func _reset_local_player_motion() -> void:
    if not _can_sample_player():
        return

    Ref.player.movement_velocity = Vector3.ZERO
    Ref.player.gravity_velocity = Vector3.ZERO
    Ref.player.knockback_velocity = Vector3.ZERO
    Ref.player.rope_velocity = Vector3.ZERO
    Ref.player.velocity = Vector3.ZERO


func _teleport_local_player_exact(target_position: Vector3) -> void:
    if not _can_sample_player():
        return

    Ref.player.global_position = target_position
    _reset_local_player_motion()


func _resolve_safe_position_near_player(target_position: Vector3) -> Vector3:
    var fallback_position: Vector3 = target_position + Vector3(1.5, 0.0, 0.0)
    return _find_safe_respawn_position_near(target_position, fallback_position)


func _close_pause_menu_if_open() -> void:
    if Ref.game_menu == null:
        return
    if int(Ref.game_menu.state) == 4 and Ref.game_menu.has_method("close_pause"):
        Ref.game_menu.close_pause()


func _is_safe_respawn_position(world_position: Vector3) -> bool:
    if not is_instance_valid(Ref.world):
        return true

    var feet_position: Vector3 = world_position
    var body_position: Vector3 = world_position + Vector3(0.0, 1.0, 0.0)
    var floor_position: Vector3 = world_position + Vector3(0.0, -1.0, 0.0)
    if not Ref.world.is_position_loaded(feet_position) or not Ref.world.is_position_loaded(body_position) or not Ref.world.is_position_loaded(floor_position):
        return false
    if Ref.world.is_block_solid_at(feet_position) or Ref.world.is_block_solid_at(body_position):
        return false
    if not Ref.world.is_block_solid_at(floor_position):
        return false
    if Ref.world.get_water_level_at(feet_position) > 0 or Ref.world.get_water_level_at(body_position) > 0:
        return false
    return true


func _find_safe_respawn_position_near(anchor_position: Vector3, fallback_position: Vector3) -> Vector3:
    var centered_anchor: Vector3 = anchor_position.floor() + Vector3(0.5, 0.0, 0.5)
    var offsets: Array[Vector3] = [
        Vector3(1.5, 0.0, 0.0),
        Vector3(-1.5, 0.0, 0.0),
        Vector3(0.0, 0.0, 1.5),
        Vector3(0.0, 0.0, -1.5),
        Vector3(1.5, 0.0, 1.5),
        Vector3(-1.5, 0.0, 1.5),
        Vector3(1.5, 0.0, -1.5),
        Vector3(-1.5, 0.0, -1.5),
        Vector3(0.0, 1.0, 0.0),
        Vector3(1.5, 1.0, 0.0),
        Vector3(-1.5, 1.0, 0.0),
        Vector3(0.0, 1.0, 1.5),
        Vector3(0.0, 1.0, -1.5),
    ]

    for offset in offsets:
        var candidate: Vector3 = centered_anchor + offset
        if _is_safe_respawn_position(candidate):
            return candidate

    var default_candidate: Vector3 = centered_anchor + Vector3(1.5, 0.0, 0.0)
    if _is_safe_respawn_position(default_candidate):
        return default_candidate
    return fallback_position


func _has_remote_respawn_anchor(prefer_host_peer: bool) -> bool:
    if not _has_live_peer() or not _can_sample_player():
        return false
    if not multiplayer.is_server() and prefer_host_peer and remote_host_respawning:
        return false

    var active_instance_key: String = get_active_dimension_instance_key()
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if multiplayer.is_server():
            if int_peer_id == 1:
                continue
        elif prefer_host_peer and int_peer_id != 1:
            continue

        var state: Dictionary = peer_states[peer_id]
        if _is_peer_state_same_instance(state, active_instance_key):
            return true
    return false


func _get_remote_respawn_anchor(prefer_host_peer: bool, fallback_position: Vector3) -> Vector3:
    if not _has_live_peer() or not _can_sample_player():
        return fallback_position
    if not multiplayer.is_server() and prefer_host_peer and remote_host_respawning:
        return fallback_position

    var active_instance_key: String = get_active_dimension_instance_key()
    var nearest_position: Vector3 = fallback_position
    var nearest_distance_squared: float = INF

    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if multiplayer.is_server():
            if int_peer_id == 1:
                continue
        elif prefer_host_peer and int_peer_id != 1:
            continue

        var state: Dictionary = peer_states[peer_id]
        if not _is_peer_state_same_instance(state, active_instance_key):
            continue

        var peer_position: Vector3 = state.get("position", fallback_position)
        if prefer_host_peer and int_peer_id == 1:
            return peer_position

        var distance_squared: float = fallback_position.distance_squared_to(peer_position)
        if distance_squared >= nearest_distance_squared:
            continue
        nearest_distance_squared = distance_squared
        nearest_position = peer_position

    return nearest_position


func _resolve_default_respawn_fallback_position(origin_position: Vector3) -> Vector3:
    if not _can_sample_player():
        return origin_position
    if local_fake_death_respawn_target_valid:
        return local_fake_death_respawn_target

    if not Ref.player.wandering_spirit and not Ref.world.respawn_positions.is_empty():
        var closest_position: Vector3i = Ref.world.respawn_positions.keys()[0]
        for position in Ref.world.respawn_positions:
            if position.distance_to(origin_position) < closest_position.distance_to(origin_position):
                closest_position = position
        return Vector3(closest_position) + Vector3(0.5, 0.0, 0.5)

    var centered_origin: Vector3 = origin_position.floor() + Vector3(0.5, 0.0, 0.5)
    return _find_safe_respawn_position_near(centered_origin, centered_origin + Vector3(0.0, 1.0, 0.0))


func _resolve_respawn_position() -> Vector3:
    if not _can_sample_player():
        return Vector3.ZERO

    if not Ref.player.wandering_spirit and not Ref.world.respawn_positions.is_empty():
        return _resolve_default_respawn_fallback_position(Ref.player.global_position)

    var fallback_position: Vector3 = Ref.player.global_position
    var found_spawn: bool = await Ref.world.spawn_tester.find_spawn_position(
        Ref.player.global_position if Ref.player.wandering_spirit else Vector3.ZERO,
        Ref.world.current_dimension,
        3.0 if Ref.player.wandering_spirit else 1.0
    )
    return Ref.player.global_position if found_spawn else fallback_position


func _resolve_double_downed_host_respawn_position() -> Vector3:
    if not _can_sample_player():
        return Vector3.ZERO

    var spawn_position: Vector3 = _resolve_default_respawn_fallback_position(Ref.player.global_position)
    if _is_safe_respawn_position(spawn_position):
        return spawn_position
    return _find_safe_respawn_position_near(spawn_position, spawn_position + Vector3(0.0, 1.0, 0.0))


func _try_begin_double_downed_recovery() -> void:
    if not multiplayer.is_server() or not local_downed or double_downed_recovery_pending:
        return
    if not _all_same_instance_partners_downed(multiplayer.get_unique_id()):
        return
    call_deferred("_begin_double_downed_recovery")


func _broadcast_local_state_now() -> void:
    if not _has_live_peer():
        return

    var local_state: Dictionary = _capture_local_state_for_send()
    if multiplayer.is_server():
        peer_states[1] = local_state
        _refresh_markers(peer_states, multiplayer.get_unique_id())
        host_snapshot_sequence += 1
        server_snapshot_reliable.rpc(host_snapshot_sequence, _serialize_peer_states())
    else:
        last_sent_client_state_hash = _hash_client_state(local_state)
        client_state_heartbeat_timer = 0.0
        submit_client_state_reliable.rpc_id(
            1,
            int(local_state.get("sequence", 0)),
            local_state.get("active", false),
            bool(local_state.get("downed", false)),
            local_state.get("dimension", -1),
            str(local_state.get("dimension_instance_key", "")),
            str(local_state.get("pocket_owner_key", "")),
            local_state.get("position", Vector3.ZERO),
            local_state.get("yaw", 0.0),
            local_state.get("pitch", 0.0),
            local_state.get("crouching", false),
            local_state.get("grounded", true),
            local_state.get("move_speed", 0.0),
            bool(local_state.get("under_water", false)),
            local_state.get("held_item_id", -1),
            local_state.get("action_state", 0),
            str(local_state.get("name", "guest")),
            str(local_state.get("player_key", "")),
            str(local_state.get("avatar_id", DEFAULT_AVATAR_ID)),
            local_state.get("skin_color", Color.WHITE),
            bool(local_state.get("breaking", false)),
            local_state.get("break_position", Vector3i.ZERO),
            int(local_state.get("break_block_id", 0)),
            float(local_state.get("break_progress", 0.0))
        )


func _capture_local_world_patch() -> Dictionary:
    if not _can_sample_player():
        return {}

    var dimension: int = int(Ref.world.current_dimension)
    var pocket_owner_key: String = get_active_pocket_owner_key()
    var prefix: String = _resolve_dimension_namespace(dimension, pocket_owner_key) + "_"
    var world_data: Dictionary = {}
    Ref.world.save_data(world_data, prefix)

    return {
        "dimension": dimension,
        "pocket_owner_key": pocket_owner_key,
        "dimension_instance_key": get_dimension_instance_key(dimension, pocket_owner_key),
        "respawn_positions": Ref.world.respawn_positions.duplicate(true),
        "world_data": world_data,
    }


func _get_unique_chunk_positions_for_world_positions(world_positions: Array) -> Array:
    if not is_instance_valid(Ref.world):
        return []

    var chunk_positions: Array = []
    var seen_positions: Dictionary = {}
    for world_position in world_positions:
        var position: Vector3
        if world_position is Vector3:
            position = world_position
        elif world_position is Vector3i:
            position = Vector3(world_position)
        else:
            continue

        var chunk_position: Vector3i = Ref.world.snap_to_chunk(position)
        if seen_positions.has(chunk_position):
            continue
        seen_positions[chunk_position] = true
        chunk_positions.append(chunk_position)

    return chunk_positions


func _filter_world_data_to_chunk_positions(world_data: Dictionary, prefix: String, chunk_positions: Array) -> Dictionary:
    var source_root: Variant = world_data.get(prefix + "world", null)
    if not (source_root is Dictionary):
        return {}

    var filtered_root: Dictionary = {}
    var source_world: Dictionary = source_root
    for suffix in ["chunk_block", "chunk_water", "chunk_water_awake", "chunk_fire"]:
        var source_key: String = prefix + suffix
        var source_entries: Variant = source_world.get(source_key, null)
        if not (source_entries is Dictionary):
            continue

        var filtered_entries: Dictionary = {}
        for chunk_position in chunk_positions:
            if source_entries.has(chunk_position):
                filtered_entries[chunk_position] = source_entries[chunk_position].duplicate(true)

        if not filtered_entries.is_empty():
            filtered_root[source_key] = filtered_entries

    if filtered_root.is_empty():
        return {}
    return {prefix + "world": filtered_root}


func _capture_local_chunk_patch_for_world_positions(world_positions: Array) -> Dictionary:
    if not _can_sample_player():
        return {}

    var chunk_positions: Array = _get_unique_chunk_positions_for_world_positions(world_positions)
    return _capture_local_chunk_patch_for_chunk_positions(chunk_positions)


func _capture_local_runtime_chunk_patch_for_world_positions(world_positions: Array) -> Dictionary:
    if not _can_sample_player():
        return {}

    var chunk_positions: Array = _get_unique_chunk_positions_for_world_positions(world_positions)
    if chunk_positions.is_empty():
        return {}

    # Avoid full world serialization on guest block actions; capture only touched chunks.
    var dimension: int = int(Ref.world.current_dimension)
    var pocket_owner_key: String = get_active_pocket_owner_key()
    var prefix: String = _resolve_dimension_namespace(dimension, pocket_owner_key) + "_"
    var chunk_blocks: Dictionary = {}
    var chunk_water: Dictionary = {}
    var chunk_water_awake: Dictionary = {}
    var chunk_fire: Dictionary = {}

    for chunk_position in chunk_positions:
        var chunk_snapshot: Dictionary = _capture_runtime_chunk_snapshot(chunk_position)
        if chunk_snapshot.is_empty():
            continue
        chunk_blocks[chunk_position] = chunk_snapshot.get("blocks", PackedInt32Array())
        chunk_water[chunk_position] = chunk_snapshot.get("water", PackedByteArray())
        chunk_water_awake[chunk_position] = chunk_snapshot.get("water_awake", PackedByteArray())
        chunk_fire[chunk_position] = chunk_snapshot.get("fire", PackedByteArray())

    if chunk_blocks.is_empty():
        return {}

    return {
        "dimension": dimension,
        "pocket_owner_key": pocket_owner_key,
        "dimension_instance_key": get_dimension_instance_key(dimension, pocket_owner_key),
        "world_data": {
            prefix + "world": {
                prefix + "chunk_block": chunk_blocks,
                prefix + "chunk_water": chunk_water,
                prefix + "chunk_water_awake": chunk_water_awake,
                prefix + "chunk_fire": chunk_fire,
            },
        },
    }


func _capture_runtime_chunk_snapshot(chunk_position: Vector3i) -> Dictionary:
    if not is_instance_valid(Ref.world) or not Ref.world.is_position_loaded(chunk_position):
        return {}

    var chunk_size: Vector3i = _get_cached_world_chunk_size()
    var cell_count: int = chunk_size.x * chunk_size.y * chunk_size.z
    if cell_count <= 0:
        return {}

    var blocks: PackedInt32Array = PackedInt32Array()
    var water: PackedByteArray = PackedByteArray()
    var water_awake: PackedByteArray = PackedByteArray()
    var fire: PackedByteArray = PackedByteArray()
    blocks.resize(cell_count)
    water.resize(cell_count)
    water_awake.resize(cell_count)
    fire.resize(cell_count)

    var index: int = 0
    for y in range(chunk_size.y):
        for z in range(chunk_size.z):
            for x in range(chunk_size.x):
                var world_position: Vector3 = Vector3(chunk_position + Vector3i(x, y, z))
                var block: Block = Ref.world.get_block_type_at(world_position)
                var water_level: int = _clamp_chunk_byte_value(Ref.world.get_water_level_at(world_position))
                blocks[index] = block.id if block != null else 0
                water[index] = water_level
                water_awake[index] = 1 if water_level > 0 else 0
                fire[index] = _clamp_chunk_byte_value(Ref.world.get_fire_at(world_position))
                index += 1

    return {
        "blocks": blocks,
        "water": water,
        "water_awake": water_awake,
        "fire": fire,
    }


func _clamp_chunk_byte_value(value: Variant) -> int:
    return clampi(int(value), 0, 255)


func _get_cached_world_chunk_size() -> Vector3i:
    if cached_world_chunk_size != Vector3i.ZERO:
        return cached_world_chunk_size

    var fallback_size: Vector3i = Vector3i(16, 16, 16)
    if not is_instance_valid(Ref.world):
        cached_world_chunk_size = fallback_size
        return cached_world_chunk_size

    var chunk_origin: Vector3i = Ref.world.snap_to_chunk(Vector3.ZERO)
    cached_world_chunk_size = Vector3i(
        _measure_world_chunk_axis_size(chunk_origin, Vector3i(1, 0, 0), fallback_size.x),
        _measure_world_chunk_axis_size(chunk_origin, Vector3i(0, 1, 0), fallback_size.y),
        _measure_world_chunk_axis_size(chunk_origin, Vector3i(0, 0, 1), fallback_size.z)
    )
    return cached_world_chunk_size


func _measure_world_chunk_axis_size(chunk_origin: Vector3i, axis: Vector3i, fallback: int) -> int:
    if not is_instance_valid(Ref.world):
        return fallback

    for step in range(1, 257):
        var sample_position: Vector3 = Vector3(chunk_origin + axis * step)
        if Ref.world.snap_to_chunk(sample_position) != chunk_origin:
            return step

    return fallback


func _capture_local_chunk_patch_for_chunk_positions(chunk_positions: Array, include_respawn_positions: bool = false) -> Dictionary:
    if not _can_sample_player() or chunk_positions.is_empty():
        return {}

    var dimension: int = int(Ref.world.current_dimension)
    var pocket_owner_key: String = get_active_pocket_owner_key()
    var prefix: String = _resolve_dimension_namespace(dimension, pocket_owner_key) + "_"
    var world_data: Dictionary = {}
    Ref.world.save_data(world_data, prefix)

    var filtered_world_data: Dictionary = _filter_world_data_to_chunk_positions(world_data, prefix, chunk_positions)
    if filtered_world_data.is_empty():
        return {}

    var patch: Dictionary = {
        "dimension": dimension,
        "pocket_owner_key": pocket_owner_key,
        "dimension_instance_key": get_dimension_instance_key(dimension, pocket_owner_key),
        "world_data": filtered_world_data,
    }
    if include_respawn_positions:
        patch["respawn_positions"] = Ref.world.respawn_positions.duplicate(true)
    return patch


func _merge_patch_dictionary(target: Dictionary, source: Dictionary) -> Dictionary:
    var merged: Dictionary = target.duplicate(true)
    for key in source.keys():
        var source_value: Variant = source[key]
        if source_value is Dictionary and merged.get(key, null) is Dictionary:
            merged[key] = _merge_patch_dictionary(merged.get(key, {}), source_value)
        else:
            merged[key] = source_value.duplicate(true) if (source_value is Dictionary or source_value is Array) else source_value
    return merged


func _merge_world_patch_into_save(world_patch: Dictionary) -> void:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file == null:
        return

    var world_data: Variant = world_patch.get("world_data", {})
    if world_data is Dictionary:
        for key in world_data.keys():
            var source_value: Variant = world_data[key]
            if source_value is Dictionary and Ref.save_file_manager.loaded_file.data.get(key, null) is Dictionary:
                Ref.save_file_manager.loaded_file.data[key] = _merge_patch_dictionary(Ref.save_file_manager.loaded_file.data.get(key, {}), source_value)
            else:
                Ref.save_file_manager.loaded_file.data[key] = source_value.duplicate(true) if (source_value is Dictionary or source_value is Array) else source_value

    if world_patch.has("respawn_positions"):
        var dimension_namespace: String = _resolve_dimension_namespace(int(world_patch.get("dimension", -1)), str(world_patch.get("pocket_owner_key", "")))
        SaveFile._set_data(Ref.save_file_manager.loaded_file.data, dimension_namespace + "/respawn_positions", world_patch.get("respawn_positions", {}))


func _apply_world_patch_locally(world_patch: Dictionary) -> void:
    if not _can_sample_player():
        return

    var dimension: int = int(world_patch.get("dimension", -1))
    var pocket_owner_key: String = str(world_patch.get("pocket_owner_key", ""))
    if get_dimension_instance_key(dimension, pocket_owner_key) != get_active_dimension_instance_key():
        return

    _merge_world_patch_into_save(world_patch)
    if world_patch.has("respawn_positions"):
        Ref.world.respawn_positions = world_patch.get("respawn_positions", {}).duplicate(true)
    Ref.world.load_data(Ref.save_file_manager.loaded_file.data, _resolve_dimension_namespace(dimension, pocket_owner_key) + "_")


func _send_local_world_patch_if_needed(force_send: bool = false) -> void:
    return


func is_client_session() -> bool:
    return _has_live_peer() and not multiplayer.is_server()


func play_local_damage_feedback(damage: int) -> void:
    if not _can_sample_player():
        return

    var camera = Ref.player.get_node_or_null("%Camera3D")
    if camera != null:
        camera.camera_shake(0.2, 0.04)

    var harm_cover = Ref.player.get_node_or_null("%HarmCover")
    if harm_cover != null and "_on_damage_taken" in harm_cover:
        harm_cover._on_damage_taken(maxi(1, damage))


func _can_sample_player() -> bool:
    return is_instance_valid(Ref.main) and is_instance_valid(Ref.world) and is_instance_valid(Ref.player) and Ref.main.loaded and Ref.world.load_enabled


func _get_rotation_pivot() -> Node3D:
    return Ref.player.get_node_or_null("%RotationPivot") as Node3D


func _get_entity_visual_yaw(entity) -> float:
    if entity == null or not is_instance_valid(entity):
        return 0.0
    var rotation_pivot: Node3D = entity.get_node_or_null("%RotationPivot") as Node3D
    return rotation_pivot.rotation.y if rotation_pivot != null else entity.rotation.y


func _set_entity_visual_yaw(entity, yaw: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    var rotation_pivot: Node3D = entity.get_node_or_null("%RotationPivot") as Node3D
    if rotation_pivot != null:
        rotation_pivot.rotation.y = yaw
    else:
        entity.rotation.y = yaw


func _get_entity_total_velocity(entity) -> Vector3:
    if entity == null or not is_instance_valid(entity):
        return Vector3.ZERO
    if entity is Entity:
        return entity.movement_velocity + entity.gravity_velocity + entity.knockback_velocity + entity.rope_velocity
    if "velocity" in entity:
        return entity.velocity
    return Vector3.ZERO


func _quantize_float(value: float, step: float = 0.05) -> float:
    if step <= 0.0:
        return value
    return snappedf(value, step)


func _quantize_vector3(value: Vector3, step: float = 0.1) -> Vector3:
    if step <= 0.0:
        return value
    return Vector3(
        snappedf(value.x, step),
        snappedf(value.y, step),
        snappedf(value.z, step)
    )


func _get_object_script_path(target: Object) -> String:
    if target == null or target.get_script() == null:
        return ""
    return str(target.get_script().resource_path)


func _is_entity_model_node(node: Object) -> bool:
    if node == null:
        return false
    if node.get_class() == "EntityModel":
        return true
    return _object_has_property(node, "look_target") and _object_has_property(node, "look_ratio")


func _is_entity_procedural_visual_node(node: Node) -> bool:
    if node == null:
        return false
    var node_name: String = str(node.name)
    if node_name == "Legs" or node_name == "LegTargets" or node_name == "LegRests" or node_name == "LegRays" or node_name == "GelModel":
        return true
    var script_path: String = _get_object_script_path(node)
    if script_path.contains("/ik_leg/"):
        return true
    return node.get_class() == "IKLeg" or node.get_class() == "SoftBody3D"


func _node_is_within_kept_client_visual_branch(node: Node) -> bool:
    var current: Node = node
    while current != null:
        if _is_entity_procedural_visual_node(current):
            return true
        current = current.get_parent()
    return false


func _is_segmented_worm_entity(entity) -> bool:
    if entity == null or not is_instance_valid(entity):
        return false
    return _get_object_script_path(entity).ends_with("/worm.gd") and entity.get_node_or_null("%Segments") is Node3D


func _get_worm_segments_root(entity) -> Node3D:
    if entity == null or not is_instance_valid(entity):
        return null
    return entity.get_node_or_null("%Segments") as Node3D


func _get_worm_segment_nodes(entity) -> Array:
    var segments_root: Node3D = _get_worm_segments_root(entity)
    if segments_root == null:
        return []

    var segment_nodes: Array = []
    for child in segments_root.get_children():
        if child is Node3D:
            segment_nodes.append(child)
    return segment_nodes


func _refresh_worm_segment_cache(entity) -> Array:
    var segment_nodes: Array = _get_worm_segment_nodes(entity)
    if entity != null and is_instance_valid(entity):
        if _object_has_property(entity, "segments"):
            entity.set("segments", segment_nodes)
        if _object_has_property(entity, "head_segment"):
            entity.set("head_segment", segment_nodes[0] if not segment_nodes.is_empty() else null)
    return segment_nodes


func _sync_worm_segment_structure(entity, required_count: int) -> Array:
    var segments_root: Node3D = _get_worm_segments_root(entity)
    if segments_root == null:
        return []

    var target_count: int = maxi(required_count, 1)
    var segment_nodes: Array = _get_worm_segment_nodes(entity)
    var segment_scene: PackedScene = entity.get("segment_scene") as PackedScene if _object_has_property(entity, "segment_scene") else null

    while segment_nodes.size() < target_count and segment_scene != null:
        var new_segment = segment_scene.instantiate()
        if new_segment == null:
            break
        segments_root.add_child(new_segment)
        if new_segment is Node:
            new_segment.owner = entity
        segment_nodes = _get_worm_segment_nodes(entity)

    while segment_nodes.size() > target_count:
        var extra_segment = segment_nodes[segment_nodes.size() - 1]
        segment_nodes.remove_at(segment_nodes.size() - 1)
        if extra_segment != null and is_instance_valid(extra_segment):
            segments_root.remove_child(extra_segment)
            extra_segment.queue_free()

    return _refresh_worm_segment_cache(entity)


func _capture_worm_segment_visual_state(entity) -> Dictionary:
    var segment_nodes: Array = _get_worm_segment_nodes(entity)
    if segment_nodes.is_empty():
        return {}

    var segment_positions: Array = []
    for segment in segment_nodes:
        if segment is Node3D:
            segment_positions.append(_quantize_vector3((segment as Node3D).global_position, 0.01))
    if segment_positions.is_empty():
        return {}

    return {
        "worm_segment_positions": segment_positions,
    }


func _apply_worm_segment_visual_state(entity, state: Dictionary, lerp_weight: float = 1.0) -> void:
    var segment_positions = state.get("worm_segment_positions", [])
    if not (segment_positions is Array) or segment_positions.is_empty():
        return

    var segment_nodes: Array = _sync_worm_segment_structure(entity, segment_positions.size())
    if segment_nodes.is_empty():
        return

    var snap_segments: bool = lerp_weight >= 1.0 or not bool(entity.get_meta("coop_worm_visual_initialized", false))
    for index in range(mini(segment_nodes.size(), segment_positions.size())):
        if not (segment_nodes[index] is Node3D) or not (segment_positions[index] is Vector3):
            continue
        var segment_node := segment_nodes[index] as Node3D
        var segment_position: Vector3 = segment_positions[index]
        if snap_segments:
            segment_node.global_position = segment_position
        else:
            segment_node.global_position = segment_node.global_position.lerp(segment_position, lerp_weight)

    var head_segment: Node3D = segment_nodes[0] as Node3D
    var look_target_variant: Variant = state.get("look_target", entity.get("look_target") if _object_has_property(entity, "look_target") else Vector3.ZERO)
    if head_segment != null and look_target_variant is Vector3:
        var look_target: Vector3 = look_target_variant
        if head_segment.global_position.distance_squared_to(look_target) > 0.0001:
            SpatialMath.look_at(head_segment, look_target)

    entity.set_meta("coop_worm_visual_initialized", true)


func _find_first_entity_model(root: Node):
    if root == null or not is_instance_valid(root):
        return null
    if root.has_meta("coop_entity_model_node"):
        var cached_model = root.get_meta("coop_entity_model_node")
        if is_instance_valid(cached_model):
            return cached_model
        if str(cached_model) == "false":
            return null
        root.remove_meta("coop_entity_model_node")
    var found = _search_first_entity_model(root)
    root.set_meta("coop_entity_model_node", found if found != null else false)
    return found


func _search_first_entity_model(root: Node):
    if _is_entity_model_node(root):
        return root
    for child in root.get_children():
        var found = _search_first_entity_model(child)
        if found != null:
            return found
    return null


func _capture_entity_model_head_look_state(root: Node) -> Dictionary:
    var model = _find_first_entity_model(root)
    if model == null:
        return {}

    var state: Dictionary = {}
    if _object_has_property(model, "look_ratio"):
        state["look_ratio"] = float(model.get("look_ratio"))
    if _object_has_property(model, "look_target"):
        state["look_target"] = model.get("look_target")
    return state


func _apply_entity_model_head_look_state(root: Node, state: Dictionary) -> void:
    if state.is_empty():
        return

    var model = _find_first_entity_model(root)
    if model == null:
        return

    if state.has("look_ratio") and _object_has_property(model, "look_ratio"):
        model.set("look_ratio", float(state.get("look_ratio", 0.0)))
    if state.has("look_target") and _object_has_property(model, "look_target"):
        model.set("look_target", state.get("look_target", Vector3.ZERO))


func _capture_node_local_rotation(node: Node3D) -> Variant:
    if node == null or not is_instance_valid(node):
        return null
    return node.rotation


func _capture_entity_procedural_visual_state(entity) -> Dictionary:
    if entity == null or not is_instance_valid(entity):
        return {}

    var state: Dictionary = {}
    if _is_segmented_worm_entity(entity):
        state.merge(_capture_worm_segment_visual_state(entity), true)
    var rotation_pivot: Node3D = entity.get_node_or_null("%RotationPivot") as Node3D
    if rotation_pivot != null:
        state["rotation_pivot_rotation"] = rotation_pivot.rotation

    if _object_has_property(entity, "look_direction"):
        state["look_direction"] = entity.get("look_direction")
    if _object_has_property(entity, "time"):
        state["time"] = _quantize_float(float(entity.get("time")), 0.01)
    if _object_has_property(entity, "flap_speed"):
        state["flap_speed"] = _quantize_float(float(entity.get("flap_speed")), 0.01)
    if _object_has_property(entity, "angle"):
        state["angle"] = _quantize_float(float(entity.get("angle")), 0.01)
    if _object_has_property(entity, "rotate_axis"):
        state["rotate_axis"] = bool(entity.get("rotate_axis"))
    if _object_has_property(entity, "state"):
        state["state"] = int(entity.get("state"))
    if _object_has_property(entity, "teleport_amount"):
        state["teleport_amount"] = _quantize_float(float(entity.get("teleport_amount")), 0.01)
    if _object_has_property(entity, "direction"):
        state["direction"] = _quantize_vector3(entity.get("direction"), 0.01)
    if _object_has_property(entity, "look_target"):
        state["look_target"] = entity.get("look_target")
    if _object_has_property(entity, "color_1"):
        state["color_1"] = entity.get("color_1")
    if _object_has_property(entity, "color_2"):
        state["color_2"] = entity.get("color_2")

    var body_model: Node3D = entity.get_node_or_null("%BodyModel") as Node3D
    if body_model != null:
        state["body_model_rotation"] = body_model.rotation

    var body: Node3D = entity.get_node_or_null("%Body") as Node3D
    if body != null:
        state["body_rotation"] = body.rotation

    var wing_holder_1: Node3D = entity.get_node_or_null("%WingHolder1") as Node3D
    if wing_holder_1 != null:
        state["wing_holder_1_rotation"] = wing_holder_1.rotation

    var wing_holder_2: Node3D = entity.get_node_or_null("%WingHolder2") as Node3D
    if wing_holder_2 != null:
        state["wing_holder_2_rotation"] = wing_holder_2.rotation

    var fish_model = entity.get_node_or_null("%FishModel")
    if fish_model != null and is_instance_valid(fish_model):
        if fish_model is Node3D:
            state["fish_model_rotation"] = (fish_model as Node3D).rotation
        if _object_has_property(fish_model, "panic"):
            state["fish_panic"] = _quantize_float(float(fish_model.get("panic")), 0.01)
        if _object_has_property(fish_model, "speed"):
            state["fish_speed"] = _quantize_float(float(fish_model.get("speed")), 0.01)
        if _object_has_property(fish_model, "time"):
            state["fish_time"] = _quantize_float(float(fish_model.get("time")), 0.01)

    var boid_model: Node3D = entity.get_node_or_null("%BoidModel") as Node3D
    if boid_model != null:
        state["boid_model_rotation"] = boid_model.rotation

    var glaggler_model: Node3D = entity.get_node_or_null("%GlagglerModel") as Node3D
    if glaggler_model != null:
        state["glaggler_model_rotation"] = glaggler_model.rotation

    var leg_rests: Node3D = entity.get_node_or_null("%LegRests") as Node3D
    if leg_rests != null:
        state["leg_rests_rotation"] = leg_rests.rotation

    var leg_targets: Node3D = entity.get_node_or_null("%LegTargets") as Node3D
    if leg_targets != null:
        var target_positions: Array = []
        for child in leg_targets.get_children():
            if child is Node3D:
                target_positions.append((child as Node3D).global_position)
        if not target_positions.is_empty():
            state["leg_target_positions"] = target_positions

    var leg_rays: Node3D = entity.get_node_or_null("%LegRays") as Node3D
    if leg_rays != null:
        state["leg_rays_rotation"] = leg_rays.rotation

    var legs_root: Node = entity.get_node_or_null("%Legs")
    if legs_root != null:
        var ik_leg_states: Array = []
        for child in legs_root.get_children():
            if not (child is Node3D):
                continue
            var leg_state: Dictionary = {
                "global_position": (child as Node3D).global_position,
                "rotation": (child as Node3D).rotation,
            }
            if _object_has_property(child, "target_anim"):
                leg_state["target_anim"] = float(child.get("target_anim"))
            if _object_has_property(child, "desired_target_position"):
                leg_state["desired_target_position"] = child.get("desired_target_position")
            if _object_has_property(child, "initial_target_position"):
                leg_state["initial_target_position"] = child.get("initial_target_position")
            if _object_has_property(child, "is_animating"):
                leg_state["is_animating"] = bool(child.get("is_animating"))
            if _object_has_property(child, "is_steady"):
                leg_state["is_steady"] = bool(child.get("is_steady"))
            if _object_has_property(child, "state"):
                leg_state["state"] = int(child.get("state"))
            ik_leg_states.append(leg_state)
        if not ik_leg_states.is_empty():
            state["ik_leg_states"] = ik_leg_states

    var core: Node3D = entity.get_node_or_null("%Core") as Node3D
    if core != null:
        state["core_rotation"] = core.rotation

    return state


func _apply_node_local_rotation(node: Node3D, target_rotation: Variant, weight: float = 1.0) -> void:
    if node == null or not is_instance_valid(node) or not (target_rotation is Vector3):
        return
    var rotation_value: Vector3 = target_rotation
    if weight >= 1.0:
        node.rotation = rotation_value
        return
    node.rotation = Vector3(
        lerp_angle(node.rotation.x, rotation_value.x, weight),
        lerp_angle(node.rotation.y, rotation_value.y, weight),
        lerp_angle(node.rotation.z, rotation_value.z, weight)
    )


func _apply_entity_procedural_visual_state(entity, state: Dictionary, lerp_weight: float = 1.0) -> void:
    if entity == null or not is_instance_valid(entity) or state.is_empty():
        return

    entity.set_meta("coop_procedural_visual_state", state.duplicate(true))

    if state.has("look_direction") and _object_has_property(entity, "look_direction"):
        entity.set("look_direction", state.get("look_direction", Vector3.ZERO))
    if state.has("time") and _object_has_property(entity, "time"):
        entity.set("time", float(state.get("time", 0.0)))
    if state.has("angle") and _object_has_property(entity, "angle"):
        entity.set("angle", float(state.get("angle", 0.0)))
    if state.has("state") and _object_has_property(entity, "state"):
        entity.set("state", int(state.get("state", 0)))
    if state.has("teleport_amount") and _object_has_property(entity, "teleport_amount"):
        entity.set("teleport_amount", float(state.get("teleport_amount", 0.0)))
    if state.has("direction") and _object_has_property(entity, "direction"):
        entity.set("direction", state.get("direction", Vector3.ZERO))
    if state.has("look_target") and _object_has_property(entity, "look_target"):
        entity.set("look_target", state.get("look_target", Vector3.ZERO))
    if state.has("color_1") and _object_has_property(entity, "color_1"):
        entity.set("color_1", state.get("color_1", Color.WHITE))
    if state.has("color_2") and _object_has_property(entity, "color_2"):
        entity.set("color_2", state.get("color_2", Color.WHITE))
    if (state.has("color_1") or state.has("color_2")) and entity.has_method("update_colors"):
        entity.call("update_colors")

    _apply_node_local_rotation(entity.get_node_or_null("%RotationPivot") as Node3D, state.get("rotation_pivot_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%BodyModel") as Node3D, state.get("body_model_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%Body") as Node3D, state.get("body_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%WingHolder1") as Node3D, state.get("wing_holder_1_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%WingHolder2") as Node3D, state.get("wing_holder_2_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%BoidModel") as Node3D, state.get("boid_model_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%GlagglerModel") as Node3D, state.get("glaggler_model_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%LegRests") as Node3D, state.get("leg_rests_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%LegRays") as Node3D, state.get("leg_rays_rotation", null), lerp_weight)
    _apply_node_local_rotation(entity.get_node_or_null("%Core") as Node3D, state.get("core_rotation", null), lerp_weight)
    if _is_segmented_worm_entity(entity):
        _apply_worm_segment_visual_state(entity, state, lerp_weight)

    if state.has("leg_target_positions"):
        var leg_targets: Node3D = entity.get_node_or_null("%LegTargets") as Node3D
        var target_positions = state.get("leg_target_positions", [])
        if leg_targets != null and target_positions is Array:
            var target_children: Array = leg_targets.get_children()
            for index in range(mini(target_children.size(), target_positions.size())):
                if target_children[index] is Node3D and target_positions[index] is Vector3:
                    var target_child := target_children[index] as Node3D
                    var target_position: Vector3 = target_positions[index]
                    if lerp_weight >= 1.0:
                        target_child.global_position = target_position
                    else:
                        target_child.global_position = target_child.global_position.lerp(target_position, lerp_weight)

    if state.has("ik_leg_states"):
        var legs_root: Node = entity.get_node_or_null("%Legs")
        var ik_leg_states = state.get("ik_leg_states", [])
        if legs_root != null and ik_leg_states is Array:
            var legs_children: Array = legs_root.get_children()
            for index in range(mini(legs_children.size(), ik_leg_states.size())):
                if not (legs_children[index] is Node3D):
                    continue
                var leg = legs_children[index]
                var leg_state = ik_leg_states[index]
                if not (leg_state is Dictionary):
                    continue
                if leg_state.has("global_position") and leg_state["global_position"] is Vector3:
                    var leg_position: Vector3 = leg_state["global_position"]
                    if lerp_weight >= 1.0:
                        (leg as Node3D).global_position = leg_position
                    else:
                        (leg as Node3D).global_position = (leg as Node3D).global_position.lerp(leg_position, lerp_weight)
                if leg_state.has("rotation") and leg_state["rotation"] is Vector3:
                    _apply_node_local_rotation(leg as Node3D, leg_state["rotation"], lerp_weight)
                if leg_state.has("target_anim") and _object_has_property(leg, "target_anim"):
                    leg.set("target_anim", float(leg_state["target_anim"]))
                if leg_state.has("desired_target_position") and _object_has_property(leg, "desired_target_position"):
                    leg.set("desired_target_position", leg_state["desired_target_position"])
                if leg_state.has("initial_target_position") and _object_has_property(leg, "initial_target_position"):
                    leg.set("initial_target_position", leg_state["initial_target_position"])
                if leg_state.has("is_animating") and _object_has_property(leg, "is_animating"):
                    leg.set("is_animating", bool(leg_state["is_animating"]))
                if leg_state.has("is_steady") and _object_has_property(leg, "is_steady"):
                    leg.set("is_steady", bool(leg_state["is_steady"]))
                if leg_state.has("state") and _object_has_property(leg, "state"):
                    leg.set("state", int(leg_state["state"]))

    var fish_model = entity.get_node_or_null("%FishModel")
    if fish_model != null and is_instance_valid(fish_model):
        if state.has("fish_panic") and _object_has_property(fish_model, "panic"):
            fish_model.set("panic", float(state.get("fish_panic", 0.0)))
        if state.has("fish_speed") and _object_has_property(fish_model, "speed"):
            fish_model.set("speed", float(state.get("fish_speed", 0.0)))
        if state.has("fish_time") and _object_has_property(fish_model, "time"):
            fish_model.set("time", float(state.get("fish_time", 0.0)))
        if fish_model is Node3D:
            _apply_node_local_rotation(fish_model as Node3D, state.get("fish_model_rotation", null), lerp_weight)

func _orient_entity_rotation_pivot(entity, direction: Vector3) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    var rotation_pivot: Node3D = entity.get_node_or_null("%RotationPivot") as Node3D
    if rotation_pivot == null or direction.length_squared() <= 0.0001:
        return
    SpatialMath.look_at(rotation_pivot, rotation_pivot.global_position + direction.normalized())


func _step_client_bee_visuals(entity, delta: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return

    if _object_has_property(entity, "look_direction"):
        var look_direction: Vector3 = entity.get("look_direction")
        look_direction = look_direction.lerp(entity.movement_velocity, clampf(delta * 2.0, 0.0, 1.0))
        entity.set("look_direction", look_direction)
        _orient_entity_rotation_pivot(entity, look_direction)

    var body_model: Node3D = entity.get_node_or_null("%BodyModel") as Node3D
    if body_model != null:
        body_model.rotation.z = lerp_angle(body_model.rotation.z, 0.0, clampf(delta * 8.0, 0.0, 1.0))

    if _object_has_property(entity, "time"):
        var flap_speed: float = float(entity.get("flap_speed")) if _object_has_property(entity, "flap_speed") else 0.0
        if flap_speed > 0.0:
            entity.set("time", float(entity.get("time")) + delta * flap_speed)
    if entity.has_method("wing_update"):
        entity.call("wing_update")


func _step_client_boid_visuals(entity, delta: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return

    if _object_has_property(entity, "look_direction"):
        var look_direction: Vector3 = entity.get("look_direction")
        look_direction = look_direction.lerp(entity.movement_velocity, clampf(delta * 6.5, 0.0, 1.0))
        entity.set("look_direction", look_direction)
        _orient_entity_rotation_pivot(entity, look_direction)

    var boid_model: Node3D = entity.get_node_or_null("%BoidModel") as Node3D
    if boid_model != null:
        boid_model.rotation.z = lerp_angle(boid_model.rotation.z, 0.0, clampf(delta * 8.0, 0.0, 1.0))


func _step_client_fish_visuals(entity, delta: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return

    var fish_model = entity.get_node_or_null("%FishModel")
    if fish_model == null or not is_instance_valid(fish_model):
        return

    var look_direction: Vector3 = entity.get("look_direction") if _object_has_property(entity, "look_direction") else Vector3.ZERO
    var state_value: int = int(entity.get("state")) if _object_has_property(entity, "state") else 0
    if state_value == 1:
        look_direction = look_direction.lerp(Vector3(0, 0, 1), clampf(delta * 1.0, 0.0, 1.0))
        if fish_model is Node3D:
            (fish_model as Node3D).rotation.z = lerp_angle((fish_model as Node3D).rotation.z, 1.5708, clampf(delta * 8.0, 0.0, 1.0))
        if _object_has_property(fish_model, "panic"):
            fish_model.set("panic", lerpf(float(fish_model.get("panic")), 1.0, clampf(delta * 8.0, 0.0, 1.0)))
    else:
        look_direction = look_direction.lerp(entity.movement_velocity, clampf(delta * 6.0, 0.0, 1.0))
        if fish_model is Node3D:
            (fish_model as Node3D).rotation.z = lerp_angle((fish_model as Node3D).rotation.z, 0.0, clampf(delta * 8.0, 0.0, 1.0))
        if _object_has_property(fish_model, "panic"):
            fish_model.set("panic", lerpf(float(fish_model.get("panic")), 0.0, clampf(delta * 8.0, 0.0, 1.0)))

    if _object_has_property(entity, "look_direction"):
        entity.set("look_direction", look_direction)
    _orient_entity_rotation_pivot(entity, look_direction)

    if _object_has_property(fish_model, "speed"):
        var base_speed: float = _resolve_object_float_property(entity, ["speed"], 1.0)
        var speed_modifier: float = _resolve_object_float_property(entity, ["speed_modifier"], 1.0)
        var speed_ratio: float = entity.velocity.length() / maxf(base_speed * speed_modifier, 0.001)
        fish_model.set("speed", lerpf(float(fish_model.get("speed")), speed_ratio, clampf(delta * 3.0, 0.0, 1.0)))


func _step_client_glaggler_visuals(entity, delta: float) -> void:
    if entity == null or not is_instance_valid(entity) or not _object_has_property(entity, "look_direction"):
        return
    var horizontal_direction: Vector3 = Vector3(entity.movement_velocity.x, 0.0, entity.movement_velocity.z)
    if horizontal_direction.length_squared() <= 0.0001:
        return
    var look_direction: Vector3 = entity.get("look_direction")
    look_direction = look_direction.lerp(horizontal_direction.normalized(), clampf(delta * 0.2, 0.0, 1.0))
    entity.set("look_direction", look_direction)
    var rotation_pivot: Node3D = entity.get_node_or_null("%RotationPivot") as Node3D
    if rotation_pivot != null:
        SpatialMath.look_at_local(rotation_pivot, look_direction)


func _step_client_shark_visuals(entity, delta: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    if _object_has_property(entity, "time"):
        entity.set("time", float(entity.get("time")) + delta * 0.1)
    var body: Node3D = entity.get_node_or_null("%Body") as Node3D
    if body != null:
        var spin_per_speed: float = float(entity.get("spin_per_speed")) if _object_has_property(entity, "spin_per_speed") else 0.0
        body.rotation.x += delta * spin_per_speed * entity.velocity.length()
    var rotation_pivot: Node3D = entity.get_node_or_null("%RotationPivot") as Node3D
    if rotation_pivot != null and entity.movement_velocity.length_squared() > 0.0001:
        SpatialMath.look_at_local(rotation_pivot, -entity.movement_velocity.normalized())


func _step_client_diatom_visuals(entity, _delta: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    var direction: Vector3 = Vector3(entity.movement_velocity.x, 0.0, entity.movement_velocity.z).normalized()
    if direction.length_squared() <= 0.0001:
        return
    var leg_rests: Node3D = entity.get_node_or_null("%LegRests") as Node3D
    if leg_rests != null:
        SpatialMath.look_at_local(leg_rests, direction)
    var leg_rays: Node3D = entity.get_node_or_null("%LegRays") as Node3D
    if leg_rays != null:
        SpatialMath.look_at_local(leg_rays, direction)
    var core: Node3D = entity.get_node_or_null("%Core") as Node3D
    if core != null:
        SpatialMath.look_at_local(core, direction)


func _step_client_gel_visuals(entity, _delta: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    entity.visible = true
    var gel_model: Node3D = entity.get_node_or_null("%GelModel") as Node3D
    if gel_model != null:
        gel_model.visible = true
    if entity.has_method("override_position"):
        entity.call("override_position")
    var softbody = entity.get_node_or_null("%SoftBody3D")
    if softbody != null and is_instance_valid(softbody):
        softbody.process_mode = Node.PROCESS_MODE_ALWAYS
        if softbody is GeometryInstance3D:
            (softbody as GeometryInstance3D).visible = true
        if softbody.has_method("set_instance_shader_parameter"):
            softbody.set_instance_shader_parameter("fade", 1.0)


func _advance_client_animation_tree(entity, delta: float) -> void:
    var animation_tree: AnimationTree = _find_first_animation_tree(entity)
    if animation_tree == null:
        return
    animation_tree.active = true
    if not bool(animation_tree.get_meta("coop_manual_advance_initialized", false)):
        animation_tree.set_meta("coop_manual_advance_initialized", true)
        animation_tree.set_process(false)
        animation_tree.set_physics_process(false)
        var animation_player: AnimationPlayer = _find_first_animation_player(entity)
        if animation_player != null:
            animation_player.set_process(false)
            animation_player.set_physics_process(false)
    animation_tree.advance(delta)


func _update_client_procedural_entity_visuals(entity, delta: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return

    var state = entity.get_meta("coop_procedural_visual_state", {}) if entity.has_meta("coop_procedural_visual_state") else {}
    if state is Dictionary and not state.is_empty():
        var lerp_weight: float = clampf(delta * 12.0, 0.0, 1.0)
        _apply_entity_procedural_visual_state(entity, state, lerp_weight)

    var script_path: String = _get_object_script_path(entity)
    if script_path.ends_with("/bee.gd"):
        _step_client_bee_visuals(entity, delta)
    elif script_path.ends_with("/boid.gd"):
        _step_client_boid_visuals(entity, delta)
    elif script_path.ends_with("/fish.gd"):
        _step_client_fish_visuals(entity, delta)
    elif script_path.ends_with("/glaggler.gd"):
        _step_client_glaggler_visuals(entity, delta)
    elif script_path.ends_with("/shark.gd"):
        _step_client_shark_visuals(entity, delta)
    elif script_path.ends_with("/diatom.gd"):
        _step_client_diatom_visuals(entity, delta)
    elif script_path.ends_with("/gel.gd"):
        _step_client_gel_visuals(entity, delta)


func calculate_attack_knockback_velocity(target, attacker_position: Vector3, attacker_velocity: Vector3, knockback_strength: float, fly_strength: float) -> Vector3:
    if target == null or not is_instance_valid(target):
        return Vector3.ZERO

    var horizontal_kb: Vector3 = target.global_position - attacker_position
    horizontal_kb.y = 0.0
    if not horizontal_kb.is_zero_approx():
        horizontal_kb = horizontal_kb.normalized()

    var jump_modifier: float = float(target.get("jump_modifier")) if _object_has_property(target, "jump_modifier") else 1.0
    var on_floor: bool = false
    if is_remote_player_proxy(target) and _object_has_property(target, "grounded"):
        on_floor = bool(target.get("grounded"))
    elif target.has_method("is_on_floor"):
        on_floor = target.is_on_floor()
    var knockback_velocity: Vector3 = 0.45 * attacker_velocity + horizontal_kb * knockback_strength
    knockback_velocity.y += knockback_strength * jump_modifier * fly_strength * (0.5 if not on_floor else 1.0)
    return knockback_velocity


func get_attack_impulse_velocity(attacker, reported_move_speed: float = -1.0) -> Vector3:
    if attacker == null or not is_instance_valid(attacker):
        return Vector3.ZERO

    var attack_velocity: Vector3 = _get_entity_total_velocity(attacker)
    if not has_connected_remote_peers():
        return attack_velocity

    var horizontal_velocity: Vector3 = Vector3(attack_velocity.x, 0.0, attack_velocity.z)
    if _object_has_property(attacker, "movement_velocity"):
        horizontal_velocity = attacker.get("movement_velocity")
        horizontal_velocity.y = 0.0

    if is_remote_player_proxy(attacker):
        var remote_speed_cap: float = maxf(reported_move_speed, 0.0)
        if remote_speed_cap > 0.0 and horizontal_velocity.length() > remote_speed_cap:
            horizontal_velocity = horizontal_velocity.normalized() * remote_speed_cap
        elif remote_speed_cap <= 0.0:
            horizontal_velocity = Vector3.ZERO

        attack_velocity.x = horizontal_velocity.x * 0.35
        attack_velocity.z = horizontal_velocity.z * 0.35
        attack_velocity.y = 0.0
        return attack_velocity

    if reported_move_speed >= 0.0 and horizontal_velocity.length() > reported_move_speed + 1.25:
        if not horizontal_velocity.is_zero_approx():
            horizontal_velocity = horizontal_velocity.normalized() * (reported_move_speed + 1.25)
        else:
            horizontal_velocity = Vector3.ZERO

    attack_velocity.x = horizontal_velocity.x
    attack_velocity.z = horizontal_velocity.z
    attack_velocity.y = clampf(attack_velocity.y, -8.0, 8.0)
    return attack_velocity


func _serialize_peer_states() -> Array:
    var snapshot: Array = []
    for peer_id in peer_states.keys():
        var state: Dictionary = peer_states[peer_id]
        snapshot.append([
            int(peer_id),
            bool(state.get("active", false)),
            bool(state.get("downed", false)),
            int(state.get("dimension", -1)),
            str(state.get("dimension_instance_key", "")),
            str(state.get("pocket_owner_key", "")),
            state.get("position", Vector3.ZERO),
            float(state.get("yaw", 0.0)),
            float(state.get("pitch", 0.0)),
            bool(state.get("crouching", false)),
            bool(state.get("grounded", true)),
            float(state.get("move_speed", 0.0)),
            bool(state.get("under_water", false)),
            int(state.get("held_item_id", -1)),
            int(state.get("action_state", 0)),
            str(state.get("name", "Peer %s" % int(peer_id))),
            str(state.get("player_key", "")),
            str(state.get("avatar_id", DEFAULT_AVATAR_ID)),
            state.get("skin_color", Color.WHITE),
            bool(state.get("breaking", false)),
            state.get("break_position", Vector3i.ZERO),
            int(state.get("break_block_id", 0)),
            float(state.get("break_progress", 0.0)),
            bool(state.get("dedicated_server", false)),
        ])
    return snapshot


func _refresh_markers(states: Dictionary, local_peer_id: int) -> void:
    var visible_ids: Dictionary = {}
    var active_instance_key: String = get_active_dimension_instance_key() if _can_sample_player() else ""
    for peer_id in states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == local_peer_id:
            continue

        var state: Dictionary = states[peer_id]
        if _is_dedicated_peer_state(int_peer_id, state):
            _remove_marker(int_peer_id)
            _remove_remote_player_proxy(int_peer_id)
            continue

        visible_ids[int_peer_id] = true
        var downed: bool = bool(state.get("downed", false))
        var same_dimension: bool = _can_sample_player() and _does_peer_state_match_instance(state, active_instance_key)
        var marker: Node = _ensure_marker(int_peer_id)
        marker.set_avatar_id(str(state.get("avatar_id", DEFAULT_AVATAR_ID)))
        var display_name: String = str(state.get("name", "Peer %s" % int_peer_id))
        marker.set_display_name("%s [DOWN]" % display_name if downed else display_name)
        marker.set_held_item_id(int(state.get("held_item_id", -1)))
        marker.set_skin_color(state.get("skin_color", Color.WHITE))
        marker.apply_state(
            bool(state.get("active", false)) and same_dimension,
            state.get("position", Vector3.ZERO),
            float(state.get("yaw", 0.0)),
            float(state.get("pitch", 0.0)),
            bool(state.get("crouching", false)) or downed,
            bool(state.get("grounded", true)),
            float(state.get("move_speed", 0.0)),
            int(state.get("action_state", 0))
        )
        _update_remote_break_outline(int_peer_id, same_dimension, state)

        if same_dimension and bool(state.get("active", false)):
            var proxy = _ensure_remote_player_proxy(int_peer_id)
            if proxy != null:
                _update_remote_player_proxy(proxy, state)
        elif remote_player_proxies.has(int_peer_id):
            _remove_remote_player_proxy(int_peer_id)

    for peer_id in markers.keys().duplicate():
        if not visible_ids.has(peer_id):
            markers[peer_id].call_deferred("queue_free")
            markers.erase(peer_id)
            _remove_remote_break_outline(peer_id)

    for peer_id in remote_player_proxies.keys().duplicate():
        if not visible_ids.has(peer_id):
            _remove_remote_player_proxy(int(peer_id))


func _ensure_marker(peer_id: int) -> Node:
    if markers.has(peer_id):
        return markers[peer_id]

    var marker_script: GDScript = load("res://coop_mod/remote_player_marker.gd")
    var marker: Node = marker_script.new()
    marker.name = "RemotePeer%s" % peer_id
    add_child(marker)
    marker.setup(peer_id)
    markers[peer_id] = marker
    return marker


func _remove_marker(peer_id: int) -> void:
    if not markers.has(peer_id):
        return
    if is_instance_valid(markers[peer_id]):
        markers[peer_id].call_deferred("queue_free")
    markers.erase(peer_id)
    _remove_remote_break_outline(peer_id)


func _clear_markers() -> void:
    for peer_id in markers.keys():
        markers[peer_id].call_deferred("queue_free")
    markers.clear()
    _clear_remote_player_proxies()
    _clear_remote_break_outlines()


func _hide_all_markers() -> void:
    for peer_id in markers.keys():
        markers[peer_id].visible = false
    _clear_remote_player_proxies()
    _clear_remote_break_outlines()


func _ensure_remote_player_proxy(peer_id: int):
    if remote_player_proxies.has(peer_id) and is_instance_valid(remote_player_proxies[peer_id]):
        return remote_player_proxies[peer_id]

    var proxy_scene = load(REMOTE_PROXY_SCENE_PATH)
    if not (proxy_scene is PackedScene):
        return null

    var proxy = proxy_scene.instantiate()
    if proxy == null:
        return null

    proxy.name = "RemotePlayerProxy%s" % peer_id
    proxy.set_meta("coop_remote_player_proxy", true)
    proxy.set_meta("coop_remote_player_proxy_peer_id", peer_id)
    get_tree().get_root().add_child(proxy)

    proxy.dead = false
    proxy.disabled = false

    remote_player_proxies[peer_id] = proxy
    return proxy


func _update_remote_player_proxy(proxy, state: Dictionary) -> void:
    if proxy == null or not is_instance_valid(proxy) or not proxy.is_inside_tree():
        return

    if proxy.has_method("apply_remote_state"):
        proxy.apply_remote_state(state)
        return

    var downed: bool = bool(state.get("downed", false))
    proxy.global_position = state.get("position", Vector3.ZERO)
    proxy.velocity = Vector3.ZERO
    proxy.dead = false
    proxy.disabled = downed
    proxy.under_water = bool(state.get("under_water", false))
    if proxy.has_method("set_crouching"):
        proxy.set_crouching(bool(state.get("crouching", false)) or downed)


func _remove_remote_player_proxy(peer_id: int) -> void:
    if not remote_player_proxies.has(peer_id):
        return
    if is_instance_valid(remote_player_proxies[peer_id]):
        _queue_runtime_node_for_cleanup(remote_player_proxies[peer_id])
    remote_player_proxies.erase(peer_id)


func _clear_remote_player_proxies() -> void:
    for peer_id in remote_player_proxies.keys().duplicate():
        _remove_remote_player_proxy(int(peer_id))


func _update_remote_break_outline(peer_id: int, same_dimension: bool, state: Dictionary) -> void:
    if not same_dimension or not bool(state.get("breaking", false)):
        _remove_remote_break_outline(peer_id)
        return

    var block_id: int = int(state.get("break_block_id", 0))
    if block_id <= 0:
        _remove_remote_break_outline(peer_id)
        return

    var block = ItemMap.map(block_id)
    if block == null:
        _remove_remote_break_outline(peer_id)
        return

    var outline = _ensure_remote_break_outline(peer_id)
    if outline == null:
        return

    outline.global_position = Vector3(state.get("break_position", Vector3i.ZERO)) + Vector3(0.5, 0.5, 0.5)
    outline.update_block(block)
    outline.update_progress(clampf(float(state.get("break_progress", 0.0)), 0.0, 1.0))


func _ensure_remote_break_outline(peer_id: int):
    if remote_break_outlines.has(peer_id) and is_instance_valid(remote_break_outlines[peer_id]):
        return remote_break_outlines[peer_id]

    var scene = load(BREAK_OUTLINE_SCENE_PATH)
    if not (scene is PackedScene):
        return null

    var outline = scene.instantiate()
    get_tree().get_root().add_child(outline)
    remote_break_outlines[peer_id] = outline
    return outline


func _remove_remote_break_outline(peer_id: int) -> void:
    if not remote_break_outlines.has(peer_id):
        return
    if is_instance_valid(remote_break_outlines[peer_id]):
        remote_break_outlines[peer_id].call_deferred("queue_free")
    remote_break_outlines.erase(peer_id)


func _clear_remote_break_outlines() -> void:
    for peer_id in remote_break_outlines.keys():
        if is_instance_valid(remote_break_outlines[peer_id]):
            remote_break_outlines[peer_id].call_deferred("queue_free")
    remote_break_outlines.clear()


func _build_hud() -> void:
    hud = CanvasLayer.new()
    hud.layer = 64
    add_child(hud)

    overlay = Control.new()
    overlay.anchor_right = 1.0
    overlay.anchor_bottom = 1.0
    overlay.offset_left = 0.0
    overlay.offset_top = 0.0
    overlay.offset_right = 0.0
    overlay.offset_bottom = 0.0
    overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    hud.add_child(overlay)

    death_overlay = Control.new()
    death_overlay.visible = false
    death_overlay.anchor_right = 1.0
    death_overlay.anchor_bottom = 1.0
    death_overlay.offset_right = 0.0
    death_overlay.offset_bottom = 0.0
    death_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    overlay.add_child(death_overlay)

    var death_fade := ColorRect.new()
    death_fade.anchor_right = 1.0
    death_fade.anchor_bottom = 1.0
    death_fade.offset_right = 0.0
    death_fade.offset_bottom = 0.0
    death_fade.color = Color(0.12, 0.0, 0.0, 0.55)
    death_overlay.add_child(death_fade)

    var death_center := CenterContainer.new()
    death_center.anchor_right = 1.0
    death_center.anchor_bottom = 1.0
    death_center.offset_right = 0.0
    death_center.offset_bottom = 0.0
    death_overlay.add_child(death_center)

    var death_panel := PanelContainer.new()
    death_panel.custom_minimum_size = Vector2(150.0, 52.0)
    death_center.add_child(death_panel)

    var death_margin := MarginContainer.new()
    death_margin.add_theme_constant_override("margin_left", 8)
    death_margin.add_theme_constant_override("margin_right", 8)
    death_margin.add_theme_constant_override("margin_top", 6)
    death_margin.add_theme_constant_override("margin_bottom", 6)
    death_panel.add_child(death_margin)

    var death_column := VBoxContainer.new()
    death_column.alignment = BoxContainer.ALIGNMENT_CENTER
    death_column.add_theme_constant_override("separation", 3)
    death_margin.add_child(death_column)

    death_overlay_title = Label.new()
    death_overlay_title.text = "YOU DIED"
    death_overlay_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    death_overlay_title.add_theme_font_size_override("font_size", 12)
    death_overlay_title.add_theme_color_override("font_color", Color(0.94, 0.42, 0.42))
    death_column.add_child(death_overlay_title)

    death_overlay_subtitle = Label.new()
    death_overlay_subtitle.text = "Respawning..."
    death_overlay_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    death_overlay_subtitle.add_theme_font_size_override("font_size", 6)
    death_column.add_child(death_overlay_subtitle)

    revive_prompt_label = Label.new()
    revive_prompt_label.visible = false
    revive_prompt_label.anchor_left = 0.5
    revive_prompt_label.anchor_top = 1.0
    revive_prompt_label.anchor_right = 0.5
    revive_prompt_label.anchor_bottom = 1.0
    revive_prompt_label.offset_left = -110.0
    revive_prompt_label.offset_top = -54.0
    revive_prompt_label.offset_right = 110.0
    revive_prompt_label.offset_bottom = -32.0
    revive_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    revive_prompt_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    revive_prompt_label.add_theme_font_size_override("font_size", 7)
    revive_prompt_label.add_theme_color_override("font_color", Color(0.95, 0.94, 0.86))
    revive_prompt_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
    revive_prompt_label.add_theme_constant_override("shadow_outline_size", 3)
    overlay.add_child(revive_prompt_label)

    reconnect_overlay = Control.new()
    reconnect_overlay.visible = false
    reconnect_overlay.anchor_right = 1.0
    reconnect_overlay.anchor_bottom = 1.0
    reconnect_overlay.offset_right = 0.0
    reconnect_overlay.offset_bottom = 0.0
    reconnect_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
    overlay.add_child(reconnect_overlay)

    var reconnect_fade := ColorRect.new()
    reconnect_fade.anchor_right = 1.0
    reconnect_fade.anchor_bottom = 1.0
    reconnect_fade.offset_right = 0.0
    reconnect_fade.offset_bottom = 0.0
    reconnect_fade.color = Color(0.0, 0.02, 0.05, 0.58)
    reconnect_overlay.add_child(reconnect_fade)

    var reconnect_center := CenterContainer.new()
    reconnect_center.anchor_right = 1.0
    reconnect_center.anchor_bottom = 1.0
    reconnect_center.offset_right = 0.0
    reconnect_center.offset_bottom = 0.0
    reconnect_overlay.add_child(reconnect_center)

    var reconnect_panel := PanelContainer.new()
    reconnect_panel.custom_minimum_size = Vector2(190.0, 74.0)
    reconnect_center.add_child(reconnect_panel)

    var reconnect_margin := MarginContainer.new()
    reconnect_margin.add_theme_constant_override("margin_left", 8)
    reconnect_margin.add_theme_constant_override("margin_right", 8)
    reconnect_margin.add_theme_constant_override("margin_top", 6)
    reconnect_margin.add_theme_constant_override("margin_bottom", 6)
    reconnect_panel.add_child(reconnect_margin)

    var reconnect_column := VBoxContainer.new()
    reconnect_column.alignment = BoxContainer.ALIGNMENT_CENTER
    reconnect_column.add_theme_constant_override("separation", 4)
    reconnect_margin.add_child(reconnect_column)

    reconnect_overlay_title = Label.new()
    reconnect_overlay_title.text = "CONNECTION LOST"
    reconnect_overlay_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    reconnect_overlay_title.add_theme_font_size_override("font_size", 10)
    reconnect_overlay_title.add_theme_color_override("font_color", Color(0.92, 0.92, 0.96))
    reconnect_column.add_child(reconnect_overlay_title)

    reconnect_overlay_subtitle = Label.new()
    reconnect_overlay_subtitle.text = "Reconnecting..."
    reconnect_overlay_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    reconnect_overlay_subtitle.add_theme_font_size_override("font_size", 6)
    reconnect_column.add_child(reconnect_overlay_subtitle)

    var reconnect_buttons := HBoxContainer.new()
    reconnect_buttons.alignment = BoxContainer.ALIGNMENT_CENTER
    reconnect_buttons.add_theme_constant_override("separation", 4)
    reconnect_column.add_child(reconnect_buttons)

    var reconnect_button := Button.new()
    reconnect_button.text = "Reconnect"
    reconnect_button.custom_minimum_size = Vector2(58, 0)
    reconnect_button.add_theme_font_size_override("font_size", 7)
    reconnect_button.pressed.connect(_attempt_reconnect)
    reconnect_buttons.add_child(reconnect_button)

    var leave_button := Button.new()
    leave_button.text = "Leave"
    leave_button.custom_minimum_size = Vector2(58, 0)
    leave_button.add_theme_font_size_override("font_size", 7)
    leave_button.pressed.connect(_leave_reconnect_to_menu)
    reconnect_buttons.add_child(leave_button)

    quit_overlay = Control.new()
    quit_overlay.visible = false
    quit_overlay.anchor_right = 1.0
    quit_overlay.anchor_bottom = 1.0
    quit_overlay.offset_right = 0.0
    quit_overlay.offset_bottom = 0.0
    quit_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
    overlay.add_child(quit_overlay)

    var quit_fade := ColorRect.new()
    quit_fade.anchor_right = 1.0
    quit_fade.anchor_bottom = 1.0
    quit_fade.offset_right = 0.0
    quit_fade.offset_bottom = 0.0
    quit_fade.color = Color(0.01, 0.01, 0.015, 0.62)
    quit_overlay.add_child(quit_fade)

    var quit_center := CenterContainer.new()
    quit_center.anchor_right = 1.0
    quit_center.anchor_bottom = 1.0
    quit_center.offset_right = 0.0
    quit_center.offset_bottom = 0.0
    quit_overlay.add_child(quit_center)

    var quit_panel := PanelContainer.new()
    quit_panel.custom_minimum_size = Vector2(190.0, 64.0)
    quit_center.add_child(quit_panel)

    var quit_margin := MarginContainer.new()
    quit_margin.add_theme_constant_override("margin_left", 8)
    quit_margin.add_theme_constant_override("margin_right", 8)
    quit_margin.add_theme_constant_override("margin_top", 6)
    quit_margin.add_theme_constant_override("margin_bottom", 6)
    quit_panel.add_child(quit_margin)

    var quit_column := VBoxContainer.new()
    quit_column.alignment = BoxContainer.ALIGNMENT_CENTER
    quit_column.add_theme_constant_override("separation", 4)
    quit_margin.add_child(quit_column)

    quit_overlay_title = Label.new()
    quit_overlay_title.text = "LEAVING SERVER"
    quit_overlay_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    quit_overlay_title.add_theme_font_size_override("font_size", 10)
    quit_overlay_title.add_theme_color_override("font_color", Color(0.92, 0.92, 0.96))
    quit_column.add_child(quit_overlay_title)

    quit_overlay_subtitle = Label.new()
    quit_overlay_subtitle.text = "Saving session state..."
    quit_overlay_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    quit_overlay_subtitle.add_theme_font_size_override("font_size", 6)
    quit_column.add_child(quit_overlay_subtitle)

    player_list_overlay = PanelContainer.new()
    player_list_overlay.visible = false
    player_list_overlay.anchor_left = 0.5
    player_list_overlay.anchor_right = 0.5
    player_list_overlay.anchor_top = 0.0
    player_list_overlay.anchor_bottom = 0.0
    player_list_overlay.offset_left = -90.0
    player_list_overlay.offset_right = 90.0
    player_list_overlay.offset_top = 10.0
    player_list_overlay.offset_bottom = 0.0
    player_list_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    overlay.add_child(player_list_overlay)

    var player_list_margin := MarginContainer.new()
    player_list_margin.add_theme_constant_override("margin_left", 6)
    player_list_margin.add_theme_constant_override("margin_right", 6)
    player_list_margin.add_theme_constant_override("margin_top", 4)
    player_list_margin.add_theme_constant_override("margin_bottom", 4)
    player_list_overlay.add_child(player_list_margin)

    player_list_overlay_label = Label.new()
    player_list_overlay_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
    player_list_overlay_label.add_theme_font_size_override("font_size", 7)
    player_list_margin.add_child(player_list_overlay_label)

    panel = PanelContainer.new()
    panel.visible = false
    panel.anchor_left = 0.5
    panel.anchor_right = 0.5
    panel.anchor_top = 0.0
    panel.anchor_bottom = 0.0
    panel.offset_left = -PANEL_WIDTH * 0.5
    panel.offset_right = PANEL_WIDTH * 0.5
    panel.offset_top = 12
    panel.offset_bottom = 156
    panel.clip_contents = false
    overlay.add_child(panel)

    panel_scroll = ScrollContainer.new()
    panel_scroll.anchor_right = 1.0
    panel_scroll.anchor_bottom = 1.0
    panel_scroll.offset_right = 0.0
    panel_scroll.offset_bottom = 0.0
    panel_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    panel_scroll.follow_focus = true
    panel.add_child(panel_scroll)

    var outer_margin: MarginContainer = MarginContainer.new()
    outer_margin.add_theme_constant_override("margin_left", 8)
    outer_margin.add_theme_constant_override("margin_right", 8)
    outer_margin.add_theme_constant_override("margin_top", 8)
    outer_margin.add_theme_constant_override("margin_bottom", 8)
    panel_scroll.add_child(outer_margin)

    panel_column = VBoxContainer.new()
    panel_column.add_theme_constant_override("separation", 6)
    outer_margin.add_child(panel_column)

    var title_row: HBoxContainer = HBoxContainer.new()
    title_row.add_theme_constant_override("separation", 6)
    panel_column.add_child(title_row)

    var title: Label = Label.new()
    title.text = "Co-op"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.add_theme_font_size_override("font_size", 13)
    title_row.add_child(title)

    var close_button: Button = Button.new()
    close_button.text = "x"
    close_button.custom_minimum_size = Vector2(24, 0)
    close_button.add_theme_font_size_override("font_size", 10)
    close_button.pressed.connect(toggle_panel.bind(false))
    title_row.add_child(close_button)

    local_ip_label = Label.new()
    local_ip_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    local_ip_label.add_theme_font_size_override("font_size", 9)
    panel_column.add_child(local_ip_label)

    var join_row: HBoxContainer = HBoxContainer.new()
    join_row.add_theme_constant_override("separation", 6)
    panel_column.add_child(join_row)

    var ip_title: Label = Label.new()
    ip_title.text = "IP"
    ip_title.custom_minimum_size = Vector2(18, 0)
    ip_title.add_theme_font_size_override("font_size", 10)
    join_row.add_child(ip_title)

    address_input = LineEdit.new()
    address_input.placeholder_text = "192.168.x.x"
    address_input.text = str(config.get("address", "127.0.0.1"))
    address_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    address_input.custom_minimum_size = Vector2(0, 22)
    address_input.add_theme_font_size_override("font_size", 10)
    address_input.text_changed.connect(_on_address_changed)
    address_input.text_submitted.connect(_on_join_text_submitted)
    join_row.add_child(address_input)

    var port_title: Label = Label.new()
    port_title.text = "Port"
    port_title.custom_minimum_size = Vector2(28, 0)
    port_title.add_theme_font_size_override("font_size", 10)
    join_row.add_child(port_title)

    port_input = SpinBox.new()
    port_input.min_value = 1
    port_input.max_value = 65535
    port_input.step = 1
    port_input.rounded = true
    port_input.custom_minimum_size = Vector2(72, 22)
    port_input.add_theme_font_size_override("font_size", 10)
    port_input.value = int(config.get("port", DEFAULT_PORT))
    port_input.value_changed.connect(_on_port_changed)
    join_row.add_child(port_input)

    var button_row: HBoxContainer = HBoxContainer.new()
    button_row.add_theme_constant_override("separation", 6)
    panel_column.add_child(button_row)

    var host_button: Button = Button.new()
    host_button.text = "Host"
    host_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    host_button.add_theme_font_size_override("font_size", 10)
    host_button.pressed.connect(host_session)
    button_row.add_child(host_button)

    var join_button: Button = Button.new()
    join_button.text = "Join"
    join_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    join_button.add_theme_font_size_override("font_size", 10)
    join_button.pressed.connect(join_session)
    button_row.add_child(join_button)

    var disconnect_button: Button = Button.new()
    disconnect_button.text = "Leave"
    disconnect_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    disconnect_button.add_theme_font_size_override("font_size", 10)
    disconnect_button.pressed.connect(leave_session)
    button_row.add_child(disconnect_button)

    var steam_button_row: HBoxContainer = HBoxContainer.new()
    steam_button_row.add_theme_constant_override("separation", 6)
    panel_column.add_child(steam_button_row)

    var steam_host_button: Button = Button.new()
    steam_host_button.text = "Host Steam"
    steam_host_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    steam_host_button.add_theme_font_size_override("font_size", 10)
    steam_host_button.pressed.connect(host_steam_session)
    steam_button_row.add_child(steam_host_button)

    var steam_invite_button: Button = Button.new()
    steam_invite_button.text = "Invite"
    steam_invite_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    steam_invite_button.add_theme_font_size_override("font_size", 10)
    steam_invite_button.pressed.connect(_open_steam_invite_dialog)
    steam_button_row.add_child(steam_invite_button)

    var chat_hint_label: Label = Label.new()
    chat_hint_label.text = "Steam invites auto-join. Slash chat: `/`  |  Spawn browser: `F10`"
    chat_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    chat_hint_label.add_theme_font_size_override("font_size", 9)
    panel_column.add_child(chat_hint_label)

    status_label = Label.new()
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    status_label.custom_minimum_size = Vector2(0, 18)
    status_label.add_theme_font_size_override("font_size", 6)
    panel_column.add_child(status_label)

    _refresh_local_ip_label()
    _sync_inputs_from_config()

    spawn_browser_overlay = Control.new()
    spawn_browser_overlay.visible = false
    spawn_browser_overlay.anchor_right = 1.0
    spawn_browser_overlay.anchor_bottom = 1.0
    spawn_browser_overlay.offset_right = 0.0
    spawn_browser_overlay.offset_bottom = 0.0
    spawn_browser_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
    overlay.add_child(spawn_browser_overlay)

    var spawn_browser_fade := ColorRect.new()
    spawn_browser_fade.anchor_right = 1.0
    spawn_browser_fade.anchor_bottom = 1.0
    spawn_browser_fade.offset_right = 0.0
    spawn_browser_fade.offset_bottom = 0.0
    spawn_browser_fade.color = Color(0.0, 0.0, 0.0, 0.55)
    spawn_browser_overlay.add_child(spawn_browser_fade)

    var spawn_browser_center := CenterContainer.new()
    spawn_browser_center.anchor_right = 1.0
    spawn_browser_center.anchor_bottom = 1.0
    spawn_browser_center.offset_right = 0.0
    spawn_browser_center.offset_bottom = 0.0
    spawn_browser_overlay.add_child(spawn_browser_center)

    spawn_browser_panel = PanelContainer.new()
    spawn_browser_panel.custom_minimum_size = Vector2(420.0, 420.0)
    spawn_browser_center.add_child(spawn_browser_panel)

    var spawn_browser_margin := MarginContainer.new()
    spawn_browser_margin.add_theme_constant_override("margin_left", 12)
    spawn_browser_margin.add_theme_constant_override("margin_right", 12)
    spawn_browser_margin.add_theme_constant_override("margin_top", 12)
    spawn_browser_margin.add_theme_constant_override("margin_bottom", 12)
    spawn_browser_panel.add_child(spawn_browser_margin)

    var spawn_browser_column := VBoxContainer.new()
    spawn_browser_column.add_theme_constant_override("separation", 8)
    spawn_browser_margin.add_child(spawn_browser_column)

    var spawn_browser_title_row := HBoxContainer.new()
    spawn_browser_title_row.add_theme_constant_override("separation", 6)
    spawn_browser_column.add_child(spawn_browser_title_row)

    var spawn_browser_title := Label.new()
    spawn_browser_title.text = "Mob Spawn Browser"
    spawn_browser_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    spawn_browser_title.add_theme_font_size_override("font_size", 16)
    spawn_browser_title_row.add_child(spawn_browser_title)

    var spawn_browser_close_button := Button.new()
    spawn_browser_close_button.text = "x"
    spawn_browser_close_button.custom_minimum_size = Vector2(28, 0)
    spawn_browser_close_button.pressed.connect(toggle_spawn_browser.bind(false, ""))
    spawn_browser_title_row.add_child(spawn_browser_close_button)

    spawn_browser_search_input = LineEdit.new()
    spawn_browser_search_input.placeholder_text = "Search mobs..."
    spawn_browser_search_input.text_changed.connect(_on_spawn_browser_search_changed)
    spawn_browser_search_input.text_submitted.connect(_on_spawn_browser_search_submitted)
    spawn_browser_column.add_child(spawn_browser_search_input)

    spawn_browser_hint_label = Label.new()
    spawn_browser_hint_label.text = "Type to filter, Enter to spawn, Esc to close"
    spawn_browser_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    spawn_browser_hint_label.add_theme_font_size_override("font_size", 10)
    spawn_browser_column.add_child(spawn_browser_hint_label)

    spawn_browser_list = ItemList.new()
    spawn_browser_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
    spawn_browser_list.allow_reselect = true
    spawn_browser_list.item_selected.connect(_on_spawn_browser_item_selected)
    spawn_browser_list.item_activated.connect(_on_spawn_browser_item_activated)
    spawn_browser_column.add_child(spawn_browser_list)

    var spawn_browser_button_row := HBoxContainer.new()
    spawn_browser_button_row.add_theme_constant_override("separation", 8)
    spawn_browser_column.add_child(spawn_browser_button_row)

    var spawn_browser_spawn_button := Button.new()
    spawn_browser_spawn_button.text = "Spawn"
    spawn_browser_spawn_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    spawn_browser_spawn_button.pressed.connect(_spawn_from_browser_selection)
    spawn_browser_button_row.add_child(spawn_browser_spawn_button)

    var spawn_browser_cancel_button := Button.new()
    spawn_browser_cancel_button.text = "Close"
    spawn_browser_cancel_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    spawn_browser_cancel_button.pressed.connect(toggle_spawn_browser.bind(false, ""))
    spawn_browser_button_row.add_child(spawn_browser_cancel_button)

    _refresh_spawn_browser_entries("")
    _build_char_select_ui()


func _build_char_select_ui() -> void:
    char_select_overlay = Control.new()
    char_select_overlay.visible = false
    char_select_overlay.anchor_right = 1.0
    char_select_overlay.anchor_bottom = 1.0
    char_select_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
    overlay.add_child(char_select_overlay)

    var fade := ColorRect.new()
    fade.anchor_right = 1.0
    fade.anchor_bottom = 1.0
    fade.color = Color(0.0, 0.0, 0.0, 0.7)
    char_select_overlay.add_child(fade)

    var center := CenterContainer.new()
    center.anchor_right = 1.0
    center.anchor_bottom = 1.0
    char_select_overlay.add_child(center)

    char_select_panel = PanelContainer.new()
    char_select_panel.custom_minimum_size = Vector2(420.0, 320.0)
    var panel_style := StyleBoxFlat.new()
    panel_style.bg_color = Color(0.12, 0.12, 0.15, 0.95)
    panel_style.corner_radius_top_left = 8
    panel_style.corner_radius_top_right = 8
    panel_style.corner_radius_bottom_left = 8
    panel_style.corner_radius_bottom_right = 8
    panel_style.border_width_left = 1
    panel_style.border_width_right = 1
    panel_style.border_width_top = 1
    panel_style.border_width_bottom = 1
    panel_style.border_color = Color(0.3, 0.3, 0.35)
    char_select_panel.add_theme_stylebox_override("panel", panel_style)
    center.add_child(char_select_panel)

    var margin := MarginContainer.new()
    margin.add_theme_constant_override("margin_left", 16)
    margin.add_theme_constant_override("margin_right", 16)
    margin.add_theme_constant_override("margin_top", 12)
    margin.add_theme_constant_override("margin_bottom", 12)
    char_select_panel.add_child(margin)

    var main_col := VBoxContainer.new()
    main_col.add_theme_constant_override("separation", 8)
    margin.add_child(main_col)

    # Title
    var title := Label.new()
    title.text = "SELECT CHARACTER"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 14)
    title.add_theme_color_override("font_color", Color(0.8, 0.8, 0.85))
    main_col.add_child(title)

    # Hint
    var hint := Label.new()
    hint.text = "Click to select, double-click or press Enter to confirm"
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    hint.add_theme_font_size_override("font_size", 10)
    hint.add_theme_color_override("font_color", Color(0.5, 0.5, 0.55))
    main_col.add_child(hint)

    # Character list - simple and clean
    char_select_list = ItemList.new()
    char_select_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
    char_select_list.custom_minimum_size = Vector2(0, 180)
    char_select_list.allow_reselect = true
    char_select_list.add_theme_font_size_override("font_size", 13)
    char_select_list.item_selected.connect(_on_char_select_item_selected)
    char_select_list.item_activated.connect(_on_char_select_item_activated)
    main_col.add_child(char_select_list)

    # Buttons
    var btn_row := HBoxContainer.new()
    btn_row.add_theme_constant_override("separation", 8)
    main_col.add_child(btn_row)

    var select_btn := Button.new()
    select_btn.text = "Select"
    select_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    select_btn.pressed.connect(_on_char_select_confirm)
    btn_row.add_child(select_btn)

    var cancel_btn := Button.new()
    cancel_btn.text = "Cancel"
    cancel_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    cancel_btn.pressed.connect(toggle_char_select.bind(false))
    btn_row.add_child(cancel_btn)

    # Tip at bottom
    var tip := Label.new()
    tip.text = "Tip: /char-select default_blocky"
    tip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    tip.add_theme_font_size_override("font_size", 9)
    tip.add_theme_color_override("font_color", Color(0.4, 0.4, 0.45))
    main_col.add_child(tip)

    _refresh_char_select_entries()


func _refresh_char_select_entries() -> void:
    if char_select_list == null:
        return
    char_select_list.clear()
    char_select_entries.clear()

    AvatarRegistry.invalidate_cache()
    var registry_entries: Array = AvatarRegistry.list_avatar_entries()
    if is_avatar_customization_enabled():
        char_select_entries = registry_entries
    else:
        char_select_entries = []
        for entry in registry_entries:
            if str(entry.get("id", DEFAULT_AVATAR_ID)) == DEFAULT_AVATAR_ID:
                char_select_entries.append(entry)
                break
        if char_select_entries.is_empty():
            char_select_entries.append({"id": DEFAULT_AVATAR_ID, "name": "Default Blocky"})

    for entry in char_select_entries:
        var display_name: String = str(entry.get("name", entry.get("id", "?")))
        char_select_list.add_item(display_name)

    # Highlight current selection
    var current_id = get_local_avatar_id()
    for i in range(char_select_entries.size()):
        if char_select_entries[i]["id"] == current_id:
            char_select_list.select(i)
            break


func toggle_char_select(show: bool = true) -> void:
    if char_select_overlay == null:
        return

    if show:
        _refresh_char_select_entries()
        char_select_overlay.visible = true
        char_select_restore_capture_on_close = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    else:
        char_select_overlay.visible = false
        if char_select_restore_capture_on_close:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _update_char_preview(index: int) -> void:
    if index < 0 or index >= char_select_entries.size():
        return
    _clear_char_preview()

    var entry = char_select_entries[index]
    if char_select_preview_container != null:
        var preview_size: Vector2 = char_select_preview_container.size
        if preview_size.x >= 32.0 and preview_size.y >= 32.0:
            char_select_preview_viewport.size = Vector2i(preview_size)

    char_select_preview_instance = RemotePlayerMarkerScript.new()
    if char_select_preview_instance != null:
        char_select_preview_viewport.add_child(char_select_preview_instance)
        if char_select_preview_instance.has_method("setup"):
            char_select_preview_instance.call("setup", -999)
        if char_select_preview_instance.has_method("set_label_enabled"):
            char_select_preview_instance.call("set_label_enabled", false)
        if char_select_preview_instance.has_method("set_display_name"):
            char_select_preview_instance.call("set_display_name", str(entry.get("name", "")))
        if char_select_preview_instance.has_method("set_skin_color"):
            char_select_preview_instance.call("set_skin_color", _get_local_skin_color())
        if char_select_preview_instance.has_method("set_avatar_id"):
            char_select_preview_instance.call("set_avatar_id", str(entry.get("id", DEFAULT_AVATAR_ID)))
        if char_select_preview_instance.has_method("apply_state"):
            char_select_preview_instance.call(
                "apply_state",
                true,
                Vector3.ZERO,
                deg_to_rad(float(entry.get("preview_yaw", 160.0))),
                0.0,
                false,
                true,
                0.0,
                0
            )
        call_deferred("_refresh_char_preview_camera", entry.duplicate(true))


func _refresh_char_preview_camera(entry: Dictionary) -> void:
    if char_select_preview_instance == null or not is_instance_valid(char_select_preview_instance):
        return

    var aabb: AABB = _get_preview_bounds(char_select_preview_instance)
    var height: float = aabb.size.y if aabb.size.y > 0.001 else 1.0
    var preview_height: float = float(entry.get("preview_height", 1.8))
    var scale_factor: float = preview_height / height
    char_select_preview_instance.scale = Vector3.ONE * scale_factor
    char_select_preview_instance.position = Vector3(0.0, -aabb.position.y * scale_factor, 0.0)

    var cam: Camera3D = char_select_preview_viewport.get_node_or_null("CharPreviewCam") as Camera3D
    if cam == null:
        return

    var scaled_center: Vector3 = (aabb.position + aabb.size * 0.5) * scale_factor
    var scaled_size: Vector3 = aabb.size * scale_factor
    var max_span: float = maxf(maxf(scaled_size.x, scaled_size.y), scaled_size.z)
    var distance: float = maxf(2.35, max_span * 2.6)
    cam.position = Vector3(0.0, scaled_center.y + scaled_size.y * 0.12, distance)
    cam.look_at(Vector3(0.0, scaled_center.y + scaled_size.y * 0.05, 0.0), Vector3.UP)


func _get_preview_bounds(root: Node3D) -> AABB:
    var mesh_bounds: Array = []
    _collect_preview_bounds(root, Transform3D.IDENTITY, mesh_bounds, true)
    if mesh_bounds.is_empty():
        return AABB(Vector3(-0.35, 0.0, -0.35), Vector3(0.7, 1.7, 0.7))

    var merged: AABB = mesh_bounds[0]
    for index in range(1, mesh_bounds.size()):
        merged = merged.merge(mesh_bounds[index])
    return merged


func _collect_preview_bounds(node: Node, parent_transform: Transform3D, mesh_bounds: Array, skip_node_transform: bool = false) -> void:
    var current_transform: Transform3D = parent_transform
    if node is Node3D and not skip_node_transform:
        current_transform = parent_transform * (node as Node3D).transform

    if node is MeshInstance3D:
        var mesh_node := node as MeshInstance3D
        if mesh_node.mesh != null:
            mesh_bounds.append(_transform_preview_aabb(mesh_node.get_aabb(), current_transform))

    for child in node.get_children():
        _collect_preview_bounds(child, current_transform, mesh_bounds, false)


func _transform_preview_aabb(source_aabb: AABB, transform: Transform3D) -> AABB:
    var corners: Array = [
        source_aabb.position,
        source_aabb.position + Vector3(source_aabb.size.x, 0.0, 0.0),
        source_aabb.position + Vector3(0.0, source_aabb.size.y, 0.0),
        source_aabb.position + Vector3(0.0, 0.0, source_aabb.size.z),
        source_aabb.position + Vector3(source_aabb.size.x, source_aabb.size.y, 0.0),
        source_aabb.position + Vector3(source_aabb.size.x, 0.0, source_aabb.size.z),
        source_aabb.position + Vector3(0.0, source_aabb.size.y, source_aabb.size.z),
        source_aabb.position + source_aabb.size,
    ]

    var first_corner: Vector3 = transform * corners[0]
    var transformed_aabb: AABB = AABB(first_corner, Vector3.ZERO)
    for index in range(1, corners.size()):
        transformed_aabb = transformed_aabb.expand(transform * corners[index])
    return transformed_aabb


func _clear_char_preview() -> void:
    if char_select_preview_instance != null:
        char_select_preview_instance.queue_free()
        char_select_preview_instance = null


func _on_char_select_item_selected(_index: int) -> void:
    pass


func _on_char_select_item_activated(_index: int) -> void:
    _on_char_select_confirm()


func _on_char_select_confirm() -> void:
    var selected = char_select_list.get_selected_items()
    if selected.size() == 0:
        return
    var index = selected[0]
    if index < 0 or index >= char_select_entries.size():
        return

    var entry = char_select_entries[index]
    _set_local_avatar_id_from_command(str(entry.get("id", DEFAULT_AVATAR_ID)), "Character set to %s")
    toggle_char_select(false)
    status_message = "Character set to %s" % entry.get("name", entry.get("id", DEFAULT_AVATAR_ID))
    _update_status_text()


func _refresh_local_ip_label() -> void:
    if local_ip_label == null:
        return

    var best_ip: String = _get_best_local_ipv4()
    var steam_status: String = "ready" if _can_use_steam_sessions() else "unavailable"
    if active_steam_lobby_id > 0:
        steam_status = "lobby %s" % active_steam_lobby_id
    local_ip_label.text = "LAN: %s\nSteam: %s" % [best_ip, steam_status]


func _get_best_local_ipv4() -> String:
    var best_ip: String = "127.0.0.1"
    var best_score: int = 999

    for address in IP.get_local_addresses():
        if ":" in address:
            continue
        if address.begins_with("127."):
            continue

        var score: int = _score_ipv4(address)
        if score < best_score:
            best_score = score
            best_ip = address

    return best_ip


func _score_ipv4(address: String) -> int:
    if address.begins_with("192.168."):
        return 0
    if address.begins_with("10."):
        return 1
    if address.begins_with("172."):
        var second_octet_text: String = address.get_slice(".", 1)
        var second_octet: int = int(second_octet_text)
        if second_octet >= 16 and second_octet <= 31:
            if second_octet == 17 or second_octet == 18:
                return 4
            return 2
    if address.begins_with("100."):
        return 3
    return 5


func _sync_inputs_from_config() -> void:
    if address_input != null:
        address_input.text = str(config.get("address", "127.0.0.1"))
    if port_input != null:
        port_input.value = int(config.get("port", DEFAULT_PORT))
    if pause_menu_coop_address_input != null:
        pause_menu_coop_address_input.text = str(config.get("address", "127.0.0.1"))
    if pause_menu_coop_port_input != null:
        pause_menu_coop_port_input.value = int(config.get("port", DEFAULT_PORT))
    if main_menu_coop_address_input != null:
        main_menu_coop_address_input.text = str(config.get("address", "127.0.0.1"))
    if main_menu_coop_port_input != null:
        main_menu_coop_port_input.value = int(config.get("port", DEFAULT_PORT))


func _apply_ui_to_config() -> void:
    var normalized_address: String = str(config.get("address", "127.0.0.1"))
    var normalized_port: int = int(config.get("port", DEFAULT_PORT))

    if pause_menu_coop_address_input != null and _is_pause_menu_coop_panel_open():
        var pause_address: String = pause_menu_coop_address_input.text.strip_edges()
        normalized_address = pause_address if pause_address != "" else "127.0.0.1"
    elif main_menu_coop_address_input != null and _is_main_menu_coop_panel_open():
        var main_menu_address: String = main_menu_coop_address_input.text.strip_edges()
        normalized_address = main_menu_address if main_menu_address != "" else "127.0.0.1"
    elif address_input != null:
        var address: String = address_input.text.strip_edges()
        normalized_address = address if address != "" else "127.0.0.1"

    if pause_menu_coop_port_input != null and _is_pause_menu_coop_panel_open():
        normalized_port = _get_spin_box_int_value(pause_menu_coop_port_input, normalized_port)
    elif main_menu_coop_port_input != null and _is_main_menu_coop_panel_open():
        normalized_port = _get_spin_box_int_value(main_menu_coop_port_input, normalized_port)
    elif port_input != null:
        normalized_port = _get_spin_box_int_value(port_input, normalized_port)

    config["address"] = normalized_address
    config["port"] = normalized_port
    _save_config()

    if address_input != null and address_input.text != normalized_address:
        address_input.text = normalized_address
    if port_input != null and int(port_input.value) != normalized_port:
        port_input.value = normalized_port
    if pause_menu_coop_address_input != null and pause_menu_coop_address_input.text != normalized_address:
        pause_menu_coop_address_input.text = normalized_address
    if pause_menu_coop_port_input != null and int(pause_menu_coop_port_input.value) != normalized_port:
        pause_menu_coop_port_input.value = normalized_port
    if main_menu_coop_address_input != null and main_menu_coop_address_input.text != normalized_address:
        main_menu_coop_address_input.text = normalized_address
    if main_menu_coop_port_input != null and int(main_menu_coop_port_input.value) != normalized_port:
        main_menu_coop_port_input.value = normalized_port


func _on_address_changed(_new_text: String) -> void:
    _apply_ui_to_config()
    _update_status_text()


func _on_join_text_submitted(_new_text: String) -> void:
    join_session()


func _on_port_changed(_new_value: float) -> void:
    _apply_ui_to_config()
    _update_status_text()


func toggle_spawn_browser(force_visible: Variant = null, initial_query: String = "") -> void:
    if spawn_browser_overlay == null:
        return

    var next_visible: bool = not spawn_browser_overlay.visible if force_visible == null else bool(force_visible)
    if next_visible == spawn_browser_overlay.visible and (not next_visible or initial_query == ""):
        return

    if next_visible:
        if panel_visible:
            toggle_panel(false)
        spawn_browser_restore_capture_on_close = MouseHandler.captured
        MouseHandler.release()
        if is_instance_valid(Ref.player):
            Ref.player.consume_actions()
        spawn_browser_overlay.visible = true
        _refresh_overlay_layout()
        if spawn_browser_search_input != null:
            spawn_browser_search_input.text = initial_query
            spawn_browser_search_input.grab_focus()
            spawn_browser_search_input.caret_column = spawn_browser_search_input.text.length()
        _refresh_spawn_browser_entries(initial_query)
        return

    spawn_browser_overlay.visible = false
    if spawn_browser_search_input != null:
        spawn_browser_search_input.text = ""
    if is_instance_valid(Ref.player):
        Ref.player.consume_actions()
    if spawn_browser_restore_capture_on_close and not panel_visible:
        MouseHandler.capture()
    spawn_browser_restore_capture_on_close = false


func _refresh_spawn_browser_entries(filter_text: String) -> void:
    if spawn_browser_list == null:
        return

    spawn_browser_entries = PackedStringArray()
    spawn_browser_list.clear()
    var lowered_filter: String = _normalize_debug_spawn_id(filter_text)
    for spawn_id in _get_debug_spawn_ids():
        var spawn_text: String = str(spawn_id)
        if lowered_filter != "" and not spawn_text.contains(lowered_filter):
            continue
        spawn_browser_entries.append(spawn_text)
        spawn_browser_list.add_item(spawn_text)

    if spawn_browser_hint_label != null:
        spawn_browser_hint_label.text = "%d mobs available - Enter or double click to spawn" % spawn_browser_entries.size() if not spawn_browser_entries.is_empty() else "No mobs match that filter"

    if not spawn_browser_entries.is_empty():
        spawn_browser_list.select(0)


func _get_selected_spawn_browser_id() -> String:
    if spawn_browser_list == null or spawn_browser_entries.is_empty():
        return ""
    var selected_items: PackedInt32Array = spawn_browser_list.get_selected_items()
    if selected_items.is_empty():
        return str(spawn_browser_entries[0])
    var selected_index: int = int(selected_items[0])
    if selected_index < 0 or selected_index >= spawn_browser_entries.size():
        return ""
    return str(spawn_browser_entries[selected_index])


func _spawn_from_browser_selection(_pressed: bool = false) -> void:
    var spawn_id: String = _get_selected_spawn_browser_id()
    if spawn_id == "":
        status_message = "No mob selected"
        _update_status_text()
        return
    _execute_spawn_command(PackedStringArray(["/spawn", spawn_id]))


func _on_spawn_browser_search_changed(new_text: String) -> void:
    _refresh_spawn_browser_entries(new_text)


func _on_spawn_browser_search_submitted(_text: String) -> void:
    _spawn_from_browser_selection()


func _on_spawn_browser_item_selected(index: int) -> void:
    if spawn_browser_hint_label == null or index < 0 or index >= spawn_browser_entries.size():
        return
    spawn_browser_hint_label.text = "Ready to spawn `%s`" % str(spawn_browser_entries[index])


func _on_spawn_browser_item_activated(_index: int) -> void:
    _spawn_from_browser_selection()


func _update_status_text() -> void:
    _refresh_local_ip_label()
    _refresh_pause_menu_coop_status()
    _refresh_pause_menu_player_list(true)
    _refresh_main_menu_coop_status()
    if status_label == null:
        return

    var mode: String = "offline"
    var transport: String = SESSION_TRANSPORT_LAN
    if _has_live_peer():
        mode = "host" if multiplayer.is_server() else "client"
        transport = active_session_transport

    var peers: int = peer_states.size()
    if peer_states.has(multiplayer.get_unique_id()):
        peers -= 1
    peers = max(peers, 0)

    status_label.text = "%s\nMode: %s  |  Transport: %s  |  Peers: %s" % [status_message, mode, transport, peers]



func _load_config(announce: bool = false) -> void:
    config = {
        "address": "127.0.0.1",
        "port": DEFAULT_PORT,
        "avatar_id": DEFAULT_AVATAR_ID,
        "server_registry_url": "",
        "server_registry_heartbeat_url": "",
        "server_registry_token": "",
        "server_public_address": "",
        "server_public_name": "",
        "server_public_region": "public",
        "show_direct_connect_tab": false,
        "enable_debug_console_commands": ENABLE_DEBUG_CONSOLE_COMMANDS_DEFAULT,
        "enable_client_visual_mod": ENABLE_CLIENT_VISUAL_MOD_DEFAULT,
        "enable_avatar_customization": ENABLE_AVATAR_CUSTOMIZATION_DEFAULT,
        "enable_avatar_alias_command": ENABLE_AVATAR_ALIAS_COMMAND_DEFAULT,
        "server_registry_cache_ttl_sec": SERVER_REGISTRY_CACHE_TTL_SEC,
        "server_entity_view_radius": DEFAULT_SERVER_ENTITY_VIEW_RADIUS,
        "server_entity_simulation_radius": DEFAULT_SERVER_ENTITY_SIMULATION_RADIUS,
        "server_command_policy": DEFAULT_SERVER_COMMAND_POLICY.duplicate(true),
        "server_admin_keys": [],
    }

    if not FileAccess.file_exists(CONFIG_PATH):
        _save_config()
        if announce:
            status_message = "Created config at %s" % OS.get_user_data_dir().path_join("lucid_blocks_coop_config.json")
            _sync_inputs_from_config()
            _update_status_text()
        return

    var file: FileAccess = FileAccess.open(CONFIG_PATH, FileAccess.READ)
    if file == null:
        return

    var data: Variant = JSON.parse_string(file.get_as_text())
    if data is Dictionary:
        config.merge(data, true)
    config["avatar_id"] = _normalize_avatar_id(str(config.get("avatar_id", DEFAULT_AVATAR_ID)))
    config["enable_debug_console_commands"] = bool(config.get("enable_debug_console_commands", ENABLE_DEBUG_CONSOLE_COMMANDS_DEFAULT))
    config["enable_client_visual_mod"] = true
    config["enable_avatar_customization"] = bool(config.get("enable_avatar_customization", ENABLE_AVATAR_CUSTOMIZATION_DEFAULT))
    config["enable_avatar_alias_command"] = bool(config.get("enable_avatar_alias_command", ENABLE_AVATAR_ALIAS_COMMAND_DEFAULT))
    config["server_registry_url"] = str(config.get("server_registry_url", "")).strip_edges()
    config["server_registry_heartbeat_url"] = str(config.get("server_registry_heartbeat_url", "")).strip_edges()
    config["server_registry_token"] = str(config.get("server_registry_token", "")).strip_edges()
    config["server_save_secret"] = str(config.get("server_save_secret", "")).strip_edges()
    config["server_public_address"] = str(config.get("server_public_address", "")).strip_edges()
    config["server_public_name"] = str(config.get("server_public_name", "")).strip_edges()
    config["server_public_region"] = str(config.get("server_public_region", "public")).strip_edges()
    config["show_direct_connect_tab"] = bool(config.get("show_direct_connect_tab", false))
    config["server_registry_cache_ttl_sec"] = maxi(0, int(config.get("server_registry_cache_ttl_sec", SERVER_REGISTRY_CACHE_TTL_SEC)))
    config["server_entity_view_radius"] = get_server_entity_view_radius()
    config["server_entity_simulation_radius"] = get_server_entity_simulation_radius()
    config["server_command_policy"] = _normalize_server_command_policy(config.get("server_command_policy", DEFAULT_SERVER_COMMAND_POLICY))
    var normalized_admin_keys: PackedStringArray = _parse_server_admin_keys(config.get("server_admin_keys", []))
    config["server_admin_keys"] = []
    for admin_key in normalized_admin_keys:
        config["server_admin_keys"].append(admin_key)
    active_server_command_policy = config["server_command_policy"].duplicate(true)

    _sync_inputs_from_config()
    _refresh_local_ip_label()

    if announce:
        status_message = "Reloaded config"
        print("[lucid-blocks-coop] reloaded config: %s" % config)
        _update_status_text()


func _save_config() -> void:
    var file: FileAccess = FileAccess.open(CONFIG_PATH, FileAccess.WRITE)
    if file == null:
        return
    file.store_string(JSON.stringify(config, "  "))


func _get_coop_protocol_info() -> Dictionary:
    return {
        "protocol": COOP_PROTOCOL_NAME,
        "version": COOP_PROTOCOL_VERSION,
        "min": COOP_PROTOCOL_MIN_COMPATIBLE,
        "features": COOP_PROTOCOL_FEATURES,
        "required_features": COOP_PROTOCOL_REQUIRED_FEATURES,
        "game_version": str(ProjectSettings.get("application/config/version")),
    }


func _get_coop_protocol_info_from_status(data: Dictionary) -> Dictionary:
    if not data.has("coop_protocol") and not data.has("coop_protocol_version") and not data.has("coop_protocol_min"):
        return {}
    var remote_version: int = int(data.get("coop_protocol_version", 0))
    return {
        "protocol": str(data.get("coop_protocol", "")),
        "version": remote_version,
        "min": int(data.get("coop_protocol_min", remote_version)),
        "features": data.get("coop_protocol_features", []),
        "required_features": data.get("coop_protocol_required_features", []),
        "game_version": str(data.get("version", "")),
    }


func _protocol_feature_list(value: Variant) -> Array:
    var result: Array = []
    if value is Array:
        for item in value:
            var feature: String = str(item).strip_edges()
            if feature != "" and not result.has(feature):
                result.append(feature)
    return result


func _has_protocol_features(available_value: Variant, required_value: Variant) -> bool:
    var available: Array = _protocol_feature_list(available_value)
    for feature in _protocol_feature_list(required_value):
        if not available.has(feature):
            return false
    return true


func _format_protocol_features(value: Variant) -> String:
    var features: Array = _protocol_feature_list(value)
    if features.is_empty():
        return "-"
    var parts: PackedStringArray = PackedStringArray()
    for feature in features:
        parts.append(str(feature))
    return ",".join(parts)


func _is_coop_protocol_compatible(remote_info: Dictionary) -> bool:
    if str(remote_info.get("protocol", "")) != COOP_PROTOCOL_NAME:
        return false
    var remote_version: int = int(remote_info.get("version", 0))
    var remote_min: int = int(remote_info.get("min", remote_version))
    if remote_version < COOP_PROTOCOL_MIN_COMPATIBLE or COOP_PROTOCOL_VERSION < remote_min:
        return false
    if not _has_protocol_features(COOP_PROTOCOL_FEATURES, remote_info.get("required_features", [])):
        return false
    if not _has_protocol_features(remote_info.get("features", []), COOP_PROTOCOL_REQUIRED_FEATURES):
        return false
    return true


func _format_coop_protocol_info(info: Dictionary) -> String:
    return "%s p%s min%s features[%s]" % [
        str(info.get("protocol", "unknown")),
        int(info.get("version", 0)),
        int(info.get("min", 0)),
        _format_protocol_features(info.get("features", [])),
    ]


func _reset_join_protocol_state() -> void:
    join_protocol_pending = false
    join_protocol_accepted = false
    join_protocol_deadline_msec = 0
    client_connection_deadline_msec = 0


func _has_pending_peer_connection() -> bool:
    return multiplayer.multiplayer_peer != null \
        and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING


func _request_join_protocol_check() -> void:
    if multiplayer.is_server() or not _has_live_peer():
        return
    join_protocol_pending = true
    join_protocol_accepted = false
    join_protocol_deadline_msec = Time.get_ticks_msec() + 8000
    _display_connection_status("Connected. Checking server protocol...", true)
    request_join_protocol.rpc_id(1, _get_coop_protocol_info())


func _tick_join_protocol_timeout() -> void:
    if not join_protocol_pending or join_protocol_accepted:
        return
    if Time.get_ticks_msec() < join_protocol_deadline_msec:
        return
    join_protocol_pending = false
    join_protocol_accepted = true
    _display_connection_status("Server did not answer protocol check; trying legacy join...", true)
    request_host_world_snapshot.rpc_id(1)


func _tick_client_connection_timeout() -> void:
    if client_connection_deadline_msec <= 0:
        return
    if multiplayer.multiplayer_peer == null:
        client_connection_deadline_msec = 0
        return
    var status: int = multiplayer.multiplayer_peer.get_connection_status()
    if status == MultiplayerPeer.CONNECTION_CONNECTED:
        client_connection_deadline_msec = 0
        return
    if status == MultiplayerPeer.CONNECTION_DISCONNECTED:
        client_connection_deadline_msec = 0
        disconnect_session(false)
        _display_connection_status("Connection failed: server closed connection", true)
        return
    if Time.get_ticks_msec() < client_connection_deadline_msec:
        return
    client_connection_deadline_msec = 0
    disconnect_session(false)
    _display_connection_status("Connection failed: ENet timeout", true)


func _reject_peer_after_protocol_mismatch(peer_id: int) -> void:
    await get_tree().create_timer(0.25, true).timeout
    if multiplayer.multiplayer_peer != null and multiplayer.is_server():
        multiplayer.multiplayer_peer.disconnect_peer(peer_id)


@rpc("any_peer", "call_remote", "reliable")
func request_join_protocol(client_info: Dictionary) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    var server_info: Dictionary = _get_coop_protocol_info()
    if not _is_coop_protocol_compatible(client_info):
        var reason: String = "Protocol mismatch: client %s, server %s" % [
            _format_coop_protocol_info(client_info),
            _format_coop_protocol_info(server_info),
        ]
        print("[lucid-blocks-coop] Rejecting peer %s: %s" % [sender_id, reason])
        receive_join_protocol_result.rpc_id(sender_id, false, server_info, reason)
        _reject_peer_after_protocol_mismatch.call_deferred(sender_id)
        return

    print("[lucid-blocks-coop] Peer %s protocol accepted: client %s server %s" % [
        sender_id,
        _format_coop_protocol_info(client_info),
        _format_coop_protocol_info(server_info),
    ])
    receive_join_protocol_result.rpc_id(sender_id, true, server_info, "Protocol accepted")


@rpc("authority", "call_remote", "reliable")
func receive_join_protocol_result(accepted: bool, server_info: Dictionary, reason: String = "") -> void:
    if multiplayer.is_server():
        return
    join_protocol_pending = false
    join_protocol_accepted = accepted
    if not accepted:
        var message: String = reason if reason != "" else "Server rejected protocol"
        _display_connection_status(message, true)
        disconnect_session(false)
        return

    _display_connection_status("Server protocol OK: %s" % _format_coop_protocol_info(server_info), true)
    _display_connection_status("Requesting server world...", true)
    request_host_world_snapshot.rpc_id(1)


func _on_peer_connected(id: int) -> void:
    var peer_message: String = "Peer %s connected" % id
    if not multiplayer.is_server() and id == 1 and not guest_persistent_ready:
        print("[lucid-blocks-coop] %s" % peer_message)
    else:
        status_message = peer_message
        print("[lucid-blocks-coop] %s" % status_message)
    if dedicated_server_enabled and multiplayer.is_server():
        print("[lucid-blocks-coop] Dedicated peer_connected id=%s players=%s" % [id, _get_server_runtime_metrics().get("players", 0)])
    if multiplayer.is_server() and id != multiplayer.get_unique_id():
        sync_server_command_policy.rpc_id(id, _get_local_server_command_policy())
    _update_status_text()
    _refresh_world_runtime_mode()
    _refresh_host_entity_activity_override(999.0)


func _on_peer_disconnected(id: int) -> void:
    var disconnected_state: Dictionary = peer_states.get(id, {})
    if multiplayer.is_server() and not disconnected_state.is_empty():
        _store_guest_exit_position_from_peer_state(id, disconnected_state)
        if dedicated_server_enabled:
            _flush_dedicated_dirty_chunks_before_snapshot.call_deferred("peer_disconnect")
    peer_states.erase(id)
    server_world_edit_selections.erase(id)
    _clear_host_interest_cache_for_peer(id)
    if markers.has(id):
        markers[id].call_deferred("queue_free")
        markers.erase(id)
    _remove_remote_player_proxy(id)
    _remove_remote_break_outline(id)
    status_message = "Peer %s disconnected" % id
    print("[lucid-blocks-coop] %s" % status_message)
    if dedicated_server_enabled and multiplayer.is_server():
        print("[lucid-blocks-coop] Dedicated peer_disconnected id=%s players=%s" % [id, _get_server_runtime_metrics().get("players", 0)])
    _update_status_text()
    _refresh_world_runtime_mode()
    if local_downed and not _has_same_instance_reviver_available(multiplayer.get_unique_id()):
        _commit_local_real_death("Your partner disconnected")


func _on_connected_to_server() -> void:
    client_connection_deadline_msec = 0
    guest_persistent_ready = false
    _install_player_death_hook()
    _install_game_menu_quit_hook()
    _mark_host_contact()
    _refresh_world_runtime_mode()
    _display_connection_status("Network connected as peer %s" % multiplayer.get_unique_id(), true)
    _request_join_protocol_check()


func _on_connection_failed() -> void:
    client_connection_deadline_msec = 0
    if reconnect_pending:
        disconnect_session(false)
        client_restore_in_progress = true
        if _can_sample_player():
            _reset_local_player_motion()
            Ref.player.disabled = true
        local_quit_in_progress = false
        status_message = "Reconnect failed"
        _update_status_text()
        reconnect_retry_timer = AUTO_RECONNECT_INTERVAL
        _set_reconnect_overlay_visible(true)
        return

    disconnect_session(false)
    local_quit_in_progress = false
    push_warning("[lucid-blocks-coop] connection failed")
    _display_connection_status("Connection failed: server unreachable or refused", true)


func _on_local_game_quit() -> void:
    if dedicated_server_enabled:
        local_quit_in_progress = false
        clear_fake_death_override_after_shutdown = false
        _apply_dedicated_player_safety()
        return

    if suppress_local_game_quit_session_shutdown:
        return

    if multiplayer.is_server() and is_local_player_fake_dead():
        _abort_host_respawn(false, false)

    clear_fake_death_override_after_shutdown = false
    if not _has_live_peer():
        local_quit_in_progress = false
        return

    local_quit_in_progress = true
    if multiplayer.is_server():
        host_rehost_pending = false
        _shutdown_host_session.call_deferred(false, "Host left the session")
    else:
        var menu_kick_already_pending: bool = client_menu_kick_pending
        if guest_persistent_ready:
            _send_persistent_state_to_host(true)
        disconnect_session(false)
        if not menu_kick_already_pending and is_instance_valid(Ref.main):
            client_menu_kick_pending = true
            _force_client_main_menu_kick.call_deferred("game quit")


func _on_server_disconnected() -> void:
    client_connection_deadline_msec = 0
    if local_quit_in_progress:
        disconnect_session(false)
        _display_connection_status("Server disconnected", true)
        return

    _begin_reconnect_flow("Server disconnected")


func _shutdown_host_session(reconnectable: bool, reason: String = "") -> void:
    if not _has_live_peer() or not multiplayer.is_server():
        return

    host_session_ending.rpc(reconnectable, reason)
    await get_tree().create_timer(0.5, true).timeout
    disconnect_session(false)
    if clear_fake_death_override_after_shutdown:
        local_fake_death_save_override.clear()
        local_fake_death_respawn_target_valid = false
        clear_fake_death_override_after_shutdown = false
    if not reconnectable:
        local_quit_in_progress = false


func _on_local_world_loaded() -> void:
    _set_single_player_shutdown_world_pause_override(false)
    if _has_live_peer() or dedicated_server_enabled:
        _install_player_death_hook()
        call_deferred("_install_game_menu_quit_hook")
    else:
        _restore_game_menu_quit_hook()
    call_deferred("_enforce_server_only_world_access")
    _migrate_loaded_legacy_pocket_to_local_owner_if_needed()
    call_deferred("_ensure_pause_menu_coop_ui")
    if not host_rehost_pending:
        return
    _resume_host_session_after_world_load.call_deferred()


func _is_loaded_world_server_only() -> bool:
    if Ref.save_file_manager == null or Ref.save_file_manager.loaded_file_register == null:
        return false
    return bool(Ref.save_file_manager.loaded_file_register.get_data(SERVER_WORLD_ONLY_KEY, false))


func _enforce_server_only_world_access() -> void:
    if dedicated_server_enabled or _has_live_peer() or not _is_loaded_world_server_only():
        return
    if not is_instance_valid(Ref.main):
        return

    status_message = "This is a server-only world. Join it through Co-op."
    _update_status_text()
    await _kick_client_to_main_menu()


func _resume_host_session_after_world_load() -> void:
    if not host_rehost_pending or _has_live_peer():
        return

    for attempt in range(50):
        await get_tree().create_timer(0.1, true).timeout
        if not host_rehost_pending or _has_live_peer():
            return
        if _can_share_loaded_world():
            break

    if not host_rehost_pending or _has_live_peer() or not _can_share_loaded_world():
        host_rehost_pending = false
        return

    config["port"] = host_rehost_port
    _sync_inputs_from_config()
    status_message = "Rehosting local session"
    _update_status_text()
    _install_player_death_hook()
    host_session()
    if multiplayer.is_server():
        host_rehost_pending = false


@rpc("authority", "call_remote", "reliable")
func host_session_ending(reconnectable: bool = false, reason: String = "") -> void:
    if multiplayer.is_server():
        return

    if reconnectable:
        local_quit_in_progress = false
        _begin_reconnect_flow(reason if reason != "" else "Host is rehosting")
        return

    await _guest_save_and_quit_to_main_menu(reason if reason != "" else "Host ended the session")


func _queue_client_main_menu_kick() -> void:
    if (multiplayer.is_server() and _has_live_peer()) or client_menu_kick_pending:
        return
    client_menu_kick_pending = true
    _kick_client_to_main_menu.call_deferred()


func _begin_reconnect_flow(reason: String) -> void:
    if multiplayer.is_server() or local_quit_in_progress:
        return
    if local_downed:
        disconnect_session(false)
        return

    var interrupted_world_restore: bool = receiving_host_world or client_restore_in_progress
    if active_session_transport == SESSION_TRANSPORT_STEAM:
        reconnect_steam_lobby_id = active_steam_lobby_id
        reconnect_steam_host_id = active_steam_host_id
    else:
        reconnect_steam_lobby_id = 0
        reconnect_steam_host_id = 0
    _close_pause_menu_if_open()
    disconnect_session(false)
    reconnect_pending = true
    client_restore_in_progress = true
    reconnect_attempt_count = 0
    reconnect_retry_timer = AUTO_RECONNECT_INTERVAL
    reconnect_reason = reason
    status_message = reason
    _update_status_text()
    _set_reconnect_overlay_visible(true)
    if _can_sample_player():
        _reset_local_player_motion()
        Ref.player.disabled = true
    if interrupted_world_restore and is_instance_valid(Ref.trans) and Ref.trans.visible:
        Ref.trans.call_deferred("close")


func _tick_reconnect(delta: float) -> void:
    if (multiplayer.is_server() and _has_live_peer()) or _has_live_peer() or receiving_host_world:
        return

    reconnect_retry_timer = maxf(0.0, reconnect_retry_timer - delta)
    if reconnect_overlay_subtitle != null:
        reconnect_overlay_subtitle.text = "%s\nRetrying in %.1fs (attempt %d)" % [
            reconnect_reason,
            reconnect_retry_timer,
            reconnect_attempt_count + 1,
        ]

    if reconnect_retry_timer > 0.0:
        return
    _attempt_reconnect()


func _attempt_reconnect() -> void:
    if (multiplayer.is_server() and _has_live_peer()) or _has_live_peer() or receiving_host_world:
        return

    _close_pause_menu_if_open()
    reconnect_pending = true
    client_restore_in_progress = true
    reconnect_attempt_count += 1
    reconnect_retry_timer = AUTO_RECONNECT_INTERVAL
    local_quit_in_progress = false
    guest_persistent_ready = false
    last_host_contact_time = 0
    client_state_heartbeat_timer = 0.0
    last_sent_client_state_hash = 0
    status_message = "Attempting reconnect..."
    _update_status_text()
    if reconnect_overlay_subtitle != null:
        reconnect_overlay_subtitle.text = "%s\nAttempting reconnect now..." % reconnect_reason

    if reconnect_steam_host_id > 0 or reconnect_steam_lobby_id > 0:
        var steam_peer := _create_steam_multiplayer_peer()
        if steam_peer == null:
            status_message = "Reconnect failed (Steam unavailable)"
            _update_status_text()
            _set_reconnect_overlay_visible(true)
            return

        var steam_err: Error = ERR_UNAVAILABLE
        if reconnect_steam_host_id > 0 and steam_peer.has_method("create_client"):
            steam_err = steam_peer.call("create_client", reconnect_steam_host_id, 0)
        elif reconnect_steam_lobby_id > 0 and steam_peer.has_method("connect_to_lobby"):
            steam_err = steam_peer.call("connect_to_lobby", reconnect_steam_lobby_id)
        elif reconnect_steam_lobby_id > 0:
            pending_steam_action = "join"
            pending_steam_lobby_id = reconnect_steam_lobby_id
            pending_steam_open_invite_dialog = false
            status_message = "Reconnecting through Steam..."
            _update_status_text()
            _steam_call_alias(["joinLobby", "join_lobby"], [reconnect_steam_lobby_id])
            _set_reconnect_overlay_visible(true)
            return

        if steam_err != OK:
            status_message = "Reconnect failed (%s)" % steam_err
            _update_status_text()
            _set_reconnect_overlay_visible(true)
            return

        multiplayer.multiplayer_peer = steam_peer
        peer_states.clear()
        active_session_transport = SESSION_TRANSPORT_STEAM
        active_steam_lobby_id = reconnect_steam_lobby_id
        active_steam_host_id = reconnect_steam_host_id
        status_message = "Reconnecting through Steam..."
        _update_status_text()
        _set_reconnect_overlay_visible(true)
        return

    var address: String = str(config.get("address", "127.0.0.1")).strip_edges()
    var port: int = int(config.get("port", DEFAULT_PORT))
    var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
    var err: Error = peer.create_client(address, port)
    if err != OK:
        status_message = "Reconnect failed (%s)" % err
        _update_status_text()
        _set_reconnect_overlay_visible(true)
        return

    multiplayer.multiplayer_peer = peer
    peer_states.clear()
    status_message = "Reconnecting to server"
    print("[lucid-blocks-coop] Reconnecting to %s:%s" % [address, port])
    _update_status_text()
    _set_reconnect_overlay_visible(true)


func _leave_reconnect_to_menu() -> void:
    leave_session()


func _set_reconnect_overlay_visible(visible: bool) -> void:
    if reconnect_overlay == null:
        return
    if visible:
        _close_pause_menu_if_open()
        if panel_visible:
            restore_capture_on_close = false
            toggle_panel(false)
        reconnect_restore_capture_on_close = MouseHandler.captured
        MouseHandler.release()
    elif reconnect_restore_capture_on_close and not panel_visible:
        MouseHandler.capture()
        reconnect_restore_capture_on_close = false
    reconnect_overlay.visible = visible
    if visible and reconnect_overlay_title != null:
        reconnect_overlay_title.text = "RECONNECTING"


func _set_quit_overlay_visible(visible: bool, subtitle: String = "Saving session state...") -> void:
    if quit_overlay == null:
        return
    if visible:
        _close_pause_menu_if_open()
        if panel_visible:
            restore_capture_on_close = false
            toggle_panel(false)
        MouseHandler.release()
        if quit_overlay_title != null:
            quit_overlay_title.text = "LEAVING SERVER"
        if quit_overlay_subtitle != null:
            quit_overlay_subtitle.text = subtitle
    quit_overlay.visible = visible


func _kick_client_to_main_menu() -> void:
    if (multiplayer.is_server() and _has_live_peer()) or not is_instance_valid(Ref.main):
        client_restore_in_progress = false
        client_menu_kick_pending = false
        return

    client_menu_kick_sequence += 1
    var kick_sequence: int = client_menu_kick_sequence
    _watch_client_menu_kick_timeout.call_deferred(kick_sequence)
    _close_pause_menu_if_open()

    var main_menu = Ref.main.get_node_or_null("%MainMenu")
    var game_menu = Ref.main.get_node_or_null("%GameMenu")
    var had_loaded_world: bool = is_instance_valid(Ref.world) and bool(Ref.world.load_enabled)

    if had_loaded_world:
        await Ref.trans.open()
    elif is_instance_valid(Ref.trans) and Ref.trans.visible:
        await Ref.trans.close()

    if had_loaded_world:
        await _quit_guest_world_without_waiting_for_chunks()

    if is_instance_valid(Ref.audio_manager):
        Ref.audio_manager.play_song(Ref.main.main_menu_music, 100)
    if main_menu != null:
        main_menu.open()
    if game_menu != null:
        game_menu.close()
    if is_instance_valid(Ref.player):
        Ref.player.consume_actions()
    if is_instance_valid(Ref.trans) and Ref.trans.visible:
        await Ref.trans.close()

    if main_menu != null:
        main_menu.activate()
        var play_button: Control = main_menu.get_node_or_null("%PlayButton") as Control
        if play_button != null:
            play_button.grab_focus()
    if is_instance_valid(Ref.player):
        Ref.player.consume_actions()
    _finish_leave_to_main_menu_state()


func _watch_client_menu_kick_timeout(kick_sequence: int) -> void:
    await get_tree().create_timer(CLIENT_MENU_KICK_TIMEOUT_SEC, true).timeout
    if kick_sequence != client_menu_kick_sequence:
        return
    if not client_menu_kick_pending and not local_quit_in_progress:
        return
    print("[lucid-blocks-coop] leave timed out; forcing main menu fallback")
    _force_client_main_menu_kick("leave timeout")


func _force_client_main_menu_kick(reason: String = "leave fallback") -> void:
    if not is_instance_valid(Ref.main):
        client_restore_in_progress = false
        client_menu_kick_pending = false
        local_quit_in_progress = false
        return

    print("[lucid-blocks-coop] forcing main menu after %s" % reason)
    var had_loaded_world: bool = is_instance_valid(Ref.world) and (bool(Ref.main.loaded) or bool(Ref.world.load_enabled) or (_object_has_property(Ref.world, "started_up") and bool(Ref.world.get("started_up"))))
    if not dedicated_server_enabled and multiplayer.multiplayer_peer != null:
        disconnect_session(false)

    if had_loaded_world:
        await _quit_guest_world_without_waiting_for_chunks()

    var main_menu = Ref.main.get_node_or_null("%MainMenu")
    var game_menu = Ref.main.get_node_or_null("%GameMenu")
    if main_menu != null:
        main_menu.open()
    if game_menu != null:
        game_menu.close()
    if is_instance_valid(Ref.trans) and Ref.trans.visible and Ref.trans.has_method("close"):
        Ref.trans.close()
    if is_instance_valid(Ref.audio_manager):
        Ref.audio_manager.play_song(Ref.main.main_menu_music, 100)
    if main_menu != null:
        main_menu.activate()
        var play_button: Control = main_menu.get_node_or_null("%PlayButton") as Control
        if play_button != null:
            play_button.grab_focus()
    if is_instance_valid(Ref.player):
        Ref.player.consume_actions()
    _finish_leave_to_main_menu_state()


func _quit_guest_world_without_waiting_for_chunks() -> void:
    if not is_instance_valid(Ref.main) or not is_instance_valid(Ref.world):
        return

    print("[lucid-blocks-coop] quitting guest world without waiting for chunk streaming")
    suppress_local_game_quit_session_shutdown = true
    Ref.main.game_quit.emit()
    suppress_local_game_quit_session_shutdown = false

    get_tree().paused = true
    if is_instance_valid(Ref.player):
        Ref.player.disabled = true
    if is_instance_valid(Ref.entity_spawner):
        Ref.entity_spawner.stop_spawning()
    if is_instance_valid(Ref.audio_manager):
        Ref.audio_manager.fade_out_sfx()

    Ref.world.simulate_enabled = false
    Ref.world.load_enabled = false
    Ref.world.debug_stall = false
    await get_tree().process_frame

    if is_instance_valid(Ref.preserve_node_manager):
        Ref.preserve_node_manager.exit_game.call_deferred()
    if is_instance_valid(Ref.boss_manager):
        Ref.boss_manager.exit_game.call_deferred()
    if is_instance_valid(Ref.sun):
        Ref.sun.exit_game()
    await get_tree().process_frame

    for node in get_tree().get_nodes_in_group("delete_on_quit"):
        if is_instance_valid(node):
            node.queue_free.call_deferred()
    await get_tree().process_frame

    Ref.world.clear()
    await get_tree().process_frame
    if is_instance_valid(Ref.main) and _object_has_property(Ref.main, "loaded"):
        Ref.main.set("loaded", false)


func _teleport_local_player_near(target_position: Vector3) -> void:
    if not _can_sample_player():
        return

    _teleport_local_player_exact(_resolve_safe_position_near_player(target_position))
    if _has_live_peer():
        _broadcast_local_state_now()


func _apply_peer_persistent_player_to_snapshot(snapshot_save_data: Dictionary, peer_id: int, target_dimension: int) -> void:
    if snapshot_save_data.is_empty():
        return

    var peer_state: Dictionary = peer_states.get(peer_id, {})
    var player_key: String = str(peer_state.get("player_key", "")).strip_edges()
    if player_key == "":
        return

    var guest_data: Dictionary = _get_guest_persistent_state(player_key)
    if guest_data.is_empty():
        return

    var global_player_data: Variant = SaveFile._get_data(guest_data, "node/player", null)
    if global_player_data is Dictionary:
        # Prevent a dimension snapshot from loading the host player's inventory onto the visiting client.
        SaveFile._set_data(snapshot_save_data, "node/player", (global_player_data as Dictionary).duplicate(true))

    var dimension_namespace: String = str(SaveFile.DIMENSION_MAP.get(target_dimension, ""))
    if dimension_namespace == "":
        return

    var dimensional_player_data: Variant = SaveFile._get_data(guest_data, "%s/node/player" % dimension_namespace, null)
    if dimensional_player_data is Dictionary:
        SaveFile._set_data(snapshot_save_data, "%s/node/player" % dimension_namespace, (dimensional_player_data as Dictionary).duplicate(true))


func _send_world_snapshot_to_peer(peer_id: int, target_dimension: int = -1, target_pocket_owner_key: String = "", follow_host_position: bool = false) -> void:
    if not _can_share_loaded_world():
        return

    _persist_current_owned_pocket_variants_if_needed()
    await _flush_dedicated_dirty_chunks_before_snapshot("world_snapshot")
    status_message = "Sending world to peer %s" % peer_id
    _update_status_text()

    # Do not force a full save here; it stalls join badly.
    # We snapshot the current loaded world/register state; dedicated dirty
    # chunks are flushed above so reconnects do not see stale save data.

    var register_data: Dictionary = Ref.save_file_manager.loaded_file_register.data.duplicate_deep()
    var actual_dimension: int = target_dimension if target_dimension >= 0 else int(Ref.world.current_dimension)
    register_data["dimension"] = actual_dimension
    register_data["pocket_owner_key"] = target_pocket_owner_key if _is_private_instance_dimension(actual_dimension) else ""

    var register_json: String = JSON.stringify(JSON.from_native(register_data))
    var snapshot_save_data: Dictionary = Ref.save_file_manager.loaded_file.data.duplicate_deep()
    _apply_peer_persistent_player_to_snapshot(snapshot_save_data, peer_id, actual_dimension)
    var save_json: String = JSON.stringify(JSON.from_native(snapshot_save_data))
    var save_buffer: PackedByteArray = save_json.to_utf8_buffer().compress(FileAccess.COMPRESSION_GZIP)
    var chunk_count: int = maxi(1, int(ceil(float(save_buffer.size()) / float(SNAPSHOT_CHUNK_SIZE))))

    var snapshot_follow_position: bool = follow_host_position
    var spawn_pos = Ref.player.global_position
    if dedicated_server_enabled and _should_force_dedicated_snapshot_spawn(peer_id, actual_dimension):
        snapshot_follow_position = true
        spawn_pos = await _resolve_dedicated_snapshot_spawn_position(actual_dimension, spawn_pos)

    begin_host_world_snapshot.rpc_id(peer_id, register_json, chunk_count, spawn_pos, snapshot_follow_position)
    for chunk_index in range(chunk_count):
        var start: int = chunk_index * SNAPSHOT_CHUNK_SIZE
        var end: int = mini(start + SNAPSHOT_CHUNK_SIZE, save_buffer.size())
        host_world_snapshot_chunk.rpc_id(peer_id, chunk_index, save_buffer.slice(start, end))
    finish_host_world_snapshot.rpc_id(peer_id)
    print("[lucid-blocks-coop] Sent host world snapshot to peer=%s chunks=%s compressed_bytes=%s" % [peer_id, chunk_count, save_buffer.size()])

    status_message = "Peer %s joined host world" % peer_id
    _update_status_text()


func _should_force_dedicated_snapshot_spawn(peer_id: int, dimension: int) -> bool:
    if not dedicated_server_enabled or not multiplayer.is_server():
        return false
    var peer_state: Dictionary = peer_states.get(peer_id, {})
    var player_key: String = str(peer_state.get("player_key", "")).strip_edges()
    if player_key == "":
        return true
    var saved_position: Variant = _get_guest_persistent_position_for_dimension(player_key, dimension)
    if not (saved_position is Vector3):
        return true
    return not _is_safe_respawn_position(saved_position)


func _resolve_dedicated_snapshot_spawn_position(dimension: int, fallback_position: Vector3) -> Vector3:
    if not dedicated_server_enabled or not _can_sample_player() or not is_instance_valid(Ref.world):
        return fallback_position

    var original_position: Vector3 = Ref.player.global_position
    var spawn_position: Vector3 = _resolve_default_respawn_fallback_position(fallback_position)
    if is_instance_valid(Ref.world.spawn_tester):
        var found_spawn: bool = await Ref.world.spawn_tester.find_spawn_position(Vector3.ZERO, dimension, 1.0)
        if found_spawn and is_instance_valid(Ref.player):
            spawn_position = Ref.player.global_position
        elif is_instance_valid(Ref.player):
            Ref.player.global_position = original_position

    if not _is_safe_respawn_position(spawn_position):
        spawn_position = _find_safe_respawn_position_near(spawn_position, fallback_position)
    print("[lucid-blocks-coop] Dedicated snapshot spawn position=%s dimension=%s" % [spawn_position, dimension])
    return spawn_position


func _apply_received_host_world() -> void:
    if incoming_snapshot_register_json == "":
        receiving_host_world = false
        return
    print("[lucid-blocks-coop] Applying host world snapshot chunks=%s/%s" % [incoming_snapshot_chunks.size(), incoming_snapshot_chunk_count])

    for chunk_index in range(incoming_snapshot_chunk_count):
        if not incoming_snapshot_chunks.has(chunk_index):
            _handle_host_world_snapshot_failure("Missing world chunk %s" % chunk_index)
            return

    var compressed_buffer: PackedByteArray = PackedByteArray()
    for chunk_index in range(incoming_snapshot_chunk_count):
        compressed_buffer.append_array(incoming_snapshot_chunks[chunk_index])

    if compressed_buffer.size() > CLIENT_SAFE_MAX_SNAPSHOT_COMPRESSED_BYTES:
        _handle_host_world_snapshot_failure("Host world snapshot is too large")
        return

    var decompressed: PackedByteArray = compressed_buffer.decompress_dynamic(CLIENT_SAFE_MAX_SNAPSHOT_DECOMPRESSED_BYTES, FileAccess.COMPRESSION_GZIP)
    if decompressed.is_empty():
        _handle_host_world_snapshot_failure("Host world snapshot could not be decompressed")
        return
    var save_json: String = decompressed.get_string_from_utf8()
    print("[lucid-blocks-coop] Host world snapshot decompressed bytes=%s" % save_json.length())
    var register_parse: Variant = JSON.parse_string(incoming_snapshot_register_json)
    var save_parse: Variant = JSON.parse_string(save_json)
    if not (register_parse is Dictionary) or not (save_parse is Dictionary):
        _handle_host_world_snapshot_failure("Failed to parse host world")
        return

    var native_register: Variant = _sanitize_network_save_data(JSON.to_native(register_parse))
    var native_save: Variant = _sanitize_network_save_data(JSON.to_native(save_parse))
    if not (native_register is Dictionary) or not (native_save is Dictionary):
        _handle_host_world_snapshot_failure("Host world snapshot failed safety checks")
        return

    await _load_host_world_snapshot(native_register, native_save, incoming_snapshot_host_position)


func _handle_host_world_snapshot_failure(reason: String) -> void:
    receiving_host_world = false
    client_restore_in_progress = false
    status_message = reason
    _update_status_text()
    if not multiplayer.is_server() and _has_live_peer() and not local_quit_in_progress:
        _begin_reconnect_flow(reason)


func _load_host_world_snapshot(register_data: Dictionary, save_data: Dictionary, host_position: Vector3) -> void:
    receiving_host_world = true
    client_restore_in_progress = true
    local_fake_death_pending = false
    local_fake_death_save_override.clear()
    local_fake_death_respawn_target_valid = false
    clear_fake_death_override_after_shutdown = false
    host_respawning = false
    remote_host_respawning = false
    status_message = "Loading host world"
    print("[lucid-blocks-coop] Loading host world title='%s' dimension=%s" % [
        str(register_data.get("title", "")),
        str(register_data.get("dimension", "")),
    ])
    _update_status_text()

    await Ref.trans.open()

    if Ref.world.load_enabled:
        suppress_local_game_quit_session_shutdown = true
        await Ref.main.quit_game(false, false)
        suppress_local_game_quit_session_shutdown = false

    var register: SaveFileRegister = SaveFileRegister.new()
    register.is_dimensional = false
    register.data = register_data.duplicate_deep()
    if not multiplayer.is_server():
        register.set_data(SERVER_WORLD_ONLY_KEY, true, true)
        register.set_data("deleted", true, true)
        register.set_data("coop_server_note", "Client cache for a server world. Join through Co-op.", true)

    var save_file: SaveFile = SaveFile.new()
    save_file.data = save_data.duplicate_deep()

    Ref.save_file_manager.loaded_file_register = register
    Ref.save_file_manager.loaded_file = save_file
    Ref.audio_manager.stop_song(Ref.main.main_menu_music)
    Ref.save_file_manager.load_file(register, false)

    await Ref.main.enter_game()
    print("[lucid-blocks-coop] Host world enter_game finished")
    client_world_sync_ready = false
    guest_persistent_ready = false
    _install_player_death_hook()
    _prepare_client_world_sync()
    if is_instance_valid(Ref.player):
        Ref.player.disabled = true
    if incoming_snapshot_follow_host_position:
        _teleport_local_player_near(host_position)
    if not multiplayer.is_server() and _has_live_peer():
        status_message = "Restoring character"
        _update_status_text()
        request_guest_persistent_state.rpc_id(1, _get_local_player_key(), _get_local_player_name())
        _watch_guest_character_restore_timeout.call_deferred()

    receiving_host_world = false
    print("[lucid-blocks-coop] Host world ready, requesting persistent character")


func _install_player_death_hook() -> void:
    if not is_instance_valid(Ref.player) or not is_instance_valid(Ref.main):
        coop_player_death_hooked = false
        coop_player_death_hooked_instance_id = 0
        return

    var coop_handler := Callable(self, "_on_player_died_for_coop")
    if coop_player_death_hooked and coop_player_death_hooked_instance_id == Ref.player.get_instance_id() and Ref.player.died.is_connected(coop_handler):
        return

    var original_handler := Callable(Ref.main, "_on_player_death")
    if Ref.player.died.is_connected(original_handler):
        Ref.player.died.disconnect(original_handler)
    if not Ref.player.died.is_connected(coop_handler):
        Ref.player.died.connect(coop_handler)
    coop_player_death_hooked = true
    coop_player_death_hooked_instance_id = Ref.player.get_instance_id()


func _on_player_died_for_coop() -> void:
    if not _has_live_peer():
        if is_instance_valid(Ref.world) and Ref.world.load_enabled and not Ref.world.is_all_loaded():
            _set_single_player_shutdown_world_pause_override(true)
        if is_instance_valid(Ref.main):
            Ref.main.player_death.call_deferred()
        return

    _enter_local_downed_state()


func _set_single_player_shutdown_world_pause_override(enabled: bool) -> void:
    if not is_instance_valid(Ref.world):
        single_player_shutdown_world_pause_override = false
        single_player_shutdown_world_original_process_mode = -1
        return

    if enabled:
        if single_player_shutdown_world_pause_override:
            return
        single_player_shutdown_world_pause_override = true
        single_player_shutdown_world_original_process_mode = int(Ref.world.process_mode)
        Ref.world.process_mode = Node.PROCESS_MODE_ALWAYS
        return

    if not single_player_shutdown_world_pause_override:
        return

    single_player_shutdown_world_pause_override = false
    if single_player_shutdown_world_original_process_mode >= 0:
        Ref.world.process_mode = single_player_shutdown_world_original_process_mode
    single_player_shutdown_world_original_process_mode = -1
    if Ref.world.has_method("refresh_multiplayer_runtime_mode"):
        Ref.world.refresh_multiplayer_runtime_mode()


func _restore_original_death_handler() -> void:
    if not coop_player_death_hooked:
        return
    if not is_instance_valid(Ref.player) or not is_instance_valid(Ref.main):
        coop_player_death_hooked = false
        coop_player_death_hooked_instance_id = 0
        return

    var coop_handler := Callable(self, "_on_player_died_for_coop")
    var original_handler := Callable(Ref.main, "_on_player_death")

    if Ref.player.died.is_connected(coop_handler):
        Ref.player.died.disconnect(coop_handler)
    if not Ref.player.died.is_connected(original_handler):
        Ref.player.died.connect(original_handler)
    coop_player_death_hooked = false
    coop_player_death_hooked_instance_id = 0


func _handle_host_player_death() -> void:
    if not local_fake_death_pending and not handling_host_respawn:
        return
    if handling_host_respawn or not _can_sample_player():
        return
    if not _has_live_peer():
        local_fake_death_pending = false
        _stabilize_local_player_after_fake_death()
        return

    handling_host_respawn = true
    host_respawn_sequence += 1
    var respawn_sequence: int = host_respawn_sequence
    if _has_live_peer():
        sync_host_respawn_state.rpc(true)
    host_respawning = true

    Steamworks.increment_statistic("death_count")
    Steamworks.set_achievement("DEATH")
    _stop_local_player_actions()
    if panel_visible:
        toggle_panel(false)

    Ref.player.disabled = true
    _stabilize_local_player_after_fake_death(false)
    var remote_anchor: Vector3 = _get_remote_respawn_anchor(false, Ref.player.global_position)
    var has_remote_anchor: bool = _has_remote_respawn_anchor(false)
    _set_death_overlay_visible(true, "Respawning near partner..." if has_remote_anchor else "Respawning at spawn point...")
    _broadcast_local_state_now()

    var respawn_position: Vector3 = await _resolve_respawn_position()
    if respawn_sequence != host_respawn_sequence or not handling_host_respawn or not host_respawning or local_quit_in_progress or not _can_sample_player():
        if respawn_sequence == host_respawn_sequence:
            local_fake_death_pending = false
            handling_host_respawn = false
            host_respawning = false
            _set_death_overlay_visible(false)
        return
    if _has_remote_respawn_anchor(false):
        remote_anchor = _get_remote_respawn_anchor(false, remote_anchor)
        respawn_position = _find_safe_respawn_position_near(remote_anchor, respawn_position)
    local_fake_death_respawn_target = respawn_position
    local_fake_death_respawn_target_valid = true
    await get_tree().create_timer(1.35, false).timeout

    if respawn_sequence != host_respawn_sequence or not handling_host_respawn or not host_respawning or local_quit_in_progress or not _can_sample_player():
        if respawn_sequence == host_respawn_sequence:
            local_fake_death_pending = false
            handling_host_respawn = false
            host_respawning = false
            _set_death_overlay_visible(false)
        return

    Ref.player.revive()
    Ref.player.dead = false
    Ref.player.disabled = false
    Ref.player.make_invincible_temporary()
    _teleport_local_player_exact(respawn_position)
    Ref.player.consume_actions()
    _set_death_overlay_visible(false)

    status_message = "Respawned"
    _update_status_text()
    local_fake_death_pending = false
    local_fake_death_save_override.clear()
    host_respawning = false
    if _has_live_peer():
        sync_host_respawn_state.rpc(false)
    _broadcast_local_state_now()
    handling_host_respawn = false


func _resync_host_world_to_clients() -> void:
    if not multiplayer.is_server() or not _has_live_peer():
        return

    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == 1:
            continue
        _send_world_snapshot_to_peer.call_deferred(int_peer_id)


func _handle_client_player_death() -> void:
    if not local_fake_death_pending and not handling_client_respawn:
        return
    if handling_client_respawn or not _can_sample_player():
        return
    if not _has_live_peer():
        local_fake_death_pending = false
        _stabilize_local_player_after_fake_death()
        return

    handling_client_respawn = true
    _broadcast_local_state_now()
    _stop_local_player_actions()
    Ref.player.dead = false
    Ref.player.disabled = false
    Ref.player.revive()
    Ref.player.make_invincible_temporary()

    var fallback_respawn_position: Vector3 = _resolve_default_respawn_fallback_position(Ref.player.global_position + Vector3(1.5, 0.0, 0.0))
    var has_host_anchor: bool = _has_remote_respawn_anchor(true)
    var respawn_anchor: Vector3 = _get_remote_respawn_anchor(true, fallback_respawn_position)
    var respawn_position: Vector3 = _find_safe_respawn_position_near(respawn_anchor, fallback_respawn_position)
    local_fake_death_respawn_target = respawn_position
    local_fake_death_respawn_target_valid = true
    _teleport_local_player_exact(respawn_position)
    if _has_live_peer():
        _send_persistent_state_to_host()
    status_message = "You died and respawned near host" if has_host_anchor else "You died and respawned at spawn"
    _update_status_text()
    local_fake_death_pending = false
    local_fake_death_save_override.clear()
    handling_client_respawn = false
    _broadcast_local_state_now()


func _prepare_client_world_sync() -> void:
    if multiplayer.is_server() or not is_instance_valid(Ref.main) or not Ref.main.loaded:
        return
    if client_world_sync_ready:
        return

    if is_instance_valid(Ref.entity_spawner):
        if _has_local_entity_authority():
            Ref.entity_spawner.start_spawning()
        else:
            Ref.entity_spawner.stop_spawning()

    if _has_local_entity_authority():
        synced_entities.clear()
        synced_dropped_items.clear()
        _clear_client_entity_dummies()
        client_world_sync_ready = true
        return

    if ENABLE_ENTITY_SYNC:
        _adopt_existing_client_world_entities_and_drops()
    else:
        _clear_client_world_entities_and_drops()
    client_world_sync_ready = true


func _clear_client_world_entities_and_drops() -> void:
    synced_entities.clear()
    synced_dropped_items.clear()
    client_collected_drop_uuids.clear()
    entity_interp_map.clear()
    _clear_client_entity_dummies()
    host_entity_last_sent.clear()
    host_entity_snapshot_last_sent.clear()
    host_entity_snapshot_last_state.clear()
    host_drop_snapshot_last_sent.clear()
    host_drop_snapshot_last_state.clear()
    client_server_time_initialized = false
    client_last_world_state_sequence = -1

    for child in _get_live_tracked_entities():
        if bool(child.get_meta("coop_synced_entity", false)) or bool(child.get_meta("coop_candidate_existing", false)):
            _queue_runtime_node_for_cleanup(child)
    for child in _get_live_tracked_drops():
        if bool(child.get_meta("coop_synced_drop", false)) or bool(child.get_meta("coop_predicted_drop", false)):
            _queue_runtime_node_for_cleanup(child)


func _clear_local_guest_authoritative_runtime() -> void:
    if multiplayer.is_server():
        return

    for child in _get_live_tracked_entities():
        if not _is_syncable_entity_node(child):
            continue
        if bool(child.get_meta("coop_synced_entity", false)):
            continue
        child.remove_meta("coop_guest_local_authority")
        _prepare_existing_client_entity(child)

    for child in _get_live_tracked_drops():
        if bool(child.get_meta("coop_synced_drop", false)):
            continue
        _queue_runtime_node_for_cleanup(child)


func _prepare_runtime_node_for_cleanup(node: Node) -> void:
    if node == null or not is_instance_valid(node):
        return

    if node is Timer:
        (node as Timer).stop()
    if node is GPUParticles3D:
        (node as GPUParticles3D).emitting = false
    elif node is GPUParticles2D:
        (node as GPUParticles2D).emitting = false
    elif node is AudioStreamPlayer3D:
        (node as AudioStreamPlayer3D).stop()
    elif node is AudioStreamPlayer:
        (node as AudioStreamPlayer).stop()
    elif node is VisibleOnScreenEnabler3D:
        (node as VisibleOnScreenEnabler3D).enable_node_path = ""

    if node.has_method("set_process"):
        node.set_process(false)
    if node.has_method("set_physics_process"):
        node.set_physics_process(false)
    if node.has_method("set_process_input"):
        node.set_process_input(false)
    if node.has_method("set_process_unhandled_input"):
        node.set_process_unhandled_input(false)

    if node is CollisionObject3D:
        var collision_object := node as CollisionObject3D
        collision_object.collision_layer = 0
        collision_object.collision_mask = 0
    if node is Area3D:
        var area := node as Area3D
        area.monitoring = false
        area.monitorable = false
    elif node is RayCast3D:
        var ray := node as RayCast3D
        ray.enabled = false
        ray.collision_mask = 0
    elif node is CollisionShape3D and _object_has_property(node, "disabled"):
        node.set_deferred("disabled", true)
    elif node is CollisionPolygon3D and _object_has_property(node, "disabled"):
        node.set_deferred("disabled", true)

    for child in node.get_children():
        if child is Node:
            _prepare_runtime_node_for_cleanup(child)


func _queue_runtime_node_for_cleanup(node: Node) -> void:
    if node == null or not is_instance_valid(node):
        return

    _prepare_runtime_node_for_cleanup(node)
    if node.is_inside_tree():
        node.call_deferred("queue_free")
    else:
        node.queue_free()


func _promote_host_synced_entities_to_local_authority() -> void:
    if multiplayer.is_server():
        return

    var bundles: Array = []
    for child in _get_live_tracked_entities():
        if not _is_syncable_entity_node(child):
            continue
        if not bool(child.get_meta("coop_synced_entity", false)):
            continue

        var uuid: String = _assign_sync_uuid(child)
        var bundle: Dictionary = _capture_entity_save_bundle(child, uuid)
        if not bundle.is_empty():
            bundles.append(bundle)

        var parent: Node = child.get_parent()
        if parent != null:
            parent.remove_child(child)
        child.queue_free()

    for dropped_item in _get_live_tracked_drops():
        if bool(dropped_item.get_meta("coop_synced_drop", false)):
            dropped_item.call_deferred("queue_free")

    synced_entities.clear()
    synced_dropped_items.clear()
    entity_interp_map.clear()
    _clear_client_entity_dummies()

    for bundle in bundles:
        _materialize_entity_from_save_bundle(bundle, true)


func _adopt_existing_client_world_entities_and_drops() -> void:
    synced_entities.clear()
    synced_dropped_items.clear()
    _clear_client_entity_dummies()
    client_last_world_state_sequence = -1

    for child in _get_live_tracked_entities():
        if child is Player:
            continue
        if child is Entity:
            var entity_uuid: String = _get_sync_uuid(child)
            if entity_uuid != "":
                synced_entities[entity_uuid] = child
                _configure_client_synced_entity(child, entity_uuid)
            else:
                _prepare_existing_client_entity(child)
    for child in _get_live_tracked_drops():
        if child is Player:
            continue
        if child is DroppedItem:
            var drop_uuid: String = _get_sync_uuid(child)
            if drop_uuid == "":
                continue
            synced_dropped_items[drop_uuid] = child
            _configure_client_synced_drop(child, drop_uuid)


func _prepare_existing_client_entity(entity) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    entity.set_meta("coop_candidate_existing", true)
    entity.set_meta("coop_client_entity_created_msec", Time.get_ticks_msec())
    _disable_client_entity_runtime(entity)
    if entity is Entity:
        entity.disabled = false
        entity.disabled_by_visibility = false
        entity.invincible = true
        entity.invincible_temporary = true
        var visible_enabler: VisibleOnScreenEnabler3D = entity.get_node_or_null("%VisibleOnScreenEnabler3D") as VisibleOnScreenEnabler3D
        if visible_enabler != null:
            visible_enabler.enable_node_path = ""


func _remember_host_recent_drop_visibility(drop_uuid: String, dimension_instance_key: String, source_peer_id: int = 0, force_same_instance_peers: bool = false) -> void:
    if drop_uuid == "" or not multiplayer.is_server():
        return
    var instance_key: String = dimension_instance_key.strip_edges()
    if instance_key == "":
        instance_key = get_active_dimension_instance_key()
    host_recent_drop_visibility[drop_uuid] = {
        "dimension_instance_key": instance_key,
        "source_peer_id": source_peer_id,
        "force_same_instance_peers": force_same_instance_peers,
        "expires_at_msec": Time.get_ticks_msec() + int(SERVER_RECENT_DROP_VISIBILITY_SEC * 1000.0),
    }


func _cleanup_host_recent_drop_visibility() -> void:
    if host_recent_drop_visibility.is_empty():
        return
    var now_msec: int = Time.get_ticks_msec()
    for uuid in host_recent_drop_visibility.keys():
        var record: Dictionary = host_recent_drop_visibility.get(uuid, {})
        if record.is_empty() or int(record.get("expires_at_msec", 0)) <= now_msec:
            host_recent_drop_visibility.erase(uuid)


func _is_host_recent_drop_visible_to_peer(drop_uuid: String, peer_id: int, active_instance_key: String) -> bool:
    if drop_uuid == "" or peer_id <= 0 or host_recent_drop_visibility.is_empty():
        return false
    var record: Dictionary = host_recent_drop_visibility.get(drop_uuid, {})
    if record.is_empty():
        return false
    if int(record.get("expires_at_msec", 0)) <= Time.get_ticks_msec():
        host_recent_drop_visibility.erase(drop_uuid)
        return false
    var record_instance_key: String = str(record.get("dimension_instance_key", ""))
    if record_instance_key != "" and record_instance_key != active_instance_key:
        return false
    if int(record.get("source_peer_id", 0)) == peer_id:
        return true
    if bool(record.get("force_same_instance_peers", false)):
        var peer_state: Dictionary = peer_states.get(peer_id, {})
        if peer_state.is_empty() and peer_states.has(str(peer_id)):
            peer_state = peer_states[str(peer_id)]
        return _is_peer_state_same_instance(peer_state, active_instance_key)
    return false


func _host_drop_snapshot_key(peer_id: int, uuid: String) -> String:
    return "%s:%s" % [peer_id, uuid]


func _get_host_drop_snapshot_interval(distance_squared: float) -> float:
    if distance_squared <= 24.0 * 24.0:
        return 0.08
    if distance_squared <= 64.0 * 64.0:
        return 0.18
    return 0.35


func _build_host_drop_snapshot_state(dropped_item: DroppedItem) -> Dictionary:
    return {
        "position": dropped_item.global_position,
        "velocity": dropped_item.velocity,
        "item": _item_state_signature(dropped_item.item),
        "can_collect": bool(dropped_item.can_collect),
        "state": int(dropped_item.state),
    }


func _is_host_drop_snapshot_state_changed(previous_state: Dictionary, next_state: Dictionary) -> bool:
    if previous_state.is_empty():
        return true
    if str(previous_state.get("item", "")) != str(next_state.get("item", "")):
        return true
    if bool(previous_state.get("can_collect", true)) != bool(next_state.get("can_collect", true)):
        return true
    if int(previous_state.get("state", -1)) != int(next_state.get("state", -1)):
        return true
    var previous_position: Vector3 = previous_state.get("position", Vector3.ZERO)
    var next_position: Vector3 = next_state.get("position", Vector3.ZERO)
    if previous_position.distance_squared_to(next_position) > DROP_DR_POS_ERR_SQ:
        return true
    var previous_velocity: Vector3 = previous_state.get("velocity", Vector3.ZERO)
    var next_velocity: Vector3 = next_state.get("velocity", Vector3.ZERO)
    return previous_velocity.distance_squared_to(next_velocity) > DROP_DR_VEL_ERR_SQ


func _should_send_host_drop_snapshot(peer_id: int, uuid: String, distance_squared: float, snapshot_state: Dictionary, force_send: bool = false) -> bool:
    if peer_id <= 0 or uuid == "":
        return true
    var snapshot_key: String = _host_drop_snapshot_key(peer_id, uuid)
    var last_sent_time: float = float(host_drop_snapshot_last_sent.get(snapshot_key, -1000.0))
    var elapsed: float = host_server_time - last_sent_time
    if force_send or elapsed >= DROP_WORLD_STATE_MAX_INTERVAL_SEC:
        host_drop_snapshot_last_sent[snapshot_key] = host_server_time
        host_drop_snapshot_last_state[snapshot_key] = snapshot_state.duplicate(true)
        return true

    var previous_state: Dictionary = host_drop_snapshot_last_state.get(snapshot_key, {})
    if previous_state.is_empty():
        host_drop_snapshot_last_sent[snapshot_key] = host_server_time
        host_drop_snapshot_last_state[snapshot_key] = snapshot_state.duplicate(true)
        return true

    if elapsed < _get_host_drop_snapshot_interval(distance_squared):
        return false
    if not _is_host_drop_snapshot_state_changed(previous_state, snapshot_state):
        return false

    host_drop_snapshot_last_sent[snapshot_key] = host_server_time
    host_drop_snapshot_last_state[snapshot_key] = snapshot_state.duplicate(true)
    return true


func _capture_host_drop_snapshots(focus_position: Vector3, peer_id: int = 0) -> Array:
    var snapshots: Array = []
    if not _can_share_loaded_world():
        return snapshots
    host_server_time = float(Time.get_ticks_msec()) / 1000.0
    _cleanup_host_recent_drop_visibility()
    var active_instance_key: String = get_active_dimension_instance_key()

    for child in _get_live_tracked_drops():
        if not (child is DroppedItem):
            continue

        var dropped_item := child as DroppedItem
        if not is_instance_valid(dropped_item) or dropped_item.item == null:
            continue

        var uuid: String = _get_sync_uuid(dropped_item)
        if uuid == "":
            uuid = _assign_sync_uuid(dropped_item)
        if uuid == "":
            continue

        var distance_squared: float = dropped_item.global_position.distance_squared_to(focus_position)
        var within_interest: bool = distance_squared <= DROP_SYNC_RADIUS * DROP_SYNC_RADIUS
        var recent_visible: bool = _is_host_recent_drop_visible_to_peer(uuid, peer_id, active_instance_key)
        if not within_interest and not recent_visible:
            continue
        var snapshot_state: Dictionary = _build_host_drop_snapshot_state(dropped_item)
        if not _should_send_host_drop_snapshot(peer_id, uuid, distance_squared, snapshot_state, recent_visible):
            continue

        snapshots.append([
            uuid,
            dropped_item.global_position,
            dropped_item.velocity,
            _serialize_item_state(dropped_item.item),
            bool(dropped_item.can_collect),
        ])

    return snapshots


func _host_entity_visual_key(peer_id: int, uuid: String) -> String:
    return "%s:%s" % [peer_id, uuid]


func _host_entity_snapshot_key(peer_id: int, uuid: String) -> String:
    return "%s:%s" % [peer_id, uuid]


func _clear_host_interest_cache_for_peer(peer_id: int) -> void:
    var prefix: String = "%s:" % peer_id
    for key in host_entity_last_sent.keys():
        if str(key).begins_with(prefix):
            host_entity_last_sent.erase(key)
    for key in host_entity_snapshot_last_sent.keys():
        if str(key).begins_with(prefix):
            host_entity_snapshot_last_sent.erase(key)
    for key in host_entity_snapshot_last_state.keys():
        if str(key).begins_with(prefix):
            host_entity_snapshot_last_state.erase(key)
    for key in host_drop_snapshot_last_sent.keys():
        if str(key).begins_with(prefix):
            host_drop_snapshot_last_sent.erase(key)
    for key in host_drop_snapshot_last_state.keys():
        if str(key).begins_with(prefix):
            host_drop_snapshot_last_state.erase(key)


func _is_peer_interested_in_position(peer_id: int, world_position: Vector3, radius: float, active_instance_key: String = "") -> bool:
    var state: Dictionary = peer_states.get(peer_id, {})
    if state.is_empty() and peer_states.has(str(peer_id)):
        state = peer_states[str(peer_id)]
    if state.is_empty() or not bool(state.get("active", false)):
        return false
    var instance_key: String = active_instance_key if active_instance_key != "" else get_active_dimension_instance_key()
    if not _is_peer_state_same_instance(state, instance_key):
        return false
    var peer_position: Vector3 = state.get("position", world_position)
    return peer_position.distance_squared_to(world_position) <= radius * radius


func _sync_spawn_drop_to_interested_peers(drop_uuid: String, item_data: PackedInt32Array, drop_position: Vector3, drop_velocity: Vector3, can_collect: bool, source_peer_id: int = 0, source_instance_key: String = "", force_same_instance_peers: bool = false) -> int:
    if not multiplayer.is_server() or not _has_live_peer():
        return 0
    var sent_count: int = 0
    var active_instance_key: String = source_instance_key.strip_edges()
    if active_instance_key == "":
        active_instance_key = get_active_dimension_instance_key()
    _remember_host_recent_drop_visibility(drop_uuid, active_instance_key, source_peer_id, force_same_instance_peers)
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == multiplayer.get_unique_id():
            continue
        var peer_state: Dictionary = peer_states.get(peer_id, {})
        if peer_state.is_empty() and peer_states.has(int_peer_id):
            peer_state = peer_states[int_peer_id]
        var should_send: bool = int_peer_id == source_peer_id
        if not should_send and force_same_instance_peers:
            should_send = _is_peer_state_same_instance(peer_state, active_instance_key)
        if not should_send:
            should_send = _is_peer_interested_in_position(int_peer_id, drop_position, DROP_SYNC_RADIUS, active_instance_key)
        if not should_send:
            continue
        sync_spawn_drop.rpc_id(int_peer_id, drop_uuid, item_data, drop_position, drop_velocity, can_collect)
        host_interest_spawn_drop_sends += 1
        sent_count += 1
    if source_peer_id > 1 and sent_count == 0:
        sync_spawn_drop.rpc_id(source_peer_id, drop_uuid, item_data, drop_position, drop_velocity, can_collect)
        host_interest_spawn_drop_sends += 1
        sent_count += 1
    return sent_count


func _get_host_entity_snapshot_interval(distance_squared: float) -> float:
    if distance_squared <= CLIENT_SYNCED_ENTITY_VISUAL_NEAR_RADIUS * CLIENT_SYNCED_ENTITY_VISUAL_NEAR_RADIUS:
        return 0.05
    if distance_squared <= CLIENT_SYNCED_ENTITY_VISUAL_MID_RADIUS * CLIENT_SYNCED_ENTITY_VISUAL_MID_RADIUS:
        return 0.12
    return 0.35


func _host_entity_yaw_delta_abs(previous_yaw: float, next_yaw: float) -> float:
    return absf(wrapf(next_yaw - previous_yaw + PI, 0.0, TAU) - PI)


func _build_host_entity_snapshot_state(entity, entity_position: Vector3, entity_yaw: float, movement_velocity: Vector3, gravity_velocity: Vector3, knockback_velocity: Vector3, rope_velocity: Vector3, dead: bool, disabled: bool, held_item_id: int, held_item_index: int) -> Dictionary:
    return {
        "position": entity_position,
        "yaw": entity_yaw,
        "movement_velocity": movement_velocity,
        "gravity_velocity": gravity_velocity,
        "knockback_velocity": knockback_velocity,
        "rope_velocity": rope_velocity,
        "dead": dead,
        "disabled": disabled,
        "held_item_id": held_item_id,
        "held_item_index": held_item_index,
        "scene": _get_sync_scene_path(entity),
    }


func _is_host_entity_snapshot_state_changed(previous_state: Dictionary, next_state: Dictionary) -> bool:
    if previous_state.is_empty():
        return true
    if str(previous_state.get("scene", "")) != str(next_state.get("scene", "")):
        return true
    if bool(previous_state.get("dead", false)) != bool(next_state.get("dead", false)):
        return true
    if bool(previous_state.get("disabled", false)) != bool(next_state.get("disabled", false)):
        return true
    if int(previous_state.get("held_item_id", -1)) != int(next_state.get("held_item_id", -1)):
        return true
    if int(previous_state.get("held_item_index", 0)) != int(next_state.get("held_item_index", 0)):
        return true

    var previous_position: Vector3 = previous_state.get("position", Vector3.ZERO)
    var next_position: Vector3 = next_state.get("position", Vector3.ZERO)
    if previous_position.distance_squared_to(next_position) > ENTITY_DR_POS_ERR_SQ:
        return true

    var previous_yaw: float = float(previous_state.get("yaw", 0.0))
    var next_yaw: float = float(next_state.get("yaw", 0.0))
    if _host_entity_yaw_delta_abs(previous_yaw, next_yaw) > deg_to_rad(ENTITY_DR_YAW_ERR_DEG):
        return true

    for velocity_key in ["movement_velocity", "gravity_velocity", "knockback_velocity", "rope_velocity"]:
        var previous_velocity: Vector3 = previous_state.get(velocity_key, Vector3.ZERO)
        var next_velocity: Vector3 = next_state.get(velocity_key, Vector3.ZERO)
        if previous_velocity.distance_squared_to(next_velocity) > ENTITY_DR_KB_ERR_SQ:
            return true

    return false


func _should_send_host_entity_snapshot(peer_id: int, uuid: String, distance_squared: float, snapshot_state: Dictionary, force_send: bool = false) -> bool:
    if peer_id <= 0 or uuid == "":
        return true

    var snapshot_key: String = _host_entity_snapshot_key(peer_id, uuid)
    var last_sent_time: float = float(host_entity_snapshot_last_sent.get(snapshot_key, -1000.0))
    var elapsed: float = host_server_time - last_sent_time
    if force_send or elapsed >= ENTITY_WORLD_STATE_MAX_INTERVAL_SEC:
        host_entity_snapshot_last_sent[snapshot_key] = host_server_time
        host_entity_snapshot_last_state[snapshot_key] = snapshot_state.duplicate(true)
        return true

    var previous_state: Dictionary = host_entity_snapshot_last_state.get(snapshot_key, {})
    if previous_state.is_empty():
        host_entity_snapshot_last_sent[snapshot_key] = host_server_time
        host_entity_snapshot_last_state[snapshot_key] = snapshot_state.duplicate(true)
        return true

    if elapsed < _get_host_entity_snapshot_interval(distance_squared):
        return false

    if not _is_host_entity_snapshot_state_changed(previous_state, snapshot_state):
        return false

    host_entity_snapshot_last_sent[snapshot_key] = host_server_time
    host_entity_snapshot_last_state[snapshot_key] = snapshot_state.duplicate(true)
    return true


func _capture_host_entity_snapshots(focus_position: Vector3, peer_id: int = 0) -> Array:
    var snapshots: Array = []
    if not ENABLE_ENTITY_SYNC or not _can_share_loaded_world():
        return snapshots

    host_server_time = float(Time.get_ticks_msec()) / 1000.0
    var view_radius: float = get_server_entity_view_radius()
    var view_radius_sq: float = view_radius * view_radius
    for child in _get_live_tracked_entities():
        if not _is_syncable_entity_node(child):
            continue

        var entity = child as Entity
        if not is_instance_valid(entity) or not entity.is_inside_tree():
            continue
        var distance_squared: float = entity.global_position.distance_squared_to(focus_position)
        if distance_squared > view_radius_sq:
            continue

        var scene_path: String = _get_sync_scene_path(entity)
        if scene_path == "":
            continue

        var uuid: String = _get_sync_uuid(entity)
        if uuid == "":
            uuid = _assign_sync_uuid(entity)
        if uuid == "":
            continue

        var held_item_index: int = int(entity.held_item_index) if _object_has_property(entity, "held_item_index") else 0
        var held_item_id: int = -1
        if _object_has_property(entity, "held_item_inventory"):
            var inventory = entity.get("held_item_inventory")
            if inventory != null and _object_has_property(inventory, "items") and held_item_index >= 0 and held_item_index < inventory.items.size():
                var held_item_state = inventory.items[held_item_index]
                held_item_id = int(held_item_state.id) if held_item_state != null else -1

        var special_state: Dictionary = {}
        var visual_key: String = _host_entity_visual_key(peer_id, uuid)
        var last_visual_state_sent: float = float(host_entity_last_sent.get(visual_key, -1000.0))
        var force_procedural_visual_sync: bool = _is_segmented_worm_entity(entity)
        var should_capture_visual_state: bool = force_procedural_visual_sync or (host_server_time - last_visual_state_sent) >= ENTITY_VISUAL_STATE_INTERVAL
        if should_capture_visual_state:
            var horizontal_speed: float = Vector3(entity.velocity.x, 0.0, entity.velocity.z).length()
            var base_speed: float = _resolve_object_float_property(entity, ["speed"], 1.0)
            var speed_modifier: float = _resolve_object_float_property(entity, ["speed_modifier"], 1.0)
            var walk_value: float = clampf(horizontal_speed / maxf(base_speed * speed_modifier, 0.001), 0.0, 1.0)
            special_state = {
                "under_water": bool(entity.under_water),
                "walk_val": walk_value,
                "compact_anim": _capture_compact_animation_state(entity),
                "head_look": _capture_entity_model_head_look_state(entity),
                "procedural_visual": _capture_entity_procedural_visual_state(entity),
            }
            if (host_server_time - last_visual_state_sent) >= ENTITY_VISUAL_STATE_INTERVAL:
                host_entity_last_sent[visual_key] = host_server_time
                _maybe_broadcast_host_entity_projectile_visual(entity, special_state)

        var movement_velocity: Vector3 = entity.movement_velocity if entity is Entity else _get_entity_total_velocity(entity)
        var gravity_velocity: Vector3 = entity.gravity_velocity if entity is Entity else Vector3.ZERO
        var knockback_velocity: Vector3 = entity.knockback_velocity if entity is Entity else Vector3.ZERO
        var rope_velocity: Vector3 = entity.rope_velocity if entity is Entity else Vector3.ZERO
        var entity_position: Vector3 = entity.global_position
        var entity_yaw: float = _get_entity_visual_yaw(entity)
        var dead: bool = bool(entity.dead)
        var disabled: bool = bool(entity.disabled)
        var snapshot_state: Dictionary = _build_host_entity_snapshot_state(
            entity,
            entity_position,
            entity_yaw,
            movement_velocity,
            gravity_velocity,
            knockback_velocity,
            rope_velocity,
            dead,
            disabled,
            held_item_id,
            held_item_index
        )
        if not _should_send_host_entity_snapshot(peer_id, uuid, distance_squared, snapshot_state, not special_state.is_empty()):
            continue

        snapshots.append([
            uuid,
            scene_path,
            entity_position,
            entity_yaw,
            movement_velocity,
            gravity_velocity,
            knockback_velocity,
            rope_velocity,
            dead,
            disabled,
            host_server_time,
            held_item_id,
            held_item_index,
            special_state,
        ])

    return snapshots


var _property_cache: Dictionary = {}

func _object_has_property(target: Object, property_name: String) -> bool:
    if target == null:
        return false
    var class_name_key: String = target.get_class()
    if target.get_script() != null:
        class_name_key = str(target.get_script().resource_path)
    var cache_key: String = class_name_key + ":" + property_name
    if _property_cache.has(cache_key):
        return bool(_property_cache[cache_key])
    var found: bool = property_name in target
    _property_cache[cache_key] = found
    return found


func _apply_entity_special_state(entity, special_state: Dictionary) -> void:
    if entity == null or not is_instance_valid(entity) or special_state.is_empty():
        return

    if entity is Entity and special_state.has("under_water"):
        entity.under_water = bool(special_state.get("under_water", false))

    var head_look_state = special_state.get("head_look", {})
    if head_look_state is Dictionary:
        entity.set_meta("coop_head_look_state", head_look_state.duplicate(true))
        _apply_entity_model_head_look_state(entity, head_look_state)

    var procedural_visual_state = special_state.get("procedural_visual", {})
    if procedural_visual_state is Dictionary:
        if _is_segmented_worm_entity(entity):
            entity.set_meta("coop_procedural_visual_state", procedural_visual_state.duplicate(true))
            if not bool(entity.get_meta("coop_worm_visual_initialized", false)):
                _apply_entity_procedural_visual_state(entity, procedural_visual_state)
            else:
                _apply_entity_procedural_visual_state(entity, procedural_visual_state, 0.0)
        else:
            _apply_entity_procedural_visual_state(entity, procedural_visual_state)

    var compact_anim: Dictionary = special_state.get("compact_anim", {}) if special_state.has("compact_anim") and special_state["compact_anim"] is Dictionary else {}
    entity.set_meta("coop_compact_anim_state", compact_anim.duplicate(true))
    var walk_val: float = float(special_state.get("walk_val", -1.0))
    if walk_val >= 0.0:
        _apply_interp_animation(entity, walk_val, compact_anim)
    else:
        _apply_compact_animation_state(entity, compact_anim)


func _apply_client_world_state(sequence: int, drop_snapshots: Array, entity_snapshots: Array = []) -> void:
    if sequence <= client_last_world_state_sequence:
        return
    if drop_snapshots.size() > CLIENT_SAFE_MAX_DROP_SNAPSHOTS or entity_snapshots.size() > CLIENT_SAFE_MAX_ENTITY_SNAPSHOTS:
        return
    client_last_world_state_sequence = sequence
    _prepare_client_world_sync()
    if ENABLE_ENTITY_SYNC:
        _apply_client_entity_snapshots(entity_snapshots, sequence)
    else:
        _purge_client_entities()
    _apply_client_drop_snapshots(drop_snapshots)


func _purge_client_entities() -> void:
    for uuid in synced_entities.keys().duplicate():
        var synced_entity = synced_entities[uuid]
        if is_instance_valid(synced_entity):
            synced_entity.call_deferred("queue_free")
    synced_entities.clear()
    entity_interp_map.clear()
    _clear_client_entity_dummies()
    for child in _get_live_tracked_entities():
        if _is_syncable_entity_node(child):
            child.call_deferred("queue_free")


func _apply_client_entity_snapshots(entity_snapshots: Array, sequence: int = 0) -> void:
    var visible_uuids: Dictionary = {}
    if entity_snapshots.size() > CLIENT_SAFE_MAX_ENTITY_SNAPSHOTS:
        return

    for entry in entity_snapshots:
        if not (entry is Array) or entry.size() < 10:
            continue
        if not (entry[2] is Vector3):
            continue

        var uuid: String = str(entry[0])
        var scene_path: String = str(entry[1])
        var entity_position: Vector3 = entry[2]
        var entity_yaw: float = float(entry[3])
        var entity_velocity: Vector3 = Vector3.ZERO
        var movement_velocity: Vector3 = entity_velocity
        var gravity_velocity: Vector3 = Vector3.ZERO
        var knockback_velocity: Vector3 = Vector3.ZERO
        var rope_velocity: Vector3 = Vector3.ZERO
        var dead: bool = false
        var disabled: bool = false
        var server_time: float = 0.0
        var held_item_id: int = -1
        var held_item_index: int = 0
        var special_state: Dictionary = {}
        if entry.size() >= 15:
            if not (entry[4] is Vector3) or not (entry[5] is Vector3) or not (entry[6] is Vector3) or not (entry[7] is Vector3) or not (entry[8] is Vector3):
                continue
            entity_velocity = entry[4]
            movement_velocity = entry[5]
            gravity_velocity = entry[6]
            knockback_velocity = entry[7]
            rope_velocity = entry[8]
            dead = bool(entry[9])
            disabled = bool(entry[10])
            server_time = float(entry[11])
            held_item_id = int(entry[12])
            held_item_index = int(entry[13])
            special_state = entry[14] if entry[14] is Dictionary else {}
        elif entry.size() >= 14:
            if not (entry[4] is Vector3) or not (entry[5] is Vector3) or not (entry[6] is Vector3) or not (entry[7] is Vector3):
                continue
            movement_velocity = entry[4]
            gravity_velocity = entry[5]
            knockback_velocity = entry[6]
            rope_velocity = entry[7]
            entity_velocity = movement_velocity + gravity_velocity + knockback_velocity + rope_velocity
            dead = bool(entry[8])
            disabled = bool(entry[9])
            server_time = float(entry[10])
            held_item_id = int(entry[11])
            held_item_index = int(entry[12])
            special_state = entry[13] if entry[13] is Dictionary else {}
        else:
            if not (entry[4] is Vector3):
                continue
            entity_velocity = entry[4]
            dead = bool(entry[5])
            disabled = bool(entry[6])
            server_time = float(entry[7])
            held_item_id = int(entry[8])
            held_item_index = int(entry[9])
            special_state = entry[10] if entry.size() >= 11 and entry[10] is Dictionary else {}
        if uuid == "" or scene_path == "":
            continue
        if not _is_safe_uuid_text(uuid) or not _is_safe_entity_scene_path(scene_path) or not _is_safe_vector3(entity_position):
            continue
        if not special_state.is_empty() and JSON.stringify(special_state).length() > 65536:
            special_state = {}
        movement_velocity = _clamp_safe_vector3(movement_velocity)
        gravity_velocity = _clamp_safe_vector3(gravity_velocity)
        knockback_velocity = _clamp_safe_vector3(knockback_velocity)
        rope_velocity = _clamp_safe_vector3(rope_velocity)

        visible_uuids[uuid] = true
        if server_time > 0.0:
            client_server_time = maxf(client_server_time, server_time)
            client_server_time_initialized = true

        if not _should_full_render_client_entity(entity_position):
            var existing_full_entity = synced_entities.get(uuid, null)
            if is_instance_valid(existing_full_entity):
                _queue_runtime_node_for_cleanup(existing_full_entity)
            synced_entities.erase(uuid)
            entity_interp_map.erase(uuid)
            _update_client_entity_dummy(uuid, scene_path, entity_position, entity_yaw, dead or disabled)
            continue

        _remove_client_entity_dummy(uuid)

        var entity = synced_entities.get(uuid, null)
        if not is_instance_valid(entity):
            entity = _find_existing_entity_by_uuid(uuid)
        if not is_instance_valid(entity):
            entity = _find_existing_entity_by_scene_and_position(scene_path, entity_position)
        if not is_instance_valid(entity):
            entity = _spawn_client_synced_entity(uuid, scene_path)
        if not is_instance_valid(entity):
            continue

        synced_entities[uuid] = entity
        _configure_client_synced_entity(entity, uuid)
        entity.set_meta("coop_last_snapshot_msec", Time.get_ticks_msec())

        if entity is Entity:
            entity.disabled_by_visibility = false
            entity.invincible = true
            entity.invincible_temporary = true
            _apply_client_entity_authoritative_lifecycle(entity as Entity, dead, disabled)
        else:
            entity.visible = not dead

        _apply_entity_held_item_state(entity, held_item_id, held_item_index)
        _apply_entity_special_state(entity, special_state)
        _apply_client_entity_snapshot(entity, entity_position, entity_yaw, entity_velocity, server_time, movement_velocity, gravity_velocity, knockback_velocity, rope_velocity, sequence)

    _remove_unlisted_client_entities(visible_uuids)


func _apply_client_drop_snapshots(drop_snapshots: Array) -> void:
    var visible_uuids: Dictionary = {}
    if drop_snapshots.size() > CLIENT_SAFE_MAX_DROP_SNAPSHOTS:
        return

    for entry in drop_snapshots:
        if not (entry is Array) or entry.size() < 4:
            continue
        if not (entry[1] is Vector3) or not (entry[2] is Vector3) or not (entry[3] is PackedInt32Array):
            continue

        var uuid: String = str(entry[0])
        var drop_position: Vector3 = entry[1]
        var drop_velocity: Vector3 = entry[2]
        var item_data: PackedInt32Array = entry[3]
        var can_collect: bool = bool(entry[4]) if entry.size() >= 5 else true
        if uuid == "" or item_data.is_empty():
            continue
        if not _is_safe_uuid_text(uuid) or not _is_safe_item_data(item_data) or not _is_safe_vector3(drop_position) or not _is_safe_vector3(drop_velocity):
            continue
        drop_velocity = _clamp_safe_vector3(drop_velocity)
        if client_collected_drop_uuids.has(uuid):
            visible_uuids[uuid] = true
            continue

        var dropped_item = synced_dropped_items.get(uuid, null)
        if not is_instance_valid(dropped_item):
            dropped_item = _find_existing_drop_by_uuid(uuid)

        var item_state = _deserialize_item_state(item_data)
        if item_state == null:
            continue

        if is_instance_valid(dropped_item) and dropped_item.item != null and int(dropped_item.item.id) != int(item_state.id):
            _queue_runtime_node_for_cleanup(dropped_item)
            dropped_item = null

        if not is_instance_valid(dropped_item):
            dropped_item = _find_matching_predicted_drop(item_state, drop_position)
            if is_instance_valid(dropped_item):
                _configure_client_synced_drop(dropped_item, uuid)

        if not is_instance_valid(dropped_item):
            dropped_item = _spawn_client_synced_drop(uuid, item_state)
        if not is_instance_valid(dropped_item):
            continue

        synced_dropped_items[uuid] = dropped_item
        visible_uuids[uuid] = true
        _apply_client_drop_snapshot(dropped_item, item_state, drop_position, drop_velocity, can_collect)

    for uuid in synced_dropped_items.keys().duplicate():
        if visible_uuids.has(uuid):
            continue
        var synced_drop = synced_dropped_items[uuid]
        if is_instance_valid(synced_drop) and _is_client_drop_sync_grace_active(synced_drop):
            continue
        if is_instance_valid(synced_drop) and _is_client_drop_snapshot_grace_active(synced_drop):
            continue
        if is_instance_valid(synced_drop):
            _queue_runtime_node_for_cleanup(synced_drop)
        synced_dropped_items.erase(uuid)

    _remove_unlisted_client_drops(visible_uuids)


func _spawn_client_synced_entity(uuid: String, scene_path: String):
    if not _is_safe_uuid_text(uuid) or not _is_safe_entity_scene_path(scene_path):
        return null
    var scene = load(scene_path)
    if not (scene is PackedScene):
        return null

    var entity = scene.instantiate()
    if entity == null or not (entity is Entity):
        if entity != null:
            entity.queue_free()
        return null

    entity.set_meta("coop_source_scene_path", scene_path)
    get_tree().get_root().add_child(entity)
    _configure_client_synced_entity(entity, uuid)
    return entity


func _client_entity_block_position(world_position: Vector3) -> Vector3i:
    return Vector3i(world_position.floor())


func _should_full_render_client_entity(world_position: Vector3) -> bool:
    if not is_instance_valid(Ref.world):
        return false
    return Ref.world.is_position_loaded(_client_entity_block_position(world_position))


func _make_client_entity_dummy_material() -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = Color(0.55, 0.64, 0.68, 0.65)
    material.roughness = 0.85
    material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    return material


func _create_client_entity_dummy(uuid: String, scene_path: String) -> Node3D:
    var dummy := Node3D.new()
    dummy.name = "CoopEntityDummy_%s" % uuid.substr(0, 8)
    dummy.set_meta("coop_uuid", uuid)
    dummy.set_meta("coop_entity_dummy", true)
    dummy.set_meta("coop_source_scene_path", scene_path)
    dummy.set_meta("coop_client_entity_created_msec", Time.get_ticks_msec())

    var mesh_instance := MeshInstance3D.new()
    mesh_instance.name = "Body"
    var mesh := BoxMesh.new()
    mesh.size = CLIENT_ENTITY_DUMMY_SIZE
    mesh_instance.mesh = mesh
    mesh_instance.material_override = _make_client_entity_dummy_material()
    mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    mesh_instance.position = Vector3(0.0, CLIENT_ENTITY_DUMMY_SIZE.y * 0.5, 0.0)
    dummy.add_child(mesh_instance)

    get_tree().get_root().add_child(dummy)
    return dummy


func _get_client_entity_dummy(uuid: String, scene_path: String) -> Node3D:
    var dummy = client_entity_dummies.get(uuid, null)
    if is_instance_valid(dummy):
        return dummy as Node3D
    dummy = _create_client_entity_dummy(uuid, scene_path)
    client_entity_dummies[uuid] = dummy
    return dummy


func _update_client_entity_dummy(uuid: String, scene_path: String, world_position: Vector3, yaw: float, hidden: bool = false) -> void:
    var dummy: Node3D = _get_client_entity_dummy(uuid, scene_path)
    if dummy == null or not is_instance_valid(dummy):
        return
    dummy.set_meta("coop_last_snapshot_msec", Time.get_ticks_msec())
    dummy.global_position = world_position
    dummy.rotation.y = yaw
    dummy.visible = not hidden


func _remove_client_entity_dummy(uuid: String) -> void:
    var dummy = client_entity_dummies.get(uuid, null)
    if is_instance_valid(dummy):
        _queue_runtime_node_for_cleanup(dummy)
    client_entity_dummies.erase(uuid)


func _clear_client_entity_dummies() -> void:
    for uuid in client_entity_dummies.keys().duplicate():
        _remove_client_entity_dummy(str(uuid))


func _spawn_client_synced_drop(uuid: String, item_state):
    if not _is_safe_uuid_text(uuid) or item_state == null:
        return null
    var scene = load(DROPPED_ITEM_SCENE_PATH)
    if not (scene is PackedScene):
        return null

    var dropped_item = scene.instantiate()
    if dropped_item == null:
        return null

    if dropped_item is DroppedItem:
        dropped_item.disabled = true

    get_tree().get_root().add_child(dropped_item)
    if Ref.preserve_node_manager != null:
        Ref.preserve_node_manager.node_to_uuid_map[dropped_item] = uuid
    dropped_item.initialize(item_state, true)
    _configure_client_synced_drop(dropped_item, uuid)
    return dropped_item


func _find_existing_entity_by_uuid(uuid: String):
    if uuid == "":
        return null
    for child in _get_live_tracked_entities():
        if _get_sync_uuid(child) == uuid:
            return child
    return null


func _find_existing_entity_by_scene_and_position(scene_path: String, world_position: Vector3, max_distance: float = 8.0):
    var best_match = null
    var best_distance_squared: float = max_distance * max_distance
    for child in _get_live_tracked_entities():
        if not _is_syncable_entity_node(child):
            continue
        var existing_uuid: String = _get_sync_uuid(child)
        if existing_uuid != "" and synced_entities.get(existing_uuid, null) == child:
            continue
        if _get_sync_scene_path(child) != scene_path:
            continue
        var distance_squared: float = child.global_position.distance_squared_to(world_position)
        if distance_squared > best_distance_squared:
            continue
        best_distance_squared = distance_squared
        best_match = child
    return best_match


func _find_existing_drop_by_uuid(uuid: String):
    for child in _get_live_tracked_drops():
        if child is DroppedItem and _get_sync_uuid(child) == uuid:
            return child
    return null


func _assign_sync_uuid(node: Node) -> String:
    var existing_uuid: String = _get_sync_uuid(node)
    if existing_uuid != "":
        node.set_meta("coop_uuid", existing_uuid)
        return existing_uuid

    var new_uuid: String = UUID.v4()
    node.set_meta("coop_uuid", new_uuid)
    if Ref.preserve_node_manager != null:
        Ref.preserve_node_manager.node_to_uuid_map[node] = new_uuid
    return new_uuid


func ensure_runtime_entity_uuid(entity) -> String:
    if entity == null or not is_instance_valid(entity) or not _is_syncable_entity_node(entity):
        return ""
    return _assign_sync_uuid(entity)


func _remove_unlisted_client_entities(visible_uuids: Dictionary) -> void:
    for uuid in client_entity_dummies.keys().duplicate():
        if visible_uuids.has(uuid):
            continue
        var dummy = client_entity_dummies[uuid]
        if is_instance_valid(dummy) and not _should_prune_client_synced_entity(dummy):
            continue
        _remove_client_entity_dummy(str(uuid))

    for uuid in synced_entities.keys().duplicate():
        if visible_uuids.has(uuid):
            continue
        var entity = synced_entities[uuid]
        if not is_instance_valid(entity):
            synced_entities.erase(uuid)
            entity_interp_map.erase(uuid)
            continue
        if not _should_prune_client_synced_entity(entity):
            continue
        _queue_runtime_node_for_cleanup(entity)
        synced_entities.erase(uuid)
        entity_interp_map.erase(uuid)

    for child in _get_live_tracked_entities():
        if not _is_syncable_entity_node(child):
            continue
        if not bool(child.get_meta("coop_candidate_existing", false)):
            continue
        if not _should_prune_client_synced_entity(child):
            continue
        _queue_runtime_node_for_cleanup(child)


func _remove_unlisted_client_drops(visible_uuids: Dictionary) -> void:
    for child in _get_live_tracked_drops():
        if not (child is DroppedItem):
            continue
        if child.state == DroppedItem.COLLECTED:
            continue
        if _is_client_drop_sync_grace_active(child):
            continue
        if _is_client_drop_snapshot_grace_active(child):
            continue
        if bool(child.get_meta("coop_predicted_drop", false)):
            continue
        var uuid: String = _get_sync_uuid(child)
        if uuid == "" or not visible_uuids.has(uuid):
            if bool(child.get_meta("coop_merge_cleanup_pending", false)):
                continue
            if bool(child.get_meta("coop_pickup_pending_request", false)) or _drop_matches_pending_pickup_receipt(child) or _is_client_drop_within_pickup_radius(child):
                _animate_client_drop_collect_removal.call_deferred(child)
            else:
                _animate_client_drop_merge_removal.call_deferred(child)


func _is_client_drop_sync_grace_active(dropped_item) -> bool:
    if dropped_item == null or not is_instance_valid(dropped_item):
        return false
    return Time.get_ticks_msec() < int(dropped_item.get_meta("coop_direct_spawn_grace_until_ms", 0))


func _is_client_drop_snapshot_grace_active(dropped_item) -> bool:
    if dropped_item == null or not is_instance_valid(dropped_item):
        return false
    var last_snapshot_msec: int = int(dropped_item.get_meta("coop_last_drop_snapshot_msec", 0))
    if last_snapshot_msec <= 0:
        return false
    return (Time.get_ticks_msec() - last_snapshot_msec) <= int(CLIENT_DROP_SYNC_GRACE_SEC * 1000.0)


func _configure_client_synced_entity(entity, uuid: String) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    entity.set_meta("coop_uuid", uuid)
    entity.set_meta("coop_synced_entity", true)
    entity.set_meta("coop_candidate_existing", false)
    entity.set_meta("coop_client_entity_created_msec", int(entity.get_meta("coop_client_entity_created_msec", Time.get_ticks_msec())))
    if Ref.preserve_node_manager != null:
        Ref.preserve_node_manager.node_to_uuid_map[entity] = uuid
    if not tracked_root_entities.has(entity):
        tracked_root_entities.append(entity)
    var runtime_configured: bool = bool(entity.get_meta("coop_client_runtime_configured", false))
    if not runtime_configured:
        _disable_client_entity_runtime(entity, true)
        _restore_client_entity_runtime_branches(entity)
        entity.set_meta("coop_client_runtime_configured", true)
    _restore_client_entity_interact_area(entity)
    _ensure_client_entity_hit_proxy(entity)
    if entity is Entity:
        entity.disabled_by_visibility = false
        entity.invincible = true
        entity.invincible_temporary = true
        if _get_object_script_path(entity).ends_with("/gel.gd"):
            entity.visible = true
            if entity.has_method("update_colors"):
                entity.call("update_colors")
        var visible_enabler: VisibleOnScreenEnabler3D = entity.get_node_or_null("%VisibleOnScreenEnabler3D") as VisibleOnScreenEnabler3D
        if visible_enabler != null:
            visible_enabler.enable_node_path = ""
            visible_enabler.process_mode = Node.PROCESS_MODE_DISABLED
        elif not runtime_configured:
            _ensure_client_entity_hit_proxy(entity)
        _set_client_entity_hit_proxy_enabled(entity, not entity.dead and not entity.disabled)


func _configure_client_synced_drop(dropped_item, uuid: String) -> void:
    if dropped_item == null:
        return
    var was_predicted: bool = bool(dropped_item.get_meta("coop_predicted_drop", false))
    dropped_item.set_meta("coop_uuid", uuid)
    dropped_item.set_meta("coop_synced_drop", true)
    dropped_item.remove_meta("coop_predicted_drop")
    dropped_item.remove_meta("coop_predicted_created_ms")
    dropped_item.remove_meta("coop_predicted_item_signature")
    dropped_item.set_meta("coop_pickup_pending_request", false)
    dropped_item.set_meta("coop_merge_cleanup_pending", false)
    if was_predicted:
        dropped_item.set_meta("coop_predicted_sync_grace_until_ms", Time.get_ticks_msec() + CLIENT_PREDICTED_DROP_SYNC_GRACE_MS)
    if dropped_item is DroppedItem:
        dropped_item.disabled = false
        dropped_item.can_merge = false
        dropped_item.can_collect = false
        dropped_item.is_collect_delayed = false
        dropped_item.is_merge_delayed = false
        dropped_item.toggle_physics(true)
    dropped_item.set_physics_process(true)


func _disable_client_entity_runtime(root: Node, preserve_interact_branch: bool = false) -> void:
    if root == null or not is_instance_valid(root):
        return

    if root.has_method("set_process"):
        root.set_process(false)
    if root.has_method("set_physics_process"):
        root.set_physics_process(false)
    if root.has_method("set_process_input"):
        root.set_process_input(false)
    if root.has_method("set_process_unhandled_input"):
        root.set_process_unhandled_input(false)

    _disable_client_entity_runtime_branch(root, root, preserve_interact_branch)


func _find_client_entity_hit_proxy(entity):
    if entity == null or not is_instance_valid(entity):
        return null
    var rotation_pivot: Node = entity.get_node_or_null("%RotationPivot")
    if rotation_pivot == null:
        return null
    return rotation_pivot.get_node_or_null("CoopHitArea") as Area3D


func _tag_client_entity_hit_owner(node: Node, entity) -> void:
    if node == null or not is_instance_valid(node) or entity == null or not is_instance_valid(entity):
        return
    node.set_meta("coop_hit_owner", entity)
    for child in node.get_children():
        if child is Node:
            _tag_client_entity_hit_owner(child, entity)


func _restore_client_entity_interact_area(entity) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    var source_area: Area3D = entity.get_node_or_null("%InteractArea3D") as Area3D
    if source_area == null:
        return
    source_area.monitoring = false
    source_area.monitorable = true
    source_area.collision_layer = 4112
    source_area.collision_mask = 0
    source_area.owner = entity
    _tag_client_entity_hit_owner(source_area, entity)
    for child in source_area.get_children():
        if _object_has_property(child, "disabled"):
            child.set_deferred("disabled", false)


func _ensure_client_entity_hit_proxy(entity) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    var rotation_pivot: Node3D = entity.get_node_or_null("%RotationPivot") as Node3D
    var source_area: Area3D = entity.get_node_or_null("%InteractArea3D") as Area3D
    if rotation_pivot == null or source_area == null:
        return

    var proxy_area: Area3D = _find_client_entity_hit_proxy(entity)
    if proxy_area == null:
        proxy_area = Area3D.new()
        proxy_area.name = "CoopHitArea"
        rotation_pivot.add_child(proxy_area)
        proxy_area.owner = entity

    proxy_area.monitoring = false
    proxy_area.monitorable = true
    proxy_area.collision_layer = int(source_area.collision_layer)
    proxy_area.collision_mask = int(source_area.collision_mask)
    proxy_area.transform = source_area.transform
    proxy_area.set_meta("coop_hit_owner", entity)

    var shape_index: int = 0
    for child in source_area.get_children():
        if child is CollisionShape3D:
            var source_shape := child as CollisionShape3D
            var proxy_shape: CollisionShape3D = null
            if shape_index < proxy_area.get_child_count() and proxy_area.get_child(shape_index) is CollisionShape3D:
                proxy_shape = proxy_area.get_child(shape_index) as CollisionShape3D
            else:
                proxy_shape = CollisionShape3D.new()
                proxy_area.add_child(proxy_shape)
                proxy_shape.owner = entity
            proxy_shape.shape = source_shape.shape
            proxy_shape.transform = source_shape.transform
            proxy_shape.disabled = source_shape.disabled
            proxy_shape.set_meta("coop_hit_owner", entity)
            shape_index += 1
        elif child is CollisionPolygon3D:
            var source_polygon := child as CollisionPolygon3D
            var proxy_polygon: CollisionPolygon3D = null
            if shape_index < proxy_area.get_child_count() and proxy_area.get_child(shape_index) is CollisionPolygon3D:
                proxy_polygon = proxy_area.get_child(shape_index) as CollisionPolygon3D
            else:
                proxy_polygon = CollisionPolygon3D.new()
                proxy_area.add_child(proxy_polygon)
                proxy_polygon.owner = entity
            proxy_polygon.polygon = source_polygon.polygon
            proxy_polygon.transform = source_polygon.transform
            proxy_polygon.disabled = source_polygon.disabled
            proxy_polygon.set_meta("coop_hit_owner", entity)
            shape_index += 1

    while proxy_area.get_child_count() > shape_index:
        proxy_area.get_child(proxy_area.get_child_count() - 1).queue_free()


func _set_client_entity_hit_proxy_enabled(entity, enabled: bool) -> void:
    var proxy_area: Area3D = _find_client_entity_hit_proxy(entity)
    if proxy_area == null:
        return
    proxy_area.monitorable = enabled
    proxy_area.collision_layer = 4112 if enabled else 0
    proxy_area.collision_mask = 0
    for child in proxy_area.get_children():
        if _object_has_property(child, "disabled"):
            child.set_deferred("disabled", not enabled)


func _restore_client_entity_runtime_branches(root: Node) -> void:
    if root == null or not is_instance_valid(root):
        return
    _restore_client_entity_runtime_branch(root, root)


func _restore_client_entity_runtime_branch(root: Node, node: Node) -> void:
    if node == null or not is_instance_valid(node):
        return

    var keep_active_area_branch: bool = _node_is_within_kept_client_entity_area(node)
    var keep_visual_branch: bool = _node_is_within_kept_client_visual_branch(node)

    if node is Area3D and _should_keep_client_entity_area_active(node as Area3D):
        var area := node as Area3D
        area.monitoring = false
        area.monitorable = true
        area.collision_layer = 4112
        area.collision_mask = 0
        area.owner = root
    elif node is CollisionShape3D or node is CollisionPolygon3D:
        if _object_has_property(node, "disabled") and keep_active_area_branch:
            node.set_deferred("disabled", false)
    elif node is SoftBody3D and keep_visual_branch:
        (node as SoftBody3D).process_mode = Node.PROCESS_MODE_ALWAYS

    if keep_active_area_branch or keep_visual_branch:
        if node.has_method("set_process"):
            node.set_process(true)
        if node.has_method("set_physics_process"):
            node.set_physics_process(true)

    for child in node.get_children():
        _restore_client_entity_runtime_branch(root, child)


func _disable_client_entity_runtime_branch(root: Node, node: Node, preserve_interact_branch: bool) -> void:
    if node == null or not is_instance_valid(node):
        return

    if node is Timer:
        (node as Timer).stop()

    var keep_active_area_branch: bool = preserve_interact_branch and _node_is_within_kept_client_entity_area(node)

    if node is Area3D:
        var area := node as Area3D
        if not (preserve_interact_branch and _should_keep_client_entity_area_active(area)):
            area.monitoring = false
            area.monitorable = false
            area.collision_layer = 0
            area.collision_mask = 0
        else:
            area.monitorable = true
    elif node is PhysicsBody3D:
        var body := node as PhysicsBody3D
        body.collision_layer = 0
        body.collision_mask = 0
        if node != root:
            body.set_physics_process(false)

    if node is CollisionShape3D or node is CollisionPolygon3D:
        var keep_root_query_shape: bool = node.get_parent() == root and root is PhysicsBody3D
        if _object_has_property(node, "disabled") and not keep_root_query_shape and not keep_active_area_branch:
            node.set_deferred("disabled", true)

    var keep_animation_runtime: bool = node is AnimationTree \
        or node is AnimationPlayer \
        or node is AudioStreamPlayer3D \
        or node is AudioStreamPlayer \
        or _is_entity_model_node(node) \
        or _node_is_within_kept_client_visual_branch(node)
    if node != root and not keep_animation_runtime:
        if node.has_method("set_process"):
            node.set_process(false)
        if node.has_method("set_physics_process"):
            node.set_physics_process(false)
        if node.has_method("set_process_input"):
            node.set_process_input(false)
        if node.has_method("set_process_unhandled_input"):
            node.set_process_unhandled_input(false)

    for child in node.get_children():
        _disable_client_entity_runtime_branch(root, child, preserve_interact_branch)


func _node_is_within_kept_client_entity_area(node: Node) -> bool:
    var current: Node = node
    while current != null:
        if current is Area3D and _should_keep_client_entity_area_active(current as Area3D):
            return true
        current = current.get_parent()
    return false


func _apply_client_entity_snapshot(entity, entity_position: Vector3, entity_yaw: float, entity_velocity: Vector3, server_time: float = 0.0, movement_velocity: Vector3 = Vector3.ZERO, gravity_velocity: Vector3 = Vector3.ZERO, knockback_velocity: Vector3 = Vector3.ZERO, rope_velocity: Vector3 = Vector3.ZERO, seq: int = 0) -> void:
    if entity == null or not is_instance_valid(entity):
        return

    var uuid: String = _get_sync_uuid(entity)
    var current_yaw: float = _get_entity_visual_yaw(entity)
    var local_receive_time: float = float(Time.get_ticks_msec()) / 1000.0
    var duration: float = maxf(WORLD_STATE_INTERVAL, 0.001)
    if uuid != "" and entity_interp_map.has(uuid):
        var existing_interp: Dictionary = entity_interp_map[uuid]
        var previous_receive_time: float = float(existing_interp.get("received_local_time", local_receive_time - duration))
        duration = clampf(local_receive_time - previous_receive_time, WORLD_STATE_INTERVAL * 0.75, ENTITY_WORLD_STATE_MAX_INTERVAL_SEC)
    var yaw_delta: float = wrapf(entity_yaw - current_yaw + PI, 0.0, TAU) - PI
    if not bool(entity.get_meta("coop_entity_snapshot_initialized", false)) or entity.global_position.distance_squared_to(entity_position) > 36.0:
        entity.global_position = entity_position
        _set_entity_visual_yaw(entity, entity_yaw)
        if entity.has_method("override_position") and not bool(entity.get_meta("coop_synced_entity", false)):
            entity.override_position()
        entity.set_meta("coop_entity_snapshot_initialized", true)
        if uuid != "":
            entity_interp_map[uuid] = {
                "entity": entity,
                "from_position": entity_position,
                "to_position": entity_position,
                "from_yaw": entity_yaw,
                "to_yaw": entity_yaw,
                "velocity": entity_velocity,
                "elapsed": 0.0,
                "duration": duration,
                "server_time": server_time,
                "seq": seq,
                "yaw_velocity": 0.0,
                "received_local_time": local_receive_time,
            }
    elif uuid != "":
        entity_interp_map[uuid] = {
            "entity": entity,
            "from_position": entity.global_position,
            "to_position": entity_position,
            "from_yaw": current_yaw,
            "to_yaw": entity_yaw,
            "velocity": entity_velocity,
            "elapsed": 0.0,
            "duration": duration,
            "server_time": server_time,
            "seq": seq,
            "yaw_velocity": yaw_delta / duration,
            "received_local_time": local_receive_time,
        }

    if entity is Entity:
        entity.velocity = entity_velocity
        entity.movement_velocity = movement_velocity
        entity.gravity_velocity = gravity_velocity
        entity.knockback_velocity = knockback_velocity
        entity.rope_velocity = rope_velocity
    elif "velocity" in entity:
        entity.velocity = entity_velocity


func _tick_entity_interpolation(delta: float) -> void:
    if entity_interp_map.is_empty():
        return

    for uuid in entity_interp_map.keys().duplicate():
        var interp: Dictionary = entity_interp_map[uuid]
        var entity = interp.get("entity", null)
        if entity == null or not is_instance_valid(entity):
            entity_interp_map.erase(uuid)
            synced_entities.erase(uuid)
            continue

        var duration: float = maxf(float(interp.get("duration", WORLD_STATE_INTERVAL)), 0.001)
        var elapsed: float = float(interp.get("elapsed", 0.0)) + delta
        var weight: float = clampf(elapsed / duration, 0.0, 1.0)
        var from_position: Vector3 = interp.get("from_position", entity.global_position)
        var to_position: Vector3 = interp.get("to_position", entity.global_position)
        var predicted_extra: float = minf(maxf(elapsed - duration, 0.0), ENTITY_WORLD_STATE_MAX_INTERVAL_SEC)
        var predicted_velocity: Vector3 = interp.get("velocity", Vector3.ZERO)
        predicted_velocity.y = 0.0
        entity.global_position = from_position.lerp(to_position, weight) + predicted_velocity * predicted_extra
        var entity_yaw: float = lerp_angle(float(interp.get("from_yaw", _get_entity_visual_yaw(entity))), float(interp.get("to_yaw", _get_entity_visual_yaw(entity))), weight) + float(interp.get("yaw_velocity", 0.0)) * predicted_extra
        _set_entity_visual_yaw(entity, entity_yaw)
        if entity.has_method("override_position") and not bool(entity.get_meta("coop_synced_entity", false)):
            entity.override_position()
        interp["elapsed"] = elapsed
        entity_interp_map[uuid] = interp


func _tick_client_synced_entity_visuals(delta: float) -> void:
    if synced_entities.is_empty():
        return

    for uuid in synced_entities.keys().duplicate():
        var entity = synced_entities[uuid]
        if entity == null or not is_instance_valid(entity):
            continue
        var entity_velocity: Vector3 = _get_entity_total_velocity(entity)
        if entity_interp_map.has(uuid):
            var interp = entity_interp_map[uuid]
            if interp is Dictionary:
                entity_velocity = interp.get("velocity", entity_velocity)
        var visual_delta: float = _consume_client_entity_visual_update_delta(entity, delta)
        if visual_delta <= 0.0:
            continue
        _update_client_entity_visuals(entity, entity_velocity, visual_delta)


func _consume_client_entity_visual_update_delta(entity, delta: float) -> float:
    if entity == null or not is_instance_valid(entity):
        return 0.0

    var update_interval: float = 0.0
    if _can_sample_player():
        var distance_squared: float = entity.global_position.distance_squared_to(Ref.player.global_position)
        if distance_squared > CLIENT_SYNCED_ENTITY_VISUAL_MID_RADIUS * CLIENT_SYNCED_ENTITY_VISUAL_MID_RADIUS:
            update_interval = CLIENT_SYNCED_ENTITY_VISUAL_FAR_INTERVAL
        elif distance_squared > CLIENT_SYNCED_ENTITY_VISUAL_NEAR_RADIUS * CLIENT_SYNCED_ENTITY_VISUAL_NEAR_RADIUS:
            update_interval = CLIENT_SYNCED_ENTITY_VISUAL_MID_INTERVAL

    if update_interval <= 0.0:
        entity.set_meta("coop_client_visual_delta_accum", 0.0)
        return delta

    var accumulated_delta: float = float(entity.get_meta("coop_client_visual_delta_accum", 0.0)) + delta
    if accumulated_delta + 0.0001 < update_interval:
        entity.set_meta("coop_client_visual_delta_accum", accumulated_delta)
        return 0.0

    entity.set_meta("coop_client_visual_delta_accum", fmod(accumulated_delta, update_interval))
    return accumulated_delta


func _apply_interp_animation(entity, walk_val: float, compact_anim: Dictionary) -> void:
    var animation_tree: AnimationTree = _find_first_animation_tree(entity)
    _apply_compact_animation_state(entity, compact_anim)
    if animation_tree != null:
        if _animation_tree_has_parameter(animation_tree, "parameters/walk/blend_amount"):
            animation_tree.set("parameters/walk/blend_amount", walk_val)
        if _animation_tree_has_parameter(animation_tree, "parameters/run/blend_amount"):
            animation_tree.set("parameters/run/blend_amount", walk_val)


func _update_client_entity_visuals(entity, entity_velocity: Vector3, _delta: float) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    if entity.has_method("override_position") and not bool(entity.get_meta("coop_synced_entity", false)):
        entity.override_position()
    _update_client_procedural_entity_visuals(entity, _delta)
    var base_speed: float = _resolve_object_float_property(entity, ["speed"], 1.0)
    var speed_modifier: float = _resolve_object_float_property(entity, ["speed_modifier"], 1.0)
    var walk_val: float = clampf(Vector3(entity_velocity.x, 0.0, entity_velocity.z).length() / maxf(base_speed * speed_modifier, 0.001), 0.0, 1.0)
    var compact_anim: Dictionary = entity.get_meta("coop_compact_anim_state", {}) if entity.has_meta("coop_compact_anim_state") else {}
    _apply_interp_animation(entity, walk_val, compact_anim if compact_anim is Dictionary else {})
    _advance_client_animation_tree(entity, _delta)


func _capture_compact_animation_state(root: Node) -> Dictionary:
    var animation_tree: AnimationTree = _find_first_animation_tree(root)
    if animation_tree == null:
        return {}

    var state: Dictionary = {}
    for property_info in animation_tree.get_property_list():
        var property_name: String = str(property_info.get("name", ""))
        if not property_name.begins_with("parameters/"):
            continue
        if property_name.ends_with("/internal_active"):
            continue
        var leaf_name: String = property_name.get_slice("/", property_name.get_slice_count("/") - 1)
        if leaf_name not in ["blend_amount", "blend_position", "request", "scale", "active"]:
            continue

        var value: Variant = animation_tree.get(property_name)
        match typeof(value):
            TYPE_BOOL, TYPE_INT:
                state[property_name] = value
            TYPE_FLOAT:
                state[property_name] = _quantize_float(float(value), 0.01)
            TYPE_VECTOR2:
                var vec2_value: Vector2 = value
                state[property_name] = Vector2(
                    _quantize_float(vec2_value.x, 0.01),
                    _quantize_float(vec2_value.y, 0.01)
                )
            TYPE_VECTOR3:
                state[property_name] = _quantize_vector3(value, 0.01)
    return state


func _resolve_host_visual_projectile_start(entity) -> Vector3:
    if entity == null or not is_instance_valid(entity):
        return Vector3.ZERO

    var hand_node: Node3D = entity.get_node_or_null("%Hand") as Node3D
    if hand_node == null and _object_has_property(entity, "hand"):
        var hand_value: Variant = entity.get("hand")
        if hand_value is Node3D and is_instance_valid(hand_value):
            hand_node = hand_value
    if hand_node != null:
        return hand_node.global_position

    var head_node: Node3D = entity.get_node_or_null("%Head") as Node3D
    if head_node == null and _object_has_property(entity, "head"):
        var head_value: Variant = entity.get("head")
        if head_value is Node3D and is_instance_valid(head_value):
            head_node = head_value
    if head_node != null:
        return head_node.global_position

    return entity.global_position + Vector3(0.0, 1.2, 0.0)


func _resolve_host_visual_projectile_direction(entity) -> Vector3:
    if entity == null or not is_instance_valid(entity):
        return Vector3.FORWARD

    var direction: Vector3 = Vector3.ZERO
    if entity.has_method("get_look_direction"):
        direction = entity.get_look_direction()
    else:
        direction = -entity.global_basis.z
    if direction.is_zero_approx():
        direction = -entity.global_basis.z
    return direction.normalized()


func _resolve_object_float_property(target: Object, property_names: Array, default_value: float) -> float:
    if target == null:
        return default_value
    for property_name_value in property_names:
        var property_name: String = str(property_name_value)
        if _object_has_property(target, property_name):
            return float(target.get(property_name))
    return default_value


func _resolve_host_visual_ball_linear_velocity(entity, held_item = null) -> Vector3:
    var direction: Vector3 = _resolve_host_visual_projectile_direction(entity)
    var speed: float = _resolve_object_float_property(held_item, ["throw_speed", "projectile_speed", "speed"], 12.0)
    if speed <= 0.0:
        speed = 12.0
    return direction * speed + _get_entity_total_velocity(entity)


func _resolve_remote_projectile_spawn_position(sender_id: int, requested_position: Vector3) -> Vector3:
    var authoritative_position: Vector3 = requested_position
    var proxy = get_remote_player_proxy(sender_id)
    if is_instance_valid(proxy):
        authoritative_position = _resolve_host_visual_projectile_start(proxy)
    else:
        var sender_state: Dictionary = peer_states.get(sender_id, {})
        authoritative_position = sender_state.get("position", requested_position) + Vector3(0.0, 1.2, 0.0)

    if requested_position.distance_squared_to(authoritative_position) <= 9.0:
        authoritative_position = requested_position

    if is_instance_valid(Ref.world) and Ref.world.is_position_loaded(authoritative_position):
        var attempts: int = 0
        while attempts < 6 and Ref.world.get_block_type_at(authoritative_position.floor()).id != 0:
            authoritative_position += Vector3(0.0, 0.3, 0.0)
            attempts += 1

    return authoritative_position


func _spawn_host_authoritative_bolt_for_peer(sender_id: int, start_position: Vector3, direction: Vector3) -> bool:
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return false

    var attacker = get_remote_player_proxy(sender_id)
    if attacker == null or not is_instance_valid(attacker):
        return false

    var scene = load(AUTHORITATIVE_BOLT_SCENE_PATH)
    if not (scene is PackedScene):
        return false

    var bolt = (scene as PackedScene).instantiate()
    if bolt == null:
        return false

    var spawn_position: Vector3 = _resolve_remote_projectile_spawn_position(sender_id, start_position)
    get_tree().get_root().add_child(bolt)
    if bolt is Node3D:
        bolt.global_position = spawn_position
    elif "global_position" in bolt:
        bolt.global_position = spawn_position

    if _object_has_property(bolt, "entity_owner"):
        bolt.set("entity_owner", attacker)

    if bolt.has_method("fire"):
        bolt.fire(normalized_direction, true)
    return true


func _spawn_host_authoritative_explosive_for_peer(sender_id: int, scene_path: String, start_position: Vector3, linear_velocity: Vector3) -> bool:
    var normalized_path: String = scene_path.strip_edges()
    if not normalized_path.begins_with("res://main/items/held_item/held_explosive/physical_explosive/") or not normalized_path.ends_with(".tscn"):
        return false

    var attacker = get_remote_player_proxy(sender_id)
    if attacker == null or not is_instance_valid(attacker):
        return false

    var scene = load(normalized_path)
    if not (scene is PackedScene):
        return false

    var explosive = (scene as PackedScene).instantiate()
    if explosive == null:
        return false

    var spawn_position: Vector3 = _resolve_remote_projectile_spawn_position(sender_id, start_position)
    var spawn_velocity: Vector3 = linear_velocity
    if spawn_velocity.length() > 48.0:
        spawn_velocity = spawn_velocity.normalized() * 48.0

    get_tree().get_root().add_child(explosive)
    if _object_has_property(explosive, "freeze"):
        explosive.freeze = true
    if explosive is Node3D:
        explosive.global_position = spawn_position
    elif "global_position" in explosive:
        explosive.global_position = spawn_position
    if _object_has_property(explosive, "freeze"):
        explosive.freeze = false

    if _object_has_property(explosive, "entity_owner"):
        explosive.set("entity_owner", attacker)
    if _object_has_property(explosive, "linear_velocity"):
        explosive.set("linear_velocity", spawn_velocity)
    elif _object_has_property(explosive, "velocity"):
        explosive.set("velocity", spawn_velocity)
    if explosive.has_method("ignite"):
        explosive.ignite()
    return true


func _spawn_host_authoritative_capsule_for_peer(sender_id: int, item_id: int, start_position: Vector3, linear_velocity: Vector3) -> bool:
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if not _is_peer_state_same_instance(sender_state, get_active_dimension_instance_key()):
        return false

    var attacker = get_remote_player_proxy(sender_id)
    if attacker == null or not is_instance_valid(attacker):
        return false

    var item = ItemMap.map(item_id)
    if item == null or item.projectile_scene == null:
        return false
    if item.entity_scene == null and _object_has_property(item, "entity_path") and str(item.entity_path) != "":
        item.entity_scene = ResourceLoader.load(item.entity_path)
    if item.entity_scene == null:
        return false

    var capsule = item.projectile_scene.instantiate()
    if capsule == null:
        return false

    var spawn_position: Vector3 = _resolve_remote_projectile_spawn_position(sender_id, start_position)
    var spawn_velocity: Vector3 = linear_velocity
    if spawn_velocity.length() > 48.0:
        spawn_velocity = spawn_velocity.normalized() * 48.0

    get_tree().get_root().add_child(capsule)
    if capsule is Node3D:
        capsule.global_position = spawn_position
    elif "global_position" in capsule:
        capsule.global_position = spawn_position

    if capsule.has_method("initialize"):
        capsule.initialize(spawn_velocity, item, item.entity_scene)
    return true


func _get_compact_anim_request(compact_anim: Dictionary, node_name: String) -> int:
    if compact_anim.is_empty() or node_name == "":
        return 0
    var request_path: String = "parameters/%s/request" % node_name
    return int(compact_anim.get(request_path, 0))


func _maybe_broadcast_host_entity_projectile_visual(entity, special_state: Dictionary) -> void:
    if not multiplayer.is_server() or not _has_live_peer() or entity == null or special_state.is_empty():
        return

    var compact_anim: Dictionary = special_state.get("compact_anim", {}) if special_state.has("compact_anim") and special_state["compact_anim"] is Dictionary else {}
    var shoot_request: int = _get_compact_anim_request(compact_anim, "shoot")
    var previous_request: int = int(entity.get_meta("coop_host_visual_shoot_request", 0))
    entity.set_meta("coop_host_visual_shoot_request", shoot_request)
    if shoot_request == 0 or previous_request == shoot_request:
        return

    var held_item = entity.get("held_item") if _object_has_property(entity, "held_item") else null
    var held_item_script_path: String = _get_object_script_path(held_item)
    var start_position: Vector3 = _resolve_host_visual_projectile_start(entity)
    if held_item_script_path.contains("/held_ball_thrower/"):
        broadcast_host_visual_ball_throw(start_position, _resolve_host_visual_ball_linear_velocity(entity, held_item))
    elif held_item_script_path.contains("/held_heart_thrower/"):
        broadcast_host_visual_heart_throw(start_position, _resolve_host_visual_ball_linear_velocity(entity, held_item))
    elif held_item_script_path.contains("/held_blaster/"):
        broadcast_host_visual_blast(start_position, _get_entity_total_velocity(entity), _resolve_host_visual_projectile_direction(entity))
    elif held_item_script_path.contains("/held_rod_thrower/"):
        broadcast_host_visual_bolt(start_position, _resolve_host_visual_projectile_direction(entity))


func _apply_compact_animation_state(root: Node, state: Dictionary) -> void:
    if root == null or not is_instance_valid(root) or state.is_empty():
        return

    var animation_tree: AnimationTree = _find_first_animation_tree(root)
    if animation_tree == null:
        return

    var request_state: Dictionary = root.get_meta("coop_anim_request_state", {}) if root.has_meta("coop_anim_request_state") else {}
    if not (request_state is Dictionary):
        request_state = {}

    for property_name_value in state.keys():
        var property_name: String = str(property_name_value)
        if property_name == "" or not _animation_tree_has_parameter(animation_tree, property_name):
            continue

        var value: Variant = state[property_name_value]
        if property_name.ends_with("/request"):
            var previous_request: Variant = request_state.get(property_name, null)
            if previous_request == value:
                continue
            request_state[property_name] = value
        animation_tree.set(property_name, value)

    root.set_meta("coop_anim_request_state", request_state)


func _apply_entity_held_item_state(entity, held_item_id: int, held_item_index: int) -> void:
    if entity == null or not is_instance_valid(entity) or not (entity is Entity):
        return
    if not _object_has_property(entity, "held_item_inventory"):
        return

    var inventory = entity.get("held_item_inventory")
    if inventory == null or not _object_has_property(inventory, "items") or inventory.items.is_empty():
        return
    var resolved_index: int = held_item_index
    if resolved_index < 0 or resolved_index >= inventory.items.size():
        resolved_index = clampi(int(entity.held_item_index), 0, inventory.items.size() - 1)
    if held_item_id < 0:
        var needs_update: bool = inventory.items[resolved_index] != null
        if needs_update:
            inventory.set_item(resolved_index, null)
        if int(entity.held_item_index) != resolved_index or (needs_update and entity.has_method("hold_item")):
            if entity.has_method("hold_item"):
                entity.call("hold_item", resolved_index)
            else:
                entity.held_item_index = resolved_index
        return

    var existing_state = inventory.items[resolved_index]
    if existing_state == null or int(existing_state.id) != held_item_id:
        var item = ItemMap.map(held_item_id)
        if item != null:
            var new_item_state := ItemState.new()
            new_item_state.initialize(item)
            inventory.set_item(resolved_index, new_item_state)

    if int(entity.held_item_index) != resolved_index:
        if entity.has_method("hold_item"):
            entity.call("hold_item", resolved_index)
        else:
            entity.held_item_index = resolved_index


func _find_first_animation_tree(root: Node) -> AnimationTree:
    if root == null or not is_instance_valid(root):
        return null
    if root.has_meta("coop_animation_tree_node"):
        var cached_tree = root.get_meta("coop_animation_tree_node")
        if cached_tree is AnimationTree and is_instance_valid(cached_tree):
            return cached_tree
        if str(cached_tree) == "false":
            return null
        root.remove_meta("coop_animation_tree_node")
    var found: AnimationTree = _search_first_animation_tree(root)
    root.set_meta("coop_animation_tree_node", found if found != null else false)
    return found


func _find_first_animation_player(root: Node) -> AnimationPlayer:
    if root == null or not is_instance_valid(root):
        return null
    if root.has_meta("coop_animation_player_node"):
        var cached_player = root.get_meta("coop_animation_player_node")
        if cached_player is AnimationPlayer and is_instance_valid(cached_player):
            return cached_player
        if str(cached_player) == "false":
            return null
        root.remove_meta("coop_animation_player_node")
    var found: AnimationPlayer = _search_first_animation_player(root)
    root.set_meta("coop_animation_player_node", found if found != null else false)
    return found


func _search_first_animation_tree(root: Node) -> AnimationTree:
    if root is AnimationTree:
        return root as AnimationTree
    for child in root.get_children():
        var found: AnimationTree = _search_first_animation_tree(child)
        if found != null:
            return found
    return null


func _search_first_animation_player(root: Node) -> AnimationPlayer:
    if root is AnimationPlayer:
        return root as AnimationPlayer
    for child in root.get_children():
        var found: AnimationPlayer = _search_first_animation_player(child)
        if found != null:
            return found
    return null


func _animation_tree_has_parameter(animation_tree: AnimationTree, parameter_path: String) -> bool:
    return animation_tree != null and _object_has_property(animation_tree, parameter_path)


func _apply_client_drop_snapshot(dropped_item, item_state, drop_position: Vector3, drop_velocity: Vector3, can_collect: bool = true) -> void:
    if dropped_item is DroppedItem and (dropped_item.state == DroppedItem.COLLECTED or bool(dropped_item.get_meta("coop_pickup_pending_request", false))):
        return
    dropped_item.set_meta("coop_last_drop_snapshot_msec", Time.get_ticks_msec())
    dropped_item.set_meta("coop_merge_cleanup_pending", false)

    var previous_can_collect: bool = bool(dropped_item.can_collect) if dropped_item is DroppedItem else false
    var grace_until_ms: int = int(dropped_item.get_meta("coop_predicted_sync_grace_until_ms", 0))
    var keep_predicted_motion: bool = grace_until_ms > Time.get_ticks_msec()
    var distance_error: float = dropped_item.global_position.distance_to(drop_position)

    dropped_item.item = item_state
    if not bool(dropped_item.get_meta("coop_drop_snapshot_initialized", false)):
        dropped_item.global_position = drop_position
        dropped_item.set_meta("coop_drop_snapshot_initialized", true)
        distance_error = 0.0
    elif not keep_predicted_motion:
        if distance_error > CLIENT_DROP_CORRECTION_DISTANCE:
            dropped_item.global_position = drop_position
        elif distance_error > 0.01:
            dropped_item.global_position = dropped_item.global_position.lerp(drop_position, CLIENT_DROP_POSITION_BLEND)
        distance_error = dropped_item.global_position.distance_to(drop_position)

    if dropped_item is DroppedItem:
        var should_wake_sleeping_drop: bool = distance_error > 0.35 or drop_velocity.length_squared() > 0.36
        if not keep_predicted_motion:
            if dropped_item.state != DroppedItem.SLEEPING or should_wake_sleeping_drop:
                dropped_item.velocity = dropped_item.velocity.lerp(drop_velocity, CLIENT_DROP_VELOCITY_BLEND)
            else:
                dropped_item.velocity = Vector3.ZERO
        dropped_item.can_collect = can_collect
        dropped_item.disabled = false
        if dropped_item.state == DroppedItem.SLEEPING and should_wake_sleeping_drop:
            dropped_item.state = DroppedItem.IDLE
            dropped_item.toggle_physics(true)
    else:
        dropped_item.velocity = drop_velocity

    if dropped_item is DroppedItem and can_collect and (not previous_can_collect or _is_client_drop_within_pickup_radius(dropped_item)):
        _attempt_client_auto_pickup_drop.call_deferred(dropped_item)


func _get_sync_uuid(node: Node) -> String:
    if node == null:
        return ""
    if node.has_meta("coop_uuid"):
        return str(node.get_meta("coop_uuid"))
    if Ref.preserve_node_manager == null:
        return ""
    return str(Ref.preserve_node_manager.node_to_uuid_map.get(node, ""))


func _entity_segment_projection(point: Vector3, segment_begin: Vector3, segment_end: Vector3) -> Dictionary:
    var segment: Vector3 = segment_end - segment_begin
    var segment_length_sq: float = segment.length_squared()
    if segment_length_sq <= 0.000001:
        return {
            "t": 0.0,
            "closest": segment_begin,
            "distance_squared": point.distance_squared_to(segment_begin),
        }
    var t: float = clampf((point - segment_begin).dot(segment) / segment_length_sq, 0.0, 1.0)
    var closest: Vector3 = segment_begin + segment * t
    return {
        "t": t,
        "closest": closest,
        "distance_squared": point.distance_squared_to(closest),
    }


func _estimate_client_attack_target_radius(entity) -> float:
    if entity == null or not is_instance_valid(entity):
        return 0.9
    var radius: float = 0.9
    var interact_area: Area3D = entity.get_node_or_null("%InteractArea3D") as Area3D
    if interact_area == null:
        return radius
    for child in interact_area.get_children():
        if not (child is CollisionShape3D):
            continue
        var collision_shape := child as CollisionShape3D
        if collision_shape.shape == null:
            continue
        if collision_shape.shape is SphereShape3D:
            radius = maxf(radius, float((collision_shape.shape as SphereShape3D).radius))
        elif collision_shape.shape is BoxShape3D:
            radius = maxf(radius, (collision_shape.shape as BoxShape3D).size.length() * 0.5)
        elif collision_shape.shape is CapsuleShape3D:
            var capsule := collision_shape.shape as CapsuleShape3D
            radius = maxf(radius, capsule.radius + capsule.height * 0.5)
        elif collision_shape.shape is CylinderShape3D:
            var cylinder := collision_shape.shape as CylinderShape3D
            radius = maxf(radius, cylinder.radius + cylinder.height * 0.5)
    return radius


func _get_client_attack_probe_points(entity) -> Array:
    var points: Array = []
    if entity == null or not is_instance_valid(entity):
        return points
    var interact_area: Area3D = entity.get_node_or_null("%InteractArea3D") as Area3D
    if interact_area != null:
        points.append(interact_area.global_position)
    if entity is Entity:
        var entity_node := entity as Entity
        if is_instance_valid(entity_node.head):
            points.append(entity_node.head.global_position)
    points.append(entity.global_position)
    return points


func find_client_ray_attack_target(segment_begin: Vector3, segment_end: Vector3):
    if multiplayer.is_server():
        return null
    var best_target = null
    var best_t: float = INF
    var best_distance_squared: float = INF
    for entity in synced_entities.values():
        if entity == null or not is_instance_valid(entity) or not (entity is Entity):
            continue
        if entity.dead or entity.disabled:
            continue
        var effective_radius: float = _estimate_client_attack_target_radius(entity) + 0.45
        var effective_radius_sq: float = effective_radius * effective_radius
        for point in _get_client_attack_probe_points(entity):
            if not (point is Vector3):
                continue
            var projection: Dictionary = _entity_segment_projection(point, segment_begin, segment_end)
            var distance_squared: float = float(projection.get("distance_squared", INF))
            if distance_squared > effective_radius_sq:
                continue
            var t: float = float(projection.get("t", INF))
            if t < best_t or (is_equal_approx(t, best_t) and distance_squared < best_distance_squared):
                best_t = t
                best_distance_squared = distance_squared
                best_target = entity
    return best_target


func get_client_attack_hit_position(entity, segment_begin: Vector3, segment_end: Vector3) -> Vector3:
    if entity == null or not is_instance_valid(entity):
        return segment_end
    var best_position: Vector3 = entity.global_position
    var best_distance_squared: float = INF
    for point in _get_client_attack_probe_points(entity):
        if not (point is Vector3):
            continue
        var projection: Dictionary = _entity_segment_projection(point, segment_begin, segment_end)
        var distance_squared: float = float(projection.get("distance_squared", INF))
        if distance_squared < best_distance_squared:
            best_distance_squared = distance_squared
            best_position = projection.get("closest", point)
    return best_position


func _get_client_sync_clock() -> float:
    if client_server_time_initialized:
        return client_server_time
    return float(Time.get_ticks_msec()) / 1000.0


func _should_prune_client_synced_entity(entity) -> bool:
    if entity == null or not is_instance_valid(entity):
        return true
    var last_snapshot_msec: int = int(entity.get_meta("coop_last_snapshot_msec", 0))
    var created_msec: int = int(entity.get_meta("coop_client_entity_created_msec", Time.get_ticks_msec()))
    var baseline_msec: int = last_snapshot_msec if last_snapshot_msec > 0 else created_msec
    return (Time.get_ticks_msec() - baseline_msec) > int(CLIENT_ENTITY_SYNC_GRACE_SEC * 1000.0)


func _resolve_client_attack_target(target):
    if target == null or not is_instance_valid(target):
        return target
    if target is Entity and _get_sync_uuid(target) != "":
        return target

    var current: Node = target as Node
    while current != null:
        if current is Entity and _get_sync_uuid(current) != "":
            return current
        if current.owner is Entity and _get_sync_uuid(current.owner) != "":
            return current.owner
        current = current.get_parent()

    if target is Entity:
        var entity_target := target as Entity
        var scene_path: String = _get_sync_scene_path(entity_target)
        if scene_path != "":
            var matched = _find_existing_entity_by_scene_and_position(scene_path, entity_target.global_position, 12.0)
            if matched != null and _get_sync_uuid(matched) != "":
                return matched
    return target


func _find_host_entity_by_uuid(uuid: String):
    if uuid == "":
        return null
    for child in _get_live_tracked_entities():
        if _get_sync_uuid(child) == uuid:
            return child
    return null


func _find_host_entity_by_scene_and_position(scene_path: String, world_position: Vector3, max_distance: float = 10.0):
    return _find_existing_entity_by_scene_and_position(scene_path, world_position, max_distance)


func _find_host_drop_by_uuid(uuid: String):
    for child in get_tree().get_root().get_children():
        if child is DroppedItem and _get_sync_uuid(child) == uuid:
            return child
    return null


func _find_client_synced_entity_by_uuid(uuid: String):
    if uuid == "":
        return null
    if synced_entities.has(uuid) and is_instance_valid(synced_entities[uuid]):
        return synced_entities[uuid]
    return _find_existing_entity_by_uuid(uuid)


func _apply_client_entity_authoritative_lifecycle(entity: Entity, dead: bool, disabled: bool) -> void:
    if entity == null or not is_instance_valid(entity):
        return

    var was_dead: bool = bool(entity.get_meta("coop_client_authoritative_dead", bool(entity.dead)))
    entity.set_meta("coop_client_authoritative_dead", dead)

    if dead:
        entity.visible = true
        entity.disabled = true
        if not entity.dead:
            entity.dead = true
        _set_client_entity_hit_proxy_enabled(entity, false)
        _play_client_entity_death_visual(entity, was_dead)
        return

    entity.visible = true
    entity.disabled = disabled
    if entity.dead:
        entity.dead = false
    entity.set_meta("coop_client_death_visual_played", false)
    _set_client_entity_hit_proxy_enabled(entity, not disabled)


func _play_client_entity_death_visual(entity: Entity, was_dead: bool) -> void:
    if entity == null or not is_instance_valid(entity):
        return
    if was_dead or bool(entity.get_meta("coop_client_death_visual_played", false)):
        return

    entity.set_meta("coop_client_death_visual_played", true)

    var interact_area: Node = entity.get_node_or_null("%InteractArea3D")
    if interact_area != null:
        for child in interact_area.get_children():
            if child is CollisionShape3D:
                child.set_deferred("disabled", true)

    var death_anim: AnimationPlayer = entity.get_node_or_null("%DeathAnimationPlayer") as AnimationPlayer
    if death_anim != null and death_anim.has_animation("die"):
        death_anim.play("die")


func _set_client_entity_direct_damage_cooldown(target, duration: float = CLIENT_ENTITY_HIT_COOLDOWN_SEC) -> void:
    if target == null or not is_instance_valid(target):
        return
    target.set_meta("coop_predicted_direct_damage_until_ms", Time.get_ticks_msec() + int(duration * 1000.0))
    if _object_has_property(target, "direct_damage_cooldown"):
        target.set("direct_damage_cooldown", true)


func _predict_client_entity_knockback(target_uuid: String, target, knockback_velocity: Vector3) -> void:
    if target == null or not is_instance_valid(target):
        return

    _set_client_entity_direct_damage_cooldown(target)

    if target is Entity:
        target.knockback_velocity = knockback_velocity
        target.velocity = _get_entity_total_velocity(target)
    elif _object_has_property(target, "velocity"):
        target.set("velocity", knockback_velocity)

    if target_uuid == "":
        return

    var local_receive_time: float = float(Time.get_ticks_msec()) / 1000.0
    var total_velocity: Vector3 = _get_entity_total_velocity(target)
    var interp: Dictionary = entity_interp_map.get(target_uuid, {})
    var duration: float = maxf(float(interp.get("duration", WORLD_STATE_INTERVAL)), WORLD_STATE_INTERVAL)
    entity_interp_map[target_uuid] = {
        "entity": target,
        "from_position": target.global_position,
        "to_position": target.global_position,
        "from_yaw": _get_entity_visual_yaw(target),
        "to_yaw": _get_entity_visual_yaw(target),
        "velocity": total_velocity,
        "elapsed": duration,
        "duration": duration,
        "server_time": float(interp.get("server_time", client_server_time)),
        "seq": int(interp.get("seq", client_last_world_state_sequence)),
        "yaw_velocity": 0.0,
        "received_local_time": local_receive_time,
    }


func _confirm_client_entity_hit(target_uuid: String, target, entity_position: Vector3, entity_yaw: float, entity_velocity: Vector3, knockback_velocity: Vector3, server_time: float, seq: int) -> void:
    if target == null or not is_instance_valid(target):
        target = _find_client_synced_entity_by_uuid(target_uuid)
    if target == null or not is_instance_valid(target):
        return
    if target is Entity:
        target.knockback_velocity = knockback_velocity
    _apply_client_entity_snapshot(target, entity_position, entity_yaw, entity_velocity, server_time, (target.movement_velocity if target is Entity else Vector3.ZERO), (target.gravity_velocity if target is Entity else Vector3.ZERO), knockback_velocity, (target.rope_velocity if target is Entity else Vector3.ZERO), seq)


func _play_client_entity_hit_feedback(target, _attacker, _damage_position: Vector3, damage: int, _attacker_position_override: Variant = null) -> void:
    if target == null or not is_instance_valid(target) or damage <= 0:
        return

    _set_client_entity_direct_damage_cooldown(target)

    if not _object_has_property(target, "damage_modulate") or not _object_has_property(target, "modulate"):
        return

    var damage_modulate: Color = target.get("damage_modulate")
    if is_instance_valid(target.get("modulate_tween")):
        target.get("modulate_tween").stop()

    var tween: Tween = get_tree().create_tween()
    if _object_has_property(target, "modulate_tween"):
        target.set("modulate_tween", tween)
    tween.tween_property(target, "modulate", damage_modulate, 0.04)
    tween.tween_interval(0.18)
    tween.tween_property(target, "modulate", Color.WHITE, 0.07)


func _apply_network_place(block_position: Vector3i, block_id: int) -> void:
    if not is_instance_valid(Ref.world):
        return
    if not _is_safe_vector3i(block_position) or not _is_safe_block_id(block_id):
        return
    if not Ref.world.is_position_loaded(block_position):
        pending_remote_block_changes[block_position] = block_id
        return
    _apply_loaded_network_place(block_position, block_id)


func _apply_loaded_network_place(block_position: Vector3i, block_id: int) -> void:
    if not _is_safe_block_id(block_id):
        return
    var current_block = Ref.world.get_block_type_at(block_position)
    if current_block != null and int(current_block.id) == block_id:
        return
    Ref.world.place_block_at(block_position, ItemMap.map(block_id), true, true)
    _invalidate_host_dynamic_cell_caches()


func _apply_network_break(block_position: Vector3i) -> void:
    if not is_instance_valid(Ref.world):
        return
    if not _is_safe_vector3i(block_position):
        return
    if not Ref.world.is_position_loaded(block_position):
        pending_remote_block_changes[block_position] = 0
        return
    _apply_loaded_network_break(block_position)


func _apply_loaded_network_break(block_position: Vector3i) -> void:
    if not is_instance_valid(Ref.world) or not Ref.world.is_position_loaded(block_position):
        return
    var block = Ref.world.get_block_type_at(block_position)
    if block == null:
        return
    if block.id == 0 and block.internal_name != "cutscene block":
        return
    Ref.world.break_block_at(block_position, true, false)
    _invalidate_host_dynamic_cell_caches()


func _apply_network_block_changes(changes: Array) -> void:
    if not is_instance_valid(Ref.world):
        return

    for entry in changes:
        if not (entry is Array) or entry.size() < 2:
            continue
        if not (entry[0] is Vector3i) or not _is_safe_vector3i(entry[0]) or not _is_safe_block_id(int(entry[1])):
            continue
        var block_position: Vector3i = entry[0]
        var block_id: int = int(entry[1])
        if not Ref.world.is_position_loaded(block_position):
            continue

        var current_block = Ref.world.get_block_type_at(block_position)
        if block_id <= 0:
            if current_block.id == 0 and current_block.internal_name != "cutscene block":
                continue
            Ref.world.break_block_at(block_position, true, false)
        else:
            if current_block.id == block_id:
                continue
            Ref.world.place_block_at(block_position, ItemMap.map(block_id), true, true)


func _apply_network_water_cells(changes: Array) -> void:
    if not is_instance_valid(Ref.world):
        return
    var applied_change: bool = false
    var dirty_positions: Array = []
    for entry in changes:
        if not (entry is Array) or entry.size() < 2:
            continue
        if not (entry[0] is Vector3i) or not _is_safe_vector3i(entry[0]):
            continue
        var block_position: Vector3i = entry[0]
        var water_level: int = int(entry[1])
        if not Ref.world.is_position_loaded(block_position):
            pending_remote_water_changes[block_position] = water_level
            continue
        Ref.world.place_water_at(block_position, water_level)
        dirty_positions.append(block_position)
        applied_change = true
    if applied_change:
        _invalidate_host_dynamic_cell_caches()
        if multiplayer.is_server():
            _mark_server_dirty_chunks_for_world_positions(get_active_dimension_instance_key(), dirty_positions)
    if applied_change and Ref.world.has_method("queue_coop_dynamic_visual_refresh"):
        Ref.world.queue_coop_dynamic_visual_refresh(2)


func _apply_network_fire_cell(block_position: Vector3i, fire_level: int) -> void:
    if not is_instance_valid(Ref.world):
        return
    if not _is_safe_vector3i(block_position):
        return
    if not Ref.world.is_position_loaded(block_position):
        pending_remote_fire_changes[block_position] = fire_level
        return
    Ref.world.place_fire_at(block_position, fire_level)
    _invalidate_host_dynamic_cell_caches()
    if Ref.world.has_method("queue_coop_dynamic_visual_refresh"):
        Ref.world.queue_coop_dynamic_visual_refresh(1)


func _apply_network_fire_cells(changes: Array) -> void:
    if not is_instance_valid(Ref.world):
        return
    var applied_change: bool = false
    for entry in changes:
        if not (entry is Array) or entry.size() < 2:
            continue
        if not (entry[0] is Vector3i) or not _is_safe_vector3i(entry[0]):
            continue
        var block_position: Vector3i = entry[0]
        var fire_level: int = int(entry[1])
        if not Ref.world.is_position_loaded(block_position):
            pending_remote_fire_changes[block_position] = fire_level
            continue
        Ref.world.place_fire_at(block_position, fire_level)
        applied_change = true
    if applied_change:
        _invalidate_host_dynamic_cell_caches()
    if applied_change and Ref.world.has_method("queue_coop_dynamic_visual_refresh"):
        Ref.world.queue_coop_dynamic_visual_refresh(1)


func _spawn_network_item(item_state, block_position: Vector3i) -> void:
    if item_state == null:
        return
    _remember_server_chunk_ticket("item_drop", 0, get_active_dimension_instance_key(), block_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 18)
    var scene = load(DROPPED_ITEM_SCENE_PATH)
    if not (scene is PackedScene):
        return

    var dropped_item = scene.instantiate()
    if dropped_item == null:
        return

    get_tree().get_root().add_child(dropped_item)
    var drop_uuid: String = _assign_sync_uuid(dropped_item)
    dropped_item.global_position = Vector3(block_position)
    dropped_item.initialize(item_state)
    if multiplayer.is_server() and _has_live_peer():
        _sync_spawn_drop_to_interested_peers(drop_uuid, _serialize_item_state(item_state), dropped_item.global_position, dropped_item.velocity, bool(dropped_item.can_collect), 0, get_active_dimension_instance_key(), true)


func _spawn_break_drops_for_block(block, block_position: Vector3i, pickaxe: bool, axe: bool, shovel: bool, meat: bool, plant: bool) -> void:
    if block == null:
        return
    if block.pickaxe_required and not pickaxe:
        return
    if block.axe_required and not axe:
        return

    var to_drop: Array[ItemState] = []

    if block.drop_item == null and block.drop_loot == null:
        if not block.can_drop:
            return

        var default_state := ItemState.new()
        default_state.initialize(block)
        default_state.count = 1
        to_drop.append(default_state)
    if block.drop_item != null:
        var explicit_state := ItemState.new()
        explicit_state.initialize(block.drop_item)
        explicit_state.count = 1
        to_drop.append(explicit_state)
    if block.drop_loot != null:
        to_drop.append_array(block.drop_loot.realize())

    for item_index in range(to_drop.size()):
        var dropped_state: ItemState = to_drop[item_index]
        if dropped_state == null:
            continue
        var dropped_item = load(DROPPED_ITEM_SCENE_PATH)
        if not (dropped_item is PackedScene):
            return
        var new_item = (dropped_item as PackedScene).instantiate()
        if new_item == null:
            continue
        if to_drop.size() > 1 and new_item is DroppedItem:
            new_item.delay_merge()
        get_tree().get_root().add_child(new_item)
        var drop_uuid: String = _assign_sync_uuid(new_item)
        new_item.global_position = Vector3(block_position)
        new_item.initialize(dropped_state)
        if new_item is DroppedItem:
            new_item.can_collect = true
            new_item.is_collect_delayed = false
            new_item.can_merge = false
            new_item.is_merge_delayed = false
        if multiplayer.is_server() and _has_live_peer():
            _remember_server_chunk_ticket("item_drop", 0, get_active_dimension_instance_key(), new_item.global_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 18)
            _sync_spawn_drop_to_interested_peers(drop_uuid, _serialize_item_state(dropped_state), new_item.global_position, new_item.velocity, bool(new_item.can_collect), 0, get_active_dimension_instance_key(), true)


func _schedule_client_visual_projectile_cleanup(projectile, lifetime: float = VISUAL_PROJECTILE_LIFETIME) -> void:
    if projectile == null or not is_instance_valid(projectile) or get_tree() == null:
        return
    var cleanup_timer: SceneTreeTimer = get_tree().create_timer(lifetime, false)
    cleanup_timer.timeout.connect(func() -> void:
        if is_instance_valid(projectile):
            _queue_runtime_node_for_cleanup(projectile)
    )


func _disable_client_visual_projectile_damage(root: Node) -> void:
    if root == null or not is_instance_valid(root):
        return

    root.set_meta("coop_visual_only_projectile", true)
    if _object_has_property(root, "entity_owner"):
        root.set("entity_owner", null)
    if _object_has_property(root, "damage"):
        root.set("damage", 0)

    if root is CollisionObject3D:
        root.collision_layer = 0
        root.collision_mask = 0
    if root is Area3D:
        root.monitoring = false
        root.monitorable = false
    elif root is RayCast3D:
        root.enabled = false
        root.collision_mask = 0
    elif root is CollisionShape3D:
        root.disabled = true
    elif root is CollisionPolygon3D:
        root.disabled = true

    for child in root.get_children():
        _disable_client_visual_projectile_damage(child)


func _spawn_client_visual_projectile(scene_path: String):
    var scene = load(scene_path)
    if not (scene is PackedScene):
        return null

    var projectile = scene.instantiate()
    if projectile == null:
        return null

    _disable_client_visual_projectile_damage(projectile)
    get_tree().get_root().add_child(projectile)
    _schedule_client_visual_projectile_cleanup(projectile)
    return projectile


func _spawn_client_visual_ball_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    var projectile = _spawn_client_visual_projectile(VISUAL_BALL_SCENE_PATH)
    if projectile == null:
        return

    if projectile is Node3D:
        projectile.global_position = start_position
    elif "global_position" in projectile:
        projectile.global_position = start_position

    if "linear_velocity" in projectile:
        projectile.linear_velocity = linear_velocity
    elif "velocity" in projectile:
        projectile.velocity = linear_velocity


func _spawn_client_visual_heart_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    var projectile = _spawn_client_visual_projectile(VISUAL_HEART_SCENE_PATH)
    if projectile == null:
        return

    if projectile is Node3D:
        projectile.global_position = start_position
    elif "global_position" in projectile:
        projectile.global_position = start_position

    if "linear_velocity" in projectile:
        projectile.linear_velocity = linear_velocity
    elif "velocity" in projectile:
        projectile.velocity = linear_velocity


func _spawn_client_visual_blast(start_position: Vector3, holder_velocity: Vector3, direction: Vector3) -> void:
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return

    var projectile = _spawn_client_visual_projectile(VISUAL_BLAST_SCENE_PATH)
    if projectile == null:
        return

    if projectile is Node3D:
        projectile.global_position = start_position
    elif "global_position" in projectile:
        projectile.global_position = start_position

    if projectile.has_method("shoot"):
        projectile.shoot(holder_velocity, normalized_direction)
    elif "velocity" in projectile:
        projectile.velocity = holder_velocity + normalized_direction * _resolve_object_float_property(projectile, ["speed"], 12.0)


func _spawn_client_visual_bolt(start_position: Vector3, direction: Vector3) -> void:
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return

    var projectile = _spawn_client_visual_projectile(VISUAL_BOLT_SCENE_PATH)
    if projectile == null:
        return

    if projectile is Node3D:
        projectile.global_position = start_position
    elif "global_position" in projectile:
        projectile.global_position = start_position

    if projectile.has_method("fire"):
        projectile.fire(normalized_direction, true)
    elif "direction" in projectile:
        projectile.direction = normalized_direction
    elif "velocity" in projectile:
        projectile.velocity = normalized_direction * _resolve_object_float_property(projectile, ["speed"], 9.0)


func broadcast_host_visual_ball_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    if not multiplayer.is_server() or not _has_live_peer():
        return
    sync_host_visual_ball_throw.rpc(start_position, linear_velocity)


func broadcast_host_visual_heart_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    if not multiplayer.is_server() or not _has_live_peer():
        return
    sync_host_visual_heart_throw.rpc(start_position, linear_velocity)


func broadcast_host_visual_blast(start_position: Vector3, holder_velocity: Vector3, direction: Vector3) -> void:
    if not multiplayer.is_server() or not _has_live_peer():
        return
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return
    sync_host_visual_blast.rpc(start_position, holder_velocity, normalized_direction)


func broadcast_host_visual_bolt(start_position: Vector3, direction: Vector3) -> void:
    if not multiplayer.is_server() or not _has_live_peer():
        return
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return
    sync_host_visual_bolt.rpc(start_position, normalized_direction)


func send_guest_visual_ball_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    if multiplayer.is_server() or not _has_live_peer() or _is_local_world_authority() or _is_client_gameplay_locked():
        return
    request_guest_visual_ball_throw.rpc_id(1, start_position, linear_velocity)


func send_guest_visual_heart_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    if multiplayer.is_server() or not _has_live_peer() or _is_local_world_authority() or _is_client_gameplay_locked():
        return
    request_guest_visual_heart_throw.rpc_id(1, start_position, linear_velocity)


func send_guest_visual_blast(start_position: Vector3, holder_velocity: Vector3, direction: Vector3) -> void:
    if multiplayer.is_server() or not _has_live_peer() or _is_local_world_authority() or _is_client_gameplay_locked():
        return
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return
    request_guest_visual_blast.rpc_id(1, start_position, holder_velocity, normalized_direction)


func send_guest_visual_bolt(start_position: Vector3, direction: Vector3) -> void:
    if multiplayer.is_server() or not _has_live_peer() or _is_local_world_authority() or _is_client_gameplay_locked():
        return
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return
    request_guest_visual_bolt.rpc_id(1, start_position, normalized_direction)


@rpc("authority", "call_remote", "unreliable")
func sync_host_visual_ball_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    if multiplayer.is_server() or receiving_host_world or _is_local_world_authority():
        return
    _mark_host_contact()
    if not _is_safe_vector3(start_position) or not _is_safe_vector3(linear_velocity):
        return
    _spawn_client_visual_ball_throw(start_position, linear_velocity)


@rpc("authority", "call_remote", "unreliable")
func sync_host_visual_heart_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    if multiplayer.is_server() or receiving_host_world or _is_local_world_authority():
        return
    _mark_host_contact()
    if not _is_safe_vector3(start_position) or not _is_safe_vector3(linear_velocity):
        return
    _spawn_client_visual_heart_throw(start_position, linear_velocity)


@rpc("authority", "call_remote", "unreliable")
func sync_host_visual_blast(start_position: Vector3, holder_velocity: Vector3, direction: Vector3) -> void:
    if multiplayer.is_server() or receiving_host_world or _is_local_world_authority():
        return
    _mark_host_contact()
    if not _is_safe_vector3(start_position) or not _is_safe_vector3(holder_velocity) or not _is_safe_vector3(direction):
        return
    _spawn_client_visual_blast(start_position, holder_velocity, direction)


@rpc("authority", "call_remote", "unreliable")
func sync_host_visual_bolt(start_position: Vector3, direction: Vector3) -> void:
    if multiplayer.is_server() or receiving_host_world or _is_local_world_authority():
        return
    _mark_host_contact()
    if not _is_safe_vector3(start_position) or not _is_safe_vector3(direction):
        return
    _spawn_client_visual_bolt(start_position, direction)


@rpc("any_peer", "call_remote", "unreliable")
func request_guest_visual_ball_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    _spawn_client_visual_ball_throw(start_position, linear_velocity)
    for peer_id in multiplayer.get_peers():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == sender_id:
            continue
        sync_host_visual_ball_throw.rpc_id(int_peer_id, start_position, linear_velocity)


@rpc("any_peer", "call_remote", "unreliable")
func request_guest_visual_heart_throw(start_position: Vector3, linear_velocity: Vector3) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    _spawn_client_visual_heart_throw(start_position, linear_velocity)
    for peer_id in multiplayer.get_peers():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == sender_id:
            continue
        sync_host_visual_heart_throw.rpc_id(int_peer_id, start_position, linear_velocity)


@rpc("any_peer", "call_remote", "unreliable")
func request_guest_visual_blast(start_position: Vector3, holder_velocity: Vector3, direction: Vector3) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return
    _spawn_client_visual_blast(start_position, holder_velocity, normalized_direction)
    for peer_id in multiplayer.get_peers():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == sender_id:
            continue
        sync_host_visual_blast.rpc_id(int_peer_id, start_position, holder_velocity, normalized_direction)


@rpc("any_peer", "call_remote", "unreliable")
func request_guest_visual_bolt(start_position: Vector3, direction: Vector3) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return
    _spawn_client_visual_bolt(start_position, normalized_direction)
    for peer_id in multiplayer.get_peers():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == sender_id:
            continue
        sync_host_visual_bolt.rpc_id(int_peer_id, start_position, normalized_direction)


@rpc("any_peer", "call_remote", "reliable")
func request_guest_bolt_throw(start_position: Vector3, direction: Vector3) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    var normalized_direction: Vector3 = direction.normalized()
    if normalized_direction.is_zero_approx():
        return
    if not _spawn_host_authoritative_bolt_for_peer(sender_id, start_position, normalized_direction):
        return

    for peer_id in multiplayer.get_peers():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == sender_id:
            continue
        sync_host_visual_bolt.rpc_id(int_peer_id, start_position, normalized_direction)


@rpc("any_peer", "call_remote", "reliable")
func request_guest_explosive_throw(scene_path: String, start_position: Vector3, linear_velocity: Vector3) -> void:
    if not multiplayer.is_server():
        return
    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    _spawn_host_authoritative_explosive_for_peer(sender_id, scene_path, start_position, linear_velocity)


@rpc("any_peer", "call_remote", "reliable")
func request_guest_capsule_throw(item_id: int, start_position: Vector3, linear_velocity: Vector3) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0 or item_id <= 0:
        return
    _spawn_host_authoritative_capsule_for_peer(sender_id, item_id, start_position, linear_velocity)


func _apply_client_break_feedback(break_behavior, block_position: Vector3i) -> void:
    if break_behavior.entity == null or break_behavior.entity.disabled or not break_behavior.enabled:
        return

    var block = ItemMap.map(Ref.world.get_block_type_at(block_position).id)
    var held_item = break_behavior.entity.held_item_inventory.items[break_behavior.entity.held_item_index]
    if break_behavior.decrease_held_item_durability and not (held_item != null and ItemMap.map(held_item.id).internal_name == "super drill"):
        if block.pickaxe_affinity and break_behavior.pickaxe or block.axe_affinity and break_behavior.axe or block.shovel_affinity and break_behavior.shovel or block.meat_affinity and break_behavior.meat or block.plant_affinity and break_behavior.plant:
            break_behavior.entity.decrease_held_item_durability(1)

    Steamworks.increment_statistic("blocks_broken")


@rpc("any_peer", "call_remote", "unreliable")
func submit_client_state(sequence: int, active: bool, downed: bool, dimension: int, dimension_instance_key: String, pocket_owner_key: String, position: Vector3, yaw: float, pitch: float, crouching: bool, grounded: bool, move_speed: float, under_water: bool, held_item_id: int, action_state: int, player_name: String, player_key: String, avatar_id: String, skin_color: Color, breaking: bool, break_position: Vector3i, break_block_id: int, break_progress: float) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    var existing_sequence: int = int(peer_states.get(sender_id, {}).get("sequence", -1))
    if sequence < existing_sequence:
        return

    peer_states[sender_id] = {
        "sequence": sequence,
        "active": active,
        "downed": downed,
        "dimension": dimension,
        "dimension_instance_key": dimension_instance_key,
        "pocket_owner_key": pocket_owner_key,
        "position": position,
        "yaw": yaw,
        "pitch": pitch,
        "crouching": crouching,
        "grounded": grounded,
        "move_speed": move_speed,
        "under_water": under_water,
        "held_item_id": held_item_id,
        "action_state": action_state,
        "name": player_name,
        "player_key": player_key,
        "avatar_id": _normalize_avatar_id(avatar_id),
        "skin_color": skin_color,
        "breaking": breaking,
        "break_position": break_position,
        "break_block_id": break_block_id,
        "break_progress": break_progress,
    }
    _refresh_markers(peer_states, multiplayer.get_unique_id())
    if downed:
        _try_begin_double_downed_recovery()


@rpc("any_peer", "call_remote", "reliable")
func submit_client_state_reliable(sequence: int, active: bool, downed: bool, dimension: int, dimension_instance_key: String, pocket_owner_key: String, position: Vector3, yaw: float, pitch: float, crouching: bool, grounded: bool, move_speed: float, under_water: bool, held_item_id: int, action_state: int, player_name: String, player_key: String, avatar_id: String, skin_color: Color, breaking: bool, break_position: Vector3i, break_block_id: int, break_progress: float) -> void:
    submit_client_state(sequence, active, downed, dimension, dimension_instance_key, pocket_owner_key, position, yaw, pitch, crouching, grounded, move_speed, under_water, held_item_id, action_state, player_name, player_key, avatar_id, skin_color, breaking, break_position, break_block_id, break_progress)


@rpc("any_peer", "call_remote", "reliable")
func request_debug_spawn(spawn_id: String, dimension_instance_key: String, spawn_origin: Vector3, look_direction: Vector3) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    if dimension_instance_key != get_active_dimension_instance_key():
        receive_debug_command_status.rpc_id(sender_id, "Spawn failed: join the host's current area first")
        return

    receive_debug_command_status.rpc_id(sender_id, _spawn_debug_entity_from_id(spawn_id, spawn_origin, look_direction))


@rpc("authority", "call_remote", "reliable")
func receive_debug_command_status(message: String) -> void:
    status_message = _safe_network_text(message, CLIENT_SAFE_MAX_COMMAND_RESPONSE_LENGTH)
    _update_status_text()


@rpc("any_peer", "call_remote", "reliable")
func request_drop_item(item_data: PackedInt32Array, spawn_position: Vector3, launch_velocity: Vector3, request_id: int = 0) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    var started_msec: int = Time.get_ticks_msec()
    if sender_id <= 0:
        return
    if _ack_duplicate_item_action_if_seen(sender_id, request_id, "drop", started_msec):
        return
    var item_state = _deserialize_item_state(item_data)
    if item_state == null:
        _ack_item_action(sender_id, request_id, "drop", false, "", "invalid_item", started_msec)
        return

    var scene = load(DROPPED_ITEM_SCENE_PATH)
    if not (scene is PackedScene):
        _ack_item_action(sender_id, request_id, "drop", false, "", "drop_scene_unavailable", started_msec)
        return

    var dropped_item = scene.instantiate()
    if dropped_item == null:
        _ack_item_action(sender_id, request_id, "drop", false, "", "drop_spawn_failed", started_msec)
        return

    get_tree().get_root().add_child(dropped_item)
    var drop_uuid: String = _assign_sync_uuid(dropped_item)
    dropped_item.delay_collect()
    dropped_item.delay_merge()
    dropped_item.global_position = spawn_position
    dropped_item.initialize(item_state)
    dropped_item.global_position = spawn_position + Vector3(0.5, 0.5, 0.5)
    dropped_item.velocity = launch_velocity
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if sender_state.is_empty() and peer_states.has(str(sender_id)):
        sender_state = peer_states[str(sender_id)]
    var sender_instance_key: String = str(sender_state.get("dimension_instance_key", get_active_dimension_instance_key()))
    _remember_server_chunk_ticket("item_drop", sender_id, sender_instance_key, dropped_item.global_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 18)
    var sent_count: int = _sync_spawn_drop_to_interested_peers(drop_uuid, item_data, dropped_item.global_position, dropped_item.velocity, bool(dropped_item.can_collect), sender_id, sender_instance_key, true)
    if dedicated_server_enabled:
        print("[lucid-blocks-coop] Dedicated item_drop spawned request=%s peer=%s uuid=%s sent=%s" % [request_id, sender_id, drop_uuid, sent_count])
    _ack_item_action(sender_id, request_id, "drop", true, drop_uuid, "", started_msec)


@rpc("any_peer", "call_remote", "reliable")
func request_pickup_drop(item_uuid: String, request_id: int = 0) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    var started_msec: int = Time.get_ticks_msec()
    if sender_id <= 0:
        return
    if _ack_duplicate_item_action_if_seen(sender_id, request_id, "pickup", started_msec):
        return

    var dropped_item = _find_host_drop_by_uuid(item_uuid)
    if dropped_item == null or dropped_item.item == null or not dropped_item.can_collect:
        _ack_item_action(sender_id, request_id, "pickup", false, item_uuid, "drop_unavailable", started_msec)
        return

    var item_data: PackedInt32Array = _serialize_item_state(dropped_item.item)
    _remember_server_chunk_ticket("item_pickup", sender_id, get_active_dimension_instance_key(), dropped_item.global_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, false, 12)
    dropped_item.collect()
    host_recent_drop_visibility.erase(item_uuid)
    sync_remove_drop.rpc(item_uuid)
    receive_picked_item.rpc_id(sender_id, item_data)
    _ack_item_action(sender_id, request_id, "pickup", true, item_uuid, "", started_msec)


@rpc("any_peer", "call_remote", "reliable")
func submit_guest_persistent_state(player_key: String, player_name: String, save_data: Dictionary) -> void:
    if not multiplayer.is_server() or player_key == "" or save_data.is_empty():
        return
    _store_guest_persistent_state(player_key, player_name, save_data)


@rpc("any_peer", "call_remote", "reliable")
func submit_guest_world_patch(world_patch: Dictionary) -> void:
    if not multiplayer.is_server() or world_patch.is_empty():
        return
    if SERVER_AUTHORITATIVE_WORLD:
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    var sender_state: Dictionary = peer_states.get(sender_id, {})
    var sender_instance_key: String = str(sender_state.get("dimension_instance_key", ""))
    var patch_instance_key: String = str(world_patch.get("dimension_instance_key", ""))
    if sender_instance_key == "" or patch_instance_key == "" or sender_instance_key != patch_instance_key:
        return

    _merge_world_patch_into_save(world_patch)


@rpc("authority", "call_remote", "reliable")
func request_guest_world_patch_flush(request_id: int, target_instance_key: String) -> void:
    if multiplayer.is_server() or request_id <= 0:
        return

    if target_instance_key != "" and get_active_dimension_instance_key() == target_instance_key:
        if pending_local_world_patch_chunks.is_empty():
            _send_full_local_world_patch_to_host()
        else:
            _flush_pending_local_world_patch_to_host(true)
    confirm_guest_world_patch_flush.rpc_id(1, request_id)


@rpc("any_peer", "call_remote", "reliable")
func confirm_guest_world_patch_flush(request_id: int) -> void:
    if not multiplayer.is_server() or request_id <= 0:
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    var pending_acks: Variant = pending_guest_world_patch_flush_acks.get(request_id, null)
    if not (pending_acks is Dictionary):
        return

    pending_acks.erase(sender_id)
    if pending_acks.is_empty():
        pending_guest_world_patch_flush_acks.erase(request_id)


@rpc("any_peer", "call_remote", "reliable")
func submit_guest_authoritative_entities(player_key: String, dimension_instance_key: String, entity_bundles: Array) -> void:
    if not multiplayer.is_server() or player_key == "" or dimension_instance_key == "":
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if not _is_peer_state_same_instance(sender_state, dimension_instance_key):
        return

    _store_guest_authoritative_entities(player_key, dimension_instance_key, entity_bundles)


@rpc("any_peer", "call_remote", "reliable")
func request_guest_persistent_state(player_key: String, player_name: String) -> void:
    if not multiplayer.is_server() or player_key == "":
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    var guest_data: Dictionary = _get_guest_persistent_state(player_key)
    if guest_data.is_empty():
        Ref.save_file_manager.loaded_file.set_data("coop/players/%s/name" % player_key, player_name, true)
    print("[lucid-blocks-coop] sending guest persistent state to peer %s empty=%s" % [sender_id, str(guest_data.is_empty())])
    receive_guest_persistent_state.rpc_id(sender_id, guest_data)


@rpc("authority", "call_remote", "reliable")
func receive_guest_persistent_state(save_data: Dictionary) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    print("[lucid-blocks-coop] received guest persistent state empty=%s" % str(save_data.is_empty()))
    if save_data.is_empty():
        _initialize_new_guest_profile()
    else:
        if JSON.stringify(save_data).length() > CLIENT_SAFE_MAX_SNAPSHOT_DECOMPRESSED_BYTES:
            return
        var sanitized: Variant = _sanitize_network_save_data(save_data)
        if sanitized is Dictionary:
            var sanitized_data: Dictionary = sanitized
            _apply_received_guest_state(sanitized_data)


@rpc("any_peer", "call_remote", "reliable")
func request_place_block(dimension_instance_key: String, block_position: Vector3i, block_id: int, world_patch: Dictionary = {}, request_id: int = 0) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    var started_msec: int = Time.get_ticks_msec()
    if sender_id <= 0:
        return
    if _ack_duplicate_block_action_if_seen(sender_id, request_id, "place", started_msec):
        return
    var active_dimension_key: String = get_active_dimension_instance_key()
    if dimension_instance_key != active_dimension_key:
        _ack_block_action(sender_id, request_id, "place", false, dimension_instance_key, block_position, block_id, "wrong_dimension", started_msec)
        return
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if not _is_peer_state_same_instance(sender_state, active_dimension_key):
        _ack_block_action(sender_id, request_id, "place", false, active_dimension_key, block_position, block_id, "peer_not_in_instance", started_msec)
        return
    _remember_server_chunk_ticket("block_place", sender_id, active_dimension_key, block_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 30)
    if not is_instance_valid(Ref.world):
        _ack_block_action(sender_id, request_id, "place", false, active_dimension_key, block_position, block_id, "world_unavailable", started_msec)
        return

    var is_loaded: bool = Ref.world.is_position_loaded(block_position)
    if is_loaded:
        _apply_network_place(block_position, block_id)
    else:
        if _can_defer_dedicated_world_action(sender_id, active_dimension_key):
            dedicated_block_action_deferred_count += 1
            _focus_dedicated_world_load_on_block(sender_id, block_position)
            _apply_dedicated_place_when_loaded.call_deferred(sender_id, active_dimension_key, block_position, block_id, request_id, started_msec)
            return
        if SERVER_AUTHORITATIVE_WORLD:
            _ack_block_action(sender_id, request_id, "place", false, active_dimension_key, block_position, block_id, "chunk_not_loaded", started_msec)
            _send_world_snapshot_to_peer.call_deferred(sender_id)
            return
        _remove_saved_preserve_node_at_position(block_position)
        _apply_world_patch_locally(world_patch)
        _upsert_saved_living_block_at_position(block_position, block_id)

    sync_place_block.rpc(active_dimension_key, block_position, block_id, _get_living_block_scene_path(block_id))
    _ack_block_action(sender_id, request_id, "place", true, active_dimension_key, block_position, block_id, "", started_msec)


func _apply_dedicated_place_when_loaded(sender_id: int, dimension_instance_key: String, block_position: Vector3i, block_id: int, request_id: int = 0, started_msec: int = 0) -> void:
    var loaded: bool = await _await_dedicated_block_loaded(sender_id, dimension_instance_key, block_position)
    if not loaded:
        _ack_block_action(sender_id, request_id, "place", false, dimension_instance_key, block_position, block_id, "load_timeout", started_msec)
        _send_world_snapshot_to_peer.call_deferred(sender_id)
        return
    if not _is_dedicated_sender_still_valid(sender_id, dimension_instance_key):
        _ack_block_action(sender_id, request_id, "place", false, dimension_instance_key, block_position, block_id, "sender_invalid", started_msec)
        return
    if not is_instance_valid(Ref.world):
        _ack_block_action(sender_id, request_id, "place", false, dimension_instance_key, block_position, block_id, "world_unavailable", started_msec)
        return

    _apply_network_place(block_position, block_id)
    sync_place_block.rpc(dimension_instance_key, block_position, block_id, _get_living_block_scene_path(block_id))
    _ack_block_action(sender_id, request_id, "place", true, dimension_instance_key, block_position, block_id, "", started_msec)


@rpc("any_peer", "call_remote", "reliable")
func request_host_world_snapshot() -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    print("[lucid-blocks-coop] Peer %s requested server world snapshot" % sender_id)
    _send_world_snapshot_to_peer.call_deferred(sender_id)


@rpc("any_peer", "call_remote", "reliable")
func request_dimension_world_snapshot(target_dimension: int, target_pocket_owner_key: String = "") -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    _send_requested_dimension_world_snapshot.call_deferred(sender_id, target_dimension, target_pocket_owner_key)


@rpc("any_peer", "call_remote", "reliable")
func request_group_dimension_travel(target_dimension: int, target_pocket_owner_key: String = "", immediate: bool = false, white_close: bool = false) -> void:
    if not multiplayer.is_server() or group_dimension_transfer_in_progress:
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if sender_state.is_empty() or not bool(sender_state.get("active", false)):
        return
    if not _is_peer_state_same_instance(sender_state, get_active_dimension_instance_key()):
        return

    _travel_group_to_dimension_async.call_deferred(target_dimension, immediate, white_close, target_pocket_owner_key)


@rpc("authority", "call_remote", "reliable")
func begin_host_world_snapshot(register_json: String, chunk_count: int, host_position: Vector3, follow_host_position: bool = false) -> void:
    if multiplayer.is_server():
        return

    _mark_host_contact()
    if register_json.length() > CLIENT_SAFE_MAX_REGISTER_JSON_BYTES or chunk_count <= 0 or chunk_count > CLIENT_SAFE_MAX_SNAPSHOT_CHUNKS or not _is_safe_vector3(host_position):
        _handle_host_world_snapshot_failure("Rejected unsafe host world snapshot")
        return

    incoming_snapshot_register_json = register_json
    incoming_snapshot_chunk_count = chunk_count
    incoming_snapshot_chunks.clear()
    incoming_snapshot_host_position = host_position
    incoming_snapshot_follow_host_position = follow_host_position
    receiving_host_world = true
    status_message = "Receiving host world (%s chunks)" % chunk_count
    print("[lucid-blocks-coop] Begin receiving host world chunks=%s register_bytes=%s" % [chunk_count, register_json.length()])
    _update_status_text()


@rpc("authority", "call_remote", "reliable")
func host_world_snapshot_chunk(chunk_index: int, data: PackedByteArray) -> void:
    if multiplayer.is_server() or not receiving_host_world:
        return

    _mark_host_contact()
    if chunk_index < 0 or chunk_index >= incoming_snapshot_chunk_count or data.size() > SNAPSHOT_CHUNK_SIZE:
        _handle_host_world_snapshot_failure("Rejected unsafe host world chunk")
        return
    var total_bytes: int = data.size()
    for chunk in incoming_snapshot_chunks.values():
        if chunk is PackedByteArray:
            total_bytes += (chunk as PackedByteArray).size()
    if total_bytes > CLIENT_SAFE_MAX_SNAPSHOT_COMPRESSED_BYTES:
        _handle_host_world_snapshot_failure("Host world snapshot is too large")
        return

    incoming_snapshot_chunks[chunk_index] = data
    status_message = "Receiving host world (%s/%s)" % [incoming_snapshot_chunks.size(), incoming_snapshot_chunk_count]
    if incoming_snapshot_chunk_count <= 8 or incoming_snapshot_chunks.size() == incoming_snapshot_chunk_count or incoming_snapshot_chunks.size() % 8 == 0:
        print("[lucid-blocks-coop] Receiving host world %s/%s" % [incoming_snapshot_chunks.size(), incoming_snapshot_chunk_count])
    _update_status_text()


@rpc("authority", "call_remote", "reliable")
func finish_host_world_snapshot() -> void:
    if multiplayer.is_server() or not receiving_host_world:
        return

    _mark_host_contact()

    print("[lucid-blocks-coop] Finish host world snapshot chunks=%s/%s" % [incoming_snapshot_chunks.size(), incoming_snapshot_chunk_count])
    _apply_received_host_world.call_deferred()


@rpc("any_peer", "call_remote", "reliable")
func begin_world_patch(chunk_count: int) -> void:
    return


@rpc("any_peer", "call_remote", "reliable")
func world_patch_chunk(chunk_index: int, data: PackedByteArray) -> void:
    return


@rpc("any_peer", "call_remote", "reliable")
func finish_world_patch() -> void:
    return


func _relay_world_patch_to_matching_peers(world_patch: Dictionary, excluded_peer_id: int = -1) -> void:
    return


@rpc("authority", "call_remote", "reliable")
func sync_place_block(dimension_instance_key: String, block_position: Vector3i, block_id: int, living_block_scene_path: String = "") -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if dimension_instance_key != get_active_dimension_instance_key():
        return
    if not _is_safe_vector3i(block_position) or not _is_safe_block_id(block_id) or not _is_safe_living_block_scene_path_for_block(block_id, living_block_scene_path):
        return
    if is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position):
        var current_block = Ref.world.get_block_type_at(block_position)
        if current_block != null and int(current_block.id) == block_id:
            return
    _apply_network_place(block_position, block_id)
    if not is_instance_valid(Ref.world) or not Ref.world.is_position_loaded(block_position):
        _remove_saved_preserve_node_at_position(block_position)
        if living_block_scene_path != "":
            _upsert_saved_living_block_at_position(block_position, block_id)


@rpc("any_peer", "call_remote", "reliable")
func request_block_resync(dimension_instance_key: String, block_position: Vector3i) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    if dimension_instance_key != get_active_dimension_instance_key():
        return

    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if sender_state.is_empty() or not _is_peer_state_same_instance(sender_state, dimension_instance_key):
        return
    _remember_server_chunk_ticket("block_resync", sender_id, dimension_instance_key, block_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, false, 20)
    if not is_instance_valid(Ref.world):
        return
    if not Ref.world.is_position_loaded(block_position):
        if dedicated_server_enabled and _can_defer_dedicated_world_action(sender_id, dimension_instance_key):
            _send_block_resync_when_loaded.call_deferred(sender_id, dimension_instance_key, block_position)
        return

    _send_block_resync_to_peer(sender_id, dimension_instance_key, block_position)


func _send_block_resync_when_loaded(sender_id: int, dimension_instance_key: String, block_position: Vector3i) -> void:
    var loaded: bool = await _await_dedicated_block_loaded(sender_id, dimension_instance_key, block_position)
    if loaded and _is_dedicated_sender_still_valid(sender_id, dimension_instance_key):
        _send_block_resync_to_peer(sender_id, dimension_instance_key, block_position)


func _send_block_resync_to_peer(peer_id: int, dimension_instance_key: String, block_position: Vector3i) -> void:
    if peer_id <= 0 or not is_instance_valid(Ref.world) or not Ref.world.is_position_loaded(block_position):
        return
    var block = Ref.world.get_block_type_at(block_position)
    var block_id: int = int(block.id) if block != null else 0
    if block_id > 0:
        sync_place_block.rpc_id(peer_id, dimension_instance_key, block_position, block_id, _get_living_block_scene_path(block_id))
    else:
        sync_break_block.rpc_id(peer_id, dimension_instance_key, block_position, _find_saved_preserve_uuid_at_block_position(block_position) != "")


@rpc("any_peer", "call_remote", "reliable")
func request_break_block(dimension_instance_key: String, block_position: Vector3i, broken_block_id: int, pickaxe: bool, axe: bool, shovel: bool, meat: bool, plant: bool, world_patch: Dictionary = {}, request_id: int = 0) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    var started_msec: int = Time.get_ticks_msec()
    if sender_id <= 0:
        return
    if _ack_duplicate_block_action_if_seen(sender_id, request_id, "break", started_msec):
        return
    var active_dimension_key: String = get_active_dimension_instance_key()
    if dimension_instance_key != active_dimension_key:
        _ack_block_action(sender_id, request_id, "break", false, dimension_instance_key, block_position, broken_block_id, "wrong_dimension", started_msec)
        return
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if not _is_peer_state_same_instance(sender_state, active_dimension_key):
        _ack_block_action(sender_id, request_id, "break", false, active_dimension_key, block_position, broken_block_id, "peer_not_in_instance", started_msec)
        return
    _remember_server_chunk_ticket("block_break", sender_id, active_dimension_key, block_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 30)
    if not is_instance_valid(Ref.world):
        _ack_block_action(sender_id, request_id, "break", false, active_dimension_key, block_position, broken_block_id, "world_unavailable", started_msec)
        return

    var broken_block = Ref.world.get_block_type_at(block_position) if Ref.world.is_position_loaded(block_position) else ItemMap.map(broken_block_id)
    if broken_block == null:
        _ack_block_action(sender_id, request_id, "break", false, active_dimension_key, block_position, broken_block_id, "unknown_block", started_msec)
        return
    if Ref.world.is_position_loaded(block_position):
        _apply_network_break(block_position)
    else:
        if _can_defer_dedicated_world_action(sender_id, active_dimension_key):
            dedicated_block_action_deferred_count += 1
            _focus_dedicated_world_load_on_block(sender_id, block_position)
            _apply_dedicated_break_when_loaded.call_deferred(
                sender_id,
                active_dimension_key,
                block_position,
                broken_block_id,
                pickaxe,
                axe,
                shovel,
                meat,
                plant,
                request_id,
                started_msec
            )
            return
        if SERVER_AUTHORITATIVE_WORLD:
            _ack_block_action(sender_id, request_id, "break", false, active_dimension_key, block_position, broken_block_id, "chunk_not_loaded", started_msec)
            _send_world_snapshot_to_peer.call_deferred(sender_id)
            return
        _remove_saved_preserve_node_at_position(block_position)
        _apply_world_patch_locally(world_patch)
    if broken_block != null:
        _spawn_break_drops_for_block(broken_block, block_position, pickaxe, axe, shovel, meat, plant)
    sync_break_block.rpc(active_dimension_key, block_position, _is_living_block_id(broken_block_id) or _find_saved_preserve_uuid_at_block_position(block_position) != "")
    _ack_block_action(sender_id, request_id, "break", true, active_dimension_key, block_position, broken_block_id, "", started_msec)


func _apply_dedicated_break_when_loaded(sender_id: int, dimension_instance_key: String, block_position: Vector3i, broken_block_id: int, pickaxe: bool, axe: bool, shovel: bool, meat: bool, plant: bool, request_id: int = 0, started_msec: int = 0) -> void:
    var loaded: bool = await _await_dedicated_block_loaded(sender_id, dimension_instance_key, block_position)
    if not loaded:
        _ack_block_action(sender_id, request_id, "break", false, dimension_instance_key, block_position, broken_block_id, "load_timeout", started_msec)
        _send_world_snapshot_to_peer.call_deferred(sender_id)
        return
    if not _is_dedicated_sender_still_valid(sender_id, dimension_instance_key):
        _ack_block_action(sender_id, request_id, "break", false, dimension_instance_key, block_position, broken_block_id, "sender_invalid", started_msec)
        return
    if not is_instance_valid(Ref.world):
        _ack_block_action(sender_id, request_id, "break", false, dimension_instance_key, block_position, broken_block_id, "world_unavailable", started_msec)
        return

    var broken_block = Ref.world.get_block_type_at(block_position)
    if broken_block == null or (broken_block.id == 0 and broken_block.internal_name != "cutscene block"):
        sync_break_block.rpc(dimension_instance_key, block_position, false)
        _ack_block_action(sender_id, request_id, "break", false, dimension_instance_key, block_position, broken_block_id, "already_empty", started_msec)
        return

    _apply_network_break(block_position)
    _spawn_break_drops_for_block(broken_block, block_position, pickaxe, axe, shovel, meat, plant)
    sync_break_block.rpc(dimension_instance_key, block_position, _is_living_block_id(broken_block_id) or _find_saved_preserve_uuid_at_block_position(block_position) != "")
    _ack_block_action(sender_id, request_id, "break", true, dimension_instance_key, block_position, broken_block_id, "", started_msec)


@rpc("any_peer", "call_remote", "reliable")
func request_water_cells(dimension_instance_key: String, changes: Array, world_patch: Dictionary = {}) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    var active_dimension_key: String = get_active_dimension_instance_key()
    if dimension_instance_key != active_dimension_key:
        return
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if not _is_peer_state_same_instance(sender_state, active_dimension_key):
        return
    for entry in changes:
        if entry is Array and entry.size() >= 1:
            _remember_server_chunk_ticket("water", sender_id, active_dimension_key, entry[0], DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 15)
    var all_loaded: bool = true
    if not is_instance_valid(Ref.world):
        return
    for entry in changes:
        if not (entry is Array) or entry.size() < 1 or not Ref.world.is_position_loaded(entry[0]):
            all_loaded = false
            break
    if all_loaded:
        _apply_network_water_cells(changes)
    else:
        if SERVER_AUTHORITATIVE_WORLD:
            _send_world_snapshot_to_peer.call_deferred(sender_id)
            return
        _apply_world_patch_locally(world_patch)
    for entry in changes:
        if entry is Array and entry.size() >= 2:
            _record_server_world_cell_journal(sender_id, 0, "water", active_dimension_key, entry[0], {"water_level": int(entry[1])})
    sync_water_cells.rpc(active_dimension_key, changes)


@rpc("authority", "call_remote", "reliable")
func sync_water_cells(dimension_instance_key: String, changes: Array) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if dimension_instance_key != get_active_dimension_instance_key():
        return
    if changes.size() > CLIENT_SAFE_MAX_WORLD_CHANGES:
        return
    for entry in changes:
        if not (entry is Array) or entry.size() < 2 or not (entry[0] is Vector3i) or not _is_safe_vector3i(entry[0]):
            return
    _apply_network_water_cells(changes)


@rpc("any_peer", "call_remote", "reliable")
func request_fire_cell(dimension_instance_key: String, block_position: Vector3i, fire_level: int, world_patch: Dictionary = {}) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    var active_dimension_key: String = get_active_dimension_instance_key()
    if dimension_instance_key != active_dimension_key:
        return
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if not _is_peer_state_same_instance(sender_state, active_dimension_key):
        return
    _remember_server_chunk_ticket("fire", sender_id, active_dimension_key, block_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 15)
    if not is_instance_valid(Ref.world):
        return
    if Ref.world.is_position_loaded(block_position):
        _apply_network_fire_cell(block_position, fire_level)
    else:
        if SERVER_AUTHORITATIVE_WORLD:
            _send_world_snapshot_to_peer.call_deferred(sender_id)
            return
        _apply_world_patch_locally(world_patch)
    _record_server_world_cell_journal(sender_id, 0, "fire", active_dimension_key, block_position, {"fire_level": fire_level})
    sync_fire_cell.rpc(active_dimension_key, block_position, fire_level)


@rpc("any_peer", "call_remote", "reliable")
func request_ignite_entity(target_uuid: String) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0 or target_uuid == "":
        return

    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if sender_state.is_empty():
        return

    var target = _find_existing_entity_by_uuid(target_uuid)
    if target == null or not is_instance_valid(target) or not (target is Entity) or target is Player or is_remote_player_proxy(target):
        return

    var target_entity := target as Entity
    if target_entity.dead or target_entity.disabled or not target_entity.has_node("%Burn"):
        return

    var sender_position: Vector3 = sender_state.get("position", Vector3.ZERO)
    if sender_position.distance_squared_to(target_entity.global_position) > 49.0:
        return

    target_entity.get_node("%Burn").ignite()


@rpc("authority", "call_remote", "reliable")
func sync_fire_cell(dimension_instance_key: String, block_position: Vector3i, fire_level: int) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if dimension_instance_key != get_active_dimension_instance_key():
        return
    if not _is_safe_vector3i(block_position):
        return
    _apply_network_fire_cell(block_position, fire_level)


@rpc("authority", "call_remote", "reliable")
func sync_fire_cells(dimension_instance_key: String, changes: Array) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if dimension_instance_key != get_active_dimension_instance_key():
        return
    if changes.size() > CLIENT_SAFE_MAX_WORLD_CHANGES:
        return
    for entry in changes:
        if not (entry is Array) or entry.size() < 2 or not (entry[0] is Vector3i) or not _is_safe_vector3i(entry[0]):
            return
    _apply_network_fire_cells(changes)


@rpc("any_peer", "call_remote", "reliable")
func request_storage_inventory(dimension_instance_key: String, block_position: Vector3i, serialized_items: Array) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return
    var active_dimension_key: String = get_active_dimension_instance_key()
    if dimension_instance_key != active_dimension_key:
        return
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if not _is_peer_state_same_instance(sender_state, active_dimension_key):
        return
    _remember_server_chunk_ticket("storage", sender_id, active_dimension_key, block_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, false, 12)

    if is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position):
        _apply_storage_inventory_snapshot(block_position, serialized_items)
    else:
        _store_remote_storage_inventory_snapshot_in_save(block_position, serialized_items)
    _record_server_world_cell_journal(sender_id, 0, "storage", active_dimension_key, block_position, {"items": serialized_items})
    sync_storage_inventory.rpc(active_dimension_key, block_position, serialized_items)


@rpc("authority", "call_remote", "reliable")
func sync_storage_inventory(dimension_instance_key: String, block_position: Vector3i, serialized_items: Array) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if dimension_instance_key != get_active_dimension_instance_key():
        return
    if not _is_safe_vector3i(block_position) or serialized_items.size() > CLIENT_SAFE_MAX_STORAGE_ITEMS:
        return
    for item_data in serialized_items:
        if item_data is PackedInt32Array and not (item_data as PackedInt32Array).is_empty() and not _is_safe_item_data(item_data):
            return
    _apply_storage_inventory_snapshot(block_position, serialized_items)


@rpc("authority", "call_remote", "reliable")
func sync_world_changes(dimension_instance_key: String, block_changes: Array, fire_changes: Array) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if dimension_instance_key != get_active_dimension_instance_key():
        return
    if block_changes.size() > CLIENT_SAFE_MAX_WORLD_CHANGES or fire_changes.size() > CLIENT_SAFE_MAX_WORLD_CHANGES:
        return
    for entry in block_changes:
        if not (entry is Array) or entry.size() < 2 or not (entry[0] is Vector3i) or not _is_safe_vector3i(entry[0]) or not _is_safe_block_id(int(entry[1])):
            return
    for entry in fire_changes:
        if not (entry is Array) or entry.size() < 2 or not (entry[0] is Vector3i) or not _is_safe_vector3i(entry[0]):
            return

    _apply_network_block_changes(block_changes)
    for entry in fire_changes:
        if not (entry is Array) or entry.size() < 2:
            continue
        _apply_network_fire_cell(entry[0], int(entry[1]))


@rpc("any_peer", "call_remote", "reliable")
func request_foliage_break(dimension_instance_key: String, block_position: Vector3i, broken_block_id: int, world_patch: Dictionary = {}, request_id: int = 0) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    var started_msec: int = Time.get_ticks_msec()
    if sender_id <= 0:
        return
    if _ack_duplicate_block_action_if_seen(sender_id, request_id, "foliage", started_msec):
        return
    var active_dimension_key: String = get_active_dimension_instance_key()
    if dimension_instance_key != active_dimension_key:
        _ack_block_action(sender_id, request_id, "foliage", false, dimension_instance_key, block_position, broken_block_id, "wrong_dimension", started_msec)
        return
    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if not _is_peer_state_same_instance(sender_state, active_dimension_key):
        _ack_block_action(sender_id, request_id, "foliage", false, active_dimension_key, block_position, broken_block_id, "peer_not_in_instance", started_msec)
        return
    _remember_server_chunk_ticket("foliage", sender_id, active_dimension_key, block_position, DEDICATED_CHUNK_TICKET_HOLD_SEC, true, 25)

    var block: Block = Ref.world.get_block_type_at(block_position) if is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position) else ItemMap.map(broken_block_id)
    if block == null or not block.foliage:
        _ack_block_action(sender_id, request_id, "foliage", false, active_dimension_key, block_position, broken_block_id, "not_foliage", started_msec)
        return

    if is_instance_valid(Ref.world) and Ref.world.is_position_loaded(block_position):
        _apply_network_break(block_position)
    else:
        if _can_defer_dedicated_world_action(sender_id, active_dimension_key):
            dedicated_block_action_deferred_count += 1
            _focus_dedicated_world_load_on_block(sender_id, block_position)
            _apply_dedicated_foliage_break_when_loaded.call_deferred(sender_id, active_dimension_key, block_position, broken_block_id, request_id, started_msec)
            return
        _remove_saved_preserve_node_at_position(block_position)
        _apply_world_patch_locally(world_patch)
    if block.can_drop:
        var new_state := ItemState.new()
        new_state.initialize(block)
        new_state.count = 1
        _spawn_network_item(new_state, block_position)
    sync_break_block.rpc(active_dimension_key, block_position, _is_living_block_id(broken_block_id) or _find_saved_preserve_uuid_at_block_position(block_position) != "")
    _ack_block_action(sender_id, request_id, "foliage", true, active_dimension_key, block_position, broken_block_id, "", started_msec)


func _apply_dedicated_foliage_break_when_loaded(sender_id: int, dimension_instance_key: String, block_position: Vector3i, broken_block_id: int, request_id: int = 0, started_msec: int = 0) -> void:
    var loaded: bool = await _await_dedicated_block_loaded(sender_id, dimension_instance_key, block_position)
    if not loaded:
        _ack_block_action(sender_id, request_id, "foliage", false, dimension_instance_key, block_position, broken_block_id, "load_timeout", started_msec)
        _send_world_snapshot_to_peer.call_deferred(sender_id)
        return
    if not _is_dedicated_sender_still_valid(sender_id, dimension_instance_key):
        _ack_block_action(sender_id, request_id, "foliage", false, dimension_instance_key, block_position, broken_block_id, "sender_invalid", started_msec)
        return
    if not is_instance_valid(Ref.world):
        _ack_block_action(sender_id, request_id, "foliage", false, dimension_instance_key, block_position, broken_block_id, "world_unavailable", started_msec)
        return

    var block: Block = Ref.world.get_block_type_at(block_position)
    if block == null or not block.foliage:
        _ack_block_action(sender_id, request_id, "foliage", false, dimension_instance_key, block_position, broken_block_id, "not_foliage", started_msec)
        return

    _apply_network_break(block_position)
    if block.can_drop:
        var new_state := ItemState.new()
        new_state.initialize(block)
        new_state.count = 1
        _spawn_network_item(new_state, block_position)
    sync_break_block.rpc(dimension_instance_key, block_position, _is_living_block_id(broken_block_id) or _find_saved_preserve_uuid_at_block_position(block_position) != "")
    _ack_block_action(sender_id, request_id, "foliage", true, dimension_instance_key, block_position, broken_block_id, "", started_msec)


@rpc("any_peer", "call_remote", "reliable")
func request_entity_attack(target_uuid: String, damage_position: Vector3, damage: int, knockback_strength: float, fly_strength: float, fire_aspect: bool) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0:
        return

    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if sender_state.is_empty() or not _is_peer_state_same_instance(sender_state, get_active_dimension_instance_key()):
        return

    var attacker = get_remote_player_proxy(sender_id)
    if attacker == null or not is_instance_valid(attacker) or attacker.dead or attacker.disabled:
        return

    var target = _find_existing_entity_by_uuid(target_uuid)
    if target == null or not is_instance_valid(target) or not (target is Entity) or target is Player or is_remote_player_proxy(target):
        return

    var target_entity := target as Entity
    if target_entity.dead or target_entity.disabled or target_entity.direct_damage_cooldown:
        return
    var attacker_position: Vector3 = sender_state.get("position", attacker.global_position)
    if attacker_position.distance_squared_to(target_entity.global_position) > (ENTITY_ATTACK_REQUEST_MAX_DISTANCE + 1.25) * (ENTITY_ATTACK_REQUEST_MAX_DISTANCE + 1.25):
        return

    var actual_damage: int = maxi(1, damage)
    var attacker_velocity: Vector3 = get_attack_impulse_velocity(attacker, float(sender_state.get("move_speed", -1.0)))
    var knockback_velocity: Vector3 = calculate_attack_knockback_velocity(target_entity, attacker_position, attacker_velocity, knockback_strength, fly_strength)
    target_entity.knockback_velocity += knockback_velocity
    target_entity.attacked(attacker, actual_damage)

    if fire_aspect and target_entity.has_node("%Burn"):
        target_entity.get_node("%Burn").ignite()

    if target_entity.has_node("%Bleed"):
        var target_to_attacker: Vector3 = (attacker_position - target_entity.global_position).normalized()
        target_entity.get_node("%Bleed").bleed(damage_position, target_to_attacker, actual_damage)

    confirm_entity_attack.rpc_id(
        sender_id,
        target_uuid,
        target_entity.global_position,
        _get_entity_visual_yaw(target_entity),
        target_entity.movement_velocity,
        target_entity.gravity_velocity,
        target_entity.knockback_velocity,
        target_entity.rope_velocity,
        bool(target_entity.dead),
        bool(target_entity.disabled),
        float(Time.get_ticks_msec()) / 1000.0
    )


@rpc("any_peer", "call_remote", "reliable")
func request_player_attack(target_peer_id: int, damage_position: Vector3, damage: int, knockback_strength: float, fly_strength: float, fire_aspect: bool) -> void:
    if not multiplayer.is_server():
        return

    var sender_id: int = multiplayer.get_remote_sender_id()
    if sender_id <= 0 or target_peer_id <= 0 or sender_id == target_peer_id:
        return

    var sender_state: Dictionary = peer_states.get(sender_id, {})
    if sender_state.is_empty() or not _is_peer_state_same_instance(sender_state, get_active_dimension_instance_key()):
        return

    var attacker = get_remote_player_proxy(sender_id)
    if attacker == null or not is_instance_valid(attacker) or attacker.dead or attacker.disabled:
        return

    var target = Ref.player if target_peer_id == 1 else get_remote_player_proxy(target_peer_id)
    if target == null or not is_instance_valid(target):
        return
    if target_peer_id != 1 and not is_remote_player_proxy(target):
        return
    if bool(target.get("dead")) or bool(target.get("disabled")) or bool(target.get("direct_damage_cooldown")):
        return

    var attacker_position: Vector3 = sender_state.get("position", attacker.global_position)
    if attacker_position.distance_squared_to(target.global_position) > (ENTITY_ATTACK_REQUEST_MAX_DISTANCE + 1.25) * (ENTITY_ATTACK_REQUEST_MAX_DISTANCE + 1.25):
        return

    var actual_damage: int = maxi(1, damage)
    var attacker_velocity: Vector3 = get_attack_impulse_velocity(attacker, float(sender_state.get("move_speed", -1.0)))
    var knockback_velocity: Vector3 = calculate_attack_knockback_velocity(target, attacker_position, attacker_velocity, knockback_strength, fly_strength)

    if target_peer_id == 1:
        _begin_target_direct_damage_cooldown(Ref.player)
        Ref.player.knockback_velocity += knockback_velocity
        Ref.player.attacked(attacker, actual_damage)
        if Ref.player.has_node("%Bleed"):
            var target_to_attacker: Vector3 = (attacker_position - Ref.player.global_position).normalized()
            Ref.player.get_node("%Bleed").bleed(damage_position, target_to_attacker, actual_damage)
        if fire_aspect and Ref.player.has_node("%Burn"):
            Ref.player.get_node("%Burn").ignite()
        return

    sync_host_attack_on_remote_player(attacker, target, damage_position, actual_damage, knockback_strength, fly_strength, fire_aspect)


@rpc("authority", "call_remote", "reliable")
func sync_break_block(dimension_instance_key: String, block_position: Vector3i, remove_saved_node: bool = false) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if dimension_instance_key != get_active_dimension_instance_key():
        return
    if not _is_safe_vector3i(block_position):
        return
    _apply_network_break(block_position)
    if remove_saved_node:
        _remove_saved_preserve_node_at_position(block_position)


@rpc("authority", "call_remote", "reliable")
func sync_spawn_drop(drop_uuid: String, item_data: PackedInt32Array, drop_position: Vector3, drop_velocity: Vector3, can_collect: bool = true) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if not _is_safe_uuid_text(drop_uuid) or not _is_safe_item_data(item_data) or not _is_safe_vector3(drop_position) or not _is_safe_vector3(drop_velocity):
        return

    var item_state = _deserialize_item_state(item_data)
    if item_state == null:
        return
    if client_collected_drop_uuids.has(drop_uuid):
        return

    var dropped_item = synced_dropped_items.get(drop_uuid, null)
    if not is_instance_valid(dropped_item):
        dropped_item = _find_existing_drop_by_uuid(drop_uuid)
    if not is_instance_valid(dropped_item):
        dropped_item = _find_matching_predicted_drop(item_state, drop_position)
        if is_instance_valid(dropped_item):
            _configure_client_synced_drop(dropped_item, drop_uuid)
    if not is_instance_valid(dropped_item):
        dropped_item = _spawn_client_synced_drop(drop_uuid, item_state)
    if not is_instance_valid(dropped_item):
        return

    dropped_item.set_meta("coop_direct_spawn_grace_until_ms", Time.get_ticks_msec() + CLIENT_DIRECT_DROP_SYNC_GRACE_MS)
    synced_dropped_items[drop_uuid] = dropped_item
    _apply_client_drop_snapshot(dropped_item, item_state, drop_position, drop_velocity, can_collect)


@rpc("authority", "call_remote", "reliable")
func sync_remove_drop(drop_uuid: String) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    if not _is_safe_uuid_text(drop_uuid):
        return

    client_collected_drop_uuids[drop_uuid] = Time.get_ticks_msec()
    var dropped_item = synced_dropped_items.get(drop_uuid, null)
    if not is_instance_valid(dropped_item):
        dropped_item = _find_existing_drop_by_uuid(drop_uuid)
    if is_instance_valid(dropped_item):
        dropped_item.set_meta("coop_pickup_pending_request", false)
        if dropped_item is DroppedItem and dropped_item.state == DroppedItem.COLLECTED:
            pass
        elif dropped_item.has_method("collect"):
            dropped_item.collect()
        else:
            dropped_item.queue_free()
    synced_dropped_items.erase(drop_uuid)


@rpc("authority", "call_remote", "unreliable")
func server_world_state(sequence: int, drop_snapshots: Array, entity_snapshots: Array = []) -> void:
    if multiplayer.is_server() or receiving_host_world or _is_local_world_authority() or _has_local_guest_entity_authority():
        return
    _mark_host_contact()
    if drop_snapshots.size() > CLIENT_SAFE_MAX_DROP_SNAPSHOTS or entity_snapshots.size() > CLIENT_SAFE_MAX_ENTITY_SNAPSHOTS:
        return
    
    var host_state = peer_states.get(1, {})
    if not host_state.is_empty() and not _does_peer_state_match_instance(host_state, get_active_dimension_instance_key()):
        return
        
    _apply_client_world_state(sequence, drop_snapshots, entity_snapshots)


@rpc("authority", "call_remote", "reliable")
func receive_picked_item(item_data: PackedInt32Array) -> void:
    if multiplayer.is_server():
        return

    _mark_host_contact() 
    if not _is_safe_item_data(item_data):
        return

    var item_state = _deserialize_item_state(item_data)
    if item_state == null or not _can_sample_player():
        return
    if _consume_pending_pickup_receipt(item_state):
        return

    var pickup_behavior = Ref.player.get_node_or_null("%PickUpItems")
    if pickup_behavior != null:
        pickup_behavior.accept_item(item_state, true)


func grant_tiamana_to_attacker(attacker, amount: float, source: Variant = 1) -> bool:
    if amount <= 0.0 or attacker == null or not is_instance_valid(attacker):
        return false
    if attacker == Ref.player:
        return grant_tiamana_to_local_player(amount, source)
    if multiplayer.is_server() and is_remote_player_proxy(attacker):
        var peer_id: int = get_remote_player_proxy_peer_id(attacker)
        if peer_id > 1:
            send_tiamana_reward.rpc_id(peer_id, amount, source)
            return true
    return false


func _sanitize_tiamana_source(source: Variant) -> Variant:
    match typeof(source):
        TYPE_INT:
            return clampi(int(source), 0, 1024)
        TYPE_FLOAT:
            return clampi(int(source), 0, 1024)
        TYPE_STRING:
            return _safe_network_text(str(source), 32)
        TYPE_STRING_NAME:
            return _safe_network_text(str(source), 32)
        TYPE_ARRAY:
            var sanitized_array: Array = []
            var source_array: Array = source
            var limit: int = mini(source_array.size(), 8)
            for index in range(limit):
                var value: Variant = source_array[index]
                match typeof(value):
                    TYPE_INT:
                        sanitized_array.append(clampi(int(value), -1024, 1024))
                    TYPE_FLOAT:
                        sanitized_array.append(clampf(float(value), -1024.0, 1024.0))
                    TYPE_STRING, TYPE_STRING_NAME:
                        sanitized_array.append(_safe_network_text(str(value), 32))
                    TYPE_BOOL:
                        sanitized_array.append(bool(value))
                    TYPE_COLOR:
                        sanitized_array.append(value)
                    _:
                        pass
            return sanitized_array if not sanitized_array.is_empty() else 1
        _:
            return 1


func grant_tiamana_to_local_player(amount: float, source: Variant = 1) -> bool:
    if amount <= 0.0 or not _can_sample_player():
        return false
    var local_level = Ref.player.get_node_or_null("%Level")
    if local_level == null or not local_level.has_method("give_tiamana"):
        return false
    local_level.give_tiamana(amount, _sanitize_tiamana_source(source))
    if _has_live_peer() and not multiplayer.is_server():
        _send_persistent_state_to_host(true)
    return true


func grant_hate_to_attacker(attacker, amount: int = 1) -> bool:
    if amount == 0 or attacker == null or not is_instance_valid(attacker):
        return false
    if attacker == Ref.player:
        return grant_player_stat_to_local_player("hate", amount)
    if multiplayer.is_server() and is_remote_player_proxy(attacker):
        var peer_id: int = get_remote_player_proxy_peer_id(attacker)
        if peer_id > 1:
            receive_player_stat_reward.rpc_id(peer_id, "hate", amount)
            return true
    return false


func grant_player_stat_to_local_player(stat_name: String, amount: int) -> bool:
    if amount == 0 or not _can_sample_player():
        return false
    match stat_name:
        "hate":
            Ref.player.hate += amount
        "faith":
            Ref.player.faith += amount
        "lust":
            Ref.player.lust += amount
        _:
            return false
    if _has_live_peer() and not multiplayer.is_server():
        _send_persistent_state_to_host(true)
    return true


@rpc("authority", "call_remote", "reliable")
func send_tiamana_reward(amount: float, source: Variant = 1) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    amount = clampf(amount, 0.0, 100000.0)
    grant_tiamana_to_local_player(amount, _sanitize_tiamana_source(source))


@rpc("authority", "call_remote", "reliable")
func receive_player_stat_reward(stat_name: String, amount: int) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    stat_name = _safe_network_text(stat_name, 32)
    amount = clampi(amount, -100000, 100000)
    if not _can_sample_player() or amount == 0:
        return
    grant_player_stat_to_local_player(stat_name, amount)


@rpc("authority", "call_remote", "reliable")
func receive_remote_player_attack(attacker_uuid: String, attacker_position: Vector3, attacker_velocity: Vector3, damage_position: Vector3, damage: int, knockback_strength: float, fly_strength: float, fire_aspect: bool) -> void:
    if multiplayer.is_server():
        return

    _mark_host_contact()
    if attacker_uuid != "" and not _is_safe_uuid_text(attacker_uuid):
        return
    if not _is_safe_vector3(attacker_position) or not _is_safe_vector3(attacker_velocity) or not _is_safe_vector3(damage_position):
        return
    attacker_velocity = _clamp_safe_vector3(attacker_velocity)
    damage = clampi(damage, 0, CLIENT_SAFE_MAX_PLAYER_DAMAGE)
    knockback_strength = clampf(knockback_strength, 0.0, CLIENT_SAFE_MAX_KNOCKBACK)
    fly_strength = clampf(fly_strength, 0.0, 8.0)

    if not _can_sample_player() or Ref.player.dead or Ref.player.disabled:
        return

    var attacker = _find_client_synced_entity_by_uuid(attacker_uuid) if attacker_uuid != "" else null

    var horizontal_kb: Vector3 = Ref.player.global_position - attacker_position
    horizontal_kb.y = 0.0
    if not horizontal_kb.is_zero_approx():
        horizontal_kb = horizontal_kb.normalized()

    Ref.player.knockback_velocity += 0.45 * attacker_velocity + horizontal_kb * knockback_strength
    Ref.player.knockback_velocity.y += knockback_strength * Ref.player.jump_modifier * fly_strength * (0.5 if not Ref.player.is_on_floor() else 1.0)
    Ref.player.attacked(attacker, maxi(1, damage))
    play_local_damage_feedback(maxi(1, damage))

    if Ref.player.has_node("%Bleed"):
        var target_to_attacker: Vector3 = (attacker_position - Ref.player.global_position).normalized()
        Ref.player.get_node("%Bleed").bleed(damage_position, target_to_attacker, maxi(1, damage))

    if fire_aspect and Ref.player.has_node("%Burn"):
        Ref.player.get_node("%Burn").ignite()


@rpc("authority", "call_remote", "reliable")
func receive_remote_player_direct_hit(attacker_uuid: String, attacker_position: Vector3, knockback_delta: Vector3, damage_position: Vector3, damage: int, fire_aspect: bool = false) -> void:
    if multiplayer.is_server():
        return

    _mark_host_contact()
    if attacker_uuid != "" and not _is_safe_uuid_text(attacker_uuid):
        return
    if not _is_safe_vector3(attacker_position) or not _is_safe_vector3(knockback_delta) or not _is_safe_vector3(damage_position):
        return
    knockback_delta = _clamp_safe_vector3(knockback_delta)
    damage = clampi(damage, 0, CLIENT_SAFE_MAX_PLAYER_DAMAGE)

    if not _can_sample_player() or Ref.player.dead or Ref.player.disabled:
        return

    var attacker = _find_client_synced_entity_by_uuid(attacker_uuid) if attacker_uuid != "" else null
    Ref.player.knockback_velocity += knockback_delta
    Ref.player.attacked(attacker, damage)

    if damage > 0:
        play_local_damage_feedback(damage)
        if Ref.player.has_node("%Bleed"):
            var target_to_attacker: Vector3 = (attacker_position - Ref.player.global_position).normalized()
            Ref.player.get_node("%Bleed").bleed(damage_position, target_to_attacker, damage)
        if fire_aspect and Ref.player.has_node("%Burn"):
            Ref.player.get_node("%Burn").ignite()


@rpc("authority", "call_remote", "reliable")
func confirm_entity_attack(target_uuid: String, entity_position: Vector3, entity_yaw: float, movement_velocity: Vector3, gravity_velocity: Vector3, knockback_velocity: Vector3, rope_velocity: Vector3, dead: bool, disabled: bool, server_time: float) -> void:
    if multiplayer.is_server():
        return

    _mark_host_contact()
    if not _is_safe_uuid_text(target_uuid) or not _is_safe_vector3(entity_position):
        return
    movement_velocity = _clamp_safe_vector3(movement_velocity)
    gravity_velocity = _clamp_safe_vector3(gravity_velocity)
    knockback_velocity = _clamp_safe_vector3(knockback_velocity)
    rope_velocity = _clamp_safe_vector3(rope_velocity)

    var target = _find_client_synced_entity_by_uuid(target_uuid)
    if target == null or not is_instance_valid(target):
        return

    if target is Entity:
        _apply_client_entity_authoritative_lifecycle(target as Entity, dead, disabled)
    else:
        target.visible = not dead

    var entity_velocity: Vector3 = movement_velocity + gravity_velocity + knockback_velocity + rope_velocity
    _apply_client_entity_snapshot(target, entity_position, entity_yaw, entity_velocity, server_time, movement_velocity, gravity_velocity, knockback_velocity, rope_velocity, client_last_world_state_sequence)


@rpc("authority", "call_remote", "reliable")
func sync_host_respawn_state(respawning: bool) -> void:
    if multiplayer.is_server():
        return
    _mark_host_contact()
    remote_host_respawning = respawning
    if respawning:
        status_message = "Host respawning"
    elif status_message == "Host respawning":
        status_message = "Host respawned"
    _update_status_text()


@rpc("authority", "call_remote", "unreliable")
func server_snapshot(snapshot_sequence: int, snapshot: Array) -> void:
    if multiplayer.is_server():
        return

    _mark_host_contact()
    if snapshot_sequence < last_received_host_snapshot_sequence:
        return
    if snapshot.size() > CLIENT_SAFE_MAX_PEER_SNAPSHOT_ENTRIES:
        return
    last_received_host_snapshot_sequence = snapshot_sequence

    peer_states.clear()
    for entry in snapshot:
        if not (entry is Array) or entry.size() < 23:
            continue
        if not (entry[6] is Vector3) or not (entry[18] is Color) or not (entry[20] is Vector3i):
            continue
        if not _is_safe_vector3(entry[6]) or not _is_safe_vector3i(entry[20]):
            continue

        peer_states[int(entry[0])] = {
            "active": bool(entry[1]),
            "downed": bool(entry[2]),
            "dimension": int(entry[3]),
            "dimension_instance_key": str(entry[4]),
            "pocket_owner_key": str(entry[5]),
            "position": entry[6],
            "yaw": float(entry[7]),
            "pitch": float(entry[8]),
            "crouching": bool(entry[9]),
            "grounded": bool(entry[10]),
            "move_speed": float(entry[11]),
            "under_water": bool(entry[12]),
            "held_item_id": int(entry[13]),
            "action_state": int(entry[14]),
            "name": _safe_network_text(str(entry[15]), 64),
            "player_key": _safe_network_text(str(entry[16]), 96),
            "avatar_id": _normalize_avatar_id(str(entry[17])),
            "skin_color": entry[18] if entry[18] is Color else Color.WHITE,
            "breaking": bool(entry[19]),
            "break_position": entry[20],
            "break_block_id": int(entry[21]),
            "break_progress": float(entry[22]),
            "dedicated_server": bool(entry[23]) if entry.size() > 23 else false,
        }

    # if not multiplayer.is_server() and not receiving_host_world and _can_sample_player() and peer_states.has(1):
    #     var host_instance_key: String = str(peer_states[1].get("dimension_instance_key", ""))
    #     if host_instance_key != "" and host_instance_key != get_active_dimension_instance_key():
    #         status_message = "Resyncing host world"
    #         _update_status_text()
    #         request_host_world_snapshot.rpc_id(1)
    #         return

    _refresh_markers(peer_states, multiplayer.get_unique_id())


@rpc("authority", "call_remote", "reliable")
func server_snapshot_reliable(snapshot_sequence: int, snapshot: Array) -> void:
    server_snapshot(snapshot_sequence, snapshot)

func _execute_help_command() -> void:
    var commands: Array = ["/whoami", "/ping", "/coords", "/host", "/join", "/steam_host", "/steam_invite", "/tp", "/list", "/home", "/char-select", "/server-commands"]
    if is_avatar_alias_command_enabled():
        commands.append("/avatar")
    if _are_console_debug_commands_enabled() or _is_local_command_admin():
        commands.append_array(["/give", "/gamemode", "/spawn", "/spawnlist", "/spawnmenu", "/time", "/weather", "/kill", "/fly"])
    if _is_local_command_admin():
        commands.append_array(["/wand", "/pos1", "/pos2", "/sel", "/fill", "/clear", "/floor", "/flat", "/border", "/peaceful", "/daylock", "/builder_setup"])
    status_message = "Commands: %s" % " ".join(commands)
    _update_status_text()


func _execute_time_command(parts: PackedStringArray) -> void:
    if not multiplayer.is_server():
        status_message = "Only host can change time"
        _update_status_text()
        return
        
    if parts.size() < 2:
        status_message = "Usage: /time <set|add|query> <value>"
        _update_status_text()
        return

    var action = parts[1].to_lower()
    
    if action == "set":
        if parts.size() < 3:
            status_message = "Usage: /time set <day|night|noon|midnight|value>"
            _update_status_text()
            return
            
        var val_str = parts[2].to_lower()
        var val_target = 0.0
        match val_str:
            "day": val_target = 0.25
            "noon": val_target = 0.5
            "night": val_target = 0.75
            "midnight": val_target = 0.0
            _:
                if val_str.is_valid_float():
                    val_target = float(val_str)
                else:
                    status_message = "Invalid time value"
                    _update_status_text()
                    return
        
        if is_instance_valid(Ref.world):
            # Hacky way to set time, depends on world script
            if "time_of_day" in Ref.world:
                Ref.world.time_of_day = val_target
                status_message = "Time set to " + str(val_target)
            else:
                status_message = "Time not accessible"
                
    elif action == "query":
        if is_instance_valid(Ref.world) and "time_of_day" in Ref.world:
            status_message = "Current time is " + str(Ref.world.time_of_day)
        else:
            status_message = "Time not accessible"
            
    _update_status_text()

func _execute_weather_command(parts: PackedStringArray) -> void:
    if not multiplayer.is_server():
        status_message = "Only host can change weather"
        _update_status_text()
        return
        
    if parts.size() < 2:
        status_message = "Usage: /weather <clear|rain|thunder>"
        _update_status_text()
        return
        
    var action = parts[1].to_lower()
    if is_instance_valid(Ref.weather):
        match action:
            "clear": 
                if Ref.weather.has_method("set_target_intensity"): Ref.weather.set_target_intensity(0.0)
            "rain":
                if Ref.weather.has_method("set_target_intensity"): Ref.weather.set_target_intensity(0.5)
            "thunder":
                if Ref.weather.has_method("set_target_intensity"): Ref.weather.set_target_intensity(1.0)
            _:
                status_message = "Invalid weather type"
                _update_status_text()
                return
        status_message = "Weather set to " + action
    else:
        status_message = "Weather not accessible"
    _update_status_text()

func _execute_kill_command(parts: PackedStringArray) -> void:
    if not multiplayer.is_server():
        status_message = "Only host can kill"
        _update_status_text()
        return
        
    # Just kill yourself for now if no args
    if is_instance_valid(Ref.player):
        if Ref.player.has_method("kill"):
            Ref.player.kill()
        elif Ref.player.has_method("take_damage"):
            Ref.player.take_damage(9999, Vector3.UP)
        status_message = "Oof"
    _update_status_text()
