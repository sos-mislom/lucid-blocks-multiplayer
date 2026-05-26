extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDedicatedBootstrap.merge_cmdline_args empty arrays -> empty")
    var result: Array = CoopDedicatedBootstrap.merge_cmdline_args([], [])
    t.assert_eq(0, result.size())

    t.begin("CoopDedicatedBootstrap.merge_cmdline_args preserves order of base args")
    result = CoopDedicatedBootstrap.merge_cmdline_args(["--lb-dedicated", "--port=27015"], [])
    t.assert_eq(2, result.size())
    t.assert_eq("--lb-dedicated", result[0])
    t.assert_eq("--port=27015", result[1])

    t.begin("CoopDedicatedBootstrap.merge_cmdline_args appends user args after base")
    result = CoopDedicatedBootstrap.merge_cmdline_args(["--lb-dedicated"], ["--lb-world", "saves/foo"])
    t.assert_eq(3, result.size())
    t.assert_eq("--lb-dedicated", result[0])
    t.assert_eq("--lb-world", result[1])
    t.assert_eq("saves/foo", result[2])

    t.begin("CoopDedicatedBootstrap.merge_cmdline_args dedupes user args that already appear in base")
    result = CoopDedicatedBootstrap.merge_cmdline_args(["--lb-dedicated", "--port=27015"], ["--lb-dedicated", "--lb-status"])
    t.assert_eq(3, result.size())
    t.assert_eq("--lb-dedicated", result[0])
    t.assert_eq("--port=27015", result[1])
    t.assert_eq("--lb-status", result[2])

    t.begin("CoopDedicatedBootstrap.merge_cmdline_args accepts PackedStringArray from OS")
    result = CoopDedicatedBootstrap.merge_cmdline_args(PackedStringArray(["--editor"]), PackedStringArray(["--lb-dedicated", "--lb-port=24667"]))
    t.assert_eq(3, result.size())
    t.assert_eq("--editor", result[0])
    t.assert_eq("--lb-dedicated", result[1])
    t.assert_eq("--lb-port=24667", result[2])

    t.begin("CoopDedicatedBootstrap.merge_cmdline_args dedupes within base args (first-wins)")
    result = CoopDedicatedBootstrap.merge_cmdline_args(["--lb-dedicated", "--lb-dedicated"], [])
    t.assert_eq(1, result.size())
    t.assert_eq("--lb-dedicated", result[0])

    t.begin("CoopDedicatedBootstrap.merge_cmdline_args non-sequence input treated as empty")
    result = CoopDedicatedBootstrap.merge_cmdline_args(null, ["--foo"])
    t.assert_eq(1, result.size())
    t.assert_eq("--foo", result[0])
