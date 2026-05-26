extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPredict.server_block_action_key composes <sender>:<request>:<action>")
    t.assert_eq("3:42:place", CoopWorldPredict.server_block_action_key(3, 42, "place"))
    t.assert_eq("1:1:break", CoopWorldPredict.server_block_action_key(1, 1, "break"))

    t.begin("CoopWorldPredict.server_block_action_key sender_id <= 0 -> '' sentinel")
    t.assert_eq("", CoopWorldPredict.server_block_action_key(0, 42, "place"))
    t.assert_eq("", CoopWorldPredict.server_block_action_key(-5, 42, "place"))

    t.begin("CoopWorldPredict.server_block_action_key request_id <= 0 -> '' sentinel")
    t.assert_eq("", CoopWorldPredict.server_block_action_key(3, 0, "place"))
    t.assert_eq("", CoopWorldPredict.server_block_action_key(3, -10, "place"))

    t.begin("CoopWorldPredict.server_block_action_key empty action -> '' sentinel")
    t.assert_eq("", CoopWorldPredict.server_block_action_key(3, 42, ""))
