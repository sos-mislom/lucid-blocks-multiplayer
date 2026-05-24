extends Node

const DEBUG_SPAWN_DISTANCE: float = 6.0
const DEBUG_SPAWN_RESOURCE_DIR: String = "res://main/items/data/spawners"
const WORLD_EDIT_CHUNK_SIZE_X: int = 16
const WORLD_EDIT_CHUNK_SIZE_Z: int = 16
const WORLD_EDIT_DEFAULT_CLEAR_HEIGHT: int = 18
const WORLD_EDIT_DEFAULT_BORDER_HEIGHT: int = 5
const WORLD_EDIT_MAX_BLOCK_OPS: int = 300000
const DEBUG_SPAWN_FALLBACK_IDS: PackedStringArray = [
    "agni", "archangel", "baal", "bee", "blasphemy", "boid", "bubble", "bubblebear", "chicken", "diatom", "egg_bubblebear", "egg_chicken", "fish", "floating_fish", "fruit_girl", "fungus_bubblebear", "gel", "glaggler", "golem", "hamsa", "kali", "kodama", "leviathan", "manikin", "meeshuu", "metal_gel", "metal_golem", "mimic", "mini_gel", "moccos", "ofanim", "plastic_sheep", "preta", "shark", "sheep", "sunny", "vyrm", "wildebeest", "worm", "yhvh"
]

var status_message: String = "Console ready"
var debug_spawn_catalog: Dictionary = {}
var world_edit_pos1: Variant = null
var world_edit_pos2: Variant = null
var builder_peaceful_enabled: bool = false
var builder_day_lock_enabled: bool = false
var builder_peaceful_sweep_timer: float = 0.0


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    set_process(true)
    print("[lucid-blocks-console] Console manager loaded")


func _process(_delta: float) -> void:
    if builder_peaceful_enabled:
        builder_peaceful_sweep_timer -= _delta
        if builder_peaceful_sweep_timer <= 0.0:
            builder_peaceful_sweep_timer = 1.0
            _apply_peaceful_runtime()
    if builder_day_lock_enabled:
        _set_day_time(false)


func execute_command(raw_text: String) -> void:
    var text: String = raw_text.lstrip(" \t\r\n")
    if text == "":
        return

	var parts: PackedStringArray = text.split(" ", false)
	var command: String = parts[0].to_lower()
	match command:
		"/whoami", "/ping", "/coords", "/pos", "/position", "/server-commands", "/server_commands", "/command-policy", "/command_policy", "/tp", "/host", "/lan", "/join", "/steam_host", "/steam-host", "/steam_invite", "/steam-invite", "/invite", "/steam_join", "/steam-join", "/home":
			if _forward_to_coop_command(text):
				return
			_set_status("Multiplayer commands are unavailable")
		"/char-select", "/charselect", "/characters", "/avatar", "/default", "/default_blocky", "/white":
			if _forward_to_coop_command(text):
				return
			_set_status("Multiplayer avatar commands are unavailable")
        "/help":
            _execute_help_command()
        "/give":
            _execute_give_command(parts)
        "/gamemode", "/gm":
            _execute_gamemode_command(parts)
        "/time":
            _execute_time_command(parts)
        "/weather":
            _execute_weather_command(parts)
        "/kill":
            _execute_kill_command()
        "/fly":
            _execute_fly_command()
        "/spawn":
            _execute_spawn_command(parts)
        "/spawnlist":
            _execute_spawnlist_command()
        "/wand":
            _execute_wand_command()
        "/pos1":
            _execute_position_command(parts, 1)
        "/pos2":
            _execute_position_command(parts, 2)
        "/sel":
            _execute_selection_info_command()
        "/fill":
            _execute_fill_command(parts)
        "/clear":
            _execute_clear_command(parts)
        "/floor":
            _execute_floor_command(parts)
        "/flat":
            _execute_flat_command(parts)
        "/border":
            _execute_border_command(parts)
        "/peaceful":
            _execute_peaceful_command(parts)
        "/daylock":
            _execute_daylock_command(parts)
        "/builder_setup":
            _execute_builder_setup_command(parts)
        "/list":
            _set_status("Local player")
        _:
            if not _forward_to_coop_command(text):
                _set_status("Unknown console command: %s" % text)


func get_command_autocomplete_entries(raw_text: String) -> Array:
    var text: String = raw_text.lstrip(" \t\r\n")
    if not text.begins_with("/"):
        return []
    if text == "/":
        return _get_root_command_autocomplete_entries("")

    var body: String = text.substr(1)
    var has_space: bool = body.contains(" ")
    var command_body: String = body.get_slice(" ", 0).to_lower()
    var argument_body: String = ""
    if has_space:
        argument_body = body.substr(command_body.length() + 1).lstrip(" \t\r\n")

	if not has_space:
		return _get_root_command_autocomplete_entries(command_body)

	if _is_coop_forwarded_command_body(command_body):
		return _get_coop_autocomplete_entries(text)

	match command_body:
		"char-select", "charselect", "characters", "avatar":
			return _get_avatar_command_autocomplete_entries(command_body, argument_body)
        "give":
            return _get_give_command_autocomplete_entries(argument_body)
        "gamemode", "gm":
            return _get_gamemode_command_autocomplete_entries(argument_body)
        "time":
            return _get_time_command_autocomplete_entries(argument_body)
        "weather":
            return _get_weather_command_autocomplete_entries(argument_body)
        "spawn":
            return _get_spawn_command_autocomplete_entries(argument_body)
        "fill", "floor", "flat", "border", "builder_setup":
            return _get_block_command_autocomplete_entries(command_body, argument_body)
        "peaceful", "daylock":
            return _get_on_off_command_autocomplete_entries(command_body, argument_body)
    return []


func _execute_help_command() -> void:
	_set_status("Console commands: /help /give /gamemode /time /weather /kill /fly /spawn /spawnlist /wand /pos1 /pos2 /sel /fill /clear /floor /flat /border /peaceful /daylock /builder_setup /list /char-select /default | Multiplayer: /whoami /ping /coords /tp /host /join /home /server-commands")


func _forward_to_coop_command(text: String) -> bool:
	if Ref.coop_manager == null or not Ref.coop_manager.has_method("execute_command"):
		return false
	Ref.coop_manager.execute_command(text)
	return true


func _is_coop_forwarded_command_body(command_body: String) -> bool:
	return [
		"whoami", "ping", "coords", "pos", "position",
		"server-commands", "server_commands", "command-policy", "command_policy",
		"tp", "host", "lan", "join",
		"steam_host", "steam-host", "steam_invite", "steam-invite", "invite", "steam_join", "steam-join",
		"home",
	].has(command_body)


func _get_coop_autocomplete_entries(text: String) -> Array:
	if Ref.coop_manager == null or not Ref.coop_manager.has_method("get_command_autocomplete_entries"):
		return []
	return Ref.coop_manager.get_command_autocomplete_entries(text)


func _execute_give_command(parts: PackedStringArray) -> void:
    if parts.size() < 2:
        _set_status("Usage: /give [amount] <item_name_or_id>")
        return

    var amount: int = 1
    var item_part_index: int = 1
    if parts[1].is_valid_int():
        amount = int(parts[1])
        item_part_index = 2

    if amount <= 0 or parts.size() <= item_part_index:
        _set_status("Usage: /give [amount] <item_name_or_id>")
        return

    if not is_instance_valid(Ref.player):
        _set_status("Cannot give items right now")
        return

    var item_query: String = " ".join(parts.slice(item_part_index, parts.size())).strip_edges()
    var resolved: Dictionary = _resolve_item_query(item_query)
    if resolved.has("error"):
        _set_status(str(resolved.get("error", "Item not found")))
        return

    var item = resolved.get("item", null)
    if item == null:
        _set_status("Item not found: %s" % item_query)
        return

    var give_result: Dictionary = _give_local_item(item, amount)
    var given: int = int(give_result.get("given", 0))
    var remaining: int = int(give_result.get("remaining", amount))
    var actual_name: String = str(resolved.get("display_name", item_query))
    if given <= 0:
        _set_status("No room for %s" % actual_name)
    elif remaining > 0:
        _set_status("Gave %s x%d (%d could not fit)" % [actual_name, given, remaining])
    else:
        _set_status("Gave %s x%d" % [actual_name, given])


func _execute_gamemode_command(parts: PackedStringArray) -> void:
    if parts.size() < 2:
        _set_status("Usage: /gamemode <c|s>")
        return
    if not is_instance_valid(Ref.main) or not is_instance_valid(Ref.player):
        _set_status("Gamemode is unavailable right now")
        return

    var mode: String = str(parts[1]).strip_edges().to_lower()
    match mode:
        "c", "creative", "1":
            _set_session_creative_mode(true)
        "s", "survival", "0":
            _set_session_creative_mode(false)
        _:
            _set_status("Usage: /gamemode <c|s>")


func _set_session_creative_mode(enabled: bool) -> void:
    Ref.main.creative = enabled
    Ref.player.invincible = enabled
    Ref.player.invincible_temporary = false
    if enabled:
        var max_health = Ref.player.get("max_health")
        if max_health != null:
            Ref.player.set("health", max_health)
    elif not enabled:
        Ref.player.flying = false
    _refresh_inventory_screen()
    _set_status("Session gamemode: %s" % ("creative" if enabled else "survival"))


func _execute_time_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can change time")
        return
    if parts.size() < 2:
        _set_status("Usage: /time <set|query> <value>")
        return
    if not is_instance_valid(Ref.world):
        _set_status("Time not accessible")
        return

    var action: String = parts[1].to_lower()
    if action == "query":
        var current_time = Ref.world.get("time_of_day")
        if current_time != null:
            _set_status("Current time is %s" % str(current_time))
        else:
            _set_status("Time not accessible")
        return
    if action != "set" or parts.size() < 3:
        _set_status("Usage: /time set <day|noon|night|midnight|value>")
        return

    var value_text: String = parts[2].to_lower()
    var target: float = 0.0
    match value_text:
        "day":
            target = 0.25
        "noon":
            target = 0.5
        "night":
            target = 0.75
        "midnight":
            target = 0.0
        _:
            if not value_text.is_valid_float():
                _set_status("Invalid time value")
                return
            target = float(value_text)
    if Ref.world.get("time_of_day") != null:
        Ref.world.time_of_day = target
        _set_status("Time set to %s" % str(target))
    else:
        _set_status("Time not accessible")


func _execute_weather_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can change weather")
        return
    if parts.size() < 2:
        _set_status("Usage: /weather <clear|rain|thunder>")
        return
    if not is_instance_valid(Ref.weather) or not Ref.weather.has_method("set_target_intensity"):
        _set_status("Weather not accessible")
        return

    var action: String = parts[1].to_lower()
    match action:
        "clear":
            Ref.weather.set_target_intensity(0.0)
        "rain":
            Ref.weather.set_target_intensity(0.5)
        "thunder":
            Ref.weather.set_target_intensity(1.0)
        _:
            _set_status("Usage: /weather <clear|rain|thunder>")
            return
    _set_status("Weather set to %s" % action)


func _execute_kill_command() -> void:
    if not is_instance_valid(Ref.player):
        _set_status("No player")
        return
    if Ref.player.has_method("kill"):
        Ref.player.kill()
    elif Ref.player.has_method("take_damage"):
        Ref.player.take_damage(9999, Vector3.UP)
    _set_status("Oof")


func _execute_fly_command() -> void:
    if not is_instance_valid(Ref.player):
        _set_status("No player")
        return
    Ref.player.fly_enabled = not Ref.player.fly_enabled
    Ref.player.flying = Ref.player.fly_enabled
    _set_status("Fly mode: %s" % ("ON" if Ref.player.fly_enabled else "OFF"))


func _execute_spawn_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can spawn entities")
        return
    if parts.size() < 2:
        _set_status("Usage: /spawn <mob_id>")
        return
    if not is_instance_valid(Ref.player):
        _set_status("Player not ready for spawning")
        return

    var spawn_id: String = _normalize_id(" ".join(parts.slice(1)).strip_edges())
    if spawn_id == "":
        _set_status("Usage: /spawn <mob_id>")
        return
    var look_direction: Vector3 = Ref.player.get_look_direction() if Ref.player.has_method("get_look_direction") else -Ref.player.global_basis.z
    _set_status(_spawn_entity_from_id(spawn_id, Ref.player.global_position, look_direction))


func _execute_spawnlist_command() -> void:
    var ids: PackedStringArray = _get_spawn_ids()
    if ids.is_empty():
        _set_status("No spawn ids found")
        return
    var preview: PackedStringArray = PackedStringArray()
    for i in range(mini(ids.size(), 10)):
        preview.append(ids[i])
    print("[lucid-blocks-console] spawn ids: %s" % ", ".join(ids))
    _set_status("Spawn ids (%d): %s%s" % [ids.size(), ", ".join(preview), " ..." if ids.size() > 10 else ""])


func _execute_wand_command() -> void:
    _set_status("WorldEdit wand ready: look at a block and use /pos1, /pos2, then /fill <block>, /clear, /floor <block>, /border <block>")


func _execute_position_command(parts: PackedStringArray, slot: int) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can edit the world")
        return
    var position: Variant = null
    if parts.size() >= 4:
        position = _parse_vector3i_parts(parts, 1)
    else:
        position = _get_target_block_position()
    if not (position is Vector3i):
        _set_status("Usage: /pos%s [x y z] or look at a block" % slot)
        return
    if slot == 1:
        world_edit_pos1 = position
    else:
        world_edit_pos2 = position
    _set_status("Position %s set to %s" % [slot, _format_vector3i(position)])


func _execute_selection_info_command() -> void:
    if not _has_world_edit_selection():
        _set_status("No selection. Use /pos1 and /pos2 first.")
        return
    var bounds: Dictionary = _get_selection_bounds()
    var min_pos: Vector3i = bounds["min"]
    var max_pos: Vector3i = bounds["max"]
    var size: Vector3i = max_pos - min_pos + Vector3i.ONE
    _set_status("Selection %s -> %s (%dx%dx%d, %d blocks)" % [
        _format_vector3i(min_pos),
        _format_vector3i(max_pos),
        size.x,
        size.y,
        size.z,
        int(size.x * size.y * size.z),
    ])


func _execute_fill_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can edit the world")
        return
    if not _has_world_edit_selection():
        _set_status("No selection. Use /pos1 and /pos2 first.")
        return
    if parts.size() < 2:
        _set_status("Usage: /fill <block_name_or_id>")
        return
    var block_result: Dictionary = _resolve_block_query(" ".join(parts.slice(1)).strip_edges())
    if block_result.has("error"):
        _set_status(str(block_result.get("error")))
        return
    var bounds: Dictionary = _get_selection_bounds()
    var result: Dictionary = _fill_box(bounds["min"], bounds["max"], block_result.get("block", null), false)
    _set_status("Filled %d blocks with %s%s" % [
        int(result.get("changed", 0)),
        str(block_result.get("display_name", "block")),
        " (%d skipped)" % int(result.get("skipped", 0)) if int(result.get("skipped", 0)) > 0 else "",
    ])


func _execute_clear_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can edit the world")
        return
    if not _has_world_edit_selection():
        _set_status("No selection. Use /pos1 and /pos2 first.")
        return
    var clear_water: bool = parts.size() >= 2 and str(parts[1]).to_lower() == "water"
    var bounds: Dictionary = _get_selection_bounds()
    var result: Dictionary = _fill_box(bounds["min"], bounds["max"], null, clear_water)
    _set_status("Cleared %d blocks%s" % [
        int(result.get("changed", 0)),
        " and water/fire" if clear_water else "",
    ])


func _execute_floor_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can edit the world")
        return
    if not _has_world_edit_selection():
        _set_status("No selection. Use /pos1 and /pos2 first.")
        return
    if parts.size() < 2:
        _set_status("Usage: /floor <block_name_or_id> [y]")
        return
    var y: int = _get_selection_bounds()["min"].y
    var block_query_end: int = parts.size()
    if parts.size() >= 3 and str(parts[parts.size() - 1]).is_valid_int():
        y = int(parts[parts.size() - 1])
        block_query_end = parts.size() - 1
    var block_result: Dictionary = _resolve_block_query(" ".join(parts.slice(1, block_query_end)).strip_edges())
    if block_result.has("error"):
        _set_status(str(block_result.get("error")))
        return
    var bounds: Dictionary = _get_selection_bounds()
    var min_pos: Vector3i = bounds["min"]
    var max_pos: Vector3i = bounds["max"]
    min_pos.y = y
    max_pos.y = y
    var result: Dictionary = _fill_box(min_pos, max_pos, block_result.get("block", null), false)
    _set_status("Floored %d blocks at y=%d with %s" % [int(result.get("changed", 0)), y, str(block_result.get("display_name", "block"))])


func _execute_flat_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can edit the world")
        return
    if not is_instance_valid(Ref.player):
        _set_status("Player not ready")
        return
    var radius_chunks: int = 2
    var floor_y: int = int(floor(Ref.player.global_position.y)) - 1
    var block_query: String = "grass"
    if parts.size() >= 2 and str(parts[1]).is_valid_int():
        radius_chunks = clampi(int(parts[1]), 0, 8)
    if parts.size() >= 3:
        block_query = str(parts[2])
    if parts.size() >= 4 and str(parts[3]).is_valid_int():
        floor_y = int(parts[3])
    var block_result: Dictionary = _resolve_block_query(block_query)
    if block_result.has("error"):
        block_result = _get_fallback_solid_block()
    var area: Dictionary = _get_chunk_square_around_player(radius_chunks)
    var result: Dictionary = _make_flat_area(area["min"], area["max"], floor_y, block_result.get("block", null), WORLD_EDIT_DEFAULT_CLEAR_HEIGHT)
    _set_status("Flat area: %d changed, radius=%d chunks, y=%d" % [int(result.get("changed", 0)), radius_chunks, floor_y])


func _execute_border_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can edit the world")
        return
    var block_query: String = "stone"
    var border_height: int = WORLD_EDIT_DEFAULT_BORDER_HEIGHT
    var min_pos: Vector3i
    var max_pos: Vector3i
    if parts.size() >= 2 and str(parts[1]).is_valid_int():
        var radius_chunks: int = clampi(int(parts[1]), 0, 12)
        var area: Dictionary = _get_chunk_square_around_player(radius_chunks)
        min_pos = area["min"]
        max_pos = area["max"]
        if parts.size() >= 3:
            block_query = str(parts[2])
        if parts.size() >= 4 and str(parts[3]).is_valid_int():
            border_height = clampi(int(parts[3]), 1, 32)
    else:
        if not _has_world_edit_selection():
            _set_status("Usage: /border <radius_chunks> [block] [height] or select /pos1 /pos2 first")
            return
        var bounds: Dictionary = _get_selection_bounds()
        min_pos = bounds["min"]
        max_pos = bounds["max"]
        if parts.size() >= 2:
            block_query = str(parts[1])
        if parts.size() >= 3 and str(parts[2]).is_valid_int():
            border_height = clampi(int(parts[2]), 1, 32)
    var block_result: Dictionary = _resolve_block_query(block_query)
    if block_result.has("error"):
        block_result = _get_fallback_solid_block()
    var base_y: int = int(floor(Ref.player.global_position.y)) if is_instance_valid(Ref.player) else min_pos.y
    var result: Dictionary = _build_border(min_pos, max_pos, base_y, border_height, block_result.get("block", null))
    _set_status("Border built: %d blocks, height=%d" % [int(result.get("changed", 0)), border_height])


func _execute_peaceful_command(parts: PackedStringArray) -> void:
    var enabled: bool = true
    if parts.size() >= 2:
        enabled = _parse_on_off(str(parts[1]), builder_peaceful_enabled)
    builder_peaceful_enabled = enabled
    if enabled:
        _apply_peaceful_runtime()
    _set_status("Peaceful builder mode: %s" % ("ON" if enabled else "OFF"))


func _execute_daylock_command(parts: PackedStringArray) -> void:
    var enabled: bool = true
    if parts.size() >= 2:
        enabled = _parse_on_off(str(parts[1]), builder_day_lock_enabled)
    builder_day_lock_enabled = enabled
    if enabled:
        _set_day_time(true)
    _set_status("Day lock: %s" % ("ON" if enabled else "OFF"))


func _execute_builder_setup_command(parts: PackedStringArray) -> void:
    if not _can_host_modify_world():
        _set_status("Only host can setup builder world")
        return
    var radius_chunks: int = 2
    var floor_y: int = int(floor(Ref.player.global_position.y)) - 1 if is_instance_valid(Ref.player) else 0
    var block_query: String = "grass"
    if parts.size() >= 2 and str(parts[1]).is_valid_int():
        radius_chunks = clampi(int(parts[1]), 0, 8)
    if parts.size() >= 3:
        block_query = str(parts[2])
    if parts.size() >= 4 and str(parts[3]).is_valid_int():
        floor_y = int(parts[3])
    _set_session_creative_mode(true)
    if is_instance_valid(Ref.player):
        Ref.player.fly_enabled = true
        Ref.player.flying = true
    builder_peaceful_enabled = true
    builder_day_lock_enabled = true
    _apply_peaceful_runtime()
    _set_day_time(true)
    if is_instance_valid(Ref.weather) and Ref.weather.has_method("set_target_intensity"):
        Ref.weather.set_target_intensity(0.0)
    var block_result: Dictionary = _resolve_block_query(block_query)
    if block_result.has("error"):
        block_result = _get_fallback_solid_block()
    var area: Dictionary = _get_chunk_square_around_player(radius_chunks)
    var flat_result: Dictionary = _make_flat_area(area["min"], area["max"], floor_y, block_result.get("block", null), WORLD_EDIT_DEFAULT_CLEAR_HEIGHT)
    var border_result: Dictionary = _build_border(area["min"], area["max"], floor_y + 1, WORLD_EDIT_DEFAULT_BORDER_HEIGHT, block_result.get("block", null))
    _set_status("Builder setup ready: flat=%d border=%d radius=%d chunks" % [
        int(flat_result.get("changed", 0)),
        int(border_result.get("changed", 0)),
        radius_chunks,
    ])


func _give_local_item(item, amount: int) -> Dictionary:
    var inventories: Array = _get_player_inventories()
    if inventories.is_empty():
        return {"given": 0, "remaining": amount}

    var remaining: int = amount
    var stack_size: int = maxi(1, int(item.stack_size))
    for inventory in inventories:
        while remaining > 0:
            var item_state := ItemState.new()
            item_state.initialize(item)
            item_state.count = mini(remaining, stack_size)
            var requested_count: int = int(item_state.count)
            var leftover = inventory.accept(item_state)
            var leftover_count: int = int(leftover.count) if leftover != null else 0
            var inserted_count: int = requested_count - leftover_count
            remaining -= inserted_count
            if inserted_count <= 0:
                break

    if is_instance_valid(Ref.player) and Ref.player.has_method("hold_item"):
        Ref.player.hold_item(int(Ref.player.held_item_index))
    _refresh_inventory_screen()
    return {"given": amount - remaining, "remaining": remaining}


func _get_player_inventories() -> Array:
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


func _object_has_property(target: Object, property_name: String) -> bool:
    if target == null:
        return false
    for property_info in target.get_property_list():
        if str(property_info.get("name", "")) == property_name:
            return true
    return false


func _get_resource_property(item, property_name: String, default_value: Variant = null) -> Variant:
    if item == null or not is_instance_valid(item):
        return default_value
    if _object_has_property(item, property_name):
        return item.get(property_name)
    return default_value


func _get_resource_display_name(item, fallback: String = "item") -> String:
    var internal_name: String = str(_get_resource_property(item, "internal_name", fallback))
    return str(_get_resource_property(item, "display_name", internal_name))


func _resolve_item_query(item_query: String) -> Dictionary:
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
                "display_name": _get_resource_display_name(numeric_item, item_query),
            }
        return {"error": "Unknown item id: %d" % numeric_item_id}

    var normalized_query: String = _slugify(item_query)
    if normalized_query == "":
        return {"error": "Usage: /give [amount] <item_name_or_id>"}

    var partial_matches: Array = []
    for item_id in item_map.id_to_resource.keys():
        var item = item_map.id_to_resource[item_id]
        for alias in _get_item_aliases(item):
            if alias == normalized_query:
                return {
                    "item_id": int(item_id),
                    "item": item,
                    "display_name": _get_resource_display_name(item, normalized_query),
                }
            if alias.contains(normalized_query):
                partial_matches.append({
                    "item_id": int(item_id),
                    "item": item,
                    "display_name": _get_resource_display_name(item, normalized_query),
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


func _get_item_aliases(item) -> PackedStringArray:
    var aliases: PackedStringArray = PackedStringArray()
    for raw_name in [_get_resource_display_name(item, ""), str(_get_resource_property(item, "internal_name", ""))]:
        var alias: String = _slugify(raw_name)
        if alias != "" and not aliases.has(alias):
            aliases.append(alias)
    return aliases


func _get_spawn_catalog() -> Dictionary:
    if not debug_spawn_catalog.is_empty():
        return debug_spawn_catalog
    var dir: DirAccess = DirAccess.open(DEBUG_SPAWN_RESOURCE_DIR)
    if dir != null:
        dir.list_dir_begin()
        var file_name: String = dir.get_next()
        while file_name != "":
            if not dir.current_is_dir() and file_name.ends_with(".tres"):
                _register_spawn_resource(file_name)
            file_name = dir.get_next()
        dir.list_dir_end()
    if debug_spawn_catalog.is_empty():
        for spawn_id in DEBUG_SPAWN_FALLBACK_IDS:
            _register_spawn_resource("%s_spawner.tres" % str(spawn_id))
    return debug_spawn_catalog


func _register_spawn_resource(file_name: String) -> void:
    var basename: String = file_name.trim_suffix(".tres")
    if basename.ends_with("_spawner"):
        basename = basename.substr(0, basename.length() - 8)
    elif basename.ends_with("_capsule"):
        basename = basename.substr(0, basename.length() - 8)
    var primary_id: String = _normalize_id(basename)
    if primary_id == "" or debug_spawn_catalog.has(primary_id):
        return
    var resource_path: String = "%s/%s" % [DEBUG_SPAWN_RESOURCE_DIR, file_name]
    if not ResourceLoader.exists(resource_path):
        var capsule_path: String = "%s/%s_capsule.tres" % [DEBUG_SPAWN_RESOURCE_DIR, primary_id]
        if ResourceLoader.exists(capsule_path):
            resource_path = capsule_path
        else:
            return
    var resource = load(resource_path)
    if primary_id != "" and resource is Spawner and str(resource.entity_path) != "":
        debug_spawn_catalog[primary_id] = {
            "resource_path": resource_path,
            "scene_path": str(resource.entity_path),
        }


func _get_spawn_ids() -> PackedStringArray:
    var ids: PackedStringArray = PackedStringArray(_get_spawn_catalog().keys())
    ids.sort()
    return ids


func _resolve_spawn_entry(query: String) -> Dictionary:
    var catalog: Dictionary = _get_spawn_catalog()
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


func _spawn_entity_from_id(spawn_id: String, spawn_origin: Vector3, look_direction: Vector3) -> String:
    var entry: Dictionary = _resolve_spawn_entry(spawn_id)
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
    if is_instance_valid(Ref.world) and Ref.world.has_method("is_position_loaded") and Ref.world.is_position_loaded(spawn_position):
        var attempts: int = 0
        while attempts < 10 and Ref.world.get_block_type_at(spawn_position.floor()).id != 0:
            spawn_position.y += 1.0
            attempts += 1
    entity.global_position = spawn_position
    entity.set_meta("console_runtime_spawned", true)
    get_tree().get_root().add_child(entity)
    if entity.has_method("allow_swarm"):
        entity.allow_swarm()
    return "Spawned %s" % spawn_id


func _parse_vector3i_parts(parts: PackedStringArray, start_index: int) -> Variant:
    if parts.size() < start_index + 3:
        return null
    for offset in range(3):
        if not str(parts[start_index + offset]).is_valid_int():
            return null
    return Vector3i(int(parts[start_index]), int(parts[start_index + 1]), int(parts[start_index + 2]))


func _get_target_block_position() -> Variant:
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


func _has_world_edit_selection() -> bool:
    return world_edit_pos1 is Vector3i and world_edit_pos2 is Vector3i


func _get_selection_bounds() -> Dictionary:
    var a: Vector3i = world_edit_pos1
    var b: Vector3i = world_edit_pos2
    return {
        "min": Vector3i(mini(a.x, b.x), mini(a.y, b.y), mini(a.z, b.z)),
        "max": Vector3i(maxi(a.x, b.x), maxi(a.y, b.y), maxi(a.z, b.z)),
    }


func _format_vector3i(position: Vector3i) -> String:
    return "%d %d %d" % [position.x, position.y, position.z]


func _resolve_block_query(block_query: String) -> Dictionary:
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
            return {"block": numeric_block, "display_name": _get_resource_display_name(numeric_block, query)}
        return {"error": "Unknown block id: %d" % numeric_id}

    var normalized_query: String = _slugify(query)
    var partial_matches: Array = []
    for item_id in item_map.id_to_resource.keys():
        var item = item_map.id_to_resource[item_id]
        if not (item is Block):
            continue
        for alias in _get_item_aliases(item):
            if alias == normalized_query:
                return {"block": item, "display_name": _get_resource_display_name(item, query)}
            if alias.contains(normalized_query):
                partial_matches.append(item)
                break
    if partial_matches.size() == 1:
        var block: Block = partial_matches[0]
        return {"block": block, "display_name": _get_resource_display_name(block, query)}
    if partial_matches.size() > 1:
        var labels: PackedStringArray = PackedStringArray()
        for index in range(mini(5, partial_matches.size())):
            var match_block: Block = partial_matches[index]
            labels.append(_get_resource_display_name(match_block, "block"))
        return {"error": "Multiple blocks match: %s" % ", ".join(labels)}
    return {"error": "Block not found: %s" % query}


func _get_fallback_solid_block() -> Dictionary:
    var item_map = get_tree().root.get_node_or_null("ItemMap")
    if is_instance_valid(item_map) and "id_to_resource" in item_map:
        for preferred in ["grass", "dirt", "stone"]:
            var resolved: Dictionary = _resolve_block_query(preferred)
            if not resolved.has("error"):
                return resolved
        for item_id in item_map.id_to_resource.keys():
            var item = item_map.id_to_resource[item_id]
            if item is Block and not bool(_get_resource_property(item, "foliage", false)) and not bool(_get_resource_property(item, "textureless", false)):
                return {"block": item, "display_name": _get_resource_display_name(item, "block")}
    return {"block": null, "display_name": "air"}


func _count_box_blocks(min_pos: Vector3i, max_pos: Vector3i) -> int:
    return maxi(0, max_pos.x - min_pos.x + 1) * maxi(0, max_pos.y - min_pos.y + 1) * maxi(0, max_pos.z - min_pos.z + 1)


func _fill_box(min_pos: Vector3i, max_pos: Vector3i, block, clear_liquids: bool) -> Dictionary:
    var planned: int = _count_box_blocks(min_pos, max_pos)
    if planned > WORLD_EDIT_MAX_BLOCK_OPS:
        return {"changed": 0, "skipped": planned, "error": "selection_too_large"}
    var changed: int = 0
    var skipped: int = 0
    for y in range(min_pos.y, max_pos.y + 1):
        for z in range(min_pos.z, max_pos.z + 1):
            for x in range(min_pos.x, max_pos.x + 1):
                var position := Vector3i(x, y, z)
                if not _set_world_block(position, block, clear_liquids):
                    skipped += 1
                else:
                    changed += 1
    _notify_world_edit_changed()
    return {"changed": changed, "skipped": skipped}


func _set_world_block(position: Vector3i, block, clear_liquids: bool = false) -> bool:
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


func _make_flat_area(min_area: Vector3i, max_area: Vector3i, floor_y: int, block, clear_height: int) -> Dictionary:
    var floor_min := Vector3i(min_area.x, floor_y, min_area.z)
    var floor_max := Vector3i(max_area.x, floor_y, max_area.z)
    var clear_min := Vector3i(min_area.x, floor_y + 1, min_area.z)
    var clear_max := Vector3i(max_area.x, floor_y + clear_height, max_area.z)
    var clear_result: Dictionary = _fill_box(clear_min, clear_max, null, true)
    var floor_result: Dictionary = _fill_box(floor_min, floor_max, block, true)
    return {
        "changed": int(clear_result.get("changed", 0)) + int(floor_result.get("changed", 0)),
        "skipped": int(clear_result.get("skipped", 0)) + int(floor_result.get("skipped", 0)),
    }


func _build_border(min_area: Vector3i, max_area: Vector3i, base_y: int, height: int, block) -> Dictionary:
    var perimeter_count: int = max(0, (max_area.x - min_area.x + 1) * 2 + (max_area.z - min_area.z - 1) * 2) * height
    if perimeter_count > WORLD_EDIT_MAX_BLOCK_OPS:
        return {"changed": 0, "skipped": perimeter_count, "error": "border_too_large"}
    var changed: int = 0
    var skipped: int = 0
    for y in range(base_y, base_y + height):
        for x in range(min_area.x, max_area.x + 1):
            if _set_world_block(Vector3i(x, y, min_area.z), block, false):
                changed += 1
            else:
                skipped += 1
            if _set_world_block(Vector3i(x, y, max_area.z), block, false):
                changed += 1
            else:
                skipped += 1
        for z in range(min_area.z + 1, max_area.z):
            if _set_world_block(Vector3i(min_area.x, y, z), block, false):
                changed += 1
            else:
                skipped += 1
            if _set_world_block(Vector3i(max_area.x, y, z), block, false):
                changed += 1
            else:
                skipped += 1
    _notify_world_edit_changed()
    return {"changed": changed, "skipped": skipped}


func _get_chunk_square_around_player(radius_chunks: int) -> Dictionary:
    var center_chunk: Vector3i = Ref.world.snap_to_chunk(Ref.player.global_position) if is_instance_valid(Ref.world) and Ref.world.has_method("snap_to_chunk") else Vector3i.ZERO
    var min_x: int = center_chunk.x - radius_chunks * WORLD_EDIT_CHUNK_SIZE_X
    var min_z: int = center_chunk.z - radius_chunks * WORLD_EDIT_CHUNK_SIZE_Z
    var max_x: int = center_chunk.x + (radius_chunks + 1) * WORLD_EDIT_CHUNK_SIZE_X - 1
    var max_z: int = center_chunk.z + (radius_chunks + 1) * WORLD_EDIT_CHUNK_SIZE_Z - 1
    return {
        "min": Vector3i(min_x, 0, min_z),
        "max": Vector3i(max_x, 0, max_z),
    }


func _notify_world_edit_changed() -> void:
    if Ref.coop_manager != null and Ref.coop_manager.has_method("notify_local_world_state_dirty"):
        Ref.coop_manager.notify_local_world_state_dirty([])


func _apply_peaceful_runtime() -> void:
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


func _set_day_time(report: bool) -> void:
    if is_instance_valid(Ref.world) and Ref.world.get("time_of_day") != null:
        Ref.world.time_of_day = 0.25
        if report:
            _set_status("Time locked to day")


func _parse_on_off(value: String, current: bool) -> bool:
    var normalized: String = value.strip_edges().to_lower()
    if ["on", "1", "true", "yes", "enable", "enabled"].has(normalized):
        return true
    if ["off", "0", "false", "no", "disable", "disabled"].has(normalized):
        return false
    return not current


func _get_root_command_autocomplete_entries(query: String) -> Array:
	var commands: Array = [
		{"command": "/help", "hint": "List console commands"},
		{"command": "/whoami", "hint": "Show your server-side player state"},
		{"command": "/ping", "hint": "Ping the server"},
		{"command": "/coords", "hint": "Show local and server coordinates"},
		{"command": "/tp", "hint": "Teleport to a player or coordinates"},
		{"command": "/host", "hint": "Host a LAN session"},
		{"command": "/join", "hint": "Join ip and port"},
		{"command": "/home", "hint": "Teleport to the server home point"},
		{"command": "/server-commands", "hint": "Show or edit server command policy"},
		{"command": "/give", "hint": "Give yourself an item"},
		{"command": "/gamemode", "hint": "Session creative or survival"},
		{"command": "/time", "hint": "Change/query world time"},
		{"command": "/weather", "hint": "Change weather"},
        {"command": "/kill", "hint": "Kill local player"},
        {"command": "/fly", "hint": "Toggle fly mode"},
        {"command": "/spawn", "hint": "Spawn a mob for testing"},
        {"command": "/spawnlist", "hint": "List spawnable mob ids"},
        {"command": "/wand", "hint": "Show builder wand usage"},
        {"command": "/pos1", "hint": "Set WorldEdit position 1"},
        {"command": "/pos2", "hint": "Set WorldEdit position 2"},
        {"command": "/sel", "hint": "Show current selection"},
        {"command": "/fill", "hint": "Fill selection with a block"},
        {"command": "/clear", "hint": "Clear selection"},
        {"command": "/floor", "hint": "Make a floor in selection"},
        {"command": "/flat", "hint": "Flatten loaded chunks around you"},
        {"command": "/border", "hint": "Build a chunk border wall"},
        {"command": "/peaceful", "hint": "Disable spawning and remove mobs"},
        {"command": "/daylock", "hint": "Keep the world in daytime"},
        {"command": "/builder_setup", "hint": "Creative, peaceful, day, flat spawn"},
        {"command": "/list", "hint": "Show local session info"},
        {"command": "/char-select", "hint": "Open multiplayer character select"},
        {"command": "/default", "hint": "Use default white multiplayer avatar"},
    ]
    var lowered_query: String = query.to_lower()
    var entries: Array = []
    for command_entry in commands:
        var command_text: String = str(command_entry.get("command", ""))
        if lowered_query != "" and not command_text.substr(1).to_lower().begins_with(lowered_query):
            continue
        entries.append(_make_autocomplete_entry(command_text, command_text, str(command_entry.get("hint", ""))))
    return entries


func _get_give_command_autocomplete_entries(query: String) -> Array:
    var entries: Array = []
    var tokens: PackedStringArray = query.split(" ", false)
    var is_item_arg: bool = tokens.size() > 1 or (tokens.size() == 1 and query.ends_with(" "))
    if is_item_arg:
        var amount_text: String = tokens[0] if tokens.size() > 0 else "1"
        var item_query: String = tokens[1].to_lower() if tokens.size() > 1 else ""
        var item_map = get_tree().root.get_node_or_null("ItemMap")
        if is_instance_valid(item_map) and "id_to_resource" in item_map:
            for item_id in item_map.id_to_resource.keys():
                var item = item_map.id_to_resource[item_id]
                var raw_name: String = _get_resource_display_name(item, "Unknown")
                var item_name: String = _slugify(raw_name)
                if item_query == "" or item_name.contains(_slugify(item_query)) or str(item_id).begins_with(item_query):
                    entries.append(_make_autocomplete_entry("/give %s %s " % [amount_text, item_name], item_name, raw_name))
                    if entries.size() >= 32:
                        break
        if entries.is_empty():
            entries.append(_make_autocomplete_entry("/give %s " % amount_text, "/give %s <item_id>" % amount_text, "Give an item"))
        return entries

    var lowered_query: String = query.to_lower()
    for amount in ["1", "16", "32", "64", "99"]:
        if lowered_query == "" or amount.begins_with(lowered_query):
            entries.append(_make_autocomplete_entry("/give %s " % amount, amount, "Amount"))
    return entries


func _get_avatar_command_autocomplete_entries(command_body: String, query: String) -> Array:
    var command_name: String = "/%s" % command_body
    var entries: Array = []
    for avatar_id in ["default_blocky"]:
        if query == "" or avatar_id.begins_with(query.to_lower()):
            entries.append(_make_autocomplete_entry("%s %s" % [command_name, avatar_id], avatar_id, "Default white multiplayer avatar"))
    return entries


func _get_gamemode_command_autocomplete_entries(query: String) -> Array:
    var entries: Array = []
    var lowered_query: String = query.to_lower()
    for entry in [
        {"insert": "/gamemode c", "display": "/gamemode c", "hint": "Session creative"},
        {"insert": "/gamemode s", "display": "/gamemode s", "hint": "Session survival"},
    ]:
        var command_text: String = str(entry.get("insert", ""))
        if lowered_query == "" or command_text.to_lower().contains(lowered_query):
            entries.append(_make_autocomplete_entry(command_text, str(entry.get("display", command_text)), str(entry.get("hint", ""))))
    return entries


func _get_time_command_autocomplete_entries(query: String) -> Array:
    var entries: Array = []
    var options: PackedStringArray = PackedStringArray(["set", "query"])
    if query.to_lower().begins_with("set "):
        var sub_query: String = query.substr(4).to_lower()
        for option in ["day", "noon", "night", "midnight"]:
            if option.begins_with(sub_query):
                entries.append(_make_autocomplete_entry("/time set %s" % option, option, "Time target"))
        return entries
    for option in options:
        if query == "" or option.begins_with(query.to_lower()):
            entries.append(_make_autocomplete_entry("/time %s" % option, option, "Time action"))
    return entries


func _get_weather_command_autocomplete_entries(query: String) -> Array:
    var entries: Array = []
    for option in ["clear", "rain", "thunder"]:
        if query == "" or option.begins_with(query.to_lower()):
            entries.append(_make_autocomplete_entry("/weather %s" % option, option, "Weather type"))
    return entries


func _get_spawn_command_autocomplete_entries(query: String) -> Array:
    var entries: Array = []
    var lowered_query: String = _normalize_id(query)
    for spawn_id in _get_spawn_ids():
        var spawn_text: String = str(spawn_id)
        if lowered_query == "" or spawn_text.contains(lowered_query):
            entries.append(_make_autocomplete_entry("/spawn %s" % spawn_text, "/spawn %s" % spawn_text, "Spawn mob"))
            if entries.size() >= 32:
                break
    if entries.is_empty():
        entries.append(_make_autocomplete_entry("/spawn ", "/spawn <mob_id>", "Use /spawnlist for ids"))
    return entries


func _get_block_command_autocomplete_entries(command_body: String, query: String) -> Array:
    var entries: Array = []
    var prefix: String = "/" + command_body
    if ["flat", "border", "builder_setup"].has(command_body):
        var tokens: PackedStringArray = query.split(" ", false)
        if tokens.size() <= 1 and not query.ends_with(" "):
            for radius in ["1", "2", "3", "4"]:
                if query == "" or radius.begins_with(query):
                    entries.append(_make_autocomplete_entry("%s %s " % [prefix, radius], radius, "Chunk radius"))
            return entries
        var block_query: String = tokens[1] if tokens.size() > 1 else ""
        var radius_text: String = tokens[0] if tokens.size() > 0 else "2"
        return _get_block_name_suggestions(prefix + " " + radius_text + " ", block_query)
    return _get_block_name_suggestions(prefix + " ", query)


func _get_block_name_suggestions(prefix: String, query: String) -> Array:
    var entries: Array = []
    var item_map = get_tree().root.get_node_or_null("ItemMap")
    if not is_instance_valid(item_map) or not "id_to_resource" in item_map:
        return entries
    var lowered_query: String = _slugify(query)
    for item_id in item_map.id_to_resource.keys():
        var item = item_map.id_to_resource[item_id]
        if not (item is Block):
            continue
        var raw_name: String = _get_resource_display_name(item, "Block")
        var block_name: String = _slugify(raw_name)
        if lowered_query == "" or block_name.contains(lowered_query) or str(item_id).begins_with(lowered_query):
            entries.append(_make_autocomplete_entry("%s%s" % [prefix, block_name], block_name, raw_name))
            if entries.size() >= 32:
                break
    return entries


func _get_on_off_command_autocomplete_entries(command_body: String, query: String) -> Array:
    var entries: Array = []
    for option in ["on", "off"]:
        if query == "" or option.begins_with(query.to_lower()):
            entries.append(_make_autocomplete_entry("/%s %s" % [command_body, option], option, "Toggle"))
    return entries


func _make_autocomplete_entry(insert_text: String, display_text: String, hint_text: String = "") -> Dictionary:
    return {
        "insert": insert_text,
        "display": display_text,
        "hint": hint_text,
    }


func _can_host_modify_world() -> bool:
    return not multiplayer.has_multiplayer_peer() or multiplayer.is_server()


func _refresh_inventory_screen() -> void:
    if is_instance_valid(Ref.game_menu) and Ref.game_menu.has_method("update_inventory_screen") and Ref.game_menu.is_inventory_open():
        Ref.game_menu.update_inventory_screen(int(Ref.game_menu.inventory_screen))


func _set_status(message: String) -> void:
    status_message = message
    print("[lucid-blocks-console] %s" % message.replace("\n", " | "))


func _normalize_id(value: String) -> String:
    var normalized: String = value.strip_edges().to_lower().replace("-", "_").replace(" ", "_")
    while normalized.contains("__"):
        normalized = normalized.replace("__", "_")
    return normalized.trim_prefix("_").trim_suffix("_")


func _slugify(raw_text: String) -> String:
    var normalized: String = raw_text.strip_edges().to_lower()
    normalized = normalized.replace("'", "")
    normalized = normalized.replace("\"", "")
    normalized = normalized.replace(".", "_")
    normalized = normalized.replace(",", "_")
    normalized = normalized.replace("-", "_")
    normalized = normalized.replace(" ", "_")
    while normalized.contains("__"):
        normalized = normalized.replace("__", "_")
    return normalized.trim_prefix("_").trim_suffix("_")
