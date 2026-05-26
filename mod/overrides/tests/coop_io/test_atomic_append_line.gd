extends RefCounted

const SCRATCH := "user://coop_test_atomic_append_line.txt"


func run(t: CoopTester) -> void:
    _cleanup()

    t.begin("CoopIO.atomic_append_line appends to a missing file")
    t.assert_true(CoopIO.atomic_append_line(SCRATCH, "first"), "append to missing file should succeed")
    t.assert_eq("first\n", _read(SCRATCH), "missing-file append should yield single line + newline")

    t.begin("CoopIO.atomic_append_line appends to an existing file")
    t.assert_true(CoopIO.atomic_append_line(SCRATCH, "second"), "append to existing should succeed")
    t.assert_eq("first\nsecond\n", _read(SCRATCH), "second append should follow newline")

    t.begin("CoopIO.atomic_append_line normalises a file missing trailing newline")
    var f: FileAccess = FileAccess.open(SCRATCH, FileAccess.WRITE)
    t.assert_true(f != null, "could not reset scratch")
    if f != null:
        f.store_string("no_newline")
        f.close()
    t.assert_true(CoopIO.atomic_append_line(SCRATCH, "after"), "append after no-newline file should succeed")
    t.assert_eq("no_newline\nafter\n", _read(SCRATCH), "missing trailing newline should be inserted before append")

    t.begin("CoopIO.atomic_append_line rejects an empty path")
    t.assert_false(CoopIO.atomic_append_line("", "x"), "empty path must return false")

    _cleanup()


func _read(path: String) -> String:
    if not FileAccess.file_exists(path):
        return ""
    var f: FileAccess = FileAccess.open(path, FileAccess.READ)
    if f == null:
        return ""
    var text: String = f.get_as_text()
    f.close()
    return text


func _cleanup() -> void:
    for path in [SCRATCH, SCRATCH + ".tmp"]:
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
