extends RefCounted


func _peer_states_three_active_same_dim() -> Dictionary:
    return {
        1: {"name": "Host", "active": true, "dimension_instance_key": "dimension:0"},
        5: {"name": "Alice", "active": true, "dimension_instance_key": "dimension:0"},
        9: {"name": "Bob", "active": true, "dimension_instance_key": "dimension:0"},
    }


func run(t: CoopTester) -> void:
    var peer_states: Dictionary = _peer_states_three_active_same_dim()
    var own_peer_id: int = 9
    var own_instance_key: String = "dimension:0"

    t.begin("CoopTeleport.build_tp_autocomplete_entries excludes own peer and inactive peers")
    var inactive_states: Dictionary = peer_states.duplicate(true)
    inactive_states[5]["active"] = false
    var with_inactive: Array = CoopTeleport.build_tp_autocomplete_entries(inactive_states, own_peer_id, own_instance_key, "")
    t.assert_eq(1, with_inactive.size(), "only host remains (Alice inactive, Bob self)")
    t.assert_eq(1, int(with_inactive[0].get("peer_id", -1)))

    t.begin("CoopTeleport.build_tp_autocomplete_entries blank query returns all active non-self peers, sorted by peer_id")
    var all_entries: Array = CoopTeleport.build_tp_autocomplete_entries(peer_states, own_peer_id, own_instance_key, "")
    t.assert_eq(2, all_entries.size())
    t.assert_eq(1, int(all_entries[0].get("peer_id", -1)), "first entry sorted to peer_id 1")
    t.assert_eq(5, int(all_entries[1].get("peer_id", -1)), "second entry sorted to peer_id 5")

    t.begin("CoopTeleport.build_tp_autocomplete_entries alias is 'host' for peer 1, 'p<id>' for others")
    t.assert_eq("host", str(all_entries[0].get("insert", "")))
    t.assert_eq("p5", str(all_entries[1].get("insert", "")))

    t.begin("CoopTeleport.build_tp_autocomplete_entries label is '<name> (<alias>)'")
    t.assert_eq("Host (host)", str(all_entries[0].get("label", "")))
    t.assert_eq("Alice (p5)", str(all_entries[1].get("label", "")))

    t.begin("CoopTeleport.build_tp_autocomplete_entries hint reflects same vs cross-instance")
    t.assert_eq(CoopTeleport.HINT_SAME_INSTANCE, str(all_entries[0].get("hint", "")), "host in same dim -> same-instance hint")
    t.assert_eq(CoopTeleport.HINT_SAME_INSTANCE, str(all_entries[1].get("hint", "")), "alice in same dim -> same-instance hint")

    t.begin("CoopTeleport.build_tp_autocomplete_entries cross-instance peer gets cross-instance hint")
    var split_states: Dictionary = peer_states.duplicate(true)
    split_states[5]["dimension_instance_key"] = "pocket:alice"
    var split_entries: Array = CoopTeleport.build_tp_autocomplete_entries(split_states, own_peer_id, own_instance_key, "")
    for entry in split_entries:
        if int(entry.get("peer_id", -1)) == 5:
            t.assert_eq(CoopTeleport.HINT_CROSS_INSTANCE, str(entry.get("hint", "")))

    t.begin("CoopTeleport.build_tp_autocomplete_entries filters by name (contains, case-insensitive)")
    var name_filtered: Array = CoopTeleport.build_tp_autocomplete_entries(peer_states, own_peer_id, own_instance_key, "ali")
    t.assert_eq(1, name_filtered.size())
    t.assert_eq(5, int(name_filtered[0].get("peer_id", -1)))

    t.begin("CoopTeleport.build_tp_autocomplete_entries filters by alias substring")
    var alias_filtered: Array = CoopTeleport.build_tp_autocomplete_entries(peer_states, own_peer_id, own_instance_key, "hos")
    t.assert_eq(1, alias_filtered.size())
    t.assert_eq(1, int(alias_filtered[0].get("peer_id", -1)))

    t.begin("CoopTeleport.build_tp_autocomplete_entries filters by exact peer_id string")
    var id_filtered: Array = CoopTeleport.build_tp_autocomplete_entries(peer_states, own_peer_id, own_instance_key, "5")
    t.assert_eq(1, id_filtered.size())
    t.assert_eq(5, int(id_filtered[0].get("peer_id", -1)))

    t.begin("CoopTeleport.build_tp_autocomplete_entries strips query whitespace before matching")
    var padded: Array = CoopTeleport.build_tp_autocomplete_entries(peer_states, own_peer_id, own_instance_key, "  ALI  ")
    t.assert_eq(1, padded.size())
    t.assert_eq(5, int(padded[0].get("peer_id", -1)))
