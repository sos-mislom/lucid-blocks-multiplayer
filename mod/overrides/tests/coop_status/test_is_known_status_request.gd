extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopStatus.is_known_status_request accepts canonical no-arg pings")
    t.assert_true(CoopStatus.is_known_status_request(""))
    t.assert_true(CoopStatus.is_known_status_request("ping"))
    t.assert_true(CoopStatus.is_known_status_request("status"))
    t.assert_true(CoopStatus.is_known_status_request("health"))

    t.begin("CoopStatus.is_known_status_request rejects unrelated request types")
    t.assert_false(CoopStatus.is_known_status_request("subscribe"))
    t.assert_false(CoopStatus.is_known_status_request("metrics"))
    t.assert_false(CoopStatus.is_known_status_request("foo"))
    t.assert_false(CoopStatus.is_known_status_request("PING"), "case-sensitive: parse_status_request normalises first")
