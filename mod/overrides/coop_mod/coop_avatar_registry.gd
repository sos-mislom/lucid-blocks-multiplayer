class_name CoopAvatarRegistry
extends RefCounted

# CoopAvatarRegistry - phase 19 extraction from coop_manager.gd.
#
# Pure helpers for avatar id + skin color normalization. The
# preloaded `AvatarRegistry` (`mod/overrides/coop_mod/avatar_registry.gd`)
# remains the source of avatar manifest data because it touches
# `DirAccess` / `FileAccess` / `ResourceLoader` to walk
# `res://coop_mod/avatar_assets`. This module exposes the
# unit-testable normalize / skin-color decision helpers without
# pulling that filesystem state.
#
# What lives here:
#   - `normalize_avatar_id` (pure form of `_normalize_avatar_id`
#     at coop_manager.gd L9442-9444 and the private
#     `_normalize_avatar_id` inside `avatar_registry.gd` L184-186):
#     strip whitespace, lowercase, fall back to `default_avatar_id`
#     when empty;
#   - `resolve_skin_color` (pure form of `_get_local_skin_color`
#     at coop_manager.gd L11088-11093): when the avatar id matches
#     the default avatar, returns `Color.WHITE`; otherwise returns
#     the settings-derived color when present, or the fallback
#     when missing/wrong type;
#   - `coerce_color` (the "Variant -> Color" helper used by
#     resolve_skin_color and by peer-state validation paths -
#     passes through when input is a `Color`, otherwise returns
#     `fallback`).
#
# Engine-bound state stays on `coop_manager.gd`:
#   - `_normalize_avatar_id` keeps the local-state synchronization
#     side effects;
#   - `_get_local_skin_color` reads
#     `Ref.save_file_manager.settings_file.get_data("skin_modulate",
#     Color.WHITE)` - the forwarder threads the read value in;
#   - `_set_local_avatar_id_from_command` reaches into
#     `config["avatar_id"]` and broadcasts `request_local_state`
#     RPCs;
#   - `AvatarRegistry.list_avatar_entries` /
#     `AvatarRegistry.invalidate_cache` /
#     `AvatarRegistry.get_avatar_entry` (filesystem-bound; living
#     in `avatar_registry.gd` as-is).
#
# This module knows NOTHING about:
#   - `Ref.*` / `multiplayer.*` / `config["..."]`.
#   - `DirAccess` / `FileAccess` / `ResourceLoader`.
#   - The `DEFAULT_AVATAR_ID` constant - threaded in via the
#     forwarder so the constant stays on `coop_manager.gd` as the
#     single source of truth for the wire-protocol avatar id.


# --- Avatar id normalization ---

# normalize_avatar_id: pure form of `_normalize_avatar_id`
# (coop_manager.gd L9442-9444, avatar_registry.gd L184-186).
# Strips whitespace, lowercases, falls back to `default_avatar_id`
# when the result is empty.
#
# Live note: `to_lower()` is locale-agnostic in GDScript's String
# (uses the Unicode lowercase mapping), matching the live
# behavior. The forwarder threads in `DEFAULT_AVATAR_ID` so the
# wire-protocol avatar id constant stays on `coop_manager.gd`.
static func normalize_avatar_id(raw_avatar_id: String, default_avatar_id: String) -> String:
    var normalized: String = raw_avatar_id.strip_edges().to_lower()
    return normalized if normalized != "" else default_avatar_id


# --- Skin color resolution ---

# coerce_color: pure form of the "Variant -> Color" coercion used
# by skin-color reads. Passes through when input is a `Color`,
# returns `fallback` otherwise (matches the live behavior where
# `settings_file.get_data("skin_modulate", Color.WHITE)` already
# defaults to `Color.WHITE` and the consumer treats any non-Color
# fallback shape as "no preference").
static func coerce_color(value: Variant, fallback: Color) -> Color:
    if value is Color:
        return value
    return fallback


# resolve_skin_color: pure form of `_get_local_skin_color`
# (coop_manager.gd L11088-11093).
#
# Returns `Color.WHITE` when:
#   - the avatar id matches `default_avatar_id` (the default
#     blocky avatar always uses untinted white skin so it stays
#     visible against any background);
#   - the settings_file read returned no Color (Ref.save_file_manager
#     missing in the live code path).
# Otherwise returns the settings color.
#
# The forwarder threads in `DEFAULT_AVATAR_ID` and the result of
# the (engine-bound) `settings_file.get_data("skin_modulate", ...)`
# read.
static func resolve_skin_color(
    avatar_id: String,
    settings_color: Variant,
    default_avatar_id: String,
    fallback: Color = Color.WHITE,
) -> Color:
    if avatar_id == default_avatar_id:
        return Color.WHITE
    return coerce_color(settings_color, fallback)
