extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopHud.build_player_list_overlay_lines empty list -> Players + 'No players'")
    var lines: PackedStringArray = CoopHud.build_player_list_overlay_lines([])
    t.assert_eq(2, lines.size())
    t.assert_eq("Players", lines[0])
    t.assert_eq("No players", lines[1])

    t.begin("CoopHud.build_player_list_overlay_lines populated -> Players + each label")
    lines = CoopHud.build_player_list_overlay_lines(["alpha", "beta", "gamma"])
    t.assert_eq(4, lines.size())
    t.assert_eq("Players", lines[0])
    t.assert_eq("alpha", lines[1])
    t.assert_eq("beta", lines[2])
    t.assert_eq("gamma", lines[3])

    t.begin("CoopHud.build_player_list_overlay_lines single entry has NO 'No players' marker")
    lines = CoopHud.build_player_list_overlay_lines(["solo"])
    t.assert_eq(2, lines.size())
    t.assert_eq("Players", lines[0])
    t.assert_eq("solo", lines[1])

    t.begin("CoopHud.build_player_list_overlay_lines stringifies non-string labels via str()")
    # Live `_format_session_player_label` always returns String,
    # so in practice this code path is dead; but the static helper
    # should be defensive in case a caller passes something else.
    lines = CoopHud.build_player_list_overlay_lines([42, "ok"])
    t.assert_eq(3, lines.size())
    t.assert_eq("42", lines[1])
    t.assert_eq("ok", lines[2])

    t.begin("CoopHud.compute_player_list_overlay_min_size width fixed at 180")
    t.assert_eq(Vector2(180.0, 18.0), CoopHud.compute_player_list_overlay_min_size(0))
    t.assert_eq(Vector2(180.0, 28.0), CoopHud.compute_player_list_overlay_min_size(1))
    t.assert_eq(Vector2(180.0, 38.0), CoopHud.compute_player_list_overlay_min_size(2))

    t.begin("CoopHud.compute_player_list_overlay_min_size height grows linearly with line count")
    t.assert_eq(Vector2(180.0, 18.0 + 10.0 * 10.0), CoopHud.compute_player_list_overlay_min_size(10))
    t.assert_eq(Vector2(180.0, 18.0 + 100.0 * 10.0), CoopHud.compute_player_list_overlay_min_size(100))
