class_name CoopWorldPatch
extends RefCounted

# CoopWorldPatch - phase 12d extraction from coop_manager.gd.
#
# Pure helpers for the guest world-patch capture/merge/filter pipeline
# that bracket `_capture_local_chunk_patch_for_*` and
# `_merge_world_patch_into_save`. The engine-bound capture step
# (`Ref.world.save_data(world_data, prefix)`, runtime per-cell read
# via `Ref.world.get_block_type_at(...)`) stays on coop_manager.gd;
# the pure module owns the post-capture filtering / merging /
# deduplication / clamping math.
#
# Five families:
#
#   1. `clamp_chunk_byte_value` - the 0-255 clamp used everywhere
#     water / fire levels travel across the wire (every byte channel
#     is a uint8 on the JSON side). Pinning it as a pure helper
#     surfaces any silent widening to 16-bit.
#
#   2. `dedupe_chunk_positions` - takes an array of `Vector3i` chunk
#     positions (already snapped to chunk by the forwarder via
#     `Ref.world.snap_to_chunk(...)`) and returns the unique set in
#     first-seen order. Pure form of the dedupe loop inside
#     `_get_unique_chunk_positions_for_world_positions` (L12667-12688).
#
#   3. `filter_world_data_to_chunk_positions` - reads the
#     `<prefix>world` nested dict and keeps only the per-chunk entries
#     (block / water / water_awake / fire) whose chunk position is in
#     the supplied list. Returns `{}` when nothing matched. Pure form
#     of `_filter_world_data_to_chunk_positions` (L12691-12714).
#
#   4. `merge_patch_dictionary` - recursive deep-merge for two
#     patch dicts. Dictionaries are merged key-by-key (so per-chunk
#     overrides land cleanly inside the same root); other types
#     overwrite. Array / Dictionary values are deep-copied so the
#     caller cannot accidentally poison the source via the merged
#     result. Pure form of `_merge_patch_dictionary` (L12867-12875).
#
#   5. `should_use_canonical_guest_block_patch` - the
#     out-of-range-from-host predicate the live
#     `_should_use_canonical_guest_block_patch` (L4728-4741) uses to
#     decide whether the guest must perform a CANONICAL whole-chunk
#     patch (host can't see the block) versus the lightweight
#     incremental patch (host can see it; let the host's
#     authoritative pass overwrite).
#
# This module knows NOTHING about:
#   - `Ref.world.snap_to_chunk(...)` - the forwarder pre-snaps world
#     positions before invoking `dedupe_chunk_positions`.
#   - `Ref.world.save_data(...)` / `Ref.world.get_block_type_at(...)` -
#     the capture step stays on coop_manager.gd; pure helpers operate
#     on the post-capture dict.
#   - `multiplayer.is_server()` / `_has_live_peer()` /
#     `_is_local_world_authority()` / `peer_states.get(1, ...)` -
#     resolved at the forwarder boundary and passed in as booleans /
#     plain Vector3.
#   - `get_same_instance_base_load_radius(...)` /
#     `HOST_SESSION_MAX_LOAD_RADIUS` - the forwarder computes
#     `host_load_radius` and threads it in.
#   - `@rpc` handlers (`submit_guest_world_patch`,
#     `request_guest_world_patch_flush`, `confirm_guest_world_patch_flush`)
#     - NodePath-bound, stay on coop_manager.gd.


# --- Constants ---

# WORLD_PATCH_CHUNK_SUFFIXES: the per-chunk dict keys the live filter
# walks through. Lifted as a constant so the four-suffix tuple is
# defined in one place rather than duplicated at the filter call site.
const WORLD_PATCH_CHUNK_SUFFIXES: Array = ["chunk_block", "chunk_water", "chunk_water_awake", "chunk_fire"]

# MIN_SAFE_GUEST_PATCH_RADIUS: the floor on the safe-distance check
# inside `should_use_canonical_guest_block_patch`. Matches the live
# `maxf(16.0, host_load_radius)` floor at L4739.
const MIN_SAFE_GUEST_PATCH_RADIUS: float = 16.0

# BLOCK_CENTER_OFFSET: half-block centring for distance-to-host
# checks. Matches the `Vector3(0.5, 0.5, 0.5)` literal at L4740 -
# block-centre is the canonical target for radius math (vs. the
# corner-anchored Vector3i).
const BLOCK_CENTER_OFFSET: Vector3 = Vector3(0.5, 0.5, 0.5)


# --- Byte clamp ---

# clamp_chunk_byte_value: pure form of `_clamp_chunk_byte_value`
# (coop_manager.gd L12808-12809).
#
# Coerces `value` to int and clamps to [0, 255]. Used on every byte
# field that travels across the wire (water level, fire level,
# water_awake flag) so the receiver can rely on `int8 == uint8` after
# a single cast.
#
# Variant input is accepted (the live signature is `value: Variant`)
# to handle the common case where `Ref.world.get_water_level_at(...)`
# returns an untyped Variant (`float` in some build paths, `int` in
# others).
static func clamp_chunk_byte_value(value: Variant) -> int:
    return clampi(int(value), 0, 255)


# --- Chunk-position dedupe ---

# dedupe_chunk_positions: pure form of the dedupe loop inside
# `_get_unique_chunk_positions_for_world_positions` (coop_manager.gd
# L12671-12687).
#
# Takes an Array of `Vector3i` chunk positions (already snapped by the
# forwarder via `Ref.world.snap_to_chunk(...)`) and returns the unique
# set in first-seen order. Non-Vector3i entries are skipped defensively
# (matches the live `world_position is Vector3 / Vector3i` filter
# before the snap-to-chunk).
#
# First-seen ordering matters: the live capture loops (e.g.
# `_capture_local_runtime_chunk_patch_for_world_positions`) iterate
# the returned list and stream chunks in that order; reordering would
# change the over-the-wire chunk sequence.
static func dedupe_chunk_positions(chunk_positions: Array) -> Array:
    var unique_positions: Array = []
    var seen: Dictionary = {}
    for chunk_position in chunk_positions:
        if not (chunk_position is Vector3i):
            continue
        if seen.has(chunk_position):
            continue
        seen[chunk_position] = true
        unique_positions.append(chunk_position)
    return unique_positions


# --- World-data filter ---

# filter_world_data_to_chunk_positions: pure form of
# `_filter_world_data_to_chunk_positions` (coop_manager.gd L12691-12714).
#
# Reads `world_data[prefix + "world"]` (the nested per-dimension root)
# and keeps only the per-chunk entries whose chunk position is in
# `chunk_positions`. Returns `{prefix + "world": <filtered_root>}` on
# hit or `{}` on miss (the source root was not a dict / no chunks
# matched).
#
# The four per-chunk dicts walked through are
# `WORLD_PATCH_CHUNK_SUFFIXES = ["chunk_block", "chunk_water",
# "chunk_water_awake", "chunk_fire"]` - each is a Dictionary keyed by
# `Vector3i` (chunk position). Entries are deep-copied on inclusion
# (matches L12707) so downstream merge can mutate without poisoning
# the source.
#
# Suffixes without matching chunks are omitted entirely; an entirely
# empty filtered root returns `{}` (matches L12712-12713).
static func filter_world_data_to_chunk_positions(
    world_data: Dictionary,
    prefix: String,
    chunk_positions: Array,
) -> Dictionary:
    var source_root: Variant = world_data.get(prefix + "world", null)
    if not (source_root is Dictionary):
        return {}

    var filtered_root: Dictionary = {}
    var source_world: Dictionary = source_root
    for suffix in WORLD_PATCH_CHUNK_SUFFIXES:
        var source_key: String = prefix + suffix
        var source_entries: Variant = source_world.get(source_key, null)
        if not (source_entries is Dictionary):
            continue

        var filtered_entries: Dictionary = {}
        for chunk_position in chunk_positions:
            if source_entries.has(chunk_position):
                filtered_entries[chunk_position] = source_entries[chunk_position].duplicate(true)

        if not filtered_entries.is_empty():
            filtered_root[source_key] = filtered_entries

    if filtered_root.is_empty():
        return {}
    return {prefix + "world": filtered_root}


# --- Patch dictionary merge ---

# merge_patch_dictionary: pure form of `_merge_patch_dictionary`
# (coop_manager.gd L12867-12875).
#
# Returns a new Dictionary that contains every key from `target` and
# `source`, deep-copied. Merge rule:
#   - If both `target[k]` and `source[k]` are Dictionaries, recurse.
#   - Otherwise `source[k]` wins (latest write).
#
# `target` is NOT mutated (the function starts by deep-copying it via
# `target.duplicate(true)`). Array / Dictionary values from `source`
# are deep-copied on assignment so the merged dict is fully decoupled
# from both inputs.
#
# Recursion depth is bounded by the depth of the source patch
# structure (the live world patches go at most three levels deep:
# `world_data` -> `<prefix>world` -> `<suffix>` -> chunk dict).
static func merge_patch_dictionary(target: Dictionary, source: Dictionary) -> Dictionary:
    var merged: Dictionary = target.duplicate(true)
    for key in source.keys():
        var source_value: Variant = source[key]
        if source_value is Dictionary and merged.get(key, null) is Dictionary:
            merged[key] = merge_patch_dictionary(merged.get(key, {}), source_value)
        else:
            merged[key] = source_value.duplicate(true) if (source_value is Dictionary or source_value is Array) else source_value
    return merged


# --- Canonical guest patch predicate ---

# should_use_canonical_guest_block_patch: pure form of
# `_should_use_canonical_guest_block_patch` (coop_manager.gd L4728-4741).
#
# Decides whether a guest block action must capture a CANONICAL patch
# (whole-chunk re-snapshot, host can't see the block) vs. an
# INCREMENTAL patch (host can see it and will overwrite via its
# authoritative pass).
#
# Inputs (resolved at the forwarder boundary):
#   - `is_server`                  - `multiplayer.is_server()`.
#   - `has_live_peer`              - `_has_live_peer()`.
#   - `is_local_world_authority`   - `_is_local_world_authority()`.
#   - `host_in_same_instance`      - `_is_peer_state_same_instance(peer_states.get(1, {}), active_instance_key)`.
#   - `host_position`              - `peer_states.get(1, {}).get("position", Vector3.ZERO)`.
#   - `block_position`             - the block being placed/broken.
#   - `host_load_radius`           - `get_same_instance_base_load_radius(HOST_SESSION_MAX_LOAD_RADIUS)`.
#   - `min_safe_radius`            - floor on the safe-distance check; defaults to `MIN_SAFE_GUEST_PATCH_RADIUS = 16.0`.
#   - `block_center_offset`        - half-block centring; defaults to `BLOCK_CENTER_OFFSET = (0.5, 0.5, 0.5)`.
#
# Returns true ONLY when:
#   - the caller is a guest (`not is_server`),
#   - they have a live peer (`has_live_peer`),
#   - they are NOT the world authority (`not is_local_world_authority`),
#   - the host is in the same dimension instance (`host_in_same_instance`),
#   - AND the block position is OUTSIDE the host's safe radius
#     (`distance_squared_to(host_position) > safe_radius^2`).
#
# Strict `>` comparison matches the live code: a block exactly at the
# safe-radius boundary uses the incremental path.
static func should_use_canonical_guest_block_patch(
    is_server: bool,
    has_live_peer: bool,
    is_local_world_authority: bool,
    host_in_same_instance: bool,
    host_position: Vector3,
    block_position: Vector3i,
    host_load_radius: float,
    min_safe_radius: float = MIN_SAFE_GUEST_PATCH_RADIUS,
    block_center_offset: Vector3 = BLOCK_CENTER_OFFSET,
) -> bool:
    if is_server or not has_live_peer or is_local_world_authority:
        return false
    if not host_in_same_instance:
        return false
    var safe_radius: float = maxf(min_safe_radius, host_load_radius)
    var target_position: Vector3 = Vector3(block_position) + block_center_offset
    return host_position.distance_squared_to(target_position) > safe_radius * safe_radius
