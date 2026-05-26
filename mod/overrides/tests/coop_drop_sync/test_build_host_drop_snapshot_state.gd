extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropSync.build_host_drop_snapshot_state pins fields")
    var state: Dictionary = CoopDropSync.build_host_drop_snapshot_state(
        Vector3(1.0, 2.0, 3.0),
        Vector3(0.1, 0.2, 0.3),
        "42:7",
        true,
        2,
    )
    t.assert_eq(Vector3(1.0, 2.0, 3.0), state.get("position"))
    t.assert_eq(Vector3(0.1, 0.2, 0.3), state.get("velocity"))
    t.assert_eq("42:7", state.get("item"))
    t.assert_eq(true, state.get("can_collect"))
    t.assert_eq(2, state.get("state"))

    t.begin("CoopDropSync.build_host_drop_snapshot_state can_collect false / state 0")
    state = CoopDropSync.build_host_drop_snapshot_state(
        Vector3.ZERO,
        Vector3.ZERO,
        "",
        false,
        0,
    )
    t.assert_eq("", state.get("item"))
    t.assert_eq(false, state.get("can_collect"))
    t.assert_eq(0, state.get("state"))
