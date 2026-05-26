extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJoinProtocol.has_protocol_features empty required -> true")
    t.assert_true(CoopJoinProtocol.has_protocol_features([], []))
    t.assert_true(CoopJoinProtocol.has_protocol_features(["foo"], []))

    t.begin("CoopJoinProtocol.has_protocol_features all covered")
    t.assert_true(CoopJoinProtocol.has_protocol_features(["foo", "bar"], ["foo"]))
    t.assert_true(CoopJoinProtocol.has_protocol_features(["foo", "bar"], ["foo", "bar"]))

    t.begin("CoopJoinProtocol.has_protocol_features missing -> false")
    t.assert_false(CoopJoinProtocol.has_protocol_features(["foo"], ["bar"]))
    t.assert_false(CoopJoinProtocol.has_protocol_features([], ["foo"]))

    t.begin("CoopJoinProtocol.has_protocol_features strips/dedupes both sides")
    t.assert_true(CoopJoinProtocol.has_protocol_features(["  foo  ", "foo"], ["foo  "]))
