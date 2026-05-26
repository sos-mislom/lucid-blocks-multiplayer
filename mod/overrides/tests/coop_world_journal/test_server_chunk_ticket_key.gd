extends RefCounted


func run(t: CoopTester) -> void:
    # NOTE: see CoopWorldJournal.server_chunk_ticket_key for the full
    # explanation. The live template `"%s:%s:%s:%s"` has 4 placeholders
    # but the substitution array has 3 entries; Godot's `String.%`
    # returns the template UNCHANGED in this case. The assertions below
    # PIN the buggy behaviour so an accidental "fix" surfaces as a CI
    # failure. The real repair lives in Phase 25.

    t.begin("CoopWorldJournal.server_chunk_ticket_key returns the unsubstituted template (live buggy behaviour pinned)")
    var key: String = CoopWorldJournal.server_chunk_ticket_key("place", 5, "dimension:0", Vector3i(1, 2, 3))
    t.assert_eq("%s:%s:%s:%s", key, "live arity mismatch: 4 placeholders, 3 args -> template returned verbatim")

    t.begin("CoopWorldJournal.server_chunk_ticket_key buggy output ignores all arguments")
    var key2: String = CoopWorldJournal.server_chunk_ticket_key("break", 99, "pocket:xyz", Vector3i(-10, 20, -30))
    t.assert_eq("%s:%s:%s:%s", key2, "every call returns the same literal string")
