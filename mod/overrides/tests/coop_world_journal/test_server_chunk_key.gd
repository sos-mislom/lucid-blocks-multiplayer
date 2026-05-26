extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldJournal.server_chunk_key composes <inst>:<x>:<y>:<z>")
    t.assert_eq("dimension:0:1:2:3", CoopWorldJournal.server_chunk_key("dimension:0", Vector3i(1, 2, 3)))

    t.begin("CoopWorldJournal.server_chunk_key handles negative components")
    t.assert_eq("pocket:abc:-7:0:-12", CoopWorldJournal.server_chunk_key("pocket:abc", Vector3i(-7, 0, -12)))

    t.begin("CoopWorldJournal.server_chunk_key handles Vector3i.ZERO")
    t.assert_eq("dimension:5:0:0:0", CoopWorldJournal.server_chunk_key("dimension:5", Vector3i.ZERO))

    t.begin("CoopWorldJournal.server_chunk_key handles empty instance key (defensive - forwarder usually filters)")
    t.assert_eq(":1:2:3", CoopWorldJournal.server_chunk_key("", Vector3i(1, 2, 3)))
