extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDedicatedBootstrap.read_cmdline_bool no match -> default")
    t.assert_eq(true, CoopDedicatedBootstrap.read_cmdline_bool([], ["--lb-status"], true))
    t.assert_eq(false, CoopDedicatedBootstrap.read_cmdline_bool([], ["--lb-status"], false))

    t.begin("CoopDedicatedBootstrap.read_cmdline_bool truthy values map to true")
    t.assert_eq(true, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=1"], ["--lb-status"], false))
    t.assert_eq(true, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=true"], ["--lb-status"], false))
    t.assert_eq(true, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=YES"], ["--lb-status"], false))
    t.assert_eq(true, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=On"], ["--lb-status"], false))

    t.begin("CoopDedicatedBootstrap.read_cmdline_bool falsy values map to false")
    t.assert_eq(false, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=0"], ["--lb-status"], true))
    t.assert_eq(false, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=False"], ["--lb-status"], true))
    t.assert_eq(false, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=no"], ["--lb-status"], true))
    t.assert_eq(false, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=OFF"], ["--lb-status"], true))

    t.begin("CoopDedicatedBootstrap.read_cmdline_bool unrecognized value -> default")
    t.assert_eq(true, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=maybe"], ["--lb-status"], true))
    t.assert_eq(false, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status=maybe"], ["--lb-status"], false))

    t.begin("CoopDedicatedBootstrap.read_cmdline_bool next-arg form works")
    t.assert_eq(true, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status", "yes"], ["--lb-status"], false))
    t.assert_eq(false, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status", "no"], ["--lb-status"], true))

    t.begin("CoopDedicatedBootstrap.read_cmdline_bool empty inline value -> default")
    t.assert_eq(true, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status="], ["--lb-status"], true))
    t.assert_eq(false, CoopDedicatedBootstrap.read_cmdline_bool(["--lb-status="], ["--lb-status"], false))
