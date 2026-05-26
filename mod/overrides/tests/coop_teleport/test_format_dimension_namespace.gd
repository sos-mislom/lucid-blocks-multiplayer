extends RefCounted

const POCKET: int = 1
const FIRMAMENT: int = 5
const OVERWORLD: int = 0
const PRIVATE_DIMS: Array = [POCKET, FIRMAMENT]


func run(t: CoopTester) -> void:
    var dimension_map: Dictionary = {
        OVERWORLD: "overworld",
        POCKET: "pocket",
        FIRMAMENT: "firmament",
    }

    t.begin("CoopTeleport.format_dimension_namespace public dim -> dimension_map[dim]")
    t.assert_eq("overworld", CoopTeleport.format_dimension_namespace(OVERWORLD, "owner_z", dimension_map, PRIVATE_DIMS))
    t.assert_eq("overworld", CoopTeleport.format_dimension_namespace(OVERWORLD, "", dimension_map, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_namespace private dim + owner -> base__<owner>")
    t.assert_eq("pocket__alice", CoopTeleport.format_dimension_namespace(POCKET, "alice", dimension_map, PRIVATE_DIMS))
    t.assert_eq("firmament__bob", CoopTeleport.format_dimension_namespace(FIRMAMENT, "bob", dimension_map, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_namespace private dim + blank owner -> base (no trailing __)")
    t.assert_eq("pocket", CoopTeleport.format_dimension_namespace(POCKET, "", dimension_map, PRIVATE_DIMS))
    t.assert_eq("pocket", CoopTeleport.format_dimension_namespace(POCKET, "   ", dimension_map, PRIVATE_DIMS))
    t.assert_eq("firmament", CoopTeleport.format_dimension_namespace(FIRMAMENT, "", dimension_map, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_namespace unknown dim -> DEFAULT_NAMESPACE_FALLBACK")
    t.assert_eq(CoopTeleport.DEFAULT_NAMESPACE_FALLBACK, CoopTeleport.format_dimension_namespace(999, "", dimension_map, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_namespace strips owner whitespace before applying suffix")
    t.assert_eq("pocket__alice", CoopTeleport.format_dimension_namespace(POCKET, "  alice  ", dimension_map, PRIVATE_DIMS))
