extends RefCounted


func run(t: CoopTester) -> void:
    var near_sq: float = CoopEntityVisuals.VISUAL_NEAR_RADIUS * CoopEntityVisuals.VISUAL_NEAR_RADIUS
    var mid_sq: float = CoopEntityVisuals.VISUAL_MID_RADIUS * CoopEntityVisuals.VISUAL_MID_RADIUS

    t.begin("CoopEntityVisuals.resolve_client_visual_update_interval !can_sample_player -> 0.0 (per-frame)")
    t.assert_eq(0.0, CoopEntityVisuals.resolve_client_visual_update_interval(false, 99999.0))

    t.begin("CoopEntityVisuals.resolve_client_visual_update_interval inside near band -> 0.0 (per-frame)")
    t.assert_eq(0.0, CoopEntityVisuals.resolve_client_visual_update_interval(true, near_sq * 0.5))

    t.begin("CoopEntityVisuals.resolve_client_visual_update_interval exactly on near boundary -> 0.0 (inclusive)")
    t.assert_eq(0.0, CoopEntityVisuals.resolve_client_visual_update_interval(true, near_sq))

    t.begin("CoopEntityVisuals.resolve_client_visual_update_interval just past near -> mid interval")
    t.assert_eq(CoopEntityVisuals.VISUAL_MID_INTERVAL,
        CoopEntityVisuals.resolve_client_visual_update_interval(true, near_sq + 1.0))

    t.begin("CoopEntityVisuals.resolve_client_visual_update_interval exactly on mid boundary -> mid interval (inclusive)")
    t.assert_eq(CoopEntityVisuals.VISUAL_MID_INTERVAL,
        CoopEntityVisuals.resolve_client_visual_update_interval(true, mid_sq))

    t.begin("CoopEntityVisuals.resolve_client_visual_update_interval just past mid -> far interval")
    t.assert_eq(CoopEntityVisuals.VISUAL_FAR_INTERVAL,
        CoopEntityVisuals.resolve_client_visual_update_interval(true, mid_sq + 1.0))

    t.begin("CoopEntityVisuals.resolve_client_visual_update_interval accepts overrides")
    t.assert_eq(99.0, CoopEntityVisuals.resolve_client_visual_update_interval(
        true, 10.0, 4.0, 9.0, 33.0, 99.0,
    ), "distance_sq=10 past mid_sq=9 -> far_interval=99")
    t.assert_eq(33.0, CoopEntityVisuals.resolve_client_visual_update_interval(
        true, 5.0, 4.0, 9.0, 33.0, 99.0,
    ), "distance_sq=5 past near_sq=4, within mid_sq=9 -> mid_interval=33")
    t.assert_eq(0.0, CoopEntityVisuals.resolve_client_visual_update_interval(
        true, 4.0, 4.0, 9.0, 33.0, 99.0,
    ), "distance_sq=4 exactly on near_sq -> 0")
