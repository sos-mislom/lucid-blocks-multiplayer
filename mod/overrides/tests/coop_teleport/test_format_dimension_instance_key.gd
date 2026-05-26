extends RefCounted

# Test fixture dimension ids (do not import LucidBlocksWorld here -
# CoopTeleport accepts the ids as plain ints).
const POCKET: int = 1
const FIRMAMENT: int = 5
const OVERWORLD: int = 0
const PRIVATE_DIMS: Array = [POCKET, FIRMAMENT]


func run(t: CoopTester) -> void:
    t.begin("CoopTeleport.format_dimension_instance_key pocket + owner -> pocket:<owner>")
    t.assert_eq("pocket:owner_x", CoopTeleport.format_dimension_instance_key(POCKET, "owner_x", POCKET, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_instance_key pocket + blank owner -> pocket:legacy")
    t.assert_eq("pocket:legacy", CoopTeleport.format_dimension_instance_key(POCKET, "", POCKET, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_instance_key pocket + whitespace owner -> pocket:legacy")
    t.assert_eq("pocket:legacy", CoopTeleport.format_dimension_instance_key(POCKET, "   ", POCKET, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_instance_key private non-pocket + owner -> dimension:<id>:<owner>")
    t.assert_eq("dimension:5:owner_y", CoopTeleport.format_dimension_instance_key(FIRMAMENT, "owner_y", POCKET, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_instance_key private non-pocket + blank owner -> dimension:<id> (no trailing colon)")
    t.assert_eq("dimension:5", CoopTeleport.format_dimension_instance_key(FIRMAMENT, "", POCKET, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_instance_key public dim ignores owner -> dimension:<id>")
    t.assert_eq("dimension:0", CoopTeleport.format_dimension_instance_key(OVERWORLD, "owner_z", POCKET, PRIVATE_DIMS))
    t.assert_eq("dimension:0", CoopTeleport.format_dimension_instance_key(OVERWORLD, "", POCKET, PRIVATE_DIMS))

    t.begin("CoopTeleport.format_dimension_instance_key uses LEGACY_POCKET_OWNER_LABEL constant")
    var formatted_blank: String = CoopTeleport.format_dimension_instance_key(POCKET, "", POCKET, PRIVATE_DIMS)
    t.assert_eq("pocket:%s" % CoopTeleport.LEGACY_POCKET_OWNER_LABEL, formatted_blank)
