extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerBrowserUI.format_card_parts online with tps")
    var entry: Dictionary = {"status": "online", "players": 2, "max_players": 4, "tps": 60.0, "region": "preta"}
    t.assert_eq_packed_string_array(PackedStringArray(["online", "2/4 players", "60 tps", "preta"]), CoopServerBrowserUI.format_card_parts(entry, 4))

    t.begin("CoopServerBrowserUI.format_card_parts online without tps -> '?'")
    entry = {"status": "online", "players": 0, "max_players": 4, "region": "preta"}
    t.assert_eq_packed_string_array(PackedStringArray(["online", "0/4 players", "? tps", "preta"]), CoopServerBrowserUI.format_card_parts(entry, 4))

    t.begin("CoopServerBrowserUI.format_card_parts checking / relay / offline / idle")
    t.assert_eq_packed_string_array(PackedStringArray(["checking", "preta"]), CoopServerBrowserUI.format_card_parts({"status": "checking", "region": "preta"}))
    t.assert_eq_packed_string_array(PackedStringArray(["relay", "waiting"]), CoopServerBrowserUI.format_card_parts({"status": "relay"}))
    t.assert_eq_packed_string_array(PackedStringArray(["offline", "preta"]), CoopServerBrowserUI.format_card_parts({"status": "offline", "region": "preta"}))
    t.assert_eq_packed_string_array(PackedStringArray(["idle", "public"]), CoopServerBrowserUI.format_card_parts({"status": "unknown"}))

    t.begin("CoopServerBrowserUI.format_browser_entry online -> joined parts")
    entry = {"status": "online", "players": 2, "max_players": 4, "tps": 60.0, "region": "preta"}
    t.assert_eq("online 2/4 players 60 tps preta", CoopServerBrowserUI.format_browser_entry(entry, 4))

    t.begin("CoopServerBrowserUI.format_browser_entry non-online ladder")
    t.assert_eq("checking   preta", CoopServerBrowserUI.format_browser_entry({"status": "checking", "region": "preta"}))
    t.assert_eq("relay online   waiting", CoopServerBrowserUI.format_browser_entry({"status": "relay"}))
    t.assert_eq("offline   preta", CoopServerBrowserUI.format_browser_entry({"status": "offline", "region": "preta"}))
    t.assert_eq("not checked   public", CoopServerBrowserUI.format_browser_entry({"status": "unknown"}))
