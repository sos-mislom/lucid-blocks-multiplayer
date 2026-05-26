extends RefCounted

# CoopBuilder.build_border — perimeter walk + cap gate + partial skip.

var place_sequence: Array = []
var unloaded: Dictionary = {}


func _is_position_loaded(pos: Vector3i) -> bool:
    return not unloaded.has(pos)


func _get_block_id_at(_pos: Vector3i) -> int:
    return 0


func _place_block(pos: Vector3i, _block) -> void:
    place_sequence.append(pos)


func _break_block(_pos: Vector3i) -> void:
    pass


func _is_block_value(_value) -> bool:
    return true


func _ops() -> Dictionary:
    return {
        "is_position_loaded": Callable(self, "_is_position_loaded"),
        "get_block_id_at": Callable(self, "_get_block_id_at"),
        "place_block": Callable(self, "_place_block"),
        "break_block": Callable(self, "_break_block"),
        "is_block_value": Callable(self, "_is_block_value"),
    }


func run(t: CoopTester) -> void:
    place_sequence.clear()
    unloaded.clear()

    var block: Object = RefCounted.new()

    t.begin("CoopBuilder.build_border returns border_too_large when perimeter exceeds cap")
    var capped: Dictionary = CoopBuilder.build_border(_ops(), Vector3i(0, 0, 0), Vector3i(100, 0, 100), 0, 5, block, 100)
    t.assert_eq("border_too_large", String(capped.get("error", "")))
    t.assert_eq(0, int(capped["changed"]))
    t.assert_true(int(capped["skipped"]) > 0, "skipped equals planned perimeter when gated")
    t.assert_eq(0, place_sequence.size(), "no iteration when gated")
    t.assert_eq([], capped["changed_positions"])

    t.begin("CoopBuilder.build_border walks perimeter and counts changes")
    place_sequence.clear()
    var full: Dictionary = CoopBuilder.build_border(_ops(), Vector3i(0, 0, 0), Vector3i(2, 0, 2), 0, 1, block, 1000)
    # Expected perimeter cells for 3x3 footprint = (3*2 + 1*2) = 8
    t.assert_eq(8, int(full["changed"]))
    t.assert_eq(0, int(full["skipped"]))
    t.assert_eq(8, place_sequence.size())

    t.begin("CoopBuilder.build_border splits changed/skipped when some cells unloaded")
    place_sequence.clear()
    unloaded[Vector3i(0, 0, 0)] = true
    unloaded[Vector3i(2, 0, 2)] = true
    var partial: Dictionary = CoopBuilder.build_border(_ops(), Vector3i(0, 0, 0), Vector3i(2, 0, 2), 0, 1, block, 1000)
    t.assert_eq(6, int(partial["changed"]))
    t.assert_eq(2, int(partial["skipped"]))
    t.assert_eq(6, (partial["changed_positions"] as Array).size())
    for pos in partial["changed_positions"]:
        t.assert_false(unloaded.has(pos), "unloaded cells must not appear in changed_positions")
