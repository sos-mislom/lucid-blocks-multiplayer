class_name CoopPlayerSync
extends RefCounted

# CoopPlayerSync - phase 20 extraction from coop_manager.gd.
#
# Pure helpers for the client/peer-state sync pipeline:
#   - `hash_client_state` (pure form of `_hash_client_state` at
#     coop_manager.gd L11122-11146) - the change-detection hash
#     used to skip redundant heartbeats. Quantizes float-valued
#     fields the same way the live code does so two states that
#     only differ below the quantization step compare equal;
#   - `serialize_peer_state_entry` (pure form of the per-peer
#     serialization in `_serialize_peer_states` at coop_manager.gd
#     L13341-13371) - builds the canonical 24-tuple Array
#     consumed by `server_snapshot` / `server_snapshot_reliable`
#     RPCs. Wire-protocol shape is locked: any reorder/insertion
#     here is a wire-protocol break;
#   - `serialize_peer_states_dict` (the loop version - takes the
#     full peer_states Dictionary and returns the Array<Array>
#     snapshot in deterministic key order).
#
# Engine-bound state stays on `coop_manager.gd`:
#   - `_capture_local_state` (reads
#     `Ref.player.global_position` / `Ref.player.yaw_target` /
#     `_get_local_break_state` / `_get_local_action_state` etc.);
#   - `server_snapshot` / `server_snapshot_reliable` /
#     `submit_client_state` @rpc handlers (NodePath-bound to
#     `multiplayer` authority);
#   - `peer_states` Dictionary mutation;
#   - `_normalize_avatar_id` forwarder (lives in
#     `CoopAvatarRegistry`);
#   - `DEFAULT_AVATAR_ID` constant (single source of truth - the
#     forwarder threads it in).
#
# This module knows NOTHING about:
#   - `Ref.*` / `multiplayer.*` / `peer_states`.
#   - `class_name Player`.
#   - `DEFAULT_AVATAR_ID` - threaded in via the forwarder.


# --- Client state hash ---

# hash_client_state: pure form of `_hash_client_state`
# (coop_manager.gd L11122-11146).
#
# Returns a Godot `hash()` of the quantized snapshot fields. The
# quantization steps preserve the live "below-threshold changes
# don't trigger a heartbeat" behavior:
#   - position: 1/20th block (5cm @ 1m blocks);
#   - yaw / pitch: 1/100 rad (~0.57 deg);
#   - move_speed: 1/20 (5cm/s);
#   - break_progress: 1/50 (2% steps).
# Wire-protocol regression risk: changing any quantization step
# changes the rate at which client state heartbeats fire across
# the network.
static func hash_client_state(local_state: Dictionary) -> int:
    var position: Vector3 = local_state.get("position", Vector3.ZERO)
    var break_position: Vector3i = local_state.get("break_position", Vector3i.ZERO)
    return hash([
        bool(local_state.get("active", false)),
        bool(local_state.get("downed", false)),
        int(local_state.get("dimension", -1)),
        str(local_state.get("dimension_instance_key", "")),
        int(round(position.x * 20.0)),
        int(round(position.y * 20.0)),
        int(round(position.z * 20.0)),
        int(round(float(local_state.get("yaw", 0.0)) * 100.0)),
        int(round(float(local_state.get("pitch", 0.0)) * 100.0)),
        bool(local_state.get("crouching", false)),
        bool(local_state.get("grounded", true)),
        int(round(float(local_state.get("move_speed", 0.0)) * 20.0)),
        int(local_state.get("held_item_id", -1)),
        int(local_state.get("action_state", 0)),
        bool(local_state.get("breaking", false)),
        break_position.x,
        break_position.y,
        break_position.z,
        int(local_state.get("break_block_id", 0)),
        int(round(float(local_state.get("break_progress", 0.0)) * 50.0)),
    ])


# --- Peer state serialization ---

# serialize_peer_state_entry: pure form of the per-peer
# serialization in `_serialize_peer_states` (coop_manager.gd
# L13345-13370).
#
# Wire-protocol shape - DO NOT REORDER:
#   [
#     0  peer_id                      :int
#     1  active                       :bool
#     2  downed                       :bool
#     3  dimension                    :int
#     4  dimension_instance_key       :String
#     5  pocket_owner_key             :String
#     6  position                     :Vector3
#     7  yaw                          :float
#     8  pitch                        :float
#     9  crouching                    :bool
#    10  grounded                     :bool
#    11  move_speed                   :float
#    12  under_water                  :bool
#    13  held_item_id                 :int
#    14  action_state                 :int
#    15  name                         :String  (default "Peer <peer_id>")
#    16  player_key                   :String
#    17  avatar_id                    :String  (default `default_avatar_id`)
#    18  skin_color                   :Color   (default Color.WHITE)
#    19  breaking                     :bool
#    20  break_position               :Vector3i
#    21  break_block_id               :int
#    22  break_progress               :float
#    23  dedicated_server             :bool
#   ]
# The forwarder threads in `DEFAULT_AVATAR_ID` so the wire-protocol
# avatar id constant stays on `coop_manager.gd`.
static func serialize_peer_state_entry(
    peer_id: int,
    state: Dictionary,
    default_avatar_id: String,
) -> Array:
    return [
        peer_id,
        bool(state.get("active", false)),
        bool(state.get("downed", false)),
        int(state.get("dimension", -1)),
        str(state.get("dimension_instance_key", "")),
        str(state.get("pocket_owner_key", "")),
        state.get("position", Vector3.ZERO),
        float(state.get("yaw", 0.0)),
        float(state.get("pitch", 0.0)),
        bool(state.get("crouching", false)),
        bool(state.get("grounded", true)),
        float(state.get("move_speed", 0.0)),
        bool(state.get("under_water", false)),
        int(state.get("held_item_id", -1)),
        int(state.get("action_state", 0)),
        str(state.get("name", "Peer %s" % peer_id)),
        str(state.get("player_key", "")),
        str(state.get("avatar_id", default_avatar_id)),
        state.get("skin_color", Color.WHITE),
        bool(state.get("breaking", false)),
        state.get("break_position", Vector3i.ZERO),
        int(state.get("break_block_id", 0)),
        float(state.get("break_progress", 0.0)),
        bool(state.get("dedicated_server", false)),
    ]


# serialize_peer_states_dict: pure form of the loop body in
# `_serialize_peer_states` (coop_manager.gd L13342-13371).
# Iterates over the Dictionary in key order (matches the live
# `peer_states.keys()` iteration order) and returns the canonical
# Array<Array> snapshot.
#
# Wire-protocol note: Godot Dictionary preserves insertion order,
# so the iteration order matches the live `_serialize_peer_states`.
static func serialize_peer_states_dict(peer_states: Dictionary, default_avatar_id: String) -> Array:
    var snapshot: Array = []
    for peer_id_key in peer_states.keys():
        var peer_id: int = int(peer_id_key)
        var state: Dictionary = peer_states[peer_id_key]
        snapshot.append(serialize_peer_state_entry(peer_id, state, default_avatar_id))
    return snapshot
