extends RefCounted

# CoopBuilder.make_flat_area — verifies clear-column + floor-row
# decomposition, sum aggregation, and changed_positions merge.

var place_calls: Array = []
var break_calls: Array = []
var water_calls: Array = []
var fire_calls: Array = []


func _is_position_loaded(_pos: Vector3i) -> bool:
    return true


func _get_block_id_at(_pos: Vector3i) -> int:
    return 0


func _place_block(pos: Vector3i, _block) -> void:
    place_calls.append(pos)


func _break_block(pos: Vector3i) -> void:
    break_calls.append(pos)


func _place_water(pos: Vector3i, _level: int) -> void:
    water_calls.append(pos)


func _place_fire(pos: Vector3i, _level: int) -> void:
    fire_calls.append(pos)


func _is_block_value(_value) -> bool:
    return true


func _ops() -> Dictionary:
    return {
        "is_position_loaded": Callable(self, "_is_position_loaded"),
        "get_block_id_at": Callable(self, "_get_block_id_at"),
        "place_block": Callable(self, "_place_block"),
        "break_block": Callable(self, "_break_block"),
        "place_water": Callable(self, "_place_water"),
        "place_fire": Callable(self, "_place_fire"),
        "is_block_value": Callable(self, "_is_block_value"),
    }


func run(t: CoopTester) -> void:
    place_calls.clear()
    break_calls.clear()
    water_calls.clear()
    fire_calls.clear()

    var block: Object = RefCounted.new()
    var result: Dictionary = CoopBuilder.make_flat_area(_ops(), Vector3i(0, 0, 0), Vector3i(1, 99, 1), 10, block, 3, 1000)

    t.begin("CoopBuilder.make_flat_area decomposes into clear (floor_y+1..floor_y+clear_height) + floor (floor_y)")
    var floor_positions: Array = []
    var clear_positions: Array = []
    for pos in place_calls:
        if pos.y == 10:
            floor_positions.append(pos)
        else:
            clear_positions.append(pos)
    t.assert_eq(4, floor_positions.size(), "2x2 floor at y=floor_y")
    for pos in floor_positions:
        t.assert_eq(10, pos.y)
    t.assert_eq(0, clear_positions.size(), "clear pass places null (no block placed)")

    t.begin("CoopBuilder.make_flat_area clear pass spans floor_y+1..floor_y+clear_height")
    var liquid_ys: Dictionary = {}
    for pos in water_calls:
        liquid_ys[pos.y] = true
    t.assert_true(liquid_ys.has(11), "y=11 cleared")
    t.assert_true(liquid_ys.has(12), "y=12 cleared")
    t.assert_true(liquid_ys.has(13), "y=13 cleared")
    t.assert_false(liquid_ys.has(14), "above clear_height (floor_y+clear_height=13) untouched")

    t.begin("CoopBuilder.make_flat_area also fires liquid clears on the floor row")
    var floor_liquid_count: int = 0
    for pos in water_calls:
        if pos.y == 10:
            floor_liquid_count += 1
    t.assert_eq(4, floor_liquid_count, "floor row triggers clear_liquids=true too")

    t.begin("CoopBuilder.make_flat_area sums changed and skipped from both sub-calls")
    var expected_changed: int = (2 * 2 * 3) + (2 * 2)
    t.assert_eq(expected_changed, int(result["changed"]))
    t.assert_eq(0, int(result["skipped"]))

    t.begin("CoopBuilder.make_flat_area merges changed_positions from clear + floor")
    var merged: Array = result["changed_positions"]
    t.assert_eq(expected_changed, merged.size())
