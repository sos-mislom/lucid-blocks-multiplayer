extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.can_offer_manual_partner_respawn all three true -> true")
    t.assert_true(CoopRevive.can_offer_manual_partner_respawn(true, true, true))

    t.begin("CoopRevive.can_offer_manual_partner_respawn local_downed false -> false")
    t.assert_false(CoopRevive.can_offer_manual_partner_respawn(false, true, true))

    t.begin("CoopRevive.can_offer_manual_partner_respawn has_reviver false -> false")
    t.assert_false(CoopRevive.can_offer_manual_partner_respawn(true, false, true))

    t.begin("CoopRevive.can_offer_manual_partner_respawn has_remote_anchor false -> false")
    t.assert_false(CoopRevive.can_offer_manual_partner_respawn(true, true, false))

    t.begin("CoopRevive.can_offer_manual_partner_respawn all three false -> false")
    t.assert_false(CoopRevive.can_offer_manual_partner_respawn(false, false, false))
