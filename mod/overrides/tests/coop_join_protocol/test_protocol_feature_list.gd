extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJoinProtocol.protocol_feature_list non-Array -> empty")
    t.assert_eq(0, CoopJoinProtocol.protocol_feature_list("foo").size())
    t.assert_eq(0, CoopJoinProtocol.protocol_feature_list(42).size())
    t.assert_eq(0, CoopJoinProtocol.protocol_feature_list(null).size())

    t.begin("CoopJoinProtocol.protocol_feature_list strips and drops empties")
    var result: Array = CoopJoinProtocol.protocol_feature_list(["  foo  ", "", "  ", "bar"])
    t.assert_eq(2, result.size())
    t.assert_eq("foo", result[0])
    t.assert_eq("bar", result[1])

    t.begin("CoopJoinProtocol.protocol_feature_list dedupes")
    result = CoopJoinProtocol.protocol_feature_list(["foo", "foo", "bar", "foo"])
    t.assert_eq(2, result.size())

    t.begin("CoopJoinProtocol.protocol_feature_list coerces non-string entries via str()")
    result = CoopJoinProtocol.protocol_feature_list([42, 7, 42])
    t.assert_eq(2, result.size())
    t.assert_eq("42", result[0])
    t.assert_eq("7", result[1])
