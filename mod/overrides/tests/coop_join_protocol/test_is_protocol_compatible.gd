extends RefCounted


func run(t: CoopTester) -> void:
    var local_name: String = "lucid-blocks-coop"
    var local_version: int = 1
    var local_min: int = 1

    t.begin("CoopJoinProtocol.is_protocol_compatible name mismatch -> false")
    t.assert_false(CoopJoinProtocol.is_protocol_compatible(
        {"protocol": "other", "version": 1, "min": 1},
        local_name, local_version, local_min, [], [],
    ))

    t.begin("CoopJoinProtocol.is_protocol_compatible empty protocol field -> false")
    t.assert_false(CoopJoinProtocol.is_protocol_compatible(
        {"version": 1, "min": 1},
        local_name, local_version, local_min, [], [],
    ))

    t.begin("CoopJoinProtocol.is_protocol_compatible remote too old -> false")
    t.assert_false(CoopJoinProtocol.is_protocol_compatible(
        {"protocol": local_name, "version": 0, "min": 0},
        local_name, local_version, local_min, [], [],
    ))

    t.begin("CoopJoinProtocol.is_protocol_compatible local too old for remote -> false")
    t.assert_false(CoopJoinProtocol.is_protocol_compatible(
        {"protocol": local_name, "version": 2, "min": 2},
        local_name, local_version, local_min, [], [],
    ))

    t.begin("CoopJoinProtocol.is_protocol_compatible same version -> true")
    t.assert_true(CoopJoinProtocol.is_protocol_compatible(
        {"protocol": local_name, "version": 1, "min": 1},
        local_name, local_version, local_min, [], [],
    ))

    t.begin("CoopJoinProtocol.is_protocol_compatible required features must be covered (both sides)")
    t.assert_false(CoopJoinProtocol.is_protocol_compatible(
        {"protocol": local_name, "version": 1, "min": 1, "required_features": ["fancy"]},
        local_name, local_version, local_min, [], [],
    ))
    t.assert_true(CoopJoinProtocol.is_protocol_compatible(
        {"protocol": local_name, "version": 1, "min": 1, "required_features": ["fancy"]},
        local_name, local_version, local_min, ["fancy"], [],
    ))

    t.begin("CoopJoinProtocol.is_protocol_compatible local required must be in remote features")
    t.assert_false(CoopJoinProtocol.is_protocol_compatible(
        {"protocol": local_name, "version": 1, "min": 1, "features": []},
        local_name, local_version, local_min, [], ["fancy"],
    ))
    t.assert_true(CoopJoinProtocol.is_protocol_compatible(
        {"protocol": local_name, "version": 1, "min": 1, "features": ["fancy"]},
        local_name, local_version, local_min, [], ["fancy"],
    ))
