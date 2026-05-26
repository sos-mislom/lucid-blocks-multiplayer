extends RefCounted

# Pure CoopBuilder.set_world_block tests. The WorldOps bag is built
# from methods on this instance so we can record every engine call
# into local Arrays and assert ordering + arguments.

var placed: Array = []
var broken: Array = []
var water: Array = []
var fire: Array = []
var loaded: Dictionary = {}
var current_id: Dictionary = {}


func _is_position_loaded(pos: Vector3i) -> bool:
    return bool(loaded.get(pos, true))


func _get_block_id_at(pos: Vector3i) -> int:
    return int(current_id.get(pos, 0))


func _place_block(pos: Vector3i, block) -> void:
    placed.append([pos, block])


func _break_block(pos: Vector3i) -> void:
    broken.append(pos)


func _place_water(pos: Vector3i, level: int) -> void:
    water.append([pos, level])


func _place_fire(pos: Vector3i, level: int) -> void:
    fire.append([pos, level])


func _is_block_value(value) -> bool:
    return value is Object


func _ops(include_liquids: bool = true, include_block_validator: bool = true) -> Dictionary:
    var ops: Dictionary = {
        "is_position_loaded": Callable(self, "_is_position_loaded"),
        "get_block_id_at": Callable(self, "_get_block_id_at"),
        "place_block": Callable(self, "_place_block"),
        "break_block": Callable(self, "_break_block"),
    }
    if include_liquids:
        ops["place_water"] = Callable(self, "_place_water")
        ops["place_fire"] = Callable(self, "_place_fire")
    if include_block_validator:
        ops["is_block_value"] = Callable(self, "_is_block_value")
    return ops


func _reset() -> void:
    placed.clear()
    broken.clear()
    water.clear()
    fire.clear()
    loaded.clear()
    current_id.clear()


func run(t: CoopTester) -> void:
    _reset()
    t.begin("CoopBuilder.set_world_block returns false when is_position_loaded is missing")
    t.assert_false(CoopBuilder.set_world_block({}, Vector3i(0, 0, 0), null, false))

    _reset()
    loaded[Vector3i(1, 2, 3)] = false
    t.begin("CoopBuilder.set_world_block returns false when position is not loaded")
    t.assert_false(CoopBuilder.set_world_block(_ops(), Vector3i(1, 2, 3), RefCounted.new(), false))
    t.assert_eq(0, placed.size(), "no place_block call when position unloaded")

    _reset()
    t.begin("CoopBuilder.set_world_block places when block is non-null and valid")
    var fake_block: Object = RefCounted.new()
    t.assert_true(CoopBuilder.set_world_block(_ops(), Vector3i(4, 5, 6), fake_block, false))
    t.assert_eq(1, placed.size())
    t.assert_eq(Vector3i(4, 5, 6), placed[0][0])
    t.assert_eq(fake_block, placed[0][1])
    t.assert_eq(0, broken.size())

    _reset()
    current_id[Vector3i(7, 8, 9)] = 12
    t.begin("CoopBuilder.set_world_block breaks when block is null and current id is non-zero")
    t.assert_true(CoopBuilder.set_world_block(_ops(), Vector3i(7, 8, 9), null, false))
    t.assert_eq(1, broken.size())
    t.assert_eq(Vector3i(7, 8, 9), broken[0])

    _reset()
    t.begin("CoopBuilder.set_world_block no-ops when block is null and cell is already air")
    t.assert_true(CoopBuilder.set_world_block(_ops(), Vector3i(0, 0, 0), null, false))
    t.assert_eq(0, broken.size(), "must skip the break call when get_block_id_at returns 0")

    _reset()
    t.begin("CoopBuilder.set_world_block rejects non-block, non-null values")
    t.assert_false(CoopBuilder.set_world_block(_ops(), Vector3i(0, 0, 0), "not a block", false))
    t.assert_false(CoopBuilder.set_world_block(_ops(), Vector3i(0, 0, 0), 42, false))
    t.assert_eq(0, placed.size(), "no place_block calls when is_block_value rejects")

    _reset()
    t.begin("CoopBuilder.set_world_block fires liquids only when clear_liquids=true")
    var block: Object = RefCounted.new()
    t.assert_true(CoopBuilder.set_world_block(_ops(), Vector3i(0, 0, 0), block, false))
    t.assert_eq(0, water.size())
    t.assert_eq(0, fire.size())
    _reset()
    t.assert_true(CoopBuilder.set_world_block(_ops(), Vector3i(0, 0, 0), block, true))
    t.assert_eq(1, water.size())
    t.assert_eq(1, fire.size())
    t.assert_eq(0, water[0][1], "water level cleared to 0")
    t.assert_eq(0, fire[0][1], "fire level cleared to 0")

    _reset()
    t.begin("CoopBuilder.set_world_block skips optional liquid callables when absent")
    t.assert_true(CoopBuilder.set_world_block(_ops(false, true), Vector3i(0, 0, 0), block, true))
    t.assert_eq(0, water.size())
    t.assert_eq(0, fire.size())
