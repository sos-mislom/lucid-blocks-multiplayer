extends RefCounted


func run(t: CoopTester) -> void:
    var near_sq: float = CoopEntitySync.ENTITY_VISUAL_NEAR_RADIUS * CoopEntitySync.ENTITY_VISUAL_NEAR_RADIUS
    var mid_sq: float = CoopEntitySync.ENTITY_VISUAL_MID_RADIUS * CoopEntitySync.ENTITY_VISUAL_MID_RADIUS

    t.begin("CoopEntitySync.get_host_entity_snapshot_interval at zero distance -> near interval (20 Hz)")
    t.assert_eq(CoopEntitySync.ENTITY_SNAPSHOT_INTERVAL_NEAR,
        CoopEntitySync.get_host_entity_snapshot_interval(0.0))

    t.begin("CoopEntitySync.get_host_entity_snapshot_interval inside near band -> near interval")
    t.assert_eq(CoopEntitySync.ENTITY_SNAPSHOT_INTERVAL_NEAR,
        CoopEntitySync.get_host_entity_snapshot_interval(near_sq * 0.5))

    t.begin("CoopEntitySync.get_host_entity_snapshot_interval exactly on near boundary -> near interval (inclusive)")
    t.assert_eq(CoopEntitySync.ENTITY_SNAPSHOT_INTERVAL_NEAR,
        CoopEntitySync.get_host_entity_snapshot_interval(near_sq))

    t.begin("CoopEntitySync.get_host_entity_snapshot_interval inside mid band -> mid interval")
    t.assert_eq(CoopEntitySync.ENTITY_SNAPSHOT_INTERVAL_MID,
        CoopEntitySync.get_host_entity_snapshot_interval((near_sq + mid_sq) * 0.5))

    t.begin("CoopEntitySync.get_host_entity_snapshot_interval exactly on mid boundary -> mid interval (inclusive)")
    t.assert_eq(CoopEntitySync.ENTITY_SNAPSHOT_INTERVAL_MID,
        CoopEntitySync.get_host_entity_snapshot_interval(mid_sq))

    t.begin("CoopEntitySync.get_host_entity_snapshot_interval past mid -> far interval")
    t.assert_eq(CoopEntitySync.ENTITY_SNAPSHOT_INTERVAL_FAR,
        CoopEntitySync.get_host_entity_snapshot_interval(mid_sq * 4.0))

    t.begin("CoopEntitySync.get_host_entity_snapshot_interval accepts override radii")
    var custom_near_sq: float = 10.0 * 10.0
    var custom_mid_sq: float = 30.0 * 30.0
    t.assert_eq(0.05, CoopEntitySync.get_host_entity_snapshot_interval(50.0, custom_near_sq, custom_mid_sq))
    t.assert_eq(0.12, CoopEntitySync.get_host_entity_snapshot_interval(500.0, custom_near_sq, custom_mid_sq))
    t.assert_eq(0.35, CoopEntitySync.get_host_entity_snapshot_interval(5000.0, custom_near_sq, custom_mid_sq))

    t.begin("CoopEntitySync.get_host_entity_snapshot_interval accepts override intervals")
    t.assert_eq(2.5, CoopEntitySync.get_host_entity_snapshot_interval(0.0, near_sq, mid_sq, 2.5, 5.0, 10.0))
    t.assert_eq(5.0, CoopEntitySync.get_host_entity_snapshot_interval(near_sq * 2.0, near_sq, mid_sq, 2.5, 5.0, 10.0))
    t.assert_eq(10.0, CoopEntitySync.get_host_entity_snapshot_interval(mid_sq * 4.0, near_sq, mid_sq, 2.5, 5.0, 10.0))
