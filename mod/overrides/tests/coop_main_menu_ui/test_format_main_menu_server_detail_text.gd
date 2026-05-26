extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopMainMenuUI.format_main_menu_server_detail_text empty registry")
    t.assert_eq("No public QUALIA servers registered.", CoopMainMenuUI.format_main_menu_server_detail_text([]))

    t.begin("CoopMainMenuUI.format_main_menu_server_detail_text any online -> click hint")
    var entries: Array = [
        {"status": "offline"},
        {"status": "online"},
    ]
    t.assert_eq("Click a QUALIA card to enter that server world.", CoopMainMenuUI.format_main_menu_server_detail_text(entries))

    t.begin("CoopMainMenuUI.format_main_menu_server_detail_text any checking -> checking hint")
    entries = [
        {"status": "checking"},
        {"status": "offline"},
    ]
    t.assert_eq("Checking public QUALIA servers...", CoopMainMenuUI.format_main_menu_server_detail_text(entries))

    t.begin("CoopMainMenuUI.format_main_menu_server_detail_text unknown also yields checking hint")
    entries = [
        {"status": "unknown"},
    ]
    t.assert_eq("Checking public QUALIA servers...", CoopMainMenuUI.format_main_menu_server_detail_text(entries))

    t.begin("CoopMainMenuUI.format_main_menu_server_detail_text all offline -> unreachable hint")
    entries = [
        {"status": "offline"},
        {"status": "offline"},
    ]
    t.assert_eq("No public QUALIA servers are reachable right now.", CoopMainMenuUI.format_main_menu_server_detail_text(entries))
