class_name CoopBuilder
extends RefCounted

# CoopBuilder — phase 6 extraction from coop_manager.gd.
#
# Pure, static helpers for the builder world-edit engine: per-block
# dispatch, AABB / border iteration, and dirty-chunk collapse.
#
# This module knows NOTHING about:
#   - Ref.world / Ref.player / Ref.entity_spawner — every engine call
#     goes through a `world_ops` Dictionary of Callables built by
#     coop_manager.gd's `_make_world_ops()` forwarder.
#   - The Block class — even the `is Block` guard is delegated to an
#     injected Callable so the module loads without the base game's
#     class_names being registered (the in-headless test runner needs
#     to instantiate CoopBuilder in isolation).
#   - WORLD_EDIT_MAX_BLOCK_OPS — passed in by the caller so the cap
#     stays in one place.
#
# WorldOps contract (Dictionary of Callables):
#   Required:
#     is_position_loaded: Callable(Vector3i) -> bool
#     get_block_id_at:    Callable(Vector3i) -> int       (0 for air / unloaded)
#     place_block:        Callable(Vector3i, Variant) -> void
#     break_block:        Callable(Vector3i) -> void
#   Optional (gated via .is_valid()):
#     place_water:        Callable(Vector3i, int) -> void
#     place_fire:         Callable(Vector3i, int) -> void
#     snap_to_chunk:      Callable(Vector3) -> Vector3i
#     is_block_value:     Callable(Variant) -> bool       (defaults to
#                                                          "any non-null is valid")


# --- Single-block dispatch ---

# set_world_block: pure form of _builder_set_world_block. Mirrors the
# original semantics exactly:
#   - skip when the cell is not loaded (or is_position_loaded callable
#     is missing)
#   - when clear_liquids is true, fire both optional liquid callables
#   - block == null -> break (or no-op when get_block_id_at returns 0)
#   - non-null block validated via is_block_value (or accepted as-is
#     when the validator callable is invalid)
static func set_world_block(world_ops: Dictionary, position: Vector3i, block, clear_liquids: bool) -> bool:
    var is_loaded: Callable = world_ops.get("is_position_loaded", Callable())
    if not is_loaded.is_valid() or not bool(is_loaded.call(position)):
        return false
    if clear_liquids:
        var place_water: Callable = world_ops.get("place_water", Callable())
        if place_water.is_valid():
            place_water.call(position, 0)
        var place_fire: Callable = world_ops.get("place_fire", Callable())
        if place_fire.is_valid():
            place_fire.call(position, 0)
    if block == null:
        var get_block_id: Callable = world_ops.get("get_block_id_at", Callable())
        if get_block_id.is_valid() and int(get_block_id.call(position)) == 0:
            return true
        var break_block: Callable = world_ops.get("break_block", Callable())
        if break_block.is_valid():
            break_block.call(position)
        return true
    var is_block_value: Callable = world_ops.get("is_block_value", Callable())
    if is_block_value.is_valid() and not bool(is_block_value.call(block)):
        return false
    var place_block: Callable = world_ops.get("place_block", Callable())
    if not place_block.is_valid():
        return false
    place_block.call(position, block)
    return true


# --- AABB / border iteration ---

# fill_box: pure form of _builder_fill_box. Returns
#   { changed, skipped, changed_positions, error? }
# `error` is only present when the planned count exceeds max_block_ops.
# Iteration order y -> z -> x matches the original so any in-engine
# observer (entity spawner, chunk dirty hooks) sees identical event
# sequencing after the refactor.
static func fill_box(world_ops: Dictionary, min_pos: Vector3i, max_pos: Vector3i, block, clear_liquids: bool, max_block_ops: int) -> Dictionary:
    var planned: int = CoopAdmin.count_box_blocks(min_pos, max_pos)
    if planned > max_block_ops:
        return {
            "changed": 0,
            "skipped": planned,
            "error": "selection_too_large",
            "changed_positions": [],
        }
    var changed: int = 0
    var skipped: int = 0
    var changed_positions: Array = []
    for y in range(min_pos.y, max_pos.y + 1):
        for z in range(min_pos.z, max_pos.z + 1):
            for x in range(min_pos.x, max_pos.x + 1):
                var position: Vector3i = Vector3i(x, y, z)
                if set_world_block(world_ops, position, block, clear_liquids):
                    changed += 1
                    changed_positions.append(position)
                else:
                    skipped += 1
    return {
        "changed": changed,
        "skipped": skipped,
        "changed_positions": changed_positions,
    }


# count_border_positions: how many cells a perimeter wall of the given
# AABB + height would touch. Mirrors the existing budget calculation
# (top + bottom edges full, left + right edges minus corners), clamped
# at 0 for inverted / single-cell spans.
static func count_border_positions(min_area: Vector3i, max_area: Vector3i, height: int) -> int:
    return maxi(0, (max_area.x - min_area.x + 1) * 2 + (max_area.z - min_area.z - 1) * 2) * maxi(0, height)


# compute_border_positions: ordered list of perimeter cells in the
# same order as the existing nested loops (z-edges first per row, then
# x-edges skipping corners). Used both by build_border and by tests
# that want to pin the call sequence.
static func compute_border_positions(min_area: Vector3i, max_area: Vector3i, base_y: int, height: int) -> Array:
    var positions: Array = []
    for y in range(base_y, base_y + height):
        for x in range(min_area.x, max_area.x + 1):
            for z in [min_area.z, max_area.z]:
                positions.append(Vector3i(x, y, z))
        for z in range(min_area.z + 1, max_area.z):
            for x in [min_area.x, max_area.x]:
                positions.append(Vector3i(x, y, z))
    return positions


# build_border: pure form of _builder_build_border. Returns the same
# shape as fill_box. The "border_too_large" error uses the existing
# string verbatim so log scraping stays stable.
static func build_border(world_ops: Dictionary, min_area: Vector3i, max_area: Vector3i, base_y: int, height: int, block, max_block_ops: int) -> Dictionary:
    var perimeter_count: int = count_border_positions(min_area, max_area, height)
    if perimeter_count > max_block_ops:
        return {
            "changed": 0,
            "skipped": perimeter_count,
            "error": "border_too_large",
            "changed_positions": [],
        }
    var changed: int = 0
    var skipped: int = 0
    var changed_positions: Array = []
    for position in compute_border_positions(min_area, max_area, base_y, height):
        if set_world_block(world_ops, position, block, false):
            changed += 1
            changed_positions.append(position)
        else:
            skipped += 1
    return {
        "changed": changed,
        "skipped": skipped,
        "changed_positions": changed_positions,
    }


# make_flat_area: pure form of _builder_make_flat_area. Decomposes
# into a clear-column fill (floor_y + 1 .. floor_y + clear_height) and
# a floor-row fill (floor_y). Sums changed / skipped, merges
# changed_positions. `error` from either sub-call propagates as a
# joined string when both fire, matching the existing best-effort
# behavior of running both fills regardless of the first's result.
static func make_flat_area(world_ops: Dictionary, min_area: Vector3i, max_area: Vector3i, floor_y: int, block, clear_height: int, max_block_ops: int) -> Dictionary:
    var floor_min: Vector3i = Vector3i(min_area.x, floor_y, min_area.z)
    var floor_max: Vector3i = Vector3i(max_area.x, floor_y, max_area.z)
    var clear_min: Vector3i = Vector3i(min_area.x, floor_y + 1, min_area.z)
    var clear_max: Vector3i = Vector3i(max_area.x, floor_y + clear_height, max_area.z)
    var clear_result: Dictionary = fill_box(world_ops, clear_min, clear_max, null, true, max_block_ops)
    var floor_result: Dictionary = fill_box(world_ops, floor_min, floor_max, block, true, max_block_ops)
    var merged_positions: Array = []
    for position in clear_result.get("changed_positions", []):
        merged_positions.append(position)
    for position in floor_result.get("changed_positions", []):
        merged_positions.append(position)
    var result: Dictionary = {
        "changed": int(clear_result.get("changed", 0)) + int(floor_result.get("changed", 0)),
        "skipped": int(clear_result.get("skipped", 0)) + int(floor_result.get("skipped", 0)),
        "changed_positions": merged_positions,
    }
    if clear_result.has("error") and floor_result.has("error"):
        result["error"] = "%s,%s" % [str(clear_result["error"]), str(floor_result["error"])]
    elif clear_result.has("error"):
        result["error"] = clear_result["error"]
    elif floor_result.has("error"):
        result["error"] = floor_result["error"]
    return result


# --- Dirty-chunk collapse ---

# collapse_changed_chunks: dedupe an Array of cell positions into the
# set of chunk keys they touch. When the snap_to_chunk callable is
# invalid (engine method missing, test fixture omits it), each position
# becomes its own "chunk" key — matches the existing fallback in
# _remember_builder_changed_chunk.
static func collapse_changed_chunks(changed_positions: Array, snap_to_chunk: Callable) -> Array:
    var chunks: Dictionary = {}
    for position in changed_positions:
        if snap_to_chunk.is_valid():
            chunks[snap_to_chunk.call(Vector3(position))] = true
        else:
            chunks[position] = true
    return chunks.keys()
