class_name CoopWorldJournal
extends RefCounted

# CoopWorldJournal - phase 12a extraction from coop_manager.gd.
#
# Pure helpers for the dedicated-server chunk journal:
#
#   1. Chunk key formatters - `server_chunk_key` and
#      `server_chunk_ticket_key`. The wire-format strings are pinned
#      so any accidental rename to the `%s:%s:%s:%s` template surfaces
#      in CI before it ever touches disk.
#
#   2. Dirty-chunk bookkeeping - `remember_server_dirty_chunk` and
#      `mark_dirty_chunks` mutate the caller-supplied `dirty_keys`
#      dictionary in-place (GDScript dicts are reference-typed, so
#      callers see the writes). The forwarder threads the live
#      `server_dirty_chunk_keys` dict in.
#
#   3. Compaction watermark - `compute_compaction_watermark`
#      computes the `watermark` integer the live
#      `_compact_server_chunk_journal_after_save` passes to
#      `CoopJournal.compact_after_save(...)`. Encoding the "use
#      saved_seq_high_water if positive, else current_sequence" rule
#      as data lets tests pin every branch without touching the file
#      system.
#
# This module knows NOTHING about:
#   - `Ref.world.*` - the world snap-to-chunk math
#     (`Ref.world.snap_to_chunk(Vector3(world_position))`) stays on
#     coop_manager.gd; the forwarder pre-snaps world positions to chunk
#     positions before invoking `mark_dirty_chunks`.
#   - `Time.get_ticks_msec()` - the timestamp is plumbed in as a plain
#     int so tests are deterministic.
#   - `dedicated_server_enabled` / `multiplayer.is_server()` gates -
#     the live forwarders gate before calling the pure helpers.
#   - File I/O / `CoopJournal.compact_after_save` - the forwarder runs
#     the I/O step around the pure watermark calculation.
#   - `_server_journal_world_id` / journal path resolution - already
#     routed through `CoopJournal.journal_paths(...)` (Phase 2).


# --- Chunk key formatters ---

# server_chunk_key: pure form of `_server_chunk_key`
# (coop_manager.gd L10731-10732).
#
# Composes the canonical chunk-journal key
# `<dimension_instance_key>:<x>:<y>:<z>` used as the dictionary key in
# `server_dirty_chunk_keys` and inside `server_chunk_ticket_key`.
# This template is part of the on-disk journal format (used by
# `_remember_server_dirty_chunk` -> `compact_after_save`), so an
# accidental rename here would invalidate any existing journal files.
# Pinning the template in a test (`test_server_chunk_key.gd`) makes
# such a change land as a CI failure rather than a silent journal
# corruption.
static func server_chunk_key(dimension_instance_key: String, chunk_position: Vector3i) -> String:
    return "%s:%s:%s:%s" % [dimension_instance_key, chunk_position.x, chunk_position.y, chunk_position.z]


# server_chunk_ticket_key: pure form of `_server_chunk_ticket_key`
# (coop_manager.gd L10735-10736).
#
# Composes the per-ticket key used by `server_chunk_tickets` in
# `_remember_server_chunk_ticket`.
#
# IMPORTANT - latent live-code quirk preserved verbatim: the live
# template is `"%s:%s:%s:%s"` (FOUR `%s` markers) but the substitution
# array has only THREE entries. Godot's `String.%` returns the template
# UNCHANGED when the arity mismatches (verified against Godot 4.6 in
# CI: `"%s:%s:%s:%s" % ["a","b","c"]` -> `"%s:%s:%s:%s"`). The practical
# effect is that EVERY ticket key resolves to the same literal
# `"%s:%s:%s:%s"` string, so `server_chunk_tickets` only ever holds a
# single entry (the most recently written ticket overwrites the prior
# one). The dedicated-server ticket system has therefore been
# operating with a "single active ticket" restriction since this
# function was first added. Phase 12a preserves the behaviour to avoid
# any silent regression; Phase 25 (final sweep) is the appropriate
# place to repair the format string and reintroduce per-(kind, peer,
# instance, chunk) tickets after a behaviour review.
#
# `test_server_chunk_ticket_key.gd` pins the buggy output so any
# accidental "fix" surfaces as a CI failure rather than a silent
# behaviour change.
static func server_chunk_ticket_key(kind: String, owner_peer_id: int, dimension_instance_key: String, chunk_position: Vector3i) -> String:
    return "%s:%s:%s:%s" % [server_chunk_key(dimension_instance_key, chunk_position), kind, owner_peer_id]


# --- Dirty-chunk bookkeeping ---

# remember_server_dirty_chunk: pure form of
# `_remember_server_dirty_chunk` (coop_manager.gd L10758-10761).
#
# Writes `now_msec` into `dirty_keys[server_chunk_key(...)]`. Returns
# the key that was written so tests / forwarders can inspect.
#
# Empty `dimension_instance_key` is a no-op (matches the live L10759
# early-return). In that case the function returns "".
#
# `dirty_keys` is mutated in-place. GDScript dicts are reference-typed,
# so the live `server_dirty_chunk_keys` member sees the write through
# the forwarder's pass-by-reference.
static func remember_server_dirty_chunk(
    dirty_keys: Dictionary,
    dimension_instance_key: String,
    chunk_position: Vector3i,
    now_msec: int,
) -> String:
    if dimension_instance_key == "":
        return ""
    var key: String = server_chunk_key(dimension_instance_key, chunk_position)
    dirty_keys[key] = now_msec
    return key


# mark_dirty_chunks: pure form of the loop body inside
# `_mark_server_dirty_chunks_for_world_positions`
# (coop_manager.gd L10857-10865).
#
# Iterates `chunk_positions` (Array of `Vector3i` ALREADY snapped to
# chunk by the forwarder via `Ref.world.snap_to_chunk(world_vec)`) and
# marks each one dirty in `dirty_keys`. Non-Vector3i entries are
# skipped defensively (matches the live `is Vector3i or is Vector3`
# pre-snap filter at L10861).
#
# Empty `dimension_instance_key` is a no-op (matches L10858).
#
# Returns the number of NEW keys added to `dirty_keys` (existing keys
# get their timestamp refreshed but do not count toward the "new"
# total). Useful for diagnostic logging in the forwarder.
static func mark_dirty_chunks(
    dirty_keys: Dictionary,
    dimension_instance_key: String,
    chunk_positions: Array,
    now_msec: int,
) -> int:
    if dimension_instance_key == "":
        return 0
    var added: int = 0
    for chunk_position in chunk_positions:
        if not (chunk_position is Vector3i):
            continue
        var key: String = server_chunk_key(dimension_instance_key, chunk_position)
        if not dirty_keys.has(key):
            added += 1
        dirty_keys[key] = now_msec
    return added


# --- Compaction watermark ---

# compute_compaction_watermark: pure form of the watermark line inside
# `_compact_server_chunk_journal_after_save` (coop_manager.gd L11028).
#
# Returns the int passed to `CoopJournal.compact_after_save(..., watermark)`.
# Live rule:
#   - `saved_seq_high_water` > 0 -> use it (snapshot captured the
#     sequence right before save start, so we can safely discard up to
#     it).
#   - `saved_seq_high_water` <= 0 (caller passed -1 default or no
#     prior save) -> use `current_sequence` (the live
#     `server_chunk_journal_sequence`).
#
# Encoding this as a pure helper lets tests pin both branches without
# spinning up the dedicated server.
static func compute_compaction_watermark(saved_seq_high_water: int, current_sequence: int) -> int:
    return saved_seq_high_water if saved_seq_high_water > 0 else current_sequence
