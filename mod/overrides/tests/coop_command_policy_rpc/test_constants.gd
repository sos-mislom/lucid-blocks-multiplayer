extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCommandPolicyRPC.REJECTION_MESSAGE_TEMPLATE pinned (renaming surfaces in CI)")
    t.assert_eq("%s is disabled by server command policy", CoopCommandPolicyRPC.REJECTION_MESSAGE_TEMPLATE)

    t.begin("CoopCommandPolicyRPC.RESET_RESPONSE pinned")
    t.assert_eq("Server command policy reset", CoopCommandPolicyRPC.RESET_RESPONSE)

    t.begin("CoopCommandPolicyRPC.CLIENT_REJECTION_RESPONSE pinned")
    t.assert_eq("Only the server can change command policy", CoopCommandPolicyRPC.CLIENT_REJECTION_RESPONSE)
