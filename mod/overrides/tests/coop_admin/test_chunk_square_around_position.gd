extends RefCounted


func run(t: CoopTester) -> void:
    var chunk_size_x: int = 16
    var chunk_size_z: int = 16

    t.begin("CoopAdmin.chunk_square_around_position with radius=0 returns a single chunk-sized footprint")
    var single: Dictionary = CoopAdmin.chunk_square_around_position(Vector3i(0, 0, 0), 0, chunk_size_x, chunk_size_z)
    t.assert_eq(Vector3i(0, 0, 0), single.get("min"))
    t.assert_eq(Vector3i(15, 0, 15), single.get("max"))

    t.begin("CoopAdmin.chunk_square_around_position with radius=1 covers a 3x3 chunk footprint")
    var three: Dictionary = CoopAdmin.chunk_square_around_position(Vector3i(0, 0, 0), 1, chunk_size_x, chunk_size_z)
    t.assert_eq(Vector3i(-16, 0, -16), three.get("min"))
    t.assert_eq(Vector3i(31, 0, 31), three.get("max"))

    t.begin("CoopAdmin.chunk_square_around_position respects a non-zero center")
    var offset: Dictionary = CoopAdmin.chunk_square_around_position(Vector3i(32, 0, 64), 1, chunk_size_x, chunk_size_z)
    t.assert_eq(Vector3i(16, 0, 48), offset.get("min"))
    t.assert_eq(Vector3i(63, 0, 95), offset.get("max"))

    t.begin("CoopAdmin.chunk_square_around_position respects negative chunk centers")
    var negative: Dictionary = CoopAdmin.chunk_square_around_position(Vector3i(-32, 0, -32), 0, chunk_size_x, chunk_size_z)
    t.assert_eq(Vector3i(-32, 0, -32), negative.get("min"))
    t.assert_eq(Vector3i(-17, 0, -17), negative.get("max"))

    t.begin("CoopAdmin.chunk_square_around_position honours non-default chunk sizes")
    var custom: Dictionary = CoopAdmin.chunk_square_around_position(Vector3i(0, 0, 0), 1, 8, 8)
    t.assert_eq(Vector3i(-8, 0, -8), custom.get("min"))
    t.assert_eq(Vector3i(15, 0, 15), custom.get("max"))

    t.begin("CoopAdmin.chunk_square_around_position always reports y=0 in min/max")
    var with_y: Dictionary = CoopAdmin.chunk_square_around_position(Vector3i(0, 50, 0), 0, chunk_size_x, chunk_size_z)
    t.assert_eq(0, int(with_y.get("min").y))
    t.assert_eq(0, int(with_y.get("max").y))
