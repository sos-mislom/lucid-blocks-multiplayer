extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPatch.should_use_canonical_guest_block_patch is_server -> false")
    t.assert_false(CoopWorldPatch.should_use_canonical_guest_block_patch(
        true, true, false, true, Vector3.ZERO, Vector3i(100, 0, 0), 8.0,
    ))

    t.begin("CoopWorldPatch.should_use_canonical_guest_block_patch no live peer -> false")
    t.assert_false(CoopWorldPatch.should_use_canonical_guest_block_patch(
        false, false, false, true, Vector3.ZERO, Vector3i(100, 0, 0), 8.0,
    ))

    t.begin("CoopWorldPatch.should_use_canonical_guest_block_patch local is world authority -> false")
    t.assert_false(CoopWorldPatch.should_use_canonical_guest_block_patch(
        false, true, true, true, Vector3.ZERO, Vector3i(100, 0, 0), 8.0,
    ))

    t.begin("CoopWorldPatch.should_use_canonical_guest_block_patch host in different instance -> false")
    t.assert_false(CoopWorldPatch.should_use_canonical_guest_block_patch(
        false, true, false, false, Vector3.ZERO, Vector3i(100, 0, 0), 8.0,
    ))

    t.begin("CoopWorldPatch.should_use_canonical_guest_block_patch block outside host safe radius -> true")
    t.assert_true(CoopWorldPatch.should_use_canonical_guest_block_patch(
        false, true, false, true, Vector3.ZERO, Vector3i(100, 0, 0), 8.0,
    ), "100m block > 16m safe-radius floor -> canonical patch required")

    t.begin("CoopWorldPatch.should_use_canonical_guest_block_patch block inside host safe radius -> false")
    t.assert_false(CoopWorldPatch.should_use_canonical_guest_block_patch(
        false, true, false, true, Vector3.ZERO, Vector3i(5, 0, 0), 8.0,
    ), "5m block within 16m safe-radius -> incremental patch")

    t.begin("CoopWorldPatch.should_use_canonical_guest_block_patch host_load_radius below floor uses MIN_SAFE_GUEST_PATCH_RADIUS")
    t.assert_false(CoopWorldPatch.should_use_canonical_guest_block_patch(
        false, true, false, true, Vector3.ZERO, Vector3i(10, 0, 0), 4.0,
    ), "host_load_radius=4 but floor is 16, so 10m block is inside the safe zone")

    t.begin("CoopWorldPatch.should_use_canonical_guest_block_patch boundary distance is incremental (strict >)")
    var radius: float = CoopWorldPatch.MIN_SAFE_GUEST_PATCH_RADIUS
    var block_position: Vector3i = Vector3i(int(radius - 1), 0, 0)
    t.assert_false(CoopWorldPatch.should_use_canonical_guest_block_patch(
        false, true, false, true, Vector3.ZERO, block_position, radius,
    ), "block just inside safe radius (15+0.5=15.5 < 16) -> incremental")
