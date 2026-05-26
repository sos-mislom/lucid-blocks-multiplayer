extends SceneTree

# Headless test runner for the lucid-blocks coop mod. Usage:
#   godot --headless --path mod/overrides --script res://tests/runner.gd
#       [--filter <substring>]
#
# Auto-discovers every res://tests/**/test_*.gd, instantiates each, calls
# `run(t)` where t is a CoopTester (tests/test_helpers.gd), and exits with
# code 0 on all-pass / 1 on any failure.
#
# Filter argument example:
#   --script res://tests/runner.gd -- --filter coop_journal
# (Args after `--` are forwarded by Godot.)

const TESTS_DIR: String = "res://tests"


func _init() -> void:
    var filter: String = _read_filter_arg()

    var helpers_script: GDScript = load("res://tests/test_helpers.gd")
    if helpers_script == null:
        printerr("[tests] FATAL could not load test_helpers.gd")
        quit(1)
        return
    # Intentionally untyped: when the project's class_name cache has
    # not been built yet (first-run / CI cold start) the parser does
    # not know about `CoopTester` so an explicit annotation here
    # short-circuits the entire suite. Duck-typed access works either
    # way and the `t.begin / assert_*` API is stable.
    var t = helpers_script.new()

    var files: Array[String] = []
    _discover(TESTS_DIR, files)
    files.sort()

    var file_count: int = 0
    var failed_files: int = 0
    for f in files:
        if filter != "" and f.find(filter) < 0:
            continue
        if f.ends_with("/runner.gd") or f.ends_with("/test_helpers.gd"):
            continue
        var script: GDScript = load(f)
        if script == null or not script.can_instantiate():
            printerr("[tests] FATAL could not load %s (parse error)" % f)
            failed_files += 1
            continue
        var instance: Object = script.new()
        if instance == null:
            printerr("[tests] FATAL could not instantiate %s" % f)
            failed_files += 1
            continue
        if not instance.has_method("run"):
            continue
        file_count += 1
        t.begin_file(f)
        instance.run(t)
        if t.file_failed:
            failed_files += 1
        t.end_file()

    var ok: bool = failed_files == 0 and t.failed_asserts == 0
    print("[tests] files=%d failed_files=%d asserts=%d failed_asserts=%d" % [file_count, failed_files, t.total_asserts, t.failed_asserts])
    if not ok:
        print("[tests] -- failure summary --")
        for line in t.failure_log:
            print(line)
    quit(0 if ok else 1)


func _discover(dir_path: String, out: Array[String]) -> void:
    var dir: DirAccess = DirAccess.open(dir_path)
    if dir == null:
        return
    dir.list_dir_begin()
    while true:
        var entry: String = dir.get_next()
        if entry == "":
            break
        if entry.begins_with("."):
            continue
        var full: String = dir_path + "/" + entry
        if dir.current_is_dir():
            _discover(full, out)
        elif entry.begins_with("test_") and entry.ends_with(".gd"):
            out.append(full)
    dir.list_dir_end()


func _read_filter_arg() -> String:
    var args: PackedStringArray = OS.get_cmdline_user_args()
    var i: int = 0
    while i < args.size():
        if args[i] == "--filter" and i + 1 < args.size():
            return args[i + 1]
        if args[i].begins_with("--filter="):
            return args[i].substr("--filter=".length())
        i += 1
    return ""
