extends RefCounted


func run(t: CoopTester) -> void:
    var admins: PackedStringArray = PackedStringArray(["steam_111", "steam_222", "guest_offline_host"])

    t.begin("CoopAuthorityValidator.is_peer_admin rejects empty player_key")
    t.assert_false(CoopAuthorityValidator.is_peer_admin("", admins))

    t.begin("CoopAuthorityValidator.is_peer_admin returns true when key is in the admin list")
    t.assert_true(CoopAuthorityValidator.is_peer_admin("steam_111", admins))
    t.assert_true(CoopAuthorityValidator.is_peer_admin("steam_222", admins))
    t.assert_true(CoopAuthorityValidator.is_peer_admin("guest_offline_host", admins))

    t.begin("CoopAuthorityValidator.is_peer_admin returns false for keys not in the admin list")
    t.assert_false(CoopAuthorityValidator.is_peer_admin("steam_333", admins))
    t.assert_false(CoopAuthorityValidator.is_peer_admin("guest_other", admins))

    t.begin("CoopAuthorityValidator.is_peer_admin is case-sensitive")
    t.assert_false(CoopAuthorityValidator.is_peer_admin("STEAM_111", admins))
    t.assert_false(CoopAuthorityValidator.is_peer_admin("Steam_111", admins))

    t.begin("CoopAuthorityValidator.is_peer_admin handles an empty admin list")
    t.assert_false(CoopAuthorityValidator.is_peer_admin("steam_111", PackedStringArray()))
