extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDimensionTravel.decide_group_travel_path no live peer -> singleplayer (regardless of is_server)")
    t.assert_eq("singleplayer", str(CoopDimensionTravel.decide_group_travel_path(true, false).get("path", "")))
    t.assert_eq("singleplayer", str(CoopDimensionTravel.decide_group_travel_path(false, false).get("path", "")))

    t.begin("CoopDimensionTravel.decide_group_travel_path client with live peer -> client_request")
    t.assert_eq("client_request", str(CoopDimensionTravel.decide_group_travel_path(false, true).get("path", "")))

    t.begin("CoopDimensionTravel.decide_group_travel_path server with live peer -> server_orchestrate")
    t.assert_eq("server_orchestrate", str(CoopDimensionTravel.decide_group_travel_path(true, true).get("path", "")))
