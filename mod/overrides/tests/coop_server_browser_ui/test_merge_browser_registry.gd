extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerBrowserUI.merge_browser_registry non-array -> {entries, changed=false}")
    var result: Dictionary = CoopServerBrowserUI.merge_browser_registry([], "not_array")
    t.assert_eq(0, (result.get("entries") as Array).size())
    t.assert_eq(false, result.get("changed"))

    t.begin("CoopServerBrowserUI.merge_browser_registry empty array -> no change")
    result = CoopServerBrowserUI.merge_browser_registry([], [])
    t.assert_eq(0, (result.get("entries") as Array).size())
    t.assert_eq(false, result.get("changed"))

    t.begin("CoopServerBrowserUI.merge_browser_registry appends new entry")
    result = CoopServerBrowserUI.merge_browser_registry([], [{"address": "1.2.3.4", "name": "A"}], 24667, 1, 4)
    var entries: Array = result.get("entries")
    t.assert_eq(1, entries.size())
    t.assert_eq("A", entries[0].get("name"))
    t.assert_eq(true, result.get("changed"))

    t.begin("CoopServerBrowserUI.merge_browser_registry skips entries without address")
    result = CoopServerBrowserUI.merge_browser_registry([], [{"name": "no addr"}, {"address": "1.2.3.4", "name": "A"}], 24667, 1, 4)
    entries = result.get("entries")
    t.assert_eq(1, entries.size())

    t.begin("CoopServerBrowserUI.merge_browser_registry merges entries with same key (raw fields win)")
    var initial: Array = [
        CoopServerBrowserUI.normalize_browser_entry({"address": "1.2.3.4", "name": "A", "status": "online", "players": 2}, 24667, 1, 4)
    ]
    result = CoopServerBrowserUI.merge_browser_registry(initial, [{"address": "1.2.3.4", "name": "A2", "status": "online"}], 24667, 1, 4)
    entries = result.get("entries")
    t.assert_eq(1, entries.size())
    t.assert_eq("A2", entries[0].get("name"))
    t.assert_eq("online", entries[0].get("status"))

    t.begin("CoopServerBrowserUI.merge_browser_registry distinguishes by endpoint_key")
    result = CoopServerBrowserUI.merge_browser_registry([], [
        {"address": "1.2.3.4", "endpoint_key": "key-a", "name": "A"},
        {"address": "1.2.3.4", "endpoint_key": "key-b", "name": "B"},
    ], 24667, 1, 4)
    entries = result.get("entries")
    t.assert_eq(2, entries.size())
