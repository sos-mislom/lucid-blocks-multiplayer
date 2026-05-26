extends RefCounted

const POCKET: int = 1
const FIRMAMENT: int = 5
const OVERWORLD: int = 0
const PRIVATE_DIMS: Array = [POCKET, FIRMAMENT]


func run(t: CoopTester) -> void:
    t.begin("CoopTeleport.parse_dimension_instance_key empty / blank -> {}")
    t.assert_true(CoopTeleport.parse_dimension_instance_key("", POCKET).is_empty())
    t.assert_true(CoopTeleport.parse_dimension_instance_key("   ", POCKET).is_empty())

    t.begin("CoopTeleport.parse_dimension_instance_key malformed -> {}")
    t.assert_true(CoopTeleport.parse_dimension_instance_key("garbage", POCKET).is_empty())
    t.assert_true(CoopTeleport.parse_dimension_instance_key("unknown:5", POCKET).is_empty())
    t.assert_true(CoopTeleport.parse_dimension_instance_key("dimension:", POCKET).is_empty(), "empty payload after dimension: -> {}")

    t.begin("CoopTeleport.parse_dimension_instance_key pocket form -> {dimension: POCKET, owner_key}")
    var pocket_with_owner: Dictionary = CoopTeleport.parse_dimension_instance_key("pocket:owner_x", POCKET)
    t.assert_eq(POCKET, int(pocket_with_owner.get("dimension", -1)))
    t.assert_eq("owner_x", str(pocket_with_owner.get("owner_key", "")))

    t.begin("CoopTeleport.parse_dimension_instance_key pocket:legacy preserves literal owner_key")
    var pocket_legacy: Dictionary = CoopTeleport.parse_dimension_instance_key("pocket:legacy", POCKET)
    t.assert_eq(POCKET, int(pocket_legacy.get("dimension", -1)))
    t.assert_eq("legacy", str(pocket_legacy.get("owner_key", "")), "parser returns literal substring (round-trip with formatter)")

    t.begin("CoopTeleport.parse_dimension_instance_key pocket: (empty after colon) -> owner_key blank")
    var pocket_empty: Dictionary = CoopTeleport.parse_dimension_instance_key("pocket:", POCKET)
    t.assert_eq(POCKET, int(pocket_empty.get("dimension", -1)))
    t.assert_eq("", str(pocket_empty.get("owner_key", "x")))

    t.begin("CoopTeleport.parse_dimension_instance_key dimension:<id> -> {dimension, owner_key: ''}")
    var public_dim: Dictionary = CoopTeleport.parse_dimension_instance_key("dimension:5", POCKET)
    t.assert_eq(5, int(public_dim.get("dimension", -1)))
    t.assert_eq("", str(public_dim.get("owner_key", "x")))

    t.begin("CoopTeleport.parse_dimension_instance_key dimension:<id>:<owner> -> both parts")
    var private_dim: Dictionary = CoopTeleport.parse_dimension_instance_key("dimension:5:owner_y", POCKET)
    t.assert_eq(5, int(private_dim.get("dimension", -1)))
    t.assert_eq("owner_y", str(private_dim.get("owner_key", "")))

    t.begin("CoopTeleport.parse_dimension_instance_key tolerates surrounding whitespace")
    var trimmed: Dictionary = CoopTeleport.parse_dimension_instance_key("  dimension:5:owner_y  ", POCKET)
    t.assert_eq(5, int(trimmed.get("dimension", -1)))
    t.assert_eq("owner_y", str(trimmed.get("owner_key", "")))

    t.begin("CoopTeleport.parse_dimension_instance_key roundtrip with format_dimension_instance_key")
    for case in [[POCKET, "owner_a"], [POCKET, ""], [FIRMAMENT, "owner_b"], [FIRMAMENT, ""], [OVERWORLD, "owner_c"]]:
        var dim: int = int(case[0])
        var owner: String = str(case[1])
        var key: String = CoopTeleport.format_dimension_instance_key(dim, owner, POCKET, PRIVATE_DIMS)
        var parsed: Dictionary = CoopTeleport.parse_dimension_instance_key(key, POCKET)
        t.assert_false(parsed.is_empty(), "roundtrip %s/%s key=%s parsed empty" % [dim, owner, key])
        t.assert_eq(dim, int(parsed.get("dimension", -1)), "roundtrip dim mismatch for %s/%s" % [dim, owner])
