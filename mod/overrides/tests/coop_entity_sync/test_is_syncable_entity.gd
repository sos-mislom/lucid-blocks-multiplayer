extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.is_syncable_entity plain Entity -> true")
    t.assert_true(CoopEntitySync.is_syncable_entity(true, false, false))

    t.begin("CoopEntitySync.is_syncable_entity Player -> false")
    t.assert_false(CoopEntitySync.is_syncable_entity(true, true, false))

    t.begin("CoopEntitySync.is_syncable_entity remote-player proxy -> false")
    t.assert_false(CoopEntitySync.is_syncable_entity(true, false, true))

    t.begin("CoopEntitySync.is_syncable_entity non-Entity -> false")
    t.assert_false(CoopEntitySync.is_syncable_entity(false, false, false))
    t.assert_false(CoopEntitySync.is_syncable_entity(false, true, false))
    t.assert_false(CoopEntitySync.is_syncable_entity(false, false, true))
    t.assert_false(CoopEntitySync.is_syncable_entity(false, true, true))

    t.begin("CoopEntitySync.is_syncable_entity Player+proxy still false (defence in depth)")
    t.assert_false(CoopEntitySync.is_syncable_entity(true, true, true))
