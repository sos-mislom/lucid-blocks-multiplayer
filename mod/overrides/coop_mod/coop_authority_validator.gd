class_name CoopAuthorityValidator
extends RefCounted

# CoopAuthorityValidator — phase 3 extraction from coop_manager.gd.
#
# Pure, static helpers that every server-side `@rpc("any_peer")` handler
# should run on its ingress before mutating world state:
#   - safe-number checks (NaN / inf / out-of-range)
#   - reach radius from a peer's last reported position
#   - admin role lookup
#   - resource-path allowlist (entity scenes, item map ids)
#
# Engine dependencies are injected through Callables so tests can stub
# `ResourceLoader.exists` and `ItemMap.map` without spinning up the full
# game runtime.
#
# coop_manager.gd keeps the existing private function names (e.g.
# `_is_safe_vector3`, `_server_peer_within_reach`) as one-line forwarders
# so the ~80 callers across the file compile unchanged. The state-bound
# lookups (peer_states dict, multiplayer.get_unique_id() self-admin
# shortcut, the live ResourceLoader / ItemMap singletons) remain in
# coop_manager.gd.


# --- Safe numbers ---

static func is_safe_float(value: float, max_abs_coord: float) -> bool:
    # NaN comparison trick: NaN != NaN. Catches NaN, infinity, and
    # arithmetic-overflow values without depending on Godot's `is_finite`
    # call surface for typed-float locals.
    if value != value:
        return false
    if value == INF or value == -INF:
        return false
    return absf(value) <= max_abs_coord


static func is_safe_vector3(value: Vector3, max_abs_coord: float) -> bool:
    return is_safe_float(value.x, max_abs_coord) and is_safe_float(value.y, max_abs_coord) and is_safe_float(value.z, max_abs_coord)


static func is_safe_vector3i(value: Vector3i, max_abs_coord: float) -> bool:
    var limit: int = int(max_abs_coord)
    return abs(value.x) <= limit and abs(value.y) <= limit and abs(value.z) <= limit


static func clamp_safe_vector3(value: Vector3, max_length: float, max_abs_coord: float) -> Vector3:
    if not is_safe_vector3(value, max_abs_coord):
        return Vector3.ZERO
    var length: float = value.length()
    if length > max_length and length > 0.001:
        return value.normalized() * max_length
    return value


# --- Block / item / resource-path allowlist ---

# is_safe_block_id: 0 (air) is always accepted; any other id is rejected
# unless `item_map_lookup.call(id)` returns non-null.
static func is_safe_block_id(block_id: int, item_map_lookup: Callable) -> bool:
    if block_id < 0:
        return false
    if block_id == 0:
        return true
    if not item_map_lookup.is_valid():
        return false
    return item_map_lookup.call(block_id) != null


# is_safe_item_data: PackedInt32Array whose first entry is a valid item id.
# Rejects empty arrays and over-large ones (DoS guard).
static func is_safe_item_data(item_data: PackedInt32Array, max_ints: int, item_map_lookup: Callable) -> bool:
    if item_data.is_empty() or item_data.size() > max_ints:
        return false
    var item_id: int = int(item_data[0])
    if item_id <= 0:
        return false
    if not item_map_lookup.is_valid():
        return false
    return item_map_lookup.call(item_id) != null


# is_safe_resource_path: only paths that begin with one of `allowed_prefixes`
# under `res://` are accepted; `..` and backslash are always rejected.
# `resource_loader_exists` is invoked last so callers can stub it in tests.
static func is_safe_resource_path(
    resource_path: String,
    allowed_prefixes: PackedStringArray,
    scene_only: bool,
    resource_loader_exists: Callable,
    forbidden_prefix: String = "res://main/entity/player/",
    max_length: int = 240,
) -> bool:
    var path: String = resource_path.strip_edges()
    if path == "" or path.length() > max_length:
        return false
    if not path.begins_with("res://") or path.contains("..") or path.contains("\\"):
        return false
    if scene_only and not (path.ends_with(".tscn") or path.ends_with(".scn")):
        return false

    var allowed: bool = false
    for prefix in allowed_prefixes:
        if path.begins_with(prefix):
            allowed = true
            break
    if not allowed:
        return false
    if forbidden_prefix != "" and path.begins_with(forbidden_prefix):
        return false
    if not resource_loader_exists.is_valid():
        return false
    return bool(resource_loader_exists.call(path))


# --- Reach checks ---

# True if `target` is within `reach` of `peer_pos`, with `vertical_slack`
# additional metres allowed on the Y axis (so a player can place blocks
# slightly above/below themselves). This is the pure form; coop_manager
# resolves `peer_pos` from peer_states[peer_id] before calling.
static func peer_within_reach(peer_pos: Vector3, target: Vector3, reach: float, vertical_slack: float) -> bool:
    var horizontal_sq: float = Vector2(peer_pos.x - target.x, peer_pos.z - target.z).length_squared()
    if horizontal_sq > reach * reach:
        return false
    var vertical: float = absf(peer_pos.y - target.y)
    if vertical > reach + vertical_slack:
        return false
    return true


# Block-coordinate convenience wrapper. Uses the block centre so a player
# standing on top of a block still has reach into the block itself.
static func peer_within_block_reach(peer_pos: Vector3, block_position: Vector3i, reach: float, vertical_slack: float) -> bool:
    return peer_within_reach(peer_pos, Vector3(block_position) + Vector3(0.5, 0.5, 0.5), reach, vertical_slack)


# --- Admin role ---

# Pure admin lookup: returns true only when `player_key` is non-empty and
# appears in `configured_admin_keys`. Case-sensitive (the rest of the
# codebase already normalises Steam ids to lowercase).
static func is_peer_admin(player_key: String, configured_admin_keys: PackedStringArray) -> bool:
    if player_key == "":
        return false
    for key in configured_admin_keys:
        if key == player_key:
            return true
    return false
