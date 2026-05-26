extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerBrowserUI.format_region_line uppercased")
    t.assert_eq("PRETA", CoopServerBrowserUI.format_region_line({"region": "preta"}))
    t.assert_eq("EUROPE", CoopServerBrowserUI.format_region_line({"region": "europe"}))

    t.begin("CoopServerBrowserUI.format_region_line empty / missing -> default fallback")
    t.assert_eq("PRETA", CoopServerBrowserUI.format_region_line({}))
    t.assert_eq("PRETA", CoopServerBrowserUI.format_region_line({"region": ""}))
    t.assert_eq("PUBLIC", CoopServerBrowserUI.format_region_line({}, "public"))

    t.begin("CoopServerBrowserUI.format_status_line joins presence + detail")
    var entry: Dictionary = {"status": "online", "players": 1, "max_players": 4, "tps": 60.0, "region": "preta"}
    t.assert_eq("ONLINE  1/4  |  60 TPS  |  PRE", CoopServerBrowserUI.format_status_line(entry, 4))

    t.begin("CoopServerBrowserUI.format_meta_line uses entry version when present")
    entry = {"version": "0.42.0", "status": "online", "players": 0, "max_players": 4, "region": "preta", "tps": 30.0}
    t.assert_eq("V0.42.0   ONLINE   0/4  |  30 TPS  |  PRE", CoopServerBrowserUI.format_meta_line(entry, "0.99.9", 4))

    t.begin("CoopServerBrowserUI.format_meta_line falls back to current_version")
    entry = {"status": "online", "players": 0, "max_players": 4, "region": "preta", "tps": 30.0}
    t.assert_eq("V0.99.9   ONLINE   0/4  |  30 TPS  |  PRE", CoopServerBrowserUI.format_meta_line(entry, "0.99.9", 4))

    t.begin("CoopServerBrowserUI.format_meta_line empty entry version falls back to current")
    entry = {"version": "  ", "status": "checking", "region": "preta"}
    t.assert_eq("V0.99.9   CHECKING   WAITING  PRE", CoopServerBrowserUI.format_meta_line(entry, "0.99.9", 4))
