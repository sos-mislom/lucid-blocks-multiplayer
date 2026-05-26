extends RefCounted

const POCKET: int = 1
const FIRMAMENT: int = 5
const OVERWORLD: int = 0
const NARAKA: int = 7
const PRIVATE_DIMS: Array = [POCKET, FIRMAMENT]


func run(t: CoopTester) -> void:
    t.begin("CoopDimensionTravel.is_private_instance_dimension pocket -> true")
    t.assert_true(CoopDimensionTravel.is_private_instance_dimension(POCKET, PRIVATE_DIMS))

    t.begin("CoopDimensionTravel.is_private_instance_dimension firmament -> true")
    t.assert_true(CoopDimensionTravel.is_private_instance_dimension(FIRMAMENT, PRIVATE_DIMS))

    t.begin("CoopDimensionTravel.is_private_instance_dimension overworld -> false")
    t.assert_false(CoopDimensionTravel.is_private_instance_dimension(OVERWORLD, PRIVATE_DIMS))

    t.begin("CoopDimensionTravel.is_private_instance_dimension unknown dim -> false")
    t.assert_false(CoopDimensionTravel.is_private_instance_dimension(NARAKA, PRIVATE_DIMS))
    t.assert_false(CoopDimensionTravel.is_private_instance_dimension(999, PRIVATE_DIMS))

    t.begin("CoopDimensionTravel.is_private_instance_dimension empty private list -> false (nothing private)")
    t.assert_false(CoopDimensionTravel.is_private_instance_dimension(POCKET, []))
    t.assert_false(CoopDimensionTravel.is_private_instance_dimension(OVERWORLD, []))
