extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldJournal.remember_server_dirty_chunk writes key with timestamp")
    var dirty: Dictionary = {}
    var key: String = CoopWorldJournal.remember_server_dirty_chunk(dirty, "dimension:0", Vector3i(1, 2, 3), 1234)
    t.assert_eq("dimension:0:1:2:3", key)
    t.assert_eq(1234, int(dirty.get("dimension:0:1:2:3", -1)))

    t.begin("CoopWorldJournal.remember_server_dirty_chunk no-op on empty instance key")
    var dirty2: Dictionary = {}
    var key2: String = CoopWorldJournal.remember_server_dirty_chunk(dirty2, "", Vector3i(1, 2, 3), 5678)
    t.assert_eq("", key2)
    t.assert_eq(0, dirty2.size(), "empty instance key must not mutate dirty_keys")

    t.begin("CoopWorldJournal.remember_server_dirty_chunk overwrites existing timestamp")
    var dirty3: Dictionary = {"dimension:0:1:2:3": 1000}
    CoopWorldJournal.remember_server_dirty_chunk(dirty3, "dimension:0", Vector3i(1, 2, 3), 2000)
    t.assert_eq(2000, int(dirty3.get("dimension:0:1:2:3", -1)), "later write replaces earlier timestamp")

    t.begin("CoopWorldJournal.remember_server_dirty_chunk multiple chunks coexist")
    var dirty4: Dictionary = {}
    CoopWorldJournal.remember_server_dirty_chunk(dirty4, "dimension:0", Vector3i(1, 2, 3), 100)
    CoopWorldJournal.remember_server_dirty_chunk(dirty4, "dimension:0", Vector3i(4, 5, 6), 200)
    CoopWorldJournal.remember_server_dirty_chunk(dirty4, "pocket:abc", Vector3i(1, 2, 3), 300)
    t.assert_eq(3, dirty4.size())
    t.assert_true(dirty4.has("dimension:0:1:2:3"))
    t.assert_true(dirty4.has("dimension:0:4:5:6"))
    t.assert_true(dirty4.has("pocket:abc:1:2:3"))
