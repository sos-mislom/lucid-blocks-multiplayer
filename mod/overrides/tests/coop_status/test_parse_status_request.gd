extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopStatus.parse_status_request collapses empty/whitespace to ''")
    t.assert_eq("", CoopStatus.parse_status_request(""))
    t.assert_eq("", CoopStatus.parse_status_request("   \n\t"))

    t.begin("CoopStatus.parse_status_request lowercases plain text")
    t.assert_eq("ping", CoopStatus.parse_status_request("PING"))
    t.assert_eq("status", CoopStatus.parse_status_request("  Status  "))
    t.assert_eq("health", CoopStatus.parse_status_request("HeAlTh"))

    t.begin("CoopStatus.parse_status_request unwraps JSON {type:...}")
    t.assert_eq("ping", CoopStatus.parse_status_request("{\"type\":\"ping\"}"))
    t.assert_eq("status", CoopStatus.parse_status_request("{\"type\":\"STATUS\"}"))

    t.begin("CoopStatus.parse_status_request unwraps JSON {request:...}")
    t.assert_eq("health", CoopStatus.parse_status_request("{\"request\":\"health\"}"))

    t.begin("CoopStatus.parse_status_request prefers 'type' over 'request' when both present")
    t.assert_eq("ping", CoopStatus.parse_status_request("{\"type\":\"ping\",\"request\":\"status\"}"))

    t.begin("CoopStatus.parse_status_request returns '' for JSON without type or request")
    t.assert_eq("", CoopStatus.parse_status_request("{\"other\":\"value\"}"))

    t.begin("CoopStatus.parse_status_request treats garbage as the lowercased trimmed string")
    t.assert_eq("garbage data", CoopStatus.parse_status_request("Garbage Data"))

    t.begin("CoopStatus.parse_status_request handles malformed JSON as lowercased text")
    t.assert_eq("{not json", CoopStatus.parse_status_request("{not json"))
