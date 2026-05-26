extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopHud.format_steam_status_text 'lobby <id>' wins when lobby_id > 0")
    t.assert_eq("lobby 12345", CoopHud.format_steam_status_text(true, 12345))
    t.assert_eq("lobby 12345", CoopHud.format_steam_status_text(false, 12345))
    t.assert_eq("lobby 1", CoopHud.format_steam_status_text(false, 1))

    t.begin("CoopHud.format_steam_status_text 'ready' when steam available, no lobby")
    t.assert_eq("ready", CoopHud.format_steam_status_text(true, 0))
    t.assert_eq("ready", CoopHud.format_steam_status_text(true, -1))

    t.begin("CoopHud.format_steam_status_text 'unavailable' when steam not available")
    t.assert_eq("unavailable", CoopHud.format_steam_status_text(false, 0))
    t.assert_eq("unavailable", CoopHud.format_steam_status_text(false, -1))

    t.begin("CoopHud.format_local_ip_label_text two-line LAN/Steam template")
    t.assert_eq("LAN: 192.168.1.1\nSteam: ready", CoopHud.format_local_ip_label_text("192.168.1.1", "ready"))
    t.assert_eq("LAN: 127.0.0.1\nSteam: lobby 555", CoopHud.format_local_ip_label_text("127.0.0.1", "lobby 555"))
    t.assert_eq("LAN: \nSteam: unavailable", CoopHud.format_local_ip_label_text("", "unavailable"))
