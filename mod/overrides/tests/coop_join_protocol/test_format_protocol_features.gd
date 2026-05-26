extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJoinProtocol.format_protocol_features empty -> '-'")
    t.assert_eq("-", CoopJoinProtocol.format_protocol_features([]))
    t.assert_eq("-", CoopJoinProtocol.format_protocol_features("not array"))

    t.begin("CoopJoinProtocol.format_protocol_features joins with comma")
    t.assert_eq("foo", CoopJoinProtocol.format_protocol_features(["foo"]))
    t.assert_eq("foo,bar", CoopJoinProtocol.format_protocol_features(["foo", "bar"]))
    t.assert_eq("foo,bar", CoopJoinProtocol.format_protocol_features([" foo ", "  bar"]))
