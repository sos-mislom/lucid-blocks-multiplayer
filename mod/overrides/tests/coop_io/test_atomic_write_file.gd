extends RefCounted

const SCRATCH := "user://coop_test_atomic_write_file.txt"


func run(t: CoopTester) -> void:
    _cleanup()

    t.begin("CoopIO.atomic_write_file writes content and returns true")
    var ok: bool = CoopIO.atomic_write_file(SCRATCH, "hello")
    t.assert_true(ok, "atomic_write_file should return true on success")
    t.assert_true(FileAccess.file_exists(SCRATCH), "target file should exist after write")
    t.assert_eq("hello", _read(SCRATCH), "round-trip content mismatch")

    t.begin("CoopIO.atomic_write_file rejects an empty path")
    t.assert_false(CoopIO.atomic_write_file("", "x"), "empty path must return false")

    t.begin("CoopIO.atomic_write_file overwrites existing content")
    t.assert_true(CoopIO.atomic_write_file(SCRATCH, "second"), "overwrite should succeed")
    t.assert_eq("second", _read(SCRATCH), "overwrite content mismatch")

    t.begin("CoopIO.atomic_write_file leaves no .tmp sibling on success")
    var tmp_sibling: String = SCRATCH + ".tmp"
    t.assert_false(FileAccess.file_exists(tmp_sibling), ".tmp sibling should be renamed away")

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
