class_name CoopTeleport
extends RefCounted

# CoopTeleport - phase 9 extraction from coop_manager.gd.
#
# Pure helpers for the `/tp` command surface and dimension-instance key
# serialisation. Three families:
#
#   1. Dimension-instance key format/parse - the canonical "pocket:..."
#      / "dimension:N[:owner]" strings carried around `peer_states` and
#      written into the save register.
#   2. `/tp` argument parsing + peer-alias matching + autocomplete
#      entry building - the pure decisions behind the `/tp` chat
#      command, F9 hotkey, and the autocomplete UI.
#   3. Safe-position iteration - the 13-offset search around an anchor
#      used by `_find_safe_respawn_position_near` and friends.
#
# This module knows NOTHING about:
#   - multiplayer.* / scene tree / @rpc - none of the teleport surface
#     uses RPCs (all `/tp` is local-only); the only network gate is the
#     `tp` entry in DEFAULT_SERVER_COMMAND_POLICY, already owned by
#     CoopCommandPolicyRPC (phase 8) + CoopAdmin (phase 5).
#   - Ref.player / Ref.world / Ref.main / Ref.save_file_manager - the
#     forwarders resolve any required values first (own peer id, active
#     instance key, etc.) and the engine teleport application
#     (`_teleport_local_player_*`) stays on coop_manager.gd entirely.
#   - SaveFile.DIMENSION_MAP / LucidBlocksWorld.Dimension.* - passed
#     in by the caller so the source-of-truth dictionaries stay in one
#     place. Same isolation pattern as Phase 5 (CoopAdmin takes
#     DEFAULT_SERVER_COMMAND_POLICY) and Phase 8 (CoopCommandPolicyRPC
#     takes default_policy).
#   - The autocomplete entry shape (`{insert, display, hint}` dict) -
#     the caller passes the per-entry constructor as a Callable so the
#     engine UI helper stays out of the pure module. Same pattern as
#     Phase 6's WorldOps Callable bag.
#
# Explicit NON-extractions (kept on coop_manager.gd, see plan):
#   - `_teleport_local_player_exact / _near / _to_coordinates` - the
#     engine teleport application (4-10 lines of Ref.player mutation
#     + broadcast). Nothing pure to extract.
#   - `_is_safe_respawn_position` - reads Ref.world; passed into
#     `find_safe_position_in_offsets` as a Callable.
#   - Dimension travel (`open_dimension_instance`, snapshots) - deferred
#     to a future CoopDimensionTravel phase.
#   - Revive / downed / respawn cluster - deferred to a future
#     CoopRevive phase.


# --- Constants ---

# USAGE_HINT: canonical "Usage: ..." line returned by `parse_tp_args`
# when the command has fewer than 2 parts. Pinned so a rename surfaces
# in CI immediately.
const USAGE_HINT: String = "Usage: /tp host, /tp <peer>, or /tp <x> <y> <z>"

# HINT_SAME_INSTANCE / HINT_CROSS_INSTANCE: per-entry hint strings the
# autocomplete builder attaches to each teleport target. "now" is shown
# for peers in the local dimension instance; "after resync" is shown
# for cross-instance teleport (which will trigger an
# `_open_dimension_instance_from_key` + stop on the engine side).
const HINT_SAME_INSTANCE: String = "Teleport now"
const HINT_CROSS_INSTANCE: String = "Teleport after resync"

# DEFAULT_NAMESPACE_FALLBACK: returned by `format_dimension_namespace`
# when `dimension_map` does not contain the requested dimension id.
# Matches the legacy default at coop_manager.gd line 10028.
const DEFAULT_NAMESPACE_FALLBACK: String = "unknown"

# LEGACY_POCKET_OWNER_LABEL: written into the "pocket:<owner>" key when
# the pocket has no explicit owner. Matches the legacy literal at
# coop_manager.gd line 10019 ("legacy" suffix for pocket:legacy).
const LEGACY_POCKET_OWNER_LABEL: String = "legacy"

# SAFE_OFFSET_CANDIDATES: the 13-offset search list from
# `_find_safe_respawn_position_near` (coop_manager.gd 12723-12737).
# Stored as an untyped `const Array` (not `Array[Vector3]`) so it can
# be a constant expression accessible via `CoopTeleport.SAFE_OFFSET_CANDIDATES`
# without instantiation - GDScript 4 does not allow typed packed/typed
# arrays as constants. Order is preserved exactly so the iteration is
# identical (first safe candidate wins).
const SAFE_OFFSET_CANDIDATES: Array = [
    Vector3(1.5, 0.0, 0.0),
    Vector3(-1.5, 0.0, 0.0),
    Vector3(0.0, 0.0, 1.5),
    Vector3(0.0, 0.0, -1.5),
    Vector3(1.5, 0.0, 1.5),
    Vector3(-1.5, 0.0, 1.5),
    Vector3(1.5, 0.0, -1.5),
    Vector3(-1.5, 0.0, -1.5),
    Vector3(0.0, 1.0, 0.0),
    Vector3(1.5, 1.0, 0.0),
    Vector3(-1.5, 1.0, 0.0),
    Vector3(0.0, 1.0, 1.5),
    Vector3(0.0, 1.0, -1.5),
]


# --- Dimension-instance key serialisation ---

# format_dimension_instance_key: pure form of get_dimension_instance_key
# (coop_manager.gd 10016-10024).
#
# Output shape:
#   - dimension == pocket_dimension_id  -> "pocket:<owner>"
#                                          (or "pocket:<LEGACY_POCKET_OWNER_LABEL>"
#                                           when `pocket_owner_key` is blank).
#   - dimension in private_dimension_ids AND owner non-blank
#                                       -> "dimension:<id>:<owner>"
#   - otherwise                         -> "dimension:<id>"
#
# `private_dimension_ids` is the caller-supplied source-of-truth list
# (LucidBlocksWorld.Dimension.POCKET + LucidBlocksWorld.Dimension.FIRMAMENT
# in the live code; tests pass arbitrary ids).
static func format_dimension_instance_key(dimension: int, pocket_owner_key: String, pocket_dimension_id: int, private_dimension_ids: Array) -> String:
    if dimension == pocket_dimension_id:
        var owner_key: String = pocket_owner_key.strip_edges()
        return "pocket:%s" % (owner_key if owner_key != "" else LEGACY_POCKET_OWNER_LABEL)
    if private_dimension_ids.has(dimension):
        var owner_key: String = pocket_owner_key.strip_edges()
        if owner_key != "":
            return "dimension:%s:%s" % [dimension, owner_key]
    return "dimension:%s" % dimension


# parse_dimension_instance_key: pure form of _parse_dimension_instance_key
# (coop_manager.gd 6476-6501).
#
# Accepts whitespace around the key (mirrors the original `.strip_edges()`).
# Returns:
#   - `{}` (empty Dictionary) on malformed input.
#   - `{dimension: int, owner_key: String}` on success.
#
# The empty-Dictionary contract matches the existing callsite at
# coop_manager.gd 6505-6507 (`if parsed_key.is_empty(): return false`).
#
# `pocket_dimension_id` is passed in so the pure module does not need
# to know the LucidBlocksWorld enum value. The forwarder threads
# `int(LucidBlocksWorld.Dimension.POCKET)` in.
static func parse_dimension_instance_key(target_key: String, pocket_dimension_id: int) -> Dictionary:
    var instance_key: String = target_key.strip_edges()
    if instance_key == "":
        return {}
    if instance_key.begins_with("pocket:"):
        return {
            "dimension": pocket_dimension_id,
            "owner_key": instance_key.substr(7),
        }
    if not instance_key.begins_with("dimension:"):
        return {}

    var payload: String = instance_key.substr(10)
    if payload == "":
        return {}
    var separator_index: int = payload.find(":")
    if separator_index == -1:
        return {
            "dimension": int(payload),
            "owner_key": "",
        }

    return {
        "dimension": int(payload.substr(0, separator_index)),
        "owner_key": payload.substr(separator_index + 1),
    }


# format_dimension_namespace: pure form of _resolve_dimension_namespace
# (coop_manager.gd 10027-10031).
#
# Returns `dimension_map[dimension]` for public dimensions, or
# `dimension_map[dimension] + "__" + pocket_owner_key` for private
# dimensions with a non-blank owner. Unknown dimensions fall back to
# `DEFAULT_NAMESPACE_FALLBACK` ("unknown").
static func format_dimension_namespace(dimension: int, pocket_owner_key: String, dimension_map: Dictionary, private_dimension_ids: Array) -> String:
    var dimension_namespace: String = dimension_map.get(dimension, DEFAULT_NAMESPACE_FALLBACK)
    if private_dimension_ids.has(dimension) and pocket_owner_key.strip_edges() != "":
        dimension_namespace = "%s__%s" % [dimension_namespace, pocket_owner_key.strip_edges()]
    return dimension_namespace


# --- /tp argument parsing ---

# parse_tp_args: pure form of the head of _execute_tp_command
# (coop_manager.gd 8418-8428).
#
# Output shapes (matches today's if/elif chain exactly):
#   `parts.size() < 2`               -> {kind: "usage", usage_message: USAGE_HINT}
#   3 valid floats at parts[1..3]    -> {kind: "coord", coord: Vector3(x, y, z)}
#   otherwise                        -> {kind: "peer", query: <joined-and-stripped>}
#
# The peer-form query joins `parts[1..]` with a single space and strips
# edges so multi-word names work (matches `" ".join(parts.slice(1)).strip_edges()`
# at coop_manager.gd 8428).
static func parse_tp_args(parts: PackedStringArray) -> Dictionary:
    if parts.size() < 2:
        return {"kind": "usage", "usage_message": USAGE_HINT}
    if parts.size() >= 4 and parts[1].is_valid_float() and parts[2].is_valid_float() and parts[3].is_valid_float():
        return {
            "kind": "coord",
            "coord": Vector3(float(parts[1]), float(parts[2]), float(parts[3])),
        }
    return {
        "kind": "peer",
        "query": " ".join(parts.slice(1)).strip_edges(),
    }


# match_peer_for_tp: pure form of the peer-lookup loop in
# _execute_tp_command (coop_manager.gd 8429-8451).
#
# Iterates `peer_states.keys()` in dict order (matches the existing
# for-loop semantics; no sort applied so the live behaviour is
# preserved). Excludes `own_peer_id`. First match wins per the
# precedence:
#
#   1. query == "host" AND peer_id == 1    -> match
#   2. query == "p<peer_id>" (case-insens) -> match
#   3. query == str(peer_id)               -> match
#   4. peer_name.to_lower() == query.to_lower() (exact name) -> match
#   5. peer_name.to_lower().contains(query.to_lower())       -> match
#
# Returns:
#   `{ok: true, peer_id: int, peer_state: Dictionary}` on hit.
#   `{ok: false, error_message: "Peer not found: %s" % query}` on miss
#   (matches the literal at coop_manager.gd 8449).
static func match_peer_for_tp(query: String, peer_states: Dictionary, own_peer_id: int) -> Dictionary:
    var lowered_query: String = query.to_lower()
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == own_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        var peer_name: String = str(state.get("name", "Peer %s" % int_peer_id))
        if lowered_query == "host" and int_peer_id == 1:
            return {"ok": true, "peer_id": int_peer_id, "peer_state": state}
        if lowered_query == ("p%s" % int_peer_id).to_lower() or query == str(int_peer_id) or peer_name.to_lower() == lowered_query or peer_name.to_lower().contains(lowered_query):
            return {"ok": true, "peer_id": int_peer_id, "peer_state": state}
    return {"ok": false, "error_message": "Peer not found: %s" % query}


# --- /tp autocomplete ---

# build_tp_autocomplete_entries: pure form of get_teleport_target_entries
# (coop_manager.gd 8177-8203).
#
# For every active non-self peer in `peer_states`, builds a Dictionary
# entry `{insert, label, hint, peer_id}`, filters by `query`, and sorts
# by peer_id ascending.
#
# Match rules (lowered query, OR-of):
#   - empty query
#   - alias.to_lower().contains(query)   ("host" / "pN")
#   - str(peer_id) == query              (numeric id)
#   - peer_name.to_lower().contains(query)
#
# Hint strings come from the module constants so a rename surfaces in
# the constants test.
#
# Returns an Array of Dictionaries. The caller (forwarder) maps these
# to the engine `{insert, display, hint}` autocomplete entries via
# `_make_command_autocomplete_entry`.
static func build_tp_autocomplete_entries(peer_states: Dictionary, own_peer_id: int, own_instance_key: String, query: String) -> Array:
    var lowered_query: String = query.strip_edges().to_lower()
    var entries: Array = []
    for peer_id in peer_states.keys():
        var int_peer_id: int = int(peer_id)
        if int_peer_id == own_peer_id:
            continue
        var state: Dictionary = peer_states[peer_id]
        if not bool(state.get("active", false)):
            continue
        var peer_name: String = str(state.get("name", "Peer %s" % int_peer_id))
        var alias: String = "host" if int_peer_id == 1 else "p%s" % int_peer_id
        var matches_query: bool = lowered_query == "" \
            or alias.to_lower().contains(lowered_query) \
            or str(int_peer_id) == lowered_query \
            or peer_name.to_lower().contains(lowered_query)
        if not matches_query:
            continue
        var same_instance: bool = str(state.get("dimension_instance_key", "")) == own_instance_key
        entries.append({
            "insert": alias,
            "label": "%s (%s)" % [peer_name, alias],
            "hint": HINT_SAME_INSTANCE if same_instance else HINT_CROSS_INSTANCE,
            "peer_id": int_peer_id,
        })
    entries.sort_custom(Callable(CoopTeleport, "sort_peer_entries"))
    return entries


# sort_peer_entries: pure form of _sort_peer_autocomplete_entries
# (coop_manager.gd 8206-8207). Ascending peer_id; entries without a
# peer_id key fall back to 0 (matches the original `.get("peer_id", 0)`).
static func sort_peer_entries(a: Dictionary, b: Dictionary) -> bool:
    return int(a.get("peer_id", 0)) < int(b.get("peer_id", 0))


# --- Safe-position iteration ---

# find_safe_position_in_offsets: pure form of _find_safe_respawn_position_near
# (coop_manager.gd 12721-12747).
#
# Iterates `offsets`; for each candidate `anchor + offset` checks
# `is_position_safe.call(candidate)`. Returns the first safe candidate.
# If no offset yields a safe candidate, retries `anchor + offsets[0]`
# once more (preserves the redundant-looking retry at coop_manager.gd
# 12744-12746 - kept for behavioural parity in case the safety predicate
# is non-deterministic for some upstream reason). Falls back to
# `fallback` if both passes fail.
#
# `anchor` is expected to be already-centered by the caller (the live
# forwarder applies `anchor.floor() + Vector3(0.5, 0.0, 0.5)` before
# calling, which keeps Ref.world / coordinate-system concerns out of
# this module).
#
# Defensive guards:
#   - invalid `is_position_safe` Callable -> returns `fallback`
#     immediately (matches the `select_entities_to_despawn` pattern
#     in Phase 7's CoopBuilderRuntime).
#   - empty `offsets` -> returns `fallback` (no candidates to try).
static func find_safe_position_in_offsets(anchor: Vector3, offsets: Array, is_position_safe: Callable, fallback: Vector3) -> Vector3:
    if not is_position_safe.is_valid():
        return fallback
    if offsets.is_empty():
        return fallback
    for offset in offsets:
        var candidate: Vector3 = anchor + offset
        if bool(is_position_safe.call(candidate)):
            return candidate
    var default_candidate: Vector3 = anchor + offsets[0]
    if bool(is_position_safe.call(default_candidate)):
        return default_candidate
    return fallback
