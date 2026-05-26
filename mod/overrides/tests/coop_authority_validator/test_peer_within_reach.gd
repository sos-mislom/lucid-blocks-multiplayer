extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAuthorityValidator.peer_within_reach accepts the same position")
    t.assert_true(CoopAuthorityValidator.peer_within_reach(Vector3.ZERO, Vector3.ZERO, 5.0, 2.0))

    t.begin("CoopAuthorityValidator.peer_within_reach rejects exceeded horizontal distance")
    t.assert_false(CoopAuthorityValidator.peer_within_reach(Vector3.ZERO, Vector3(6.0, 0.0, 0.0), 5.0, 2.0))
    t.assert_false(CoopAuthorityValidator.peer_within_reach(Vector3.ZERO, Vector3(0.0, 0.0, 5.1), 5.0, 2.0))

    t.begin("CoopAuthorityValidator.peer_within_reach accepts within-reach horizontal distance")
    t.assert_true(CoopAuthorityValidator.peer_within_reach(Vector3.ZERO, Vector3(3.0, 0.0, 4.0), 5.0, 2.0), "3-4-5 right triangle should sit on boundary")
    t.assert_true(CoopAuthorityValidator.peer_within_reach(Vector3.ZERO, Vector3(0.0, 0.0, 4.99), 5.0, 2.0))

    t.begin("CoopAuthorityValidator.peer_within_reach widens vertical bound by vertical_slack")
    var peer: Vector3 = Vector3.ZERO
    var target_high: Vector3 = Vector3(0.0, 6.5, 0.0)
    t.assert_true(CoopAuthorityValidator.peer_within_reach(peer, target_high, 5.0, 2.0), "5 + 2 slack must accept 6.5")
    t.assert_false(CoopAuthorityValidator.peer_within_reach(peer, Vector3(0.0, 7.5, 0.0), 5.0, 2.0), "must reject beyond 5 + slack")
    t.assert_false(CoopAuthorityValidator.peer_within_reach(peer, Vector3(0.0, -7.5, 0.0), 5.0, 2.0), "vertical slack is symmetrical")

    t.begin("CoopAuthorityValidator.peer_within_block_reach uses block centre")
    var pos: Vector3 = Vector3(0.5, 0.5, 0.5)
    var block: Vector3i = Vector3i(0, 0, 0)
    t.assert_true(CoopAuthorityValidator.peer_within_block_reach(pos, block, 1.0, 0.0), "block centre (0.5,0.5,0.5) coincides with peer")

    t.begin("CoopAuthorityValidator.peer_within_block_reach rejects out-of-reach blocks")
    t.assert_false(CoopAuthorityValidator.peer_within_block_reach(Vector3.ZERO, Vector3i(10, 0, 0), 5.0, 2.0))
