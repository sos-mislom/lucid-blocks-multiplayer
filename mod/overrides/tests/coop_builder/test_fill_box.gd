extends RefCounted

# CoopBuilder.fill_box tests: iteration order (y -> z -> x),
# selection-cap gate, partial-skip aggregation, changed_positions.

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
    var result: Dictionary = CoopBuilder.fill_box(_ops(), Vector3i(0, 0, 0), Vector3i(1, 1, 1), block, false, 1000)

    t.begin("CoopBuilder.fill_box iterates y -> z -> x in order")
    var expected_sequence: Array = [
        Vector3i(0, 0, 0), Vector3i(1, 0, 0), Vector3i(0, 0, 1), Vector3i(1, 0, 1),
        Vector3i(0, 1, 0), Vector3i(1, 1, 0), Vector3i(0, 1, 1), Vector3i(1, 1, 1),
    ]
    t.assert_eq(expected_sequence.size(), place_sequence.size())
    for i in range(expected_sequence.size()):
        t.assert_eq(expected_sequence[i], place_sequence[i], "step %d" % i)
    t.assert_eq(8, int(result["changed"]))
    t.assert_eq(0, int(result["skipped"]))

    t.begin("CoopBuilder.fill_box returns selection_too_large when planned > cap")
    place_sequence.clear()
    var capped: Dictionary = CoopBuilder.fill_box(_ops(), Vector3i(0, 0, 0), Vector3i(9, 9, 9), block, false, 100)
    t.assert_eq("selection_too_large", String(capped.get("error", "")))
    t.assert_eq(0, int(capped["changed"]))
    t.assert_eq(1000, int(capped["skipped"]), "skipped equals planned when gated")
    t.assert_eq(0, place_sequence.size(), "no iteration when gated")
    t.assert_eq([], capped["changed_positions"])

    t.begin("CoopBuilder.fill_box aggregates changed + skipped when some cells unloaded")
    place_sequence.clear()
    unloaded[Vector3i(0, 0, 0)] = true
    unloaded[Vector3i(1, 1, 1)] = true
    var partial: Dictionary = CoopBuilder.fill_box(_ops(), Vector3i(0, 0, 0), Vector3i(1, 1, 1), block, false, 1000)
    t.assert_eq(6, int(partial["changed"]))
    t.assert_eq(2, int(partial["skipped"]))
    t.assert_eq(6, (partial["changed_positions"] as Array).size())

    t.begin("CoopBuilder.fill_box emits changed_positions only for successful writes")
    var changed_positions: Array = partial["changed_positions"]
    for pos in changed_positions:
        t.assert_false(unloaded.has(pos), "unloaded cells must not appear in changed_positions")
