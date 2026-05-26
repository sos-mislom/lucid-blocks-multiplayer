extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJoinProtocol.build_protocol_info pins fields")
    var info: Dictionary = CoopJoinProtocol.build_protocol_info(
        "lucid-blocks-coop",
        1,
        1,
        ["foo"],
        ["bar"],
        "0.42.0",
    )
    t.assert_eq("lucid-blocks-coop", info.get("protocol"))
    t.assert_eq(1, info.get("version"))
    t.assert_eq(1, info.get("min"))
    t.assert_eq(1, (info.get("features") as Array).size())
    t.assert_eq("foo", (info.get("features") as Array)[0])
    t.assert_eq(1, (info.get("required_features") as Array).size())
    t.assert_eq("0.42.0", info.get("game_version"))
