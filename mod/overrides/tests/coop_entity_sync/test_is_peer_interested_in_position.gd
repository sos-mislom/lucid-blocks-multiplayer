extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopEntitySync.is_peer_interested_in_position inactive peer -> false")
    t.assert_false(CoopEntitySync.is_peer_interested_in_position(false, true, Vector3.ZERO, Vector3.ZERO, 10.0))

    t.begin("CoopEntitySync.is_peer_interested_in_position different instance -> false")
    t.assert_false(CoopEntitySync.is_peer_interested_in_position(true, false, Vector3.ZERO, Vector3.ZERO, 10.0))

    t.begin("CoopEntitySync.is_peer_interested_in_position inside radius -> true")
    t.assert_true(CoopEntitySync.is_peer_interested_in_position(true, true, Vector3(5.0, 0.0, 0.0), Vector3.ZERO, 10.0))

    t.begin("CoopEntitySync.is_peer_interested_in_position at exact radius -> true (inclusive)")
    t.assert_true(CoopEntitySync.is_peer_interested_in_position(true, true, Vector3(10.0, 0.0, 0.0), Vector3.ZERO, 10.0))

    t.begin("CoopEntitySync.is_peer_interested_in_position outside radius -> false")
    t.assert_false(CoopEntitySync.is_peer_interested_in_position(true, true, Vector3(15.0, 0.0, 0.0), Vector3.ZERO, 10.0))

    t.begin("CoopEntitySync.is_peer_interested_in_position zero radius -> only co-located")
    t.assert_true(CoopEntitySync.is_peer_interested_in_position(true, true, Vector3.ZERO, Vector3.ZERO, 0.0))
    t.assert_false(CoopEntitySync.is_peer_interested_in_position(true, true, Vector3(0.1, 0.0, 0.0), Vector3.ZERO, 0.0))

    t.begin("CoopEntitySync.is_peer_interested_in_position considers all three axes (3D distance)")
    # 3-4-5 triangle in XYZ:
    t.assert_true(CoopEntitySync.is_peer_interested_in_position(true, true, Vector3(3.0, 4.0, 0.0), Vector3.ZERO, 5.0))
    t.assert_false(CoopEntitySync.is_peer_interested_in_position(true, true, Vector3(3.0, 4.0, 0.0), Vector3.ZERO, 4.999))
