extends RefCounted


func run(t: CoopTester) -> void:
    var entries: Array = [
        {"address": "1.1.1.1", "status_port": 24668},
        {"address": "2.2.2.2", "status_port": 24700},
    ]
    var pending: Dictionary = {"3.3.3.3:24668": 1}

    t.begin("CoopServerBrowserUI.find_browser_entry_index pending lookup wins")
    t.assert_eq(1, CoopServerBrowserUI.find_browser_entry_index(entries, pending, "3.3.3.3", 24668))

    t.begin("CoopServerBrowserUI.find_browser_entry_index falls back to entry-list match")
    t.assert_eq(0, CoopServerBrowserUI.find_browser_entry_index(entries, {}, "1.1.1.1", 24668))
    t.assert_eq(1, CoopServerBrowserUI.find_browser_entry_index(entries, {}, "2.2.2.2", 24700))

    t.begin("CoopServerBrowserUI.find_browser_entry_index no match -> -1")
    t.assert_eq(-1, CoopServerBrowserUI.find_browser_entry_index(entries, {}, "9.9.9.9", 24668))
