class_name CoopAdmin
extends RefCounted

# CoopAdmin — phase 5 extraction from coop_manager.gd.
#
# Pure, static helpers for the admin / command-policy / builder-parsing
# surface. Designed to be called from coop_manager.gd forwarders so the
# original private function names (and all their ~80 callers) stay
# unchanged.
#
# This module knows NOTHING about:
#   - Ref.* singletons (Ref.world, Ref.player, Ref.entity_spawner) —
#     callers resolve any required values (e.g. snap_to_chunk) first.
#   - multiplayer.* / scene tree / @rpc — engine-bound dispatch stays on
#     coop_manager.gd.
#   - Game constants (DEFAULT_SERVER_COMMAND_POLICY,
#     ADMIN_BUILDER_COMMAND_NAMES, CORE_DEBUG_COMMAND_NAMES,
#     WORLD_EDIT_CHUNK_SIZE_*) — passed in by the caller so the
#     source-of-truth does not fork.
#
# All command-name comparisons in this module assume the caller has
# already lowercased / normalized via `normalize_command_name`.


# --- Admin keys ---

# parse_admin_keys: accept either an `Array` of entries, a single
# comma-separated string, or a semicolon-separated string (mixed
# delimiters are allowed). Trim each entry, drop blanks, deduplicate.
# Preserves original casing — the existing coop_manager comparison
# (`PackedStringArray.has(...)`) is case-sensitive.
static func parse_admin_keys(raw_keys: Variant) -> PackedStringArray:
    var keys: PackedStringArray = PackedStringArray()
    if raw_keys is Array:
        for raw_entry in raw_keys:
            var entry: String = str(raw_entry).strip_edges()
            if entry != "" and not keys.has(entry):
                keys.append(entry)
        return keys

    var text: String = str(raw_keys).strip_edges()
    if text == "":
        return keys
    for raw_entry in text.replace(";", ",").split(",", false):
        var entry: String = str(raw_entry).strip_edges()
        if entry != "" and not keys.has(entry):
            keys.append(entry)
    return keys


# --- Command name normalization ---

# normalize_command_name: canonical lookup form for command-policy and
# admin-builder classification. Strips whitespace, lowercases, removes
# any leading `/` characters, swaps `-` for `_`, then collapses two
# aliases (`gm` -> `gamemode`, `mobs` -> `spawnmenu`).
static func normalize_command_name(raw_command: String) -> String:
    var name: String = raw_command.strip_edges().to_lower()
    while name.begins_with("/"):
        name = name.substr(1)
    name = name.replace("-", "_")
    if name == "gm":
        return "gamemode"
    if name == "mobs":
        return "spawnmenu"
    return name


# --- Command policy ---

# normalize_command_policy: deep-copy `default_policy`, layer the raw
# config dictionary on top (every entry coerced to bool via
# `normalize_command_name`), then mirror the two alias pairs so callers
# can look up policy by either name.
static func normalize_command_policy(raw_policy: Variant, default_policy: Dictionary) -> Dictionary:
    var policy: Dictionary = default_policy.duplicate(true)
    if raw_policy is Dictionary:
        for key in raw_policy.keys():
            var command_name: String = normalize_command_name(str(key))
            if command_name == "":
                continue
            # GDScript's `bool(...)` global only succeeds when the
            # underlying Variant is already convertible (bool / int /
            # float). Raw_policy values can be arbitrary (string, null,
            # Object, etc.) so we coerce via the truthy gate which
            # handles every Variant type uniformly.
            policy[command_name] = true if raw_policy[key] else false
    policy["gm"] = bool(policy.get("gamemode", false))
    policy["mobs"] = bool(policy.get("spawnmenu", false))
    return policy


# is_policy_controlled: true when `default_policy` has the
# (normalized) command name — i.e. the host has an explicit allow/deny
# entry for it. Commands that aren't policy-controlled are always
# allowed for everyone (see is_command_allowed below).
static func is_policy_controlled(command: String, default_policy: Dictionary) -> bool:
    return default_policy.has(normalize_command_name(command))


# is_command_allowed: pure policy lookup. Non-controlled commands
# always allowed; controlled commands fall back to the default-policy
# value when the effective policy is silent on the key.
static func is_command_allowed(command: String, effective_policy: Dictionary, default_policy: Dictionary) -> bool:
    if not is_policy_controlled(command, default_policy):
        return true
    var command_name: String = normalize_command_name(command)
    return bool(effective_policy.get(command_name, default_policy.get(command_name, true)))


# --- Command set classification ---

# is_admin_builder_command: true when the (normalized) command is part
# of the admin builder set (`/wand`, `/pos1`, `/fill`, `/builder_setup`,
# etc.).
static func is_admin_builder_command(command: String, admin_builder_names: PackedStringArray) -> bool:
    return admin_builder_names.has(normalize_command_name(command))


# is_core_debug_command: true when the command (`/give`, `/spawn`, ...)
# is part of the core debug set. Comparison is case-insensitive but
# expects the leading `/` so we can share the list with the autocomplete
# helper below.
static func is_core_debug_command(command: String, core_debug_names: PackedStringArray) -> bool:
    var normalized: String = command.strip_edges().to_lower()
    for debug_command in core_debug_names:
        if normalized == str(debug_command):
            return true
    return false


# is_core_debug_autocomplete_command: autocomplete entries arrive
# without a leading `/`, so we re-prefix before delegating.
static func is_core_debug_autocomplete_command(command_body: String, core_debug_names: PackedStringArray) -> bool:
    return is_core_debug_command("/" + command_body.strip_edges().to_lower(), core_debug_names)


# --- Builder parsing primitives ---

# parse_vector3i_parts: read three consecutive ints from `parts`
# starting at `start_index`. Returns `null` when the slice is short or
# any element is not a valid int. The Variant return shape matches the
# existing `_parse_builder_vector3i_parts` contract so the forwarder is
# a one-liner.
static func parse_vector3i_parts(parts: PackedStringArray, start_index: int) -> Variant:
    if parts.size() < start_index + 3:
        return null
    for offset in range(3):
        if not str(parts[start_index + offset]).is_valid_int():
            return null
    return Vector3i(int(parts[start_index]), int(parts[start_index + 1]), int(parts[start_index + 2]))


# parse_on_off: accept the common toggle spellings; unknown values
# flip the `current` boolean (the existing builder behavior — typing
# `/peaceful junk` toggles instead of erroring).
static func parse_on_off(value: String, current: bool) -> bool:
    var normalized: String = value.strip_edges().to_lower()
    if ["on", "1", "true", "yes", "enable", "enabled"].has(normalized):
        return true
    if ["off", "0", "false", "no", "disable", "disabled"].has(normalized):
        return false
    return not current


# format_vector3i: canonical "x y z" representation used by builder
# command responses. Space-separated (not comma-separated) so it can
# be pasted straight back into a `/tp` argument.
static func format_vector3i(position: Vector3i) -> String:
    return "%d %d %d" % [position.x, position.y, position.z]


# --- Item aliases / slug ---

# slugify: alphanumeric + `_` collapse. Lowercases, runs of non-alnum
# chars collapse to a single `_`, leading/trailing `_` trimmed. Used by
# builder block-name lookup and by 10+ other coop_manager callsites; the
# forwarder preserves the original signature for all of them.
static func slugify(raw_text: String) -> String:
    var normalized: String = raw_text.strip_edges().to_lower()
    var output: PackedStringArray = []
    for character in normalized:
        var unicode_value: int = character.unicode_at(0)
        var is_digit: bool = unicode_value >= 48 and unicode_value <= 57
        var is_lower: bool = unicode_value >= 97 and unicode_value <= 122
        if is_digit or is_lower:
            output.append(character)
        elif output.is_empty() or output[-1] != "_":
            output.append("_")

    var slug: String = "".join(output).strip_edges()
    return slug.trim_prefix("_").trim_suffix("_")


# item_aliases: emit deduplicated slugs for an item, given its
# display_name and internal_name. The caller (coop_manager forwarder)
# resolves the strings off the engine `Block` resource first, so this
# helper stays pure.
static func item_aliases(display_name: String, internal_name: String) -> PackedStringArray:
    var aliases: PackedStringArray = PackedStringArray()
    for raw_name in [display_name, internal_name]:
        var alias: String = slugify(str(raw_name))
        if alias != "" and not aliases.has(alias):
            aliases.append(alias)
    return aliases


# --- Selection geometry ---

# has_selection: true when the per-peer selection record holds two
# Vector3i corners. `record` shape: { "pos1": Vector3i, "pos2": Vector3i }.
static func has_selection(record: Dictionary) -> bool:
    return record.get("pos1", null) is Vector3i and record.get("pos2", null) is Vector3i


# selection_bounds: min/max AABB for the two corner points. Caller is
# expected to have verified `has_selection` first; the existing
# coop_manager helper crashes on missing keys too, so we match.
static func selection_bounds(record: Dictionary) -> Dictionary:
    var a: Vector3i = record["pos1"]
    var b: Vector3i = record["pos2"]
    return {
        "min": Vector3i(mini(a.x, b.x), mini(a.y, b.y), mini(a.z, b.z)),
        "max": Vector3i(maxi(a.x, b.x), maxi(a.y, b.y), maxi(a.z, b.z)),
    }


# --- World-edit math ---

# chunk_square_around_position: square footprint (in block coords)
# around a chunk-snapped center, covering (2*radius_chunks+1) chunks per
# axis. The Y component is intentionally zero because callers fill from
# `WORLD_EDIT_DEFAULT_CLEAR_HEIGHT` upward.
#
# The caller is responsible for resolving `center_chunk` via
# `Ref.world.snap_to_chunk(position)` before invoking this helper —
# that keeps `Ref.world` out of CoopAdmin.
static func chunk_square_around_position(center_chunk: Vector3i, radius_chunks: int, chunk_size_x: int, chunk_size_z: int) -> Dictionary:
    var min_x: int = center_chunk.x - radius_chunks * chunk_size_x
    var min_z: int = center_chunk.z - radius_chunks * chunk_size_z
    var max_x: int = center_chunk.x + (radius_chunks + 1) * chunk_size_x - 1
    var max_z: int = center_chunk.z + (radius_chunks + 1) * chunk_size_z - 1
    return {
        "min": Vector3i(min_x, 0, min_z),
        "max": Vector3i(max_x, 0, max_z),
    }


# count_box_blocks: block-count of the AABB inclusive of both corners,
# clamped at 0 per axis to handle degenerate (inverted) input safely.
static func count_box_blocks(min_pos: Vector3i, max_pos: Vector3i) -> int:
    return maxi(0, max_pos.x - min_pos.x + 1) * maxi(0, max_pos.y - min_pos.y + 1) * maxi(0, max_pos.z - min_pos.z + 1)
