extends Node


var coop_manager
var coop_native_patch
var coop_native_multi_region_enabled: bool = false
var console_manager
var command_chat_manager


@onready var main = get_tree().get_root().get_node("Main")
@onready var world = get_tree().get_root().get_node("Main/World")
@onready var weather = get_tree().get_root().get_node("Main/World/Weather")
@onready var entity_spawner = get_tree().get_root().get_node("Main/World/EntitySpawner")
@onready var player = get_tree().get_root().get_node("Main/Player")
@onready var player_camera = get_tree().get_root().get_node("Main/Player/%Camera3D")

@onready var sun = get_tree().get_root().get_node("Main/World/Sun")
@onready var sun_box = get_tree().get_root().get_node("Main/World/SunBoxOffset/SunBox")
@onready var sky = get_tree().get_root().get_node("Main/World/SkyBoxOffset/Sky")

@onready var save_file_manager = get_tree().get_root().get_node("Main/%SaveFileManager")
@onready var audio_manager = get_tree().get_root().get_node("Main/AudioManager")
@onready var ambience_manager = get_tree().get_root().get_node("Main/AudioManager/AmbienceManager")
@onready var biome_music_manager = get_tree().get_root().get_node("Main/%BiomeMusicManager")
@onready var preserve_node_manager = get_tree().get_root().get_node("Main/%PreserveNodeManager")
@onready var plot_manager = get_tree().get_root().get_node("Main/%PlotManager")
@onready var boss_manager = get_tree().get_root().get_node("Main/%BossManager")
@onready var discovery_manager = get_tree().get_root().get_node("Main/%DiscoveryManager")

@onready var player_inventory = get_tree().get_root().get_node("Main/%Player/%Inventory")
@onready var player_hotbar = get_tree().get_root().get_node("Main/%Player/%Hotbar")
@onready var player_fuser = get_tree().get_root().get_node("Main/%Player/%Fuser")
@onready var player_fusion_source = get_tree().get_root().get_node("Main/%Player/%FusionSource")
@onready var player_fusion_result = get_tree().get_root().get_node("Main/%Player/%FusionResult")
@onready var player_equipment = get_tree().get_root().get_node("Main/%Player/%Equipment")

@onready var ui = get_tree().get_root().get_node("Main/UI")
@onready var cutscene_layer = get_tree().get_root().get_node("Main/CutsceneLayer")
@onready var trans = get_tree().get_root().get_node("Main/TransitionLayer/Transition")
@onready var environment = get_tree().get_root().get_node("Main/World/MainEnvironment")
@onready var water_filter = get_tree().get_root().get_node("Main/UI/WaterFilter")
@onready var game_menu = get_tree().get_root().get_node("Main/UI/GameMenu")
@onready var cutscene_menu = get_tree().get_root().get_node("Main/UI/CutsceneMenu")
@onready var world_edit_menu = get_tree().get_root().get_node("Main/UI/WorldEditMenu")
@onready var level_up_menu = get_tree().get_root().get_node("Main/UI/LevelUpMenu")
@onready var settings_menu = get_tree().get_root().get_node("Main/UI/SettingsMenu")
@onready var bead_get_menu = get_tree().get_root().get_node("Main/UI/BeadGetMenu")
@onready var challenge_status_menu = get_tree().get_root().get_node("Main/UI/ChallengeStatusMenu")
@onready var dither_filter = get_tree().get_root().get_node("Main/UI/%DitheringFilter")
@onready var shader_loader = get_tree().get_root().get_node("Main/ShaderLoader")
@onready var splash_layer = get_tree().get_root().get_node("Main/SplashLayer")
@onready var on_screen_keyboard = get_tree().get_root().get_node("Main/%OnscreenKeyboard")
@onready var save_notifier = get_tree().get_root().get_node("Main/%SaveNotifier")


func _enter_tree() -> void:
    _apply_dedicated_render_limits()
    _bootstrap_native_patch()


func _ready() -> void:
    print("[lucid-blocks-console] Ref override loaded")
    call_deferred("_bootstrap_coop")
    call_deferred("_bootstrap_console")
    call_deferred("_bootstrap_command_chat")


func _bootstrap_coop() -> void:
    if has_node("LucidBlocksCoop"):
        coop_manager = get_node("LucidBlocksCoop")
        return

    if not ResourceLoader.exists("res://coop_mod/coop_manager.gd"):
        return

    var coop_script = load("res://coop_mod/coop_manager.gd")
    if coop_script == null:
        return

    coop_manager = coop_script.new()
    coop_manager.name = "LucidBlocksCoop"
    add_child(coop_manager)


func _bootstrap_native_patch() -> void:
    var executable_path: String = OS.get_executable_path()
    if executable_path.is_empty():
        return

    var native_patch_dir: String = executable_path.get_base_dir().path_join("coop-native-patch")
    var extension_path: String = native_patch_dir.path_join("coop_native_patch.gdextension")
    if not FileAccess.file_exists(extension_path):
        return

    if not GDExtensionManager.is_extension_loaded(extension_path):
        var status := GDExtensionManager.load_extension(extension_path)
        print("[lucid-blocks-coop] Native patch extension load status: %s" % str(status))

    if ClassDB.class_exists("CoopNativePatch"):
        coop_native_patch = ClassDB.instantiate("CoopNativePatch")
        if coop_native_patch != null and coop_native_patch.has_method("get_status"):
            print("[lucid-blocks-coop] Native patch status: %s" % str(coop_native_patch.call("get_status")))
            _apply_native_patch_config(native_patch_dir.path_join("patch_config.json"))


func _apply_native_patch_config(config_path: String) -> void:
    if coop_native_patch == null:
        return

    var enabled: bool = true
    coop_native_multi_region_enabled = false
    var instance_radius_cap: int = 192
    var render_distance: int = 192
    var dedicated_boot: bool = _is_dedicated_server_boot_arg()
    if FileAccess.file_exists(config_path):
        var config_file := FileAccess.open(config_path, FileAccess.READ)
        if config_file != null:
            var parsed = JSON.parse_string(config_file.get_as_text())
            if typeof(parsed) == TYPE_DICTIONARY:
                var config: Dictionary = parsed
                enabled = bool(config.get("enabled", enabled))
                coop_native_multi_region_enabled = bool(config.get("multi_region_hooks_enabled", coop_native_multi_region_enabled))
                instance_radius_cap = int(config.get("instance_radius_cap", instance_radius_cap))
                render_distance = int(config.get("instantiate_chunks_render_distance", render_distance))

    if not enabled:
        return

    var no_render_ok: bool = false
    if dedicated_boot:
        var dedicated_no_render: bool = _read_dedicated_bool_arg(["--lb-dedicated-no-render", "--dedicated-no-render"], true)
        if dedicated_no_render and coop_native_patch.has_method("set_dedicated_no_render_enabled"):
            no_render_ok = bool(coop_native_patch.call("set_dedicated_no_render_enabled", true))
        var dedicated_load_radius: int = _read_dedicated_int_arg(["--lb-load-radius", "--load-radius"], 16)
        var dedicated_render_distance: int = _read_dedicated_int_arg(["--lb-native-render-distance", "--lb-render-distance"], dedicated_load_radius)
        instance_radius_cap = clampi(dedicated_load_radius, 16, 128)
        render_distance = clampi(dedicated_render_distance, instance_radius_cap, 128)
    else:
        instance_radius_cap = maxi(96, instance_radius_cap)
        render_distance = maxi(96, render_distance)

    render_distance = maxi(render_distance, instance_radius_cap)
    if render_distance % 16 != 0:
        render_distance = (int(render_distance / 16) + 1) * 16

    if not coop_native_patch.has_method("patch_world_streaming_limits"):
        push_error("[lucid-blocks-coop] Loaded native patch extension is missing patch_world_streaming_limits")
        return

    var status: Variant = coop_native_patch.call("get_status") if coop_native_patch.has_method("get_status") else {}
    var can_patch_limits: bool = status is Dictionary and bool(status.get("binary_supported", false))
    var ok: bool = false
    if can_patch_limits:
        ok = bool(coop_native_patch.call("patch_world_streaming_limits", instance_radius_cap, render_distance))
    else:
        print("[lucid-blocks-coop] Native world streaming limit patch skipped; current gdblocks DLL does not match known resize sites.")
    var hook_mode: String = "enabled" if coop_native_multi_region_enabled else "disabled"
    print("[lucid-blocks-coop] Native patch applied=%s hooks=%s no_render=%s cap=%d render_distance=%d" % [str(ok), hook_mode, str(no_render_ok), instance_radius_cap, render_distance])


func _apply_dedicated_render_limits() -> void:
    if not _is_dedicated_server_boot_arg():
        return

    var buffer_size: int = _read_dedicated_int_arg(["--lb-shader-instance-buffer", "--shader-instance-buffer"], 262144)
    buffer_size = clampi(buffer_size, 65536, 1048576)
    ProjectSettings.set_setting("rendering/limits/global_shader_variables/buffer_size", buffer_size)
    ProjectSettings.set_setting("rendering/limits/global_shader_variables/buffer_size_mobile", buffer_size)
    print("[lucid-blocks-coop] Dedicated: shader instance buffer_size=%s." % buffer_size)


func _is_dedicated_server_boot_arg() -> bool:
    var args: Array[String] = _get_all_cmdline_args()
    for raw_arg in args:
        var arg: String = str(raw_arg).strip_edges()
        for name in ["--lb-dedicated", "--lucid-dedicated", "--dedicated"]:
            if arg == name:
                return true
            if arg.begins_with("%s=" % name):
                var value: String = arg.substr(name.length() + 1).strip_edges().to_lower()
                return not ["0", "false", "no", "off"].has(value)
    return false


func _read_dedicated_int_arg(names: Array[String], default_value: int) -> int:
    var args: Array[String] = _get_all_cmdline_args()
    for i in range(args.size()):
        var arg: String = str(args[i]).strip_edges()
        for name in names:
            if arg == name and i + 1 < args.size():
                var next_arg: String = str(args[i + 1]).strip_edges()
                if next_arg.is_valid_int():
                    return int(next_arg)
            if arg.begins_with("%s=" % name):
                var value: String = arg.substr(name.length() + 1).strip_edges()
                if value.is_valid_int():
                    return int(value)
    return default_value


func _read_dedicated_bool_arg(names: Array[String], default_value: bool) -> bool:
    var args: Array[String] = _get_all_cmdline_args()
    for i in range(args.size()):
        var arg: String = str(args[i]).strip_edges()
        for name in names:
            if arg == name:
                return true
            if arg.begins_with("%s=" % name):
                var value: String = arg.substr(name.length() + 1).strip_edges().to_lower()
                if ["1", "true", "yes", "on"].has(value):
                    return true
                if ["0", "false", "no", "off"].has(value):
                    return false
            var negative_name: String = name.substr(2) if name.begins_with("--") else name
            if arg == "--no-%s" % negative_name:
                return false
    return default_value


func _get_all_cmdline_args() -> Array[String]:
    var args: Array[String] = []
    for arg in OS.get_cmdline_args():
        args.append(str(arg))
    for arg in OS.get_cmdline_user_args():
        var user_arg: String = str(arg)
        if not args.has(user_arg):
            args.append(user_arg)
    return args


func _bootstrap_command_chat() -> void:
    if has_node("LucidBlocksCommandChat"):
        command_chat_manager = get_node("LucidBlocksCommandChat")
        return

    var chat_script = load("res://chat_mod/command_chat_manager.gd")
    if chat_script == null:
        return

    command_chat_manager = chat_script.new()
    command_chat_manager.name = "LucidBlocksCommandChat"
    add_child(command_chat_manager)


func _bootstrap_console() -> void:
    if has_node("LucidBlocksConsole"):
        console_manager = get_node("LucidBlocksConsole")
        return

    var console_script = load("res://console_mod/console_manager.gd")
    if console_script == null:
        return

    console_manager = console_script.new()
    console_manager.name = "LucidBlocksConsole"
    add_child(console_manager)
