extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopCommandPolicyRPC.rejection_message formats with the command name")
    t.assert_eq("tp is disabled by server command policy", CoopCommandPolicyRPC.rejection_message("tp"))
    t.assert_eq("gamemode is disabled by server command policy", CoopCommandPolicyRPC.rejection_message("gamemode"))

    t.begin("CoopCommandPolicyRPC.rejection_message tolerates an empty command name (no crash)")
    t.assert_eq(" is disabled by server command policy", CoopCommandPolicyRPC.rejection_message(""))

    t.begin("CoopCommandPolicyRPC.rejection_message uses the canonical template constant")
    t.assert_eq(
        CoopCommandPolicyRPC.REJECTION_MESSAGE_TEMPLATE % "fill",
        CoopCommandPolicyRPC.rejection_message("fill"),
    )
