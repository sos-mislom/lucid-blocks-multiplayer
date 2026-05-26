extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDedicatedBootstrap.read_cmdline_value next-arg form")
    t.assert_eq(
        "saves/foo",
        CoopDedicatedBootstrap.read_cmdline_value(["--lb-world", "saves/foo"], ["--lb-world"], ""),
    )

    t.begin("CoopDedicatedBootstrap.read_cmdline_value inline =value form")
    t.assert_eq(
        "saves/foo",
        CoopDedicatedBootstrap.read_cmdline_value(["--lb-world=saves/foo"], ["--lb-world"], ""),
    )

    t.begin("CoopDedicatedBootstrap.read_cmdline_value strips whitespace from value")
    t.assert_eq(
        "saves/foo",
        CoopDedicatedBootstrap.read_cmdline_value(["--lb-world", "  saves/foo  "], ["--lb-world"], ""),
    )

    t.begin("CoopDedicatedBootstrap.read_cmdline_value falls back to default when no match")
    t.assert_eq(
        "fallback",
        CoopDedicatedBootstrap.read_cmdline_value(["--lb-status"], ["--lb-world"], "fallback"),
    )

    t.begin("CoopDedicatedBootstrap.read_cmdline_value alias list (first matching arg wins)")
    t.assert_eq(
        "27015",
        CoopDedicatedBootstrap.read_cmdline_value(["--port", "27015"], ["--lb-port", "--port"], ""),
    )

    t.begin("CoopDedicatedBootstrap.read_cmdline_value returns first occurrence")
    t.assert_eq(
        "first",
        CoopDedicatedBootstrap.read_cmdline_value(
            ["--lb-world=first", "--lb-world=second"],
            ["--lb-world"],
            "",
        ),
    )

    t.begin("CoopDedicatedBootstrap.read_cmdline_value literal at last position with no follow-up returns default")
    # Live behavior: literal `--lb-world` as final arg yields no value -> default.
    t.assert_eq(
        "fallback",
        CoopDedicatedBootstrap.read_cmdline_value(["--lb-world"], ["--lb-world"], "fallback"),
    )

    t.begin("CoopDedicatedBootstrap.read_cmdline_value inline empty value -> empty string")
    t.assert_eq(
        "",
        CoopDedicatedBootstrap.read_cmdline_value(["--lb-world="], ["--lb-world"], "fallback"),
    )
