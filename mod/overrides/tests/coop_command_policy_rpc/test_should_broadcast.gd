extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCommandPolicyRPC.should_broadcast true only when server AND live peer")
    t.assert_true(CoopCommandPolicyRPC.should_broadcast(true, true), "server with live peer must broadcast")

    t.begin("CoopCommandPolicyRPC.should_broadcast false in singleplayer (server, no peers)")
    t.assert_false(CoopCommandPolicyRPC.should_broadcast(true, false), "server with no peers must not broadcast")

    t.begin("CoopCommandPolicyRPC.should_broadcast false from client with peer")
    t.assert_false(CoopCommandPolicyRPC.should_broadcast(false, true), "client must never broadcast policy")

    t.begin("CoopCommandPolicyRPC.should_broadcast false from disconnected client")
    t.assert_false(CoopCommandPolicyRPC.should_broadcast(false, false), "disconnected client must not broadcast")
