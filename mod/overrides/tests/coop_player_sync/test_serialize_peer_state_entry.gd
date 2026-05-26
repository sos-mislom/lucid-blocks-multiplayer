extends RefCounted


func run(t: CoopTester) -> void:
    const DEFAULT_ID: String = "default_blocky"

    t.begin("CoopPlayerSync.serialize_peer_state_entry default-everywhere fills 24 fields")
    var entry: Array = CoopPlayerSync.serialize_peer_state_entry(7, {}, DEFAULT_ID)
    t.assert_eq(24, entry.size())
    t.assert_eq(7, entry[0])
    t.assert_eq(false, entry[1])
    t.assert_eq(false, entry[2])
    t.assert_eq(-1, entry[3])
    t.assert_eq("", entry[4])
    t.assert_eq("", entry[5])
    t.assert_eq(Vector3.ZERO, entry[6])
    t.assert_eq(0.0, entry[7])
    t.assert_eq(0.0, entry[8])
    t.assert_eq(false, entry[9])
    t.assert_eq(true, entry[10])
    t.assert_eq(0.0, entry[11])
    t.assert_eq(false, entry[12])
    t.assert_eq(-1, entry[13])
    t.assert_eq(0, entry[14])
    t.assert_eq("Peer 7", entry[15])
    t.assert_eq("", entry[16])
    t.assert_eq(DEFAULT_ID, entry[17])
    t.assert_eq(Color.WHITE, entry[18])
    t.assert_eq(false, entry[19])
    t.assert_eq(Vector3i.ZERO, entry[20])
    t.assert_eq(0, entry[21])
    t.assert_eq(0.0, entry[22])
    t.assert_eq(false, entry[23])

    t.begin("CoopPlayerSync.serialize_peer_state_entry honors all provided fields")
    var state: Dictionary = {
        "active": true,
        "downed": true,
        "dimension": 2,
        "dimension_instance_key": "void",
        "pocket_owner_key": "host",
        "position": Vector3(10, 20, 30),
        "yaw": 1.5,
        "pitch": -0.25,
        "crouching": true,
        "grounded": false,
        "move_speed": 4.5,
        "under_water": true,
        "held_item_id": 42,
        "action_state": 3,
        "name": "Tim",
        "player_key": "steam_123",
        "avatar_id": "neon",
        "skin_color": Color.RED,
        "breaking": true,
        "break_position": Vector3i(1, 2, 3),
        "break_block_id": 5,
        "break_progress": 0.75,
        "dedicated_server": true,
    }
    entry = CoopPlayerSync.serialize_peer_state_entry(11, state, DEFAULT_ID)
    t.assert_eq(11, entry[0])
    t.assert_eq(true, entry[1])
    t.assert_eq(true, entry[2])
    t.assert_eq(2, entry[3])
    t.assert_eq("void", entry[4])
    t.assert_eq("host", entry[5])
    t.assert_eq(Vector3(10, 20, 30), entry[6])
    t.assert_eq(1.5, entry[7])
    t.assert_eq(-0.25, entry[8])
    t.assert_eq(true, entry[9])
    t.assert_eq(false, entry[10])
    t.assert_eq(4.5, entry[11])
    t.assert_eq(true, entry[12])
    t.assert_eq(42, entry[13])
    t.assert_eq(3, entry[14])
    t.assert_eq("Tim", entry[15])
    t.assert_eq("steam_123", entry[16])
    t.assert_eq("neon", entry[17])
    t.assert_eq(Color.RED, entry[18])
    t.assert_eq(true, entry[19])
    t.assert_eq(Vector3i(1, 2, 3), entry[20])
    t.assert_eq(5, entry[21])
    t.assert_eq(0.75, entry[22])
    t.assert_eq(true, entry[23])

    t.begin("CoopPlayerSync.serialize_peer_state_entry honors threaded-in default_avatar_id")
    entry = CoopPlayerSync.serialize_peer_state_entry(1, {}, "custom_default")
    t.assert_eq("custom_default", entry[17])
