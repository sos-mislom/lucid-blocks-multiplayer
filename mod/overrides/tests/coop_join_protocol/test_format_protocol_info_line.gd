extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJoinProtocol.format_protocol_info_line full info")
    t.assert_eq(
        "lucid-blocks-coop p1 min1 features[foo,bar]",
        CoopJoinProtocol.format_protocol_info_line({
            "protocol": "lucid-blocks-coop",
            "version": 1,
            "min": 1,
            "features": ["foo", "bar"],
        })
    )

    t.begin("CoopJoinProtocol.format_protocol_info_line missing fields -> unknown / 0 / -")
    t.assert_eq("unknown p0 min0 features[-]", CoopJoinProtocol.format_protocol_info_line({}))

    t.begin("CoopJoinProtocol.format_protocol_info_line empty features -> '-'")
    t.assert_eq(
        "lucid-blocks-coop p2 min1 features[-]",
        CoopJoinProtocol.format_protocol_info_line({
            "protocol": "lucid-blocks-coop",
            "version": 2,
            "min": 1,
            "features": [],
        })
    )
