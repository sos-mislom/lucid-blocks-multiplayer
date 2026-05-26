extends RefCounted

# Stateful mock predicates - we install a script-scope counter / list
# so we can pin the iteration order and assert how many calls were made.

var _always_true_calls: int = 0
var _always_false_calls: int = 0
var _safe_positions: Array = []  # populated per-test; predicate returns true iff candidate in this list
var _predicate_calls: Array = []  # records every position passed to the predicate (in order)


func _is_always_true(_pos: Vector3) -> bool:
    _always_true_calls += 1
    return true


func _is_always_false(_pos: Vector3) -> bool:
    _always_false_calls += 1
    return false


func _is_safe_lookup(pos: Vector3) -> bool:
    _predicate_calls.append(pos)
    return _safe_positions.has(pos)


func run(t: CoopTester) -> void:
    var anchor: Vector3 = Vector3(10, 5, 20)
    var fallback: Vector3 = Vector3(-1, -1, -1)
    var offsets: Array = [Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1)]

    t.begin("CoopTeleport.find_safe_position_in_offsets invalid Callable -> fallback")
    var invalid_result: Vector3 = CoopTeleport.find_safe_position_in_offsets(anchor, offsets, Callable(), fallback)
    t.assert_eq(fallback, invalid_result)

    t.begin("CoopTeleport.find_safe_position_in_offsets empty offsets -> fallback")
    var empty_result: Vector3 = CoopTeleport.find_safe_position_in_offsets(anchor, [], Callable(self, "_is_always_true"), fallback)
    t.assert_eq(fallback, empty_result)
    t.assert_eq(0, _always_true_calls, "empty offsets must not call predicate")

    t.begin("CoopTeleport.find_safe_position_in_offsets always-true returns anchor + offsets[0]")
    _always_true_calls = 0
    var true_result: Vector3 = CoopTeleport.find_safe_position_in_offsets(anchor, offsets, Callable(self, "_is_always_true"), fallback)
    t.assert_eq(anchor + offsets[0], true_result)
    t.assert_eq(1, _always_true_calls, "first-hit-wins: predicate called exactly once")

    t.begin("CoopTeleport.find_safe_position_in_offsets always-false -> fallback (loop + retry both fail)")
    _always_false_calls = 0
    var false_result: Vector3 = CoopTeleport.find_safe_position_in_offsets(anchor, offsets, Callable(self, "_is_always_false"), fallback)
    t.assert_eq(fallback, false_result)
    t.assert_eq(offsets.size() + 1, _always_false_calls, "predicate called for every offset + 1 retry on offsets[0]")

    t.begin("CoopTeleport.find_safe_position_in_offsets safe at index 2 returns that candidate")
    _predicate_calls.clear()
    _safe_positions = [anchor + offsets[2]]
    var indexed_result: Vector3 = CoopTeleport.find_safe_position_in_offsets(anchor, offsets, Callable(self, "_is_safe_lookup"), fallback)
    t.assert_eq(anchor + offsets[2], indexed_result)
    t.assert_eq(3, _predicate_calls.size(), "called for offsets 0, 1, 2")
    t.assert_eq(anchor + offsets[0], _predicate_calls[0])
    t.assert_eq(anchor + offsets[1], _predicate_calls[1])
    t.assert_eq(anchor + offsets[2], _predicate_calls[2])

    t.begin("CoopTeleport.find_safe_position_in_offsets uses live SAFE_OFFSET_CANDIDATES (13 offsets + 1 retry on all-false)")
    _always_false_calls = 0
    var live_result: Vector3 = CoopTeleport.find_safe_position_in_offsets(anchor, CoopTeleport.SAFE_OFFSET_CANDIDATES, Callable(self, "_is_always_false"), fallback)
    t.assert_eq(fallback, live_result)
    t.assert_eq(14, _always_false_calls, "13 live offsets + 1 retry on first offset")

    t.begin("CoopTeleport.find_safe_position_in_offsets retry-after-loop returns offsets[0] when predicate flips")
    var flip_state: Object = RefCounted.new()
    flip_state.set_meta("seen_offsets", [])
    flip_state.set_meta("anchor", anchor)
    flip_state.set_meta("offsets", offsets)
    flip_state.set_meta("call_count", 0)
    var flip_predicate: Callable = func(pos: Vector3) -> bool:
        var seen: Array = flip_state.get_meta("seen_offsets")
        seen.append(pos)
        flip_state.set_meta("seen_offsets", seen)
        var current_count: int = int(flip_state.get_meta("call_count")) + 1
        flip_state.set_meta("call_count", current_count)
        # All false during main loop (3 calls), then true on retry (call #4)
        return current_count > 3
    var flip_result: Vector3 = CoopTeleport.find_safe_position_in_offsets(anchor, offsets, flip_predicate, fallback)
    t.assert_eq(anchor + offsets[0], flip_result, "retry pass hits offsets[0] candidate")
    t.assert_eq(4, int(flip_state.get_meta("call_count")), "main loop (3) + 1 retry call")
