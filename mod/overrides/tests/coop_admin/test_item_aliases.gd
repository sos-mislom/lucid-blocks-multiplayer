extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.item_aliases emits one alias when display and internal slugs collide")
    var same: PackedStringArray = CoopAdmin.item_aliases("Stone", "stone")
    t.assert_eq_packed_string_array(PackedStringArray(["stone"]), same)

    t.begin("CoopAdmin.item_aliases emits both aliases when they differ")
    var different: PackedStringArray = CoopAdmin.item_aliases("Red Stone", "redstone_internal")
    t.assert_eq_packed_string_array(PackedStringArray(["red_stone", "redstone_internal"]), different)

    t.begin("CoopAdmin.item_aliases drops empty slugs")
    var with_empty: PackedStringArray = CoopAdmin.item_aliases("", "stone")
    t.assert_eq_packed_string_array(PackedStringArray(["stone"]), with_empty)
    var both_empty: PackedStringArray = CoopAdmin.item_aliases("", "")
    t.assert_eq(0, both_empty.size())

    t.begin("CoopAdmin.item_aliases preserves order (display first, internal second)")
    var ordered: PackedStringArray = CoopAdmin.item_aliases("A Display", "z_internal")
    t.assert_eq_packed_string_array(PackedStringArray(["a_display", "z_internal"]), ordered)

    t.begin("CoopAdmin.item_aliases deduplicates when slugify converges")
    var converging: PackedStringArray = CoopAdmin.item_aliases("Red Stone", "RED-STONE")
    t.assert_eq_packed_string_array(PackedStringArray(["red_stone"]), converging)
