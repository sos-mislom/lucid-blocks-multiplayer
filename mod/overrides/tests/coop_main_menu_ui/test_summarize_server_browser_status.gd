extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopMainMenuUI.summarize_server_browser_status empty -> zero counts")
    var counts: Dictionary = CoopMainMenuUI.summarize_server_browser_status([])
    t.assert_eq(0, counts.get("online"))
    t.assert_eq(0, counts.get("checking"))

    t.begin("CoopMainMenuUI.summarize_server_browser_status counts online")
    counts = CoopMainMenuUI.summarize_server_browser_status([
        {"status": "online"},
        {"status": "online"},
        {"status": "checking"},
    ])
    t.assert_eq(2, counts.get("online"))
    t.assert_eq(1, counts.get("checking"))

    t.begin("CoopMainMenuUI.summarize_server_browser_status unknown counts as checking")
    counts = CoopMainMenuUI.summarize_server_browser_status([
        {"status": "unknown"},
        {"status": "checking"},
        {"status": "offline"},
    ])
    t.assert_eq(0, counts.get("online"))
    t.assert_eq(2, counts.get("checking"))

    t.begin("CoopMainMenuUI.summarize_server_browser_status missing status -> unknown -> checking")
    counts = CoopMainMenuUI.summarize_server_browser_status([{}])
    t.assert_eq(0, counts.get("online"))
    t.assert_eq(1, counts.get("checking"))

    t.begin("CoopMainMenuUI.summarize_server_browser_status skips non-Dictionary entries")
    counts = CoopMainMenuUI.summarize_server_browser_status([
        "not a dict",
        {"status": "online"},
        null,
    ])
    t.assert_eq(1, counts.get("online"))
    t.assert_eq(0, counts.get("checking"))
