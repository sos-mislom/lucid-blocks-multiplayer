extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.client_entity_block_position floors towards -inf")
    t.assert_eq(Vector3i(0, 0, 0), CoopEntitySync.client_entity_block_position(Vector3(0.0, 0.0, 0.0)))
    t.assert_eq(Vector3i(0, 0, 0), CoopEntitySync.client_entity_block_position(Vector3(0.9, 0.9, 0.9)))
    t.assert_eq(Vector3i(1, 1, 1), CoopEntitySync.client_entity_block_position(Vector3(1.0, 1.0, 1.0)))
    t.assert_eq(Vector3i(1, 2, 3), CoopEntitySync.client_entity_block_position(Vector3(1.5, 2.5, 3.5)))

    t.begin("CoopEntitySync.client_entity_block_position handles negative coordinates correctly")
    # Floor of -0.5 is -1 (not 0).
    t.assert_eq(Vector3i(-1, -1, -1), CoopEntitySync.client_entity_block_position(Vector3(-0.5, -0.5, -0.5)))
    t.assert_eq(Vector3i(-1, -1, -1), CoopEntitySync.client_entity_block_position(Vector3(-0.1, -0.1, -0.1)))
    t.assert_eq(Vector3i(-2, -3, -4), CoopEntitySync.client_entity_block_position(Vector3(-1.5, -2.5, -3.5)))

    t.begin("CoopEntitySync.client_entity_block_position negative integer is identity")
    t.assert_eq(Vector3i(-10, -10, -10), CoopEntitySync.client_entity_block_position(Vector3(-10.0, -10.0, -10.0)))
