extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopTeleport.USAGE_HINT pinned")
    t.assert_eq("Usage: /tp host, /tp <peer>, or /tp <x> <y> <z>", CoopTeleport.USAGE_HINT)

    t.begin("CoopTeleport.HINT_SAME_INSTANCE pinned")
    t.assert_eq("Teleport now", CoopTeleport.HINT_SAME_INSTANCE)

    t.begin("CoopTeleport.HINT_CROSS_INSTANCE pinned")
    t.assert_eq("Teleport after resync", CoopTeleport.HINT_CROSS_INSTANCE)

    t.begin("CoopTeleport.DEFAULT_NAMESPACE_FALLBACK pinned")
    t.assert_eq("unknown", CoopTeleport.DEFAULT_NAMESPACE_FALLBACK)

    t.begin("CoopTeleport.LEGACY_POCKET_OWNER_LABEL pinned")
    t.assert_eq("legacy", CoopTeleport.LEGACY_POCKET_OWNER_LABEL)

    t.begin("CoopTeleport.SAFE_OFFSET_CANDIDATES is 13 entries (matches pre-refactor _find_safe_respawn_position_near)")
    t.assert_eq(13, CoopTeleport.SAFE_OFFSET_CANDIDATES.size())

    t.begin("CoopTeleport.SAFE_OFFSET_CANDIDATES first entry is +X 1.5 (matches legacy iteration order)")
    t.assert_eq(Vector3(1.5, 0.0, 0.0), CoopTeleport.SAFE_OFFSET_CANDIDATES[0])

    t.begin("CoopTeleport.SAFE_OFFSET_CANDIDATES last entry is -Z up-1")
    t.assert_eq(Vector3(0.0, 1.0, -1.5), CoopTeleport.SAFE_OFFSET_CANDIDATES[12])

    t.begin("CoopTeleport.SAFE_OFFSET_CANDIDATES all entries are Vector3 (typed defensively)")
    for offset in CoopTeleport.SAFE_OFFSET_CANDIDATES:
        t.assert_true(offset is Vector3, "entry is not a Vector3: %s" % str(offset))
