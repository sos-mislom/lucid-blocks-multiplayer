extends RefCounted


func run(t: CoopTester) -> void:
    var default_policy: Dictionary = {
        "tp": true,
        "gamemode": false,
        "gm": false,
        "spawnmenu": false,
        "mobs": false,
        "fill": false,
    }
    var local_policy: Dictionary = {"tp": true, "gamemode": false, "gm": false, "spawnmenu": true, "mobs": true, "fill": false}
    var active_policy: Dictionary = {"tp": false, "gamemode": true, "gm": true, "spawnmenu": false, "mobs": false, "fill": true}

    t.begin("CoopCommandPolicyRPC.choose_effective returns local when is_server=true (regardless of active)")
    var server_choice: Dictionary = CoopCommandPolicyRPC.choose_effective(local_policy, active_policy, default_policy, true, true)
    t.assert_eq_dict(local_policy, server_choice)

    t.begin("CoopCommandPolicyRPC.choose_effective returns local when is_server=true and no live peer")
    var server_solo: Dictionary = CoopCommandPolicyRPC.choose_effective(local_policy, active_policy, default_policy, true, false)
    t.assert_eq_dict(local_policy, server_solo)

    t.begin("CoopCommandPolicyRPC.choose_effective returns local in singleplayer (is_server=false, has_live_peer=false)")
    var singleplayer: Dictionary = CoopCommandPolicyRPC.choose_effective(local_policy, active_policy, default_policy, false, false)
    t.assert_eq_dict(local_policy, singleplayer)

    t.begin("CoopCommandPolicyRPC.choose_effective normalises active via CoopAdmin when client with live peer")
    var client_choice: Dictionary = CoopCommandPolicyRPC.choose_effective(local_policy, active_policy, default_policy, false, true)
    # client must read active, not local
    t.assert_false(bool(client_choice.get("tp", true)), "active says tp=false; client must honour active")
    t.assert_true(bool(client_choice.get("fill", false)), "active says fill=true; client must honour active")
    # CoopAdmin mirroring still applies on the way out
    t.assert_true(bool(client_choice.get("gm", false)), "gm mirrored from gamemode=true on the active dict")

    t.begin("CoopCommandPolicyRPC.choose_effective falls back to default-only when active is not a Dictionary")
    var null_active: Dictionary = CoopCommandPolicyRPC.choose_effective(local_policy, null, default_policy, false, true)
    t.assert_eq_dict(CoopAdmin.normalize_command_policy(null, default_policy), null_active)

    t.begin("CoopCommandPolicyRPC.choose_effective handles garbage active payload via CoopAdmin defaults")
    var garbage: Dictionary = CoopCommandPolicyRPC.choose_effective(local_policy, 42, default_policy, false, true)
    t.assert_eq_dict(CoopAdmin.normalize_command_policy(42, default_policy), garbage)
