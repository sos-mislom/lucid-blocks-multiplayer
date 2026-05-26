extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerBrowserUI.format_presence_text known statuses")
    t.assert_eq("ONLINE", CoopServerBrowserUI.format_presence_text({"status": "online"}))
    t.assert_eq("ONLINE", CoopServerBrowserUI.format_presence_text({"status": "ready"}))
    t.assert_eq("ONLINE", CoopServerBrowserUI.format_presence_text({"status": "ONLINE"}))
    t.assert_eq("CHECKING", CoopServerBrowserUI.format_presence_text({"status": "checking"}))
    t.assert_eq("RELAY", CoopServerBrowserUI.format_presence_text({"status": "relay"}))
    t.assert_eq("UPDATE", CoopServerBrowserUI.format_presence_text({"status": "incompatible"}))
    t.assert_eq("OFFLINE", CoopServerBrowserUI.format_presence_text({"status": "offline"}))

    t.begin("CoopServerBrowserUI.format_presence_text unknown / missing -> IDLE")
    t.assert_eq("IDLE", CoopServerBrowserUI.format_presence_text({}))
    t.assert_eq("IDLE", CoopServerBrowserUI.format_presence_text({"status": "weird"}))
    t.assert_eq("IDLE", CoopServerBrowserUI.format_presence_text({"status": "unknown"}))
