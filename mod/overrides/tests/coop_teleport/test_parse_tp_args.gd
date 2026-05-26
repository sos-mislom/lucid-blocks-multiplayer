extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopTeleport.parse_tp_args empty parts -> usage")
    var parsed_empty: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray([]))
    t.assert_eq("usage", str(parsed_empty.get("kind", "")))
    t.assert_eq(CoopTeleport.USAGE_HINT, str(parsed_empty.get("usage_message", "")))

    t.begin("CoopTeleport.parse_tp_args bare /tp -> usage")
    var parsed_bare: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp"]))
    t.assert_eq("usage", str(parsed_bare.get("kind", "")))

    t.begin("CoopTeleport.parse_tp_args three valid floats -> coord")
    var parsed_coord: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp", "1.5", "2.5", "3.5"]))
    t.assert_eq("coord", str(parsed_coord.get("kind", "")))
    t.assert_eq(Vector3(1.5, 2.5, 3.5), parsed_coord.get("coord", Vector3.ZERO))

    t.begin("CoopTeleport.parse_tp_args integer args parse as coord (is_valid_float accepts ints)")
    var parsed_ints: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp", "10", "64", "20"]))
    t.assert_eq("coord", str(parsed_ints.get("kind", "")))
    t.assert_eq(Vector3(10, 64, 20), parsed_ints.get("coord", Vector3.ZERO))

    t.begin("CoopTeleport.parse_tp_args negative floats parse as coord")
    var parsed_negative: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp", "-1.5", "0", "-3.5"]))
    t.assert_eq("coord", str(parsed_negative.get("kind", "")))
    t.assert_eq(Vector3(-1.5, 0.0, -3.5), parsed_negative.get("coord", Vector3.ZERO))

    t.begin("CoopTeleport.parse_tp_args one peer arg -> peer with single-word query")
    var parsed_one: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp", "host"]))
    t.assert_eq("peer", str(parsed_one.get("kind", "")))
    t.assert_eq("host", str(parsed_one.get("query", "")))

    t.begin("CoopTeleport.parse_tp_args multi-word peer args -> joined with single space")
    var parsed_multi: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp", "John", "Doe"]))
    t.assert_eq("peer", str(parsed_multi.get("kind", "")))
    t.assert_eq("John Doe", str(parsed_multi.get("query", "")))

    t.begin("CoopTeleport.parse_tp_args mixed validity falls to peer form")
    # one float in third slot is not valid - drops to peer
    var parsed_mixed: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp", "1", "2", "notafloat"]))
    t.assert_eq("peer", str(parsed_mixed.get("kind", "")))
    t.assert_eq("1 2 notafloat", str(parsed_mixed.get("query", "")))

    t.begin("CoopTeleport.parse_tp_args two args (less than 4) -> peer not coord")
    var parsed_two: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp", "1.5", "2.5"]))
    t.assert_eq("peer", str(parsed_two.get("kind", "")))
    t.assert_eq("1.5 2.5", str(parsed_two.get("query", "")))

    t.begin("CoopTeleport.parse_tp_args strips surrounding whitespace on joined query")
    var parsed_padded: Dictionary = CoopTeleport.parse_tp_args(PackedStringArray(["/tp", "  spaced  "]))
    t.assert_eq("peer", str(parsed_padded.get("kind", "")))
    t.assert_eq("spaced", str(parsed_padded.get("query", "")))
