class_name CoopConfig
extends RefCounted

# CoopConfig - phase 22 extraction from coop_manager.gd.
#
# Pure helpers for normalizing values written into the live
# `config` Dictionary. The file I/O path (`_load_config` /
# `_save_config` and the JSON.parse / atomic_write_file calls)
# stays on `coop_manager.gd` as a forwarder because:
#   1. it touches `FileAccess.file_exists` / `FileAccess.open` /
#      `JSON.parse_string` / `JSON.stringify`;
#   2. it depends on the live `CONFIG_PATH` constant and
#      `OS.get_user_data_dir().path_join(...)` for the announce
#      message;
#   3. it triggers `_sync_inputs_from_config` /
#      `_refresh_local_ip_label` / `_update_status_text` UI
#      side effects.
#
# What lives here:
#   - `normalize_string_field` (strip whitespace, fall back to
#     default when the value is null);
#   - `normalize_bool_field` (default when null, bool() otherwise);
#   - `normalize_string_field_with_default_when_empty` (the variant
#     used for `server_public_region` where the field is stripped
#     then falls back to the default string when empty - matches
#     the live behavior where `region` defaults to `"public"`);
#   - `clamp_server_entity_radius` (the [16, 256] float clamp used
#     by `get_server_entity_view_radius` / `_simulation_radius`);
#   - `clamp_registry_cache_ttl_sec` (the `maxi(0, ...)` clamp
#     used by `server_registry_cache_ttl_sec`);
#   - `build_default_config` (the literal default Dictionary; the
#     forwarder threads in the static constants so the wire-shape
#     contract stays on `coop_manager.gd`).
#
# This module knows NOTHING about:
#   - `FileAccess` / `DirAccess` / `JSON.*` / `OS.*`.
#   - `Ref.*` / `multiplayer.*` / `config["..."]` Dictionary state.
#   - `CONFIG_PATH` / `DEFAULT_PORT` / `DEFAULT_AVATAR_ID` /
#     `ENABLE_*_DEFAULT` / `DEFAULT_SERVER_*_RADIUS` /
#     `DEFAULT_SERVER_COMMAND_POLICY` /
#     `SERVER_REGISTRY_CACHE_TTL_SEC` constants - threaded in via
#     the forwarder.


# --- Generic field normalization ---

# normalize_string_field: pure form of the
# `str(config.get(<k>, <default>)).strip_edges()` pattern repeated
# all over `_load_config` (coop_manager.gd L14544-14550).
#
# Returns the stripped string value, or the stripped default when
# the value is `null` / missing.
static func normalize_string_field(value: Variant, default_value: String) -> String:
    if value == null:
        return default_value.strip_edges()
    return str(value).strip_edges()


# normalize_string_field_with_default_when_empty: variant used by
# `server_public_region` where the stripped value falls back to
# the default when empty (matches the live pattern where region
# defaults to `"public"` even if the user clears the field).
static func normalize_string_field_with_default_when_empty(value: Variant, default_value: String) -> String:
    var stripped: String = normalize_string_field(value, default_value)
    return stripped if stripped != "" else default_value.strip_edges()


# normalize_bool_field: pure form of the
# `bool(config.get(<k>, <default>))` pattern (coop_manager.gd
# L14540-14543, L14551).
static func normalize_bool_field(value: Variant, default_value: bool) -> bool:
    if value == null:
        return default_value
    return bool(value)


# --- Numeric clamps ---

# clamp_server_entity_radius: pure form of the [16, 256] clamp
# used by `get_server_entity_view_radius` /
# `get_server_entity_simulation_radius` (coop_manager.gd
# L779-784).
static func clamp_server_entity_radius(value: Variant, default_radius: float) -> float:
    var resolved: float = default_radius
    if value != null:
        resolved = float(value)
    return clampf(resolved, 16.0, 256.0)


# clamp_registry_cache_ttl_sec: pure form of the `maxi(0, ...)`
# clamp used by `server_registry_cache_ttl_sec` (coop_manager.gd
# L14552). TTL is in seconds; the upper bound is open by design
# (callers may want to set effectively-infinite TTLs by passing a
# very large value).
static func clamp_registry_cache_ttl_sec(value: Variant, default_ttl_sec: int) -> int:
    var resolved: int = default_ttl_sec
    if value != null:
        resolved = int(value)
    return maxi(0, resolved)


# --- Default config dict ---

# build_default_config: pure form of the literal default `config`
# Dictionary built at the top of `_load_config` (coop_manager.gd
# L14502-14522).
#
# The forwarder threads in the live constants so this module
# stays oblivious to:
#   - DEFAULT_PORT
#   - DEFAULT_AVATAR_ID
#   - ENABLE_*_DEFAULT booleans
#   - SERVER_REGISTRY_CACHE_TTL_SEC
#   - DEFAULT_SERVER_ENTITY_VIEW_RADIUS
#   - DEFAULT_SERVER_ENTITY_SIMULATION_RADIUS
#   - DEFAULT_SERVER_COMMAND_POLICY (deep-duplicated by the
#     caller before being threaded in, so the constant isn't
#     mutated)
#
# Wire-shape note: the returned Dictionary IS the on-disk config
# shape; adding/removing keys here changes what
# `lucid_blocks_coop_config.json` will look like for everyone on
# the next save.
static func build_default_config(
    default_port: int,
    default_avatar_id: String,
    enable_debug_console_commands_default: bool,
    enable_client_visual_mod_default: bool,
    enable_avatar_customization_default: bool,
    enable_avatar_alias_command_default: bool,
    server_registry_cache_ttl_sec_default: int,
    server_entity_view_radius_default: float,
    server_entity_simulation_radius_default: float,
    server_command_policy_default: Dictionary,
) -> Dictionary:
    return {
        "address": "127.0.0.1",
        "port": default_port,
        "avatar_id": default_avatar_id,
        "server_registry_url": "",
        "server_registry_heartbeat_url": "",
        "server_registry_token": "",
        "server_public_address": "",
        "server_public_name": "",
        "server_public_region": "public",
        "show_direct_connect_tab": false,
        "enable_debug_console_commands": enable_debug_console_commands_default,
        "enable_client_visual_mod": enable_client_visual_mod_default,
        "enable_avatar_customization": enable_avatar_customization_default,
        "enable_avatar_alias_command": enable_avatar_alias_command_default,
        "server_registry_cache_ttl_sec": server_registry_cache_ttl_sec_default,
        "server_entity_view_radius": server_entity_view_radius_default,
        "server_entity_simulation_radius": server_entity_simulation_radius_default,
        "server_command_policy": server_command_policy_default,
        "server_admin_keys": [],
    }
