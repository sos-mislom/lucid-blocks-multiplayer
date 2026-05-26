extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopPauseMenuUI.is_dedicated_peer_state matches peer 1 + dedicated_server=true")
    t.assert_true(CoopPauseMenuUI.is_dedicated_peer_state(1, {"dedicated_server": true}))

    t.begin("CoopPauseMenuUI.is_dedicated_peer_state non-peer-1 returns false")
    t.assert_false(CoopPauseMenuUI.is_dedicated_peer_state(7, {"dedicated_server": true}))

    t.begin("CoopPauseMenuUI.is_dedicated_peer_state peer 1 without flag returns false")
    t.assert_false(CoopPauseMenuUI.is_dedicated_peer_state(1, {}))
    t.assert_false(CoopPauseMenuUI.is_dedicated_peer_state(1, {"dedicated_server": false}))
