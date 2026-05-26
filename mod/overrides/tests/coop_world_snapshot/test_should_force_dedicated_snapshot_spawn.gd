extends RefCounted


class _SafetyPredicate:
    var calls: int = 0
    var safe_positions: Array = []
    func _init(safe_positions_in: Array = []) -> void:
        safe_positions = safe_positions_in
    func is_safe(position: Vector3) -> bool:
        calls += 1
        return safe_positions.has(position)


func run(t: CoopTester) -> void:
    t.begin("CoopWorldSnapshot.should_force_dedicated_snapshot_spawn not dedicated -> false")
    var pred: _SafetyPredicate = _SafetyPredicate.new()
    t.assert_false(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        false, true, "alice", Vector3(1, 1, 1), Callable(pred, "is_safe"),
    ))

    t.begin("CoopWorldSnapshot.should_force_dedicated_snapshot_spawn not server -> false")
    t.assert_false(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        true, false, "alice", Vector3(1, 1, 1), Callable(pred, "is_safe"),
    ))

    t.begin("CoopWorldSnapshot.should_force_dedicated_snapshot_spawn empty player_key -> true (force reroute)")
    t.assert_true(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        true, true, "", Vector3(1, 1, 1), Callable(pred, "is_safe"),
    ))

    t.begin("CoopWorldSnapshot.should_force_dedicated_snapshot_spawn saved_position not Vector3 -> true")
    t.assert_true(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        true, true, "alice", null, Callable(pred, "is_safe"),
    ))
    t.assert_true(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        true, true, "alice", "garbage", Callable(pred, "is_safe"),
    ))
    t.assert_true(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        true, true, "alice", Vector3i(1, 1, 1), Callable(pred, "is_safe"),  # Vector3i != Vector3
    ))

    t.begin("CoopWorldSnapshot.should_force_dedicated_snapshot_spawn saved position is safe -> false")
    var safe_pred: _SafetyPredicate = _SafetyPredicate.new([Vector3(5, 5, 5)])
    t.assert_false(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        true, true, "alice", Vector3(5, 5, 5), Callable(safe_pred, "is_safe"),
    ))
    t.assert_eq(1, safe_pred.calls, "predicate invoked exactly once for a Vector3 input")

    t.begin("CoopWorldSnapshot.should_force_dedicated_snapshot_spawn saved position unsafe -> true (force reroute)")
    var unsafe_pred: _SafetyPredicate = _SafetyPredicate.new([Vector3(0, 0, 0)])
    t.assert_true(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        true, true, "alice", Vector3(99, 99, 99), Callable(unsafe_pred, "is_safe"),
    ))

    t.begin("CoopWorldSnapshot.should_force_dedicated_snapshot_spawn invalid predicate -> false (don't reroute)")
    # An invalid callable shouldn't fire a spurious reroute - if we can't
    # verify safety we treat the saved position as trustworthy.
    t.assert_false(CoopWorldSnapshot.should_force_dedicated_snapshot_spawn(
        true, true, "alice", Vector3(1, 1, 1), Callable(),
    ))
