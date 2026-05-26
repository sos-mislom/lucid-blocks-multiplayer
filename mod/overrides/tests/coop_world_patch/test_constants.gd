extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPatch.WORLD_PATCH_CHUNK_SUFFIXES pinned to 4 expected entries")
    t.assert_eq(4, CoopWorldPatch.WORLD_PATCH_CHUNK_SUFFIXES.size())
    t.assert_eq("chunk_block", str(CoopWorldPatch.WORLD_PATCH_CHUNK_SUFFIXES[0]))
    t.assert_eq("chunk_water", str(CoopWorldPatch.WORLD_PATCH_CHUNK_SUFFIXES[1]))
    t.assert_eq("chunk_water_awake", str(CoopWorldPatch.WORLD_PATCH_CHUNK_SUFFIXES[2]))
    t.assert_eq("chunk_fire", str(CoopWorldPatch.WORLD_PATCH_CHUNK_SUFFIXES[3]))

    t.begin("CoopWorldPatch.MIN_SAFE_GUEST_PATCH_RADIUS pinned to 16.0")
    t.assert_eq(16.0, CoopWorldPatch.MIN_SAFE_GUEST_PATCH_RADIUS)

    t.begin("CoopWorldPatch.BLOCK_CENTER_OFFSET pinned to (0.5, 0.5, 0.5)")
    t.assert_eq(Vector3(0.5, 0.5, 0.5), CoopWorldPatch.BLOCK_CENTER_OFFSET)
