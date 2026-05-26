extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerBrowserUI.format_detail_line online with TPS")
    var entry: Dictionary = {
        "status": "online",
        "region": "preta",
        "players": 2,
        "max_players": 4,
        "tps": 60.0,
    }
    t.assert_eq("2/4  |  60 TPS  |  PRE", CoopServerBrowserUI.format_detail_line(entry, 4))

    t.begin("CoopServerBrowserUI.format_detail_line online without TPS -> ? TPS")
    entry = {"status": "ready", "region": "europe", "players": 1, "max_players": 4}
    t.assert_eq("1/4  |  ? TPS  |  EUR", CoopServerBrowserUI.format_detail_line(entry, 4))

    t.begin("CoopServerBrowserUI.format_detail_line empty region defaults to public")
    entry = {"status": "online", "players": 0, "max_players": 4, "tps": 30.0}
    t.assert_eq("0/4  |  30 TPS  |  PUB", CoopServerBrowserUI.format_detail_line(entry, 4))

    t.begin("CoopServerBrowserUI.format_detail_line checking")
    t.assert_eq("WAITING  PRE", CoopServerBrowserUI.format_detail_line({"status": "checking", "region": "preta"}, 4))

    t.begin("CoopServerBrowserUI.format_detail_line relay")
    t.assert_eq("WAITING", CoopServerBrowserUI.format_detail_line({"status": "relay"}, 4))

    t.begin("CoopServerBrowserUI.format_detail_line incompatible")
    t.assert_eq("PROTOCOL", CoopServerBrowserUI.format_detail_line({"status": "incompatible"}, 4))

    t.begin("CoopServerBrowserUI.format_detail_line offline / unknown -> region tag")
    t.assert_eq("PRE", CoopServerBrowserUI.format_detail_line({"status": "offline", "region": "preta"}, 4))
    t.assert_eq("PUB", CoopServerBrowserUI.format_detail_line({"status": "unknown"}, 4))
