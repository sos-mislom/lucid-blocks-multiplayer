extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJoinProtocol.extract_protocol_info_from_status missing all keys -> empty")
    t.assert_true(CoopJoinProtocol.extract_protocol_info_from_status({}).is_empty())
    t.assert_true(CoopJoinProtocol.extract_protocol_info_from_status({"foo": "bar"}).is_empty())

    t.begin("CoopJoinProtocol.extract_protocol_info_from_status any key triggers extraction")
    var info: Dictionary = CoopJoinProtocol.extract_protocol_info_from_status({"coop_protocol": "lucid-blocks-coop"})
    t.assert_false(info.is_empty())
    t.assert_eq("lucid-blocks-coop", info.get("protocol"))
    t.assert_eq(0, info.get("version"))
    t.assert_eq(0, info.get("min"))

    t.begin("CoopJoinProtocol.extract_protocol_info_from_status min defaults to version")
    info = CoopJoinProtocol.extract_protocol_info_from_status({"coop_protocol_version": 3})
    t.assert_eq(3, info.get("version"))
    t.assert_eq(3, info.get("min"))

    t.begin("CoopJoinProtocol.extract_protocol_info_from_status full extraction")
    info = CoopJoinProtocol.extract_protocol_info_from_status({
        "coop_protocol": "lucid-blocks-coop",
        "coop_protocol_version": 2,
        "coop_protocol_min": 1,
        "coop_protocol_features": ["foo", "bar"],
        "coop_protocol_required_features": ["baz"],
        "version": "0.42.0",
    })
    t.assert_eq("lucid-blocks-coop", info.get("protocol"))
    t.assert_eq(2, info.get("version"))
    t.assert_eq(1, info.get("min"))
    t.assert_eq(2, (info.get("features") as Array).size())
    t.assert_eq(1, (info.get("required_features") as Array).size())
    t.assert_eq("0.42.0", info.get("game_version"))
