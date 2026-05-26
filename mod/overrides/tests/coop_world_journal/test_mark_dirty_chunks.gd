extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldJournal.mark_dirty_chunks writes all chunk keys with timestamp")
    var dirty: Dictionary = {}
    var added: int = CoopWorldJournal.mark_dirty_chunks(
        dirty,
        "dimension:0",
        [Vector3i(0, 0, 0), Vector3i(16, 0, 0), Vector3i(0, 16, 0)],
        5000,
    )
    t.assert_eq(3, added)
    t.assert_eq(3, dirty.size())
    t.assert_eq(5000, int(dirty.get("dimension:0:0:0:0", -1)))
    t.assert_eq(5000, int(dirty.get("dimension:0:16:0:0", -1)))

    t.begin("CoopWorldJournal.mark_dirty_chunks no-op on empty instance key")
    var dirty2: Dictionary = {}
    var added2: int = CoopWorldJournal.mark_dirty_chunks(dirty2, "", [Vector3i(0, 0, 0)], 100)
    t.assert_eq(0, added2)
    t.assert_eq(0, dirty2.size())

    t.begin("CoopWorldJournal.mark_dirty_chunks skips non-Vector3i entries (defensive)")
    var dirty3: Dictionary = {}
    var added3: int = CoopWorldJournal.mark_dirty_chunks(
        dirty3,
        "dimension:0",
        [Vector3i(1, 0, 0), "not a vec", null, Vector3(2.0, 0.0, 0.0), Vector3i(3, 0, 0)],
        100,
    )
    t.assert_eq(2, added3, "only the two Vector3i entries count")
    t.assert_eq(2, dirty3.size())
    t.assert_true(dirty3.has("dimension:0:1:0:0"))
    t.assert_true(dirty3.has("dimension:0:3:0:0"))

    t.begin("CoopWorldJournal.mark_dirty_chunks empty list returns 0 added")
    var dirty4: Dictionary = {}
    var added4: int = CoopWorldJournal.mark_dirty_chunks(dirty4, "dimension:0", [], 100)
    t.assert_eq(0, added4)

    t.begin("CoopWorldJournal.mark_dirty_chunks 'added' counts only NEW keys, refresh of existing key does not count")
    var dirty5: Dictionary = {"dimension:0:1:0:0": 50}
    var added5: int = CoopWorldJournal.mark_dirty_chunks(
        dirty5,
        "dimension:0",
        [Vector3i(1, 0, 0), Vector3i(2, 0, 0)],
        500,
    )
    t.assert_eq(1, added5, "only (2,0,0) is new; (1,0,0) was already dirty")
    t.assert_eq(500, int(dirty5.get("dimension:0:1:0:0", -1)), "timestamp refreshed on existing key")
    t.assert_eq(500, int(dirty5.get("dimension:0:2:0:0", -1)))
