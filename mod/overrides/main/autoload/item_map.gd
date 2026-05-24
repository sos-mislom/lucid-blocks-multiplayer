extends Node


var item_path: String = "res://main/items/data"

var id_to_resource: Dictionary[int, Item]
var all_item_ids: Array[int]
var all_items_loaded: bool = false

signal items_done_loading

const directions: Array[Vector3i] = [Vector3i(0, 1, 0), Vector3i(0, -1, 0), Vector3i(0, 0, 1), Vector3i(0, 0, -1), Vector3i(1, 0, 0), Vector3i(-1, 0, 0)]


func _is_dedicated_server_boot() -> bool:
    var args: Array[String] = []
    for arg in OS.get_cmdline_args():
        args.append(str(arg))
    for arg in OS.get_cmdline_user_args():
        var user_arg: String = str(arg)
        if not args.has(user_arg):
            args.append(user_arg)
    for raw_arg in args:
        var arg: String = str(raw_arg).strip_edges()
        if arg == "--lb-dedicated" or arg == "--lucid-dedicated" or arg == "--dedicated":
            return true
        if arg.begins_with("--lb-dedicated=") or arg.begins_with("--lucid-dedicated=") or arg.begins_with("--dedicated="):
            var value: String = arg.substr(arg.find("=") + 1).strip_edges().to_lower()
            return not ["0", "false", "no", "off"].has(value)
    return false


func _ready() -> void :
    var dedicated_boot: bool = _is_dedicated_server_boot()
    var stack: Array[String] = [item_path]
    var loader_helper: ItemLoader = ItemLoader.new()

    print("Loading items...")

    while stack.size() > 0:
        var dir: DirAccess = DirAccess.open(stack.pop_back())
        dir.list_dir_begin()
        var file_name: String = dir.get_next()

        while file_name != "":
            var path: String = dir.get_current_dir() + "/" + file_name
            if dir.dir_exists(path):
                if file_name != "sounds" and file_name != "loot" and file_name != "textures" and file_name != "icons":
                    stack.append(path)
            else:
                if ".tres" in path:
                    path = path.replace(".remap", "")
                    var resource: Resource = ResourceLoader.load(path)
                    if resource is Item:
                        var item: Item = resource as Item
                        assert ( not (item.id in id_to_resource))
                        id_to_resource[item.id] = item
                        all_item_ids.append(item.id)
                    if resource is Block:
                        var block: Block = resource as Block

                        assert ( not block.display_name.ends_with("+") and not block.display_name.ends_with("-"))

                        if block.directional:
                            for direction in directions:
                                var new_block: Block = loader_helper.generate_directional_variant(block, direction, not block is LetterBlock)
                                assert ( not (new_block.id in id_to_resource))
                                id_to_resource[new_block.id] = new_block
                                all_item_ids.append(new_block.id)
            file_name = dir.get_next()
    print("Items loaded.")
    all_item_ids.sort()

    Ref.world.reload_types()
    Ref.world.set_block_indices()
    Ref.world.create_texture_atlas()




    if not dedicated_boot:
        await Ref.main.get_node("%IconGenerator").ready
        await Ref.main.get_node("%IconGenerator").generate_icons()
        Ref.main.get_node("%IconGenerator").queue_free()
    else:
        var icon_generator := Ref.main.get_node_or_null("%IconGenerator")
        if icon_generator != null:
            icon_generator.queue_free()
        print("[lucid-blocks-coop] Dedicated: skipped item icon generation.")

    if not dedicated_boot:
        print("Preloading item scenes...")
        for id in all_item_ids:
            var item: Item = id_to_resource[id]
            item.held_item_scene = ResourceLoader.load(item.held_item_path)
            if item is Block and item.living_block_path != "":
                item.living_block_scene = ResourceLoader.load(item.living_block_path)
            if item is Spawner and item.entity_path != "":
                item.entity_scene = ResourceLoader.load(item.entity_path)
        print("Item scenes preloaded.")
    else:
        print("[lucid-blocks-coop] Dedicated: item scenes will lazy-load on demand.")

    items_done_loading.emit()
    all_items_loaded = true


func map(id: int) -> Item:
    return id_to_resource[id]
