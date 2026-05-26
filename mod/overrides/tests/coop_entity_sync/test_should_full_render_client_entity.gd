extends RefCounted


class _PositionLoadedProbe:
    var loaded_set: Dictionary = {}
    var calls: int = 0
    func _init(loaded: Array = []) -> void:
        for position in loaded:
            loaded_set[position] = true
    func is_position_loaded(block_position: Vector3i) -> bool:
        calls += 1
        return loaded_set.has(block_position)


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.should_full_render_client_entity world invalid -> false")
    var pr_invalid: _PositionLoadedProbe = _PositionLoadedProbe.new()
    t.assert_false(CoopEntitySync.should_full_render_client_entity(
        false, Vector3.ZERO, Callable(pr_invalid, "is_position_loaded"),
    ))

    t.begin("CoopEntitySync.should_full_render_client_entity invalid callable -> false")
    t.assert_false(CoopEntitySync.should_full_render_client_entity(true, Vector3.ZERO, Callable()))

    t.begin("CoopEntitySync.should_full_render_client_entity loaded chunk -> true")
    var pr_yes: _PositionLoadedProbe = _PositionLoadedProbe.new([Vector3i(0, 0, 0)])
    t.assert_true(CoopEntitySync.should_full_render_client_entity(
        true, Vector3(0.5, 0.5, 0.5), Callable(pr_yes, "is_position_loaded"),
    ))
    t.assert_eq(1, pr_yes.calls, "predicate invoked once")

    t.begin("CoopEntitySync.should_full_render_client_entity not-loaded chunk -> false")
    var pr_no: _PositionLoadedProbe = _PositionLoadedProbe.new([Vector3i(0, 0, 0)])
    t.assert_false(CoopEntitySync.should_full_render_client_entity(
        true, Vector3(100.0, 100.0, 100.0), Callable(pr_no, "is_position_loaded"),
    ))

    t.begin("CoopEntitySync.should_full_render_client_entity uses floored block position")
    var pr_neg: _PositionLoadedProbe = _PositionLoadedProbe.new([Vector3i(-1, -1, -1)])
    t.assert_true(CoopEntitySync.should_full_render_client_entity(
        true, Vector3(-0.5, -0.5, -0.5), Callable(pr_neg, "is_position_loaded"),
    ))
