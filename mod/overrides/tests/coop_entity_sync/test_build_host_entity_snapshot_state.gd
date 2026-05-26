extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.build_host_entity_snapshot_state populates all 11 fields")
    var snapshot: Dictionary = CoopEntitySync.build_host_entity_snapshot_state(
        "res://entities/chicken.tscn",
        Vector3(1.0, 2.0, 3.0),
        1.5707,
        Vector3(0.1, 0.0, 0.0),
        Vector3(0.0, -9.8, 0.0),
        Vector3(0.5, 0.0, 0.0),
        Vector3(0.0, 0.0, 0.2),
        false,
        true,
        42,
        3,
    )
    t.assert_eq(11, snapshot.size(), "11 known fields populated")
    t.assert_eq(Vector3(1.0, 2.0, 3.0), snapshot.get("position", Vector3.ZERO))
    t.assert_eq(1.5707, float(snapshot.get("yaw", 0.0)))
    t.assert_eq(Vector3(0.1, 0.0, 0.0), snapshot.get("movement_velocity", Vector3.ZERO))
    t.assert_eq(Vector3(0.0, -9.8, 0.0), snapshot.get("gravity_velocity", Vector3.ZERO))
    t.assert_eq(Vector3(0.5, 0.0, 0.0), snapshot.get("knockback_velocity", Vector3.ZERO))
    t.assert_eq(Vector3(0.0, 0.0, 0.2), snapshot.get("rope_velocity", Vector3.ZERO))
    t.assert_false(bool(snapshot.get("dead", true)))
    t.assert_true(bool(snapshot.get("disabled", false)))
    t.assert_eq(42, int(snapshot.get("held_item_id", -1)))
    t.assert_eq(3, int(snapshot.get("held_item_index", -1)))
    t.assert_eq("res://entities/chicken.tscn", str(snapshot.get("scene", "")))

    t.begin("CoopEntitySync.build_host_entity_snapshot_state accepts empty scene path")
    var empty_scene: Dictionary = CoopEntitySync.build_host_entity_snapshot_state(
        "", Vector3.ZERO, 0.0, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO,
        false, false, -1, 0,
    )
    t.assert_eq("", str(empty_scene.get("scene", "MISSING")))
