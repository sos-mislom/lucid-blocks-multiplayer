extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPatch.clamp_chunk_byte_value clamps positive int to [0, 255]")
    t.assert_eq(0, CoopWorldPatch.clamp_chunk_byte_value(0))
    t.assert_eq(255, CoopWorldPatch.clamp_chunk_byte_value(255))
    t.assert_eq(255, CoopWorldPatch.clamp_chunk_byte_value(999))

    t.begin("CoopWorldPatch.clamp_chunk_byte_value clamps negative to 0")
    t.assert_eq(0, CoopWorldPatch.clamp_chunk_byte_value(-5))
    t.assert_eq(0, CoopWorldPatch.clamp_chunk_byte_value(-9999))

    t.begin("CoopWorldPatch.clamp_chunk_byte_value coerces float to int via truncation")
    t.assert_eq(7, CoopWorldPatch.clamp_chunk_byte_value(7.9), "int(7.9) == 7")
    t.assert_eq(0, CoopWorldPatch.clamp_chunk_byte_value(0.5))

    t.begin("CoopWorldPatch.clamp_chunk_byte_value handles passing through 128 (mid-range)")
    t.assert_eq(128, CoopWorldPatch.clamp_chunk_byte_value(128))
