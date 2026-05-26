extends Node



const app_id: int = 3495730

signal qualia_uploaded(success: bool)
signal qualia_downloaded(success: bool)
signal qualia_deleted(success: bool)
signal workshop_qualia_received(results: Array[Dictionary])

var achievements: Dictionary[String, bool] = {
    "FIRST_FUSION": false, 
    "LIVING_FUSION": false, 
    "RARE_FUSION": false, 
    "GLIDER": false, 
    "HOOKSHOT": false, 
    "PLANT_SEED": false, 
    "HARVEST_PLANT": false, 
    "RENAME_ENTITY": false, 
    "BALL_WAND": false, 
    "FAITH_WAND": false, 
    "BOMB": false, 
    "BUBBLEBEAR_MASSACRE": false, 
    "BLASPHEMY": false, 
    "DEATH": false, 
    "CUTSCENE": false, 
    "NEW_WORLD": false, 
    "END_GAME": false, 
    "CHALLENGE": false, 
    "HAND_WAND": false
}

var statistics: Dictionary[String, int] = {
    "blocks_broken": 0, 
    "blocks_placed": 0, 
    "death_count": 0, 
    "fusion_count": 0, 
}

var steam_id: int = -1
var steam_enabled: bool = false
var statistics_loaded: bool = false
var achievements_loaded: bool = false

var retry_count: int = 0
var register_to_save: SaveFileRegister
var current_upload_id: int = -1
var current_download_id: int = -1
var current_ugc_query_handler_id: int = -1

var allow_steam: bool = false
var steam_core: Object


func _init() -> void :
    allow_steam = not OS.has_feature("android") and not _is_dedicated_server_boot_arg()

    if not allow_steam:
        return

    steam_core = Engine.get_singleton("Steam")

    process_mode = Node.PROCESS_MODE_ALWAYS
    OS.set_environment("SteamAppId", str(app_id))
    OS.set_environment("SteamGameId", str(app_id))
    steam_core.item_created.connect(_on_item_created)
    steam_core.item_updated.connect(_on_item_updated)
    steam_core.item_downloaded.connect(_on_item_downloaded)
    steam_core.item_deleted.connect(_on_item_deleted)
    steam_core.ugc_query_completed.connect(_on_ugc_query_completed)


func _ready() -> void :
    print("Steam loading...")
    if not allow_steam:
        if _is_dedicated_server_boot_arg():
            print("[lucid-blocks-coop] Dedicated: Steamworks disabled for server boot.")
        return
    print("GodotSteam version: ", steam_core.get_godotsteam_version())
    initialize_steam()


func _process(_delta: float) -> void :
    if not allow_steam:
        return
    steam_core.run_callbacks()


func _is_dedicated_server_boot_arg() -> bool:
    var args: Array[String] = []
    for arg in OS.get_cmdline_args():
        args.append(str(arg))
    for arg in OS.get_cmdline_user_args():
        var user_arg: String = str(arg)
        if not args.has(user_arg):
            args.append(user_arg)

    for raw_arg in args:
        var arg_text: String = str(raw_arg).strip_edges()
        for name in ["--lb-dedicated", "--lucid-dedicated", "--dedicated"]:
            if arg_text == name:
                return true
            if arg_text.begins_with("%s=" % name):
                var value: String = arg_text.substr(name.length() + 1).strip_edges().to_lower()
                return not ["0", "false", "no", "off"].has(value)
    return false



func _on_item_created(result: int, file_id: int, needs_to_accept_tos: bool) -> void :
    if needs_to_accept_tos:
        steam_core.activateGameOverlayToWebPage("https://steamcommunity.com/workshop/workshoplegalagreement/?appid=%s" % app_id)

    if not result == steam_core.RESULT_OK:
        printerr("Failed creating workshop item. Error: " + str(result))
        qualia_uploaded.emit(false)
    else:
        print_rich("[color=#5c6066]Item with id %d successfully created" % [file_id])
        var handler_id: int = steam_core.startItemUpdate(app_id, file_id)
        var path: String = ProjectSettings.globalize_path(Ref.save_file_manager.get_save_file_directory(register_to_save.get_data("uuid")))

        print(path)
        steam_core.setItemContent(handler_id, path)

        steam_core.setItemTitle(handler_id, register_to_save.get_data("title", "unnamed qualia"))
        steam_core.setItemTags(handler_id, ["qualia", ProjectSettings.get("application/config/version")])
        steam_core.setItemMetadata(handler_id, JSON.stringify(JSON.from_native(register_to_save.data)))
        steam_core.setItemVisibility(handler_id, steam_core.REMOTE_STORAGE_PUBLISHED_VISIBILITY_PUBLIC)
        steam_core.submitItemUpdate(handler_id, "initial commit")

        current_upload_id = file_id


func _on_item_deleted(result: int, file_id: int) -> void :
    if not result == steam_core.RESULT_OK:
        printerr("Failed deleting workshop item. Error: " + str(result))
        qualia_deleted.emit(false)
    else:
        print_rich("[color=#5c6066]Item with id %d successfully deleted" % [file_id])
        qualia_deleted.emit(true)


func _on_item_updated(result: int, file_id: int, needs_to_accept_tos: bool) -> void :
    if needs_to_accept_tos:
        steam_core.activateGameOverlayToWebPage("https://steamcommunity.com/workshop/workshoplegalagreement/?appid=%s" % app_id)

    if not result == steam_core.RESULT_OK:
        printerr("Failed updating workshop item. Error: " + str(result))
        steam_core.deleteItem(file_id)
        qualia_uploaded.emit(false)
    else:
        print_rich("[color=#5c6066]Item successfully updated")
        qualia_uploaded.emit(true)


func _on_item_downloaded(result: int, file_id: int, download_app_id: int) -> void :
    if not download_app_id == app_id:
        qualia_downloaded.emit(false)
        printerr("Download for other game received")
        return
    if result != steam_core.RESULT_OK:
        qualia_downloaded.emit(false)
        print_debug("Failed downloading workshop item. Error: %d" % result)
        return
    if file_id != current_download_id:
        printerr("Incorrect download received")
        qualia_downloaded.emit(false)
        return
    var info: Dictionary = Steam.getItemInstallInfo(file_id)
    var path: String = info.folder + "/"

    print_rich("[color=#5c6066]Item successfully downloaded: %s" % info)


    var file: FileAccess = FileAccess.open(path + "/register.txt", FileAccess.READ)
    if file == null:
        printerr("Register file not found in download")
        qualia_downloaded.emit(false)
        return
    var parse_result: Variant = JSON.parse_string(file.get_line())
    file.close()
    if parse_result == null:
        printerr("Register file invalid")
        qualia_downloaded.emit(false)
        return
    var data: Variant = JSON.to_native(parse_result)
    if data == null or not "uuid" in data:
        printerr("Register file invalid")
        qualia_downloaded.emit(false)
        return
    var register: SaveFileRegister = SaveFileRegister.new()
    register.is_dimensional = false
    register.is_downloaded = true
    register.data = data
    register.set_data("workshop_id", file_id)
    register.set_data("progression_disabled", true)


    Ref.save_file_manager.initialize_save_file_directory(register.get_data("uuid"), true)


    var folder_name: String = data.uuid
    var destination_path: String = Ref.save_file_manager.root_ugc_path() + folder_name
    DirAccess.make_dir_absolute(destination_path)
    var copy_result: int = DirAccess.copy_absolute(path + "data.txt", destination_path + "/data.txt")
    if not copy_result == Error.OK:
        printerr("Copy failed (data). Error: %d" % copy_result)
        qualia_downloaded.emit(false)
        return


    var file_register: FileAccess = FileAccess.open(destination_path + "/register.txt", FileAccess.WRITE)
    file_register.store_line(JSON.stringify(JSON.from_native(register.data)))
    file_register.close()

    print_rich("[color=#5c6066]Item successfully copied to local folder")

    qualia_downloaded.emit(true)


func _on_ugc_query_completed(handle: int, result: int, results_returned: int, _total_matching: int, _cached: bool, _next_cursor: String) -> void :
    var empty: Array[Dictionary]
    if handle != current_ugc_query_handler_id:
        printerr("Incorrect UGC query: %d vs. %d" % [handle, current_ugc_query_handler_id])
        steam_core.releaseQueryUGCRequest(handle)
        workshop_qualia_received.emit(empty)
        return
    if result != steam_core.RESULT_OK:
        printerr("Failed loading UGC query. Error: " + str(result))
        workshop_qualia_received.emit(empty)
        return
    print_rich("[color=#5c6066]Query successful: %d results" % results_returned)
    var list_of_results: Array[Dictionary] = []
    for item_id in range(results_returned):
        var item: Dictionary = steam_core.getQueryUGCResult(handle, item_id)
        var metadata: String = steam_core.getQueryUGCMetadata(handle, item_id)
        var parse_result: Variant = JSON.parse_string(metadata)
        if parse_result == null:
            printerr("Qualia skipped (invalid JSON): %s, %d" % [item.title, item_id])
            continue

        var data: Variant = JSON.to_native(parse_result)
        if data == null:
            printerr("Qualia skipped (invalid JSON): %s" % item.title)
            continue

        var save_file_register: SaveFileRegister = SaveFileRegister.new()
        save_file_register.is_dimensional = false
        save_file_register.data = data
        save_file_register.set_data("workshop_id", item.file_id)
        save_file_register.set_data("votes_up", item.votes_up)
        save_file_register.set_data("votes_down", item.votes_down)

        item["metadata"] = metadata
        item["register"] = save_file_register

        list_of_results.append(item)

    steam_core.releaseQueryUGCRequest(handle)
    current_ugc_query_handler_id = 0

    workshop_qualia_received.emit(list_of_results)


func initialize_steam() -> void :
    steam_enabled = false
    var initialize_response: Dictionary = steam_core.steamInitEx()

    if initialize_response["status"] > steam_core.STEAM_API_INIT_RESULT_OK:
        printerr("Failed to initialize steam_core, shutting down: %s" % initialize_response)
        return
    else:
        print_rich("[color=#5c6066]steam_core initialized: %s" % initialize_response)

    steam_id = steam_core.getSteamID()

    load_steam_stats()
    load_steam_achievements()

    steam_enabled = true


func load_steam_stats() -> void :
    statistics_loaded = true
    for this_stat in statistics.keys():
        var steam_stat: int = steam_core.getStatInt(this_stat)

        if statistics[this_stat] > steam_stat:
            statistics[this_stat] = steam_stat
        elif statistics[this_stat] < steam_stat:
            statistics[this_stat] = steam_stat

    print_rich("[color=#5c6066]steam_core statistics loaded")


func load_steam_achievements() -> void :
    achievements_loaded = true
    for this_achievement in achievements.keys():
        var steam_achievement: Dictionary = steam_core.getAchievement(this_achievement)


        if not steam_achievement["ret"]:
            continue

        if achievements[this_achievement] == steam_achievement["achieved"]:
            continue

        set_achievement(this_achievement, true)

    print_rich("[color=#5c6066]steam_core achievements loaded")


func set_achievement(this_achievement: String, override_progression: bool = false) -> void :
    if not override_progression and (Ref.main.progression_disabled or not steam_enabled or not achievements_loaded):
        printerr("Achievement not given: %s" % this_achievement)
        return

    if not achievements.has(this_achievement):
        printerr("This achievement does not exist locally: %s" % this_achievement)
        return
    achievements[this_achievement] = true

    if not steam_core.setAchievement(this_achievement):
        printerr("Failed to set achievement: %s" % this_achievement)
        return

    print_rich("[color=#5c6066]Set acheivement: %s" % this_achievement)

    if not steam_core.storeStats():
        printerr("Failed to store data on steam_core, should be stored locally")
        return

    print_rich("[color=#5c6066]Data successfully sent to steam_core")


func set_statistic(this_stat: String, new_value: int = 0) -> void :
    if Ref.main.creative or not steam_enabled or not statistics_loaded:
        return

    if not statistics.has(this_stat):
        printerr("This statistic does not exist locally: %s" % this_stat)
        return
    statistics[this_stat] = new_value

    if not steam_core.setStatInt(this_stat, new_value):
        printerr("Failed to set stat %s to: %s" % [this_stat, new_value])
        return

    print_rich("[color=#5c6066]Set statistics %s succesfully: %s" % [this_stat, new_value])

    if not steam_core.storeStats():
        printerr("Failed to store data on steam_core, should be stored locally")
        return

    print_rich("[color=#5c6066]Data successfully sent to steam_core")


func increment_statistic(this_stat: String, increment: int = 1) -> void :
    if Ref.main.creative:
        return
    set_statistic(this_stat, statistics[this_stat] + increment)


func offer_save_file(register: SaveFileRegister) -> bool:
    if not steam_enabled:
        return false
    register_to_save = register
    steam_core.createItem(app_id, steam_core.WORKSHOP_FILE_TYPE_COMMUNITY)
    var result: bool = await qualia_uploaded
    register_to_save = null
    current_upload_id = -1
    return result


func get_workshop_qualia(page: int, must_match_version: bool, sort_by_rank: bool, search_text: String = "") -> Array[Dictionary]:
    if not steam_enabled:
        var empty: Array[Dictionary] = []
        return empty
    if current_ugc_query_handler_id > 0:
        steam_core.releaseQueryUGCRequest(current_ugc_query_handler_id)

    var rank: int = steam_core.UGC_QUERY_RANKED_BY_VOTE if sort_by_rank else steam_core.UGC_QUERY_RANKED_BY_PUBLICATION_DATE

    current_ugc_query_handler_id = steam_core.createQueryAllUGCRequestPage(rank, steam_core.UGC_MATCHING_UGC_TYPE_ITEMS, app_id, app_id, page)

    steam_core.setReturnMetadata(current_ugc_query_handler_id, true)
    steam_core.setReturnTotalOnly(current_ugc_query_handler_id, false)
    steam_core.addRequiredTag(current_ugc_query_handler_id, "qualia")
    if search_text.strip_edges() != "" and steam_core.has_method("setSearchText"):
        steam_core.setSearchText(current_ugc_query_handler_id, search_text.strip_edges())
    if must_match_version:
        steam_core.addRequiredTag(current_ugc_query_handler_id, ProjectSettings.get("application/config/version"))
    steam_core.setAllowCachedResponse(current_ugc_query_handler_id, 1)
    steam_core.sendQueryUGCRequest(current_ugc_query_handler_id)

    var results: Array[Dictionary] = await workshop_qualia_received
    return results


func get_self_workshop_qualia(page: int, sort_by_rank: bool) -> Array[Dictionary]:
    if not steam_enabled:
        var empty: Array[Dictionary] = []
        return empty
    if current_ugc_query_handler_id > 0:
        steam_core.releaseQueryUGCRequest(current_ugc_query_handler_id)

    var user_id: int = steam_core.getSteamID()
    var rank: int = steam_core.UGC_QUERY_RANKED_BY_VOTES_UP if sort_by_rank else steam_core.UGC_QUERY_RANKED_BY_PUBLICATION_DATE
    var type: int = steam_core.USER_UGC_LIST_PUBLISHED

    current_ugc_query_handler_id = steam_core.createQueryUserUGCRequest(user_id, type, steam_core.UGC_MATCHING_UGC_TYPE_ITEMS, rank, app_id, app_id, page)

    steam_core.setReturnMetadata(current_ugc_query_handler_id, true)
    steam_core.setReturnTotalOnly(current_ugc_query_handler_id, false)
    steam_core.addRequiredTag(current_ugc_query_handler_id, "qualia")

    steam_core.setAllowCachedResponse(current_ugc_query_handler_id, 1)
    steam_core.sendQueryUGCRequest(current_ugc_query_handler_id)

    var results: Array[Dictionary] = await workshop_qualia_received
    return results


func delete_workshop_qualia(id: int) -> bool:
    steam_core.deleteItem(id)
    return await qualia_deleted


func download_workshop_qualia(id: int) -> bool:
    if current_download_id > 0:
        printerr("Already downloading item")
        return false

    if steam_core.downloadItem(id, false):
        current_download_id = id
        var result: bool = await qualia_downloaded
        current_download_id = -1
        return result
    else:
        printerr("Download failed to start.")
        return false


func update_workshop_vote(id: int, upvote: bool) -> void :
    steam_core.setUserItemVote(id, upvote)


func get_username() -> String:
    if not steam_enabled:
        return "preta"
    return steam_core.getPersonaName()


func _exit_tree() -> void :
    if current_ugc_query_handler_id > 0:
        steam_core.releaseQueryUGCRequest(current_ugc_query_handler_id)
