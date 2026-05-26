extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDedicatedBootstrap.cmdline_has_flag literal match")
    t.assert_eq(true, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-dedicated"], ["--lb-dedicated"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag literal match with alias list")
    t.assert_eq(
        true,
        CoopDedicatedBootstrap.cmdline_has_flag(["--dedicated"], ["--lb-dedicated", "--dedicated", "--lucid-dedicated"]),
    )

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag no match -> false")
    t.assert_eq(false, CoopDedicatedBootstrap.cmdline_has_flag(["--foo", "bar"], ["--lb-dedicated"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag --flag=1 truthy")
    t.assert_eq(true, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=1"], ["--lb-status"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag --flag=true truthy")
    t.assert_eq(true, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=true"], ["--lb-status"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag --flag=yes/on case-insensitive truthy")
    t.assert_eq(true, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=YES"], ["--lb-status"]))
    t.assert_eq(true, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=On"], ["--lb-status"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag --flag=0/false/no/off short-circuits to false")
    t.assert_eq(false, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=0"], ["--lb-status"]))
    t.assert_eq(false, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=False"], ["--lb-status"]))
    t.assert_eq(false, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=no"], ["--lb-status"]))
    t.assert_eq(false, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=OFF"], ["--lb-status"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag --flag=arbitrary truthy")
    t.assert_eq(true, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=anything"], ["--lb-status"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag empty value (--flag=) treated as truthy")
    # Live behavior: empty value is NOT in the falsy list, so it returns true.
    t.assert_eq(true, CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status="], ["--lb-status"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag whitespace-padded args still match")
    t.assert_eq(true, CoopDedicatedBootstrap.cmdline_has_flag(["   --lb-dedicated   "], ["--lb-dedicated"]))

    t.begin("CoopDedicatedBootstrap.cmdline_has_flag earlier --flag=0 short-circuits before later --flag")
    # Live behavior: scanning hits `--lb-status=0` first which returns false,
    # so a later `--lb-status` literal never gets a chance to flip the answer.
    t.assert_eq(
        false,
        CoopDedicatedBootstrap.cmdline_has_flag(["--lb-status=0", "--lb-status"], ["--lb-status"]),
    )
