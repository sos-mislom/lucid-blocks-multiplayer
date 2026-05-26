extends RefCounted


func run(t: CoopTester) -> void:
    const DEFAULT_ID: String = "default_blocky"

    t.begin("CoopPlayerSync.serialize_peer_states_dict empty -> empty Array")
    var result: Array = CoopPlayerSync.serialize_peer_states_dict({}, DEFAULT_ID)
    t.assert_eq(0, result.size())

    t.begin("CoopPlayerSync.serialize_peer_states_dict preserves dict insertion order")
    var peer_states: Dictionary = {}
    peer_states[3] = {"name": "Gamma"}
    peer_states[1] = {"name": "Alpha"}
    peer_states[2] = {"name": "Beta"}
    result = CoopPlayerSync.serialize_peer_states_dict(peer_states, DEFAULT_ID)
    t.assert_eq(3, result.size())
    t.assert_eq(3, (result[0] as Array)[0])
    t.assert_eq("Gamma", (result[0] as Array)[15])
    t.assert_eq(1, (result[1] as Array)[0])
    t.assert_eq("Alpha", (result[1] as Array)[15])
    t.assert_eq(2, (result[2] as Array)[0])
    t.assert_eq("Beta", (result[2] as Array)[15])

    t.begin("CoopPlayerSync.serialize_peer_states_dict each entry has 24 fields")
    peer_states = {1: {}, 2: {}}
    result = CoopPlayerSync.serialize_peer_states_dict(peer_states, DEFAULT_ID)
    t.assert_eq(2, result.size())
    t.assert_eq(24, (result[0] as Array).size())
    t.assert_eq(24, (result[1] as Array).size())

    t.begin("CoopPlayerSync.serialize_peer_states_dict honors string keys as ints")
    peer_states = {"5": {"name": "Delta"}}
    result = CoopPlayerSync.serialize_peer_states_dict(peer_states, DEFAULT_ID)
    t.assert_eq(1, result.size())
    t.assert_eq(5, (result[0] as Array)[0])
    # Default "Peer 5" because state has "name" key set to "Delta"
    t.assert_eq("Delta", (result[0] as Array)[15])

    t.begin("CoopPlayerSync.serialize_peer_states_dict default peer name uses int peer id")
    peer_states = {42: {}}
    result = CoopPlayerSync.serialize_peer_states_dict(peer_states, DEFAULT_ID)
    t.assert_eq("Peer 42", (result[0] as Array)[15])
