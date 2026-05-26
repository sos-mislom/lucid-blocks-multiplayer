class_name CoopWorldSnapshot
extends RefCounted

# CoopWorldSnapshot - phase 12e extraction from coop_manager.gd.
#
# Pure helpers for the host-world-snapshot pipeline (send-side
# `_send_world_snapshot_to_peer` + `_should_force_dedicated_snapshot_spawn`
# + `_apply_peer_persistent_player_to_snapshot`; receive-side
# `host_world_snapshot_chunk` + `_apply_received_host_world` /
# `_load_host_world_snapshot`). The engine-bound orchestration
# (`@rpc` handlers `begin_host_world_snapshot` /
# `host_world_snapshot_chunk` / `finish_host_world_snapshot`,
# `Ref.save_file_manager.loaded_file*` mutations, `Ref.world.spawn_tester`
# async, `Ref.main.enter_game` / `Ref.trans.open` / `Ref.audio_manager.*`,
# JSON.parse / .to_native / `_sanitize_network_save_data`, the
# decompress_dynamic call, `SaveFile.*` static accessors, the
# `_get_guest_persistent_state` / `_get_guest_persistent_position_for_dimension`
# guest-state lookups, and the `_is_safe_respawn_position` predicate)
# stays on coop_manager.gd; the pure module owns the predicates,
# validators, indexers, and chunk-math that bracket those calls.
#
# Six families:
#
#   1. `resolve_peer_player_key` - the `str(peer_state.get("player_key",
#     "")).strip_edges()` pattern shared by both the snapshot-spawn
#     gate (`_should_force_dedicated_snapshot_spawn` L15689) and the
#     guest-persistent override application
#     (`_apply_peer_persistent_player_to_snapshot` L15620).
#
#   2. `should_force_dedicated_snapshot_spawn` - the pure tail of
#     `_should_force_dedicated_snapshot_spawn` (coop_manager.gd
#     L15685-15695). Decides whether the dedicated host should reroute
#     a guest spawn to `_resolve_dedicated_snapshot_spawn_position`
#     instead of letting them land on `Ref.player.global_position`.
#
#   3. `build_peer_persistent_snapshot_overrides` - the pure
#     dimension-namespace + persistent-player-data merge from
#     `_apply_peer_persistent_player_to_snapshot` (L15615-15639).
#     Returns a `Dictionary` of `<path> -> Dictionary` that the
#     forwarder applies to `snapshot_save_data` via `SaveFile._set_data`.
#     Decoupling the path / value computation from the SaveFile
#     accessor keeps the merge testable without the base-game class.
#
#   4. `validate_snapshot_chunks_complete` - the pure form of the
#     `for chunk_index in range(incoming_snapshot_chunk_count): if
#     not incoming_snapshot_chunks.has(chunk_index): ...` loop in
#     `_apply_received_host_world` (L15723-15726). Returns
#     `{complete, missing_index}` so the forwarder can surface the
#     missing index in the failure message.
#
#   5. `concat_snapshot_chunks` - the pure form of the
#     `compressed_buffer.append_array(incoming_snapshot_chunks[i])`
#     loop in `_apply_received_host_world` (L15728-15730). Skips
#     missing / non-PackedByteArray entries defensively (matches the
#     guards used elsewhere in the snapshot pipeline).
#
#   6. `is_snapshot_compressed_size_within_limit` - the pure cap check
#     `compressed_buffer.size() > CLIENT_SAFE_MAX_SNAPSHOT_COMPRESSED_BYTES`
#     (L15732) and the running-total variant from
#     `host_world_snapshot_chunk` (L19366-19374). Combined so both
#     call sites share one rule.
#
# Three small chunk-math helpers (`compute_snapshot_chunk_count`,
# `slice_snapshot_chunk`, `is_snapshot_chunk_index_valid`) round out
# the send-side / per-chunk validation surface so coop_manager.gd
# can keep `begin_host_world_snapshot` / `host_world_snapshot_chunk`
# as thin RPC handlers.
#
# This module knows NOTHING about:
#   - `Ref.world.spawn_tester` / `Ref.player.global_position` -
#     the dedicated spawn resolver stays on coop_manager.gd; the pure
#     gate only decides whether to call it.
#   - `Ref.save_file_manager.loaded_file*` - applied by the forwarder.
#   - `_is_safe_respawn_position` / `_get_guest_persistent_state` /
#     `_get_guest_persistent_position_for_dimension` - the forwarder
#     resolves the saved-position Variant + safety predicate Callable
#     and threads them in.
#   - `SaveFile._get_data` / `_set_data` / `DIMENSION_MAP` - the
#     forwarder accesses SaveFile so the test harness does not need
#     the base-game class registered.
#   - `multiplayer.is_server()` / `dedicated_server_enabled` -
#     resolved at the forwarder boundary.
#   - `@rpc` handlers (`begin_host_world_snapshot`,
#     `host_world_snapshot_chunk`, `finish_host_world_snapshot`) -
#     NodePath-bound, stay on coop_manager.gd.


# --- Peer player key ---

# resolve_peer_player_key: pure form of the `str(peer_state.get(
# "player_key", "")).strip_edges()` lookup used by both
# `_should_force_dedicated_snapshot_spawn` (coop_manager.gd L15689) and
# `_apply_peer_persistent_player_to_snapshot` (L15620). Defensive
# against a `peer_states.get(peer_id, {})` miss (`{}.get(...) == null`
# -> `str(null) == "<null>"`, so we explicitly default to ""), and
# strip whitespace so any leading/trailing space in a hand-edited
# guest key does not break the equality check downstream.
static func resolve_peer_player_key(peer_state: Dictionary) -> String:
    var raw_key: Variant = peer_state.get("player_key", "")
    if raw_key == null:
        return ""
    return str(raw_key).strip_edges()


# --- Dedicated snapshot spawn gate ---

# should_force_dedicated_snapshot_spawn: pure form of
# `_should_force_dedicated_snapshot_spawn` (coop_manager.gd L15685-15695).
#
# Inputs (resolved at the forwarder boundary):
#   - `dedicated_server_enabled` - the module-level flag.
#   - `is_server`                - `multiplayer.is_server()`.
#   - `player_key`               - already-resolved via
#                                  `resolve_peer_player_key(peer_state)`.
#   - `saved_position_variant`   - the result of
#                                  `_get_guest_persistent_position_for_dimension(
#                                      player_key, dimension)`. May be
#                                  `Vector3`, `null`, or any other
#                                  variant; the predicate handles
#                                  every case.
#   - `is_safe_position`         - `Callable` that wraps
#                                  `_is_safe_respawn_position(Vector3)`.
#                                  Invoked only when the saved
#                                  position is a `Vector3`; if the
#                                  callable is invalid we fall back
#                                  to "safe" (do not force a spawn
#                                  reroute) so a missing predicate
#                                  cannot trigger spurious teleports
#                                  during cache-cold first runs.
#
# Returns true ONLY when:
#   - the caller is a dedicated server with multiplayer authority,
#   - AND the resolved player key is empty
#     (no guest persistent state yet → force the spawn reroute), or
#   - AND the saved position is not a Vector3
#     (guest never visited this dimension), or
#   - AND the saved position is a Vector3 but `is_safe_position`
#     reports it is no longer safe (chunk overwritten, block placed
#     on top, etc.).
static func should_force_dedicated_snapshot_spawn(
    dedicated_server_enabled: bool,
    is_server: bool,
    player_key: String,
    saved_position_variant: Variant,
    is_safe_position: Callable,
) -> bool:
    if not dedicated_server_enabled or not is_server:
        return false
    if player_key == "":
        return true
    if not (saved_position_variant is Vector3):
        return true
    if not is_safe_position.is_valid():
        return false
    return not bool(is_safe_position.call(saved_position_variant))


# --- Peer persistent override builder ---

# build_peer_persistent_snapshot_overrides: pure form of the
# global + dimensional persistent-player override application from
# `_apply_peer_persistent_player_to_snapshot` (coop_manager.gd
# L15628-15639).
#
# Inputs (resolved at the forwarder boundary):
#   - `guest_global_player_data`      - the result of
#                                       `SaveFile._get_data(guest_data,
#                                       "node/player", null)`. May be
#                                       `Dictionary` or any other
#                                       variant (typically `null`).
#   - `guest_dimensional_player_data` - the result of
#                                       `SaveFile._get_data(guest_data,
#                                       "<namespace>/node/player",
#                                       null)`. May be `Dictionary`
#                                       or any other variant.
#   - `dimension_namespace`           - `str(SaveFile.DIMENSION_MAP.get(
#                                       target_dimension, ""))`. The
#                                       dimensional override is
#                                       omitted when the namespace is
#                                       empty (unknown dimension).
#
# Returns a `Dictionary` of `path -> override_dict` that the
# forwarder applies to `snapshot_save_data` via
# `SaveFile._set_data(snapshot_save_data, path, override_dict)`.
#
# Path conventions match the live SaveFile schema:
#   - `node/player`                       - the global slot.
#   - `<namespace>/node/player`           - the dimensional slot.
#
# Each override value is deep-copied so a downstream mutation of
# `snapshot_save_data` cannot poison the guest persistent cache.
static func build_peer_persistent_snapshot_overrides(
    guest_global_player_data: Variant,
    guest_dimensional_player_data: Variant,
    dimension_namespace: String,
) -> Dictionary:
    var overrides: Dictionary = {}
    if guest_global_player_data is Dictionary:
        overrides["node/player"] = (guest_global_player_data as Dictionary).duplicate(true)
    if dimension_namespace != "" and (guest_dimensional_player_data is Dictionary):
        var path: String = "%s/node/player" % dimension_namespace
        overrides[path] = (guest_dimensional_player_data as Dictionary).duplicate(true)
    return overrides


# --- Receive-side validation ---

# validate_snapshot_chunks_complete: pure form of the missing-chunk
# loop in `_apply_received_host_world` (coop_manager.gd L15723-15726).
#
# Walks `range(expected_count)` and returns the first missing index
# (so the forwarder can surface a precise failure message). Returns
# `{"complete": true, "missing_index": -1}` when every index is
# present.
#
# `expected_count <= 0` is treated as a "trivially complete" result
# (no chunks expected, no chunks missing) so the forwarder treats it
# as a clean snapshot.
static func validate_snapshot_chunks_complete(
    chunks: Dictionary,
    expected_count: int,
) -> Dictionary:
    if expected_count <= 0:
        return {"complete": true, "missing_index": -1}
    for chunk_index in range(expected_count):
        if not chunks.has(chunk_index):
            return {"complete": false, "missing_index": chunk_index}
    return {"complete": true, "missing_index": -1}


# concat_snapshot_chunks: pure form of the compressed-buffer
# assembly loop in `_apply_received_host_world` (coop_manager.gd
# L15728-15730). Iterates `range(chunk_count)` in order and
# `append_array`s every PackedByteArray entry. Missing or
# non-PackedByteArray entries are skipped defensively (the forwarder
# is expected to call `validate_snapshot_chunks_complete` first, but
# in practice both call sites benefit from the defensive skip when
# the dict was partially populated by a buggy host).
static func concat_snapshot_chunks(
    chunks: Dictionary,
    chunk_count: int,
) -> PackedByteArray:
    var buffer: PackedByteArray = PackedByteArray()
    for chunk_index in range(chunk_count):
        if not chunks.has(chunk_index):
            continue
        var entry: Variant = chunks[chunk_index]
        if not (entry is PackedByteArray):
            continue
        buffer.append_array(entry)
    return buffer


# is_snapshot_compressed_size_within_limit: pure cap check shared by
# `_apply_received_host_world` (L15732, post-concat total) and
# `host_world_snapshot_chunk` (L19366-19374, running total as each
# chunk arrives).
#
# Returns true when `size <= max_size`; the live code uses `>` for
# the rejection path, so the inversion is centralised here.
# `max_size <= 0` is treated as "no limit" so call sites with the
# limit disabled (test harness) still pass.
static func is_snapshot_compressed_size_within_limit(
    size: int,
    max_size: int,
) -> bool:
    if max_size <= 0:
        return true
    return size <= max_size


# --- Chunk math (send-side + receive-side per-chunk validation) ---

# compute_snapshot_chunk_count: pure form of
# `maxi(1, int(ceil(float(save_buffer.size()) / float(SNAPSHOT_CHUNK_SIZE))))`
# (coop_manager.gd L15665).
#
# Returns the number of chunks needed to ship a `buffer_size`-byte
# payload at `chunk_size` bytes per chunk. Floor of 1 so an empty
# save still ships a single empty chunk (matches the live behaviour).
#
# `chunk_size <= 0` returns 1 (degenerate config; ship the whole
# buffer in one chunk; the receiver's per-chunk cap will reject).
static func compute_snapshot_chunk_count(
    buffer_size: int,
    chunk_size: int,
) -> int:
    if chunk_size <= 0:
        return 1
    var chunk_count: int = int(ceil(float(buffer_size) / float(chunk_size)))
    return maxi(1, chunk_count)


# slice_snapshot_chunk: pure form of the
# `save_buffer.slice(start, end)` send-side per-chunk slice
# (coop_manager.gd L15675-15677).
#
# Returns the bytes `[chunk_index * chunk_size,
# min((chunk_index+1) * chunk_size, buffer.size()))`. Returns an
# empty `PackedByteArray` for out-of-range / negative indices so the
# caller can rely on a non-null result.
static func slice_snapshot_chunk(
    buffer: PackedByteArray,
    chunk_index: int,
    chunk_size: int,
) -> PackedByteArray:
    if chunk_size <= 0 or chunk_index < 0:
        return PackedByteArray()
    var start: int = chunk_index * chunk_size
    if start >= buffer.size():
        return PackedByteArray()
    var end: int = mini(start + chunk_size, buffer.size())
    return buffer.slice(start, end)


# is_snapshot_chunk_index_valid: pure form of the per-chunk index +
# size guard from `host_world_snapshot_chunk` (coop_manager.gd
# L19366).
#
# Returns true ONLY when `0 <= chunk_index < expected_count` AND
# `data_size <= max_chunk_size`. The forwarder calls
# `_handle_host_world_snapshot_failure` when this returns false.
#
# `max_chunk_size <= 0` is treated as "no size cap" so a relaxed
# config (test harness) still accepts the chunk; the index range
# check is always applied.
static func is_snapshot_chunk_index_valid(
    chunk_index: int,
    expected_count: int,
    data_size: int,
    max_chunk_size: int,
) -> bool:
    if chunk_index < 0 or chunk_index >= expected_count:
        return false
    if max_chunk_size > 0 and data_size > max_chunk_size:
        return false
    return true
