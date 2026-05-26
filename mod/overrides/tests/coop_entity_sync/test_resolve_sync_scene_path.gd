extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.resolve_sync_scene_path scene_file_path wins when present")
    t.assert_eq("res://entities/chicken.tscn", CoopEntitySync.resolve_sync_scene_path(
        "res://entities/chicken.tscn", "res://fallback.tscn",
    ))

    t.begin("CoopEntitySync.resolve_sync_scene_path falls back to meta when scene_file_path is empty")
    t.assert_eq("res://procedural/worm.tscn", CoopEntitySync.resolve_sync_scene_path(
        "", "res://procedural/worm.tscn",
    ))

    t.begin("CoopEntitySync.resolve_sync_scene_path both empty -> empty")
    t.assert_eq("", CoopEntitySync.resolve_sync_scene_path("", ""))

    t.begin("CoopEntitySync.resolve_sync_scene_path does NOT strip whitespace")
    t.assert_eq("  res://x.tscn  ", CoopEntitySync.resolve_sync_scene_path("  res://x.tscn  ", ""))
