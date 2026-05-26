extends RefCounted

const SCRATCH := "user://coop_test_applied_seq.txt"


func run(t: CoopTester) -> void:
    _cleanup()

    t.begin("CoopJournal.read_applied_seq returns 0 for a missing file")
    t.assert_eq(0, CoopJournal.read_applied_seq(SCRATCH))

    t.begin("CoopJournal.write_applied_seq + read_applied_seq round-trip")
    t.assert_true(CoopJournal.write_applied_seq(SCRATCH, 1234), "write_applied_seq must succeed")
    t.assert_eq(1234, CoopJournal.read_applied_seq(SCRATCH))

    t.begin("CoopJournal.write_applied_seq rejects non-positive seq")
    t.assert_false(CoopJournal.write_applied_seq(SCRATCH, 0), "0 must be rejected")
    t.assert_false(CoopJournal.write_applied_seq(SCRATCH, -7), "negative must be rejected")
    t.assert_eq(1234, CoopJournal.read_applied_seq(SCRATCH), "value must be unchanged after rejected writes")

    t.begin("CoopJournal.write_applied_seq rejects empty path")
    t.assert_false(CoopJournal.write_applied_seq("", 5))

    t.begin("CoopJournal.read_applied_seq returns 0 for non-integer content")
    var f: FileAccess = FileAccess.open(SCRATCH, FileAccess.WRITE)
    t.assert_true(f != null, "could not open scratch for garbage")
    if f != null:
        f.store_string("not a number")
        f.close()
    t.assert_eq(0, CoopJournal.read_applied_seq(SCRATCH))

    _cleanup()


func _cleanup() -> void:
    for path in [SCRATCH, SCRATCH + ".tmp"]:
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
