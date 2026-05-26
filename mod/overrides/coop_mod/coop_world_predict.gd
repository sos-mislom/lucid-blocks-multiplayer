class_name CoopWorldPredict
extends RefCounted

# CoopWorldPredict - phase 12c extraction from coop_manager.gd.
#
# Pure helpers for the two write-prediction caches that bracket the
# server world-edit pipeline:
#
#   - CLIENT side: pending block actions keyed by per-client
#     request_id, used to roll the local optimistic block placement
#     back when the host rejects a request (or when the inventory
#     snapshot is restored on rollback).
#
#   - SERVER side: recent block-action results keyed by
#     `<sender_id>:<request_id>:<action>`, used to ACK duplicate
#     requests (`_ack_duplicate_block_action_if_seen`) and to roll an
#     in-flight client back to a known state when peers disconnect.
#
# Six families:
#
#   1. `next_action_id` - the per-client sequence counter with
#     wrap-at-MAX semantics. Used by both `_next_client_block_action_id`
#     and `_next_client_item_action_id` (they share the same int32
#     wrap rule).
#
#   2. `make_pending_action_record` - builds the Dictionary cached in
#     `client_pending_block_actions[request_id]`. Encoding the schema
#     as data makes additions / renames immediately visible in CI.
#
#   3. `count_pending_place_reservations` - counts how many "place"
#     actions are outstanding against a given inventory slot. Lets
#     the forwarder gate further placements until the host ACKs the
#     in-flight ones (`_can_reserve_client_block_place`).
#
#   4. `is_inventory_item_placing_block_id` - the pure tail of
#     `_does_inventory_item_place_block_id`. The engine-bound part
#     (`ItemMap.map(...)` and `item is Block`) stays on coop_manager.gd
#     because the test harness does not register `class_name Block` in
#     base game (see Phase 1 notes in docs/ARCHITECTURE.md). The pure
#     helper accepts the *resolved* `directional` flag plus the
#     item/block IDs and decides whether `block_id` is one of the
#     allowed rotation variants.
#
#   5. `server_block_action_key` - the wire-stable key used by the
#     server's recent-result cache. Returns "" for invalid inputs
#     (sender_id <= 0 / request_id <= 0 / empty action) so the
#     forwarder's "key == ''" guard stays in one place.
#
#   6. Action-result lifecycle:
#     - `make_server_block_action_entry`     - builds the per-result
#       Dictionary stored in `server_recent_block_action_results[key]`.
#     - `is_action_result_expired`           - one-line TTL predicate
#       used by `_cleanup_server_block_action_results`.
#     - `prune_expired_action_results`       - bulk TTL cleanup.
#     - `purge_action_results_for_peer`      - remove every key that
#       starts with `<peer_id>:` from the supplied dict. The forwarder
#       calls it twice (once for block, once for item) to clear a
#       disconnected peer's cache fingerprint.
#
# This module knows NOTHING about:
#   - `client_pending_block_actions` / `server_recent_block_action_results`
#     allocation / clearing - the forwarders own the dict members and
#     thread them through these helpers by reference (GDScript dicts
#     are pass-by-reference).
#   - `ItemMap.map(...)` / `class_name Block` - the engine-side
#     lookup stays on coop_manager.gd; the pure helper just decides
#     based on the resolved `directional` flag.
#   - `Ref.world.is_position_loaded` / `_apply_network_*` mutations -
#     `_rollback_client_block_action` / `_commit_client_block_action`
#     stay on coop_manager.gd because they call engine helpers.
#   - `@rpc` handlers (`request_place_block`, `request_break_block`,
#     `confirm_block_action`, `receive_block_action_result`,
#     `request_block_resync`) - NodePath-bound, stay on coop_manager.gd.


# --- Constants ---

# CLIENT_ACTION_SEQUENCE_MAX: pinned to 2_147_480_000. The live
# `_next_client_block_action_id` and `_next_client_item_action_id`
# both use the same int32-safe wrap point - the value is slightly
# below INT32_MAX (2_147_483_647) so any rollover stays inside the
# bit-width all wire protocols assume. Pinning the constant here lets
# tests guard the wrap behaviour without touching coop_manager.gd.
const CLIENT_ACTION_SEQUENCE_MAX: int = 2147480000


# --- Action-id sequencing ---

# next_action_id: pure form of `_next_client_block_action_id`
# (coop_manager.gd L8420-8424) and `_next_client_item_action_id`
# (L8533-8537).
#
# Increments `current_sequence` by 1, wrapping back to 1 when the
# next value would meet or exceed `max_sequence`. Returns the new
# value.
#
# Wrap semantics: matches the live `if ... >= MAX: ... = 1`. The wrap
# is to 1 (NOT 0) so that 0 stays reserved as "no action" / "unused".
static func next_action_id(current_sequence: int, max_sequence: int = CLIENT_ACTION_SEQUENCE_MAX) -> int:
    var next: int = current_sequence + 1
    if next >= max_sequence:
        next = 1
    return next


# --- Client-side pending action record ---

# make_pending_action_record: pure form of the dictionary built inside
# `_remember_client_block_action` (coop_manager.gd L8430-8437).
#
# Schema:
#   - `action: String`              - "place" / "break" / "foliage" / ...
#   - `position: Vector3i`          - the block coordinate touched
#   - `block_id: int`               - target block id (place) / 0 (break)
#   - `inventory: Variant`          - opaque ref to the live inventory
#     (used for equality checks; never dereferenced here).
#   - `inventory_index: int`        - the slot index inside `inventory`.
#   - `inventory_snapshot: Dictionary` - the deep-copied slot state for
#     rollback (`_restore_inventory_snapshot`); `{}` when the caller
#     does not need rollback.
#   - `created_ms: int`             - `Time.get_ticks_msec()` snapshot,
#     plumbed in as an int so tests stay deterministic.
static func make_pending_action_record(
    action: String,
    block_position: Vector3i,
    block_id: int,
    inventory: Variant,
    inventory_index: int,
    inventory_snapshot: Dictionary,
    created_ms: int,
) -> Dictionary:
    return {
        "action": action,
        "position": block_position,
        "block_id": block_id,
        "inventory": inventory,
        "inventory_index": inventory_index,
        "inventory_snapshot": inventory_snapshot,
        "created_ms": created_ms,
    }


# count_pending_place_reservations: pure form of
# `_get_pending_block_place_reservations` (coop_manager.gd L8492-8506).
#
# Iterates `pending_actions.values()` (the live `client_pending_block_actions`
# dict) and counts how many entries are:
#   - action == "place"
#   - inventory == `inventory_ref` (identity compare via `!=`)
#   - inventory_index == `inventory_index`
#
# Defensive: `null` inventory or negative index returns 0 immediately
# (matches L8493-8494). Non-Dictionary entries skipped (matches L8497).
static func count_pending_place_reservations(
    pending_actions: Dictionary,
    inventory_ref: Variant,
    inventory_index: int,
) -> int:
    if inventory_ref == null or inventory_index < 0:
        return 0
    var count: int = 0
    for pending_action in pending_actions.values():
        if not (pending_action is Dictionary):
            continue
        if str(pending_action.get("action", "")) != "place":
            continue
        if pending_action.get("inventory", null) != inventory_ref:
            continue
        if int(pending_action.get("inventory_index", -1)) != inventory_index:
            continue
        count += 1
    return count


# is_inventory_item_placing_block_id: pure form of the decision tree
# inside `_does_inventory_item_place_block_id` (coop_manager.gd L8509-8518)
# AFTER the engine-side `ItemMap.map(item_id)` lookup is done.
#
# Inputs:
#   - `item_id`             - the held item's id.
#   - `block_id`            - the block id the client wants to place.
#   - `item_resolves_to_block` - true when `ItemMap.map(item_id) is Block`
#     (the forwarder runs the lookup; tests can flip the flag freely).
#   - `item_is_directional` - true when the resolved Block has
#     `directional = true`. Ignored if `item_resolves_to_block` is false.
#   - `directional_variant_count` - number of rotation variants beyond
#     the base id; the live code uses 6 (block_id in
#     [item_id + 1, item_id + 6]).
#
# Decision:
#   - `item_id == block_id`                                -> true (exact match)
#   - `not item_resolves_to_block`                         -> false
#   - `not item_is_directional`                            -> false
#   - `block_id in [item_id + 1, item_id + directional_variant_count]` -> true
#   - otherwise                                            -> false
static func is_inventory_item_placing_block_id(
    item_id: int,
    block_id: int,
    item_resolves_to_block: bool,
    item_is_directional: bool,
    directional_variant_count: int = 6,
) -> bool:
    if item_id == block_id:
        return true
    if not item_resolves_to_block:
        return false
    if not item_is_directional:
        return false
    return block_id >= item_id + 1 and block_id <= item_id + directional_variant_count


# --- Server-side action-result key + cache ---

# server_block_action_key: pure form of `_server_block_action_key`
# (coop_manager.gd L11079-11082).
#
# Composes the cache key `<sender_id>:<request_id>:<action>`. Returns
# "" for invalid input (sender_id <= 0, request_id <= 0, empty action)
# - the live forwarder uses "" as a sentinel "do not cache" value
# (L11086 / L11122).
static func server_block_action_key(sender_id: int, request_id: int, action: String) -> String:
    if sender_id <= 0 or request_id <= 0 or action == "":
        return ""
    return "%s:%s:%s" % [sender_id, request_id, action]


# make_server_block_action_entry: pure form of the dictionary built
# inside `_remember_server_block_action_result` (L11089-11096).
#
# Mirrors the live schema verbatim so an added/renamed field surfaces
# in CI before reaching the on-the-wire ACK path.
static func make_server_block_action_entry(
    success: bool,
    dimension_instance_key: String,
    block_position: Vector3i,
    block_id: int,
    reason: String,
    created_ms: int,
) -> Dictionary:
    return {
        "success": success,
        "dimension_instance_key": dimension_instance_key,
        "block_position": block_position,
        "block_id": block_id,
        "reason": reason,
        "created_ms": created_ms,
    }


# is_action_result_expired: pure form of the TTL comparison inside
# `_cleanup_server_block_action_results` (L11105).
#
# Returns true when `(now_msec - created_ms) > ttl_msec`. Encodes the
# live `>` strict-greater comparison: an entry at exactly the TTL
# boundary is KEPT.
static func is_action_result_expired(created_ms: int, now_msec: int, ttl_msec: int) -> bool:
    return (now_msec - created_ms) > ttl_msec


# prune_expired_action_results: pure form of the loop body inside
# `_cleanup_server_block_action_results` (L11101-11106).
#
# Mutates `results` in place. Iterates a duplicated keys list (the
# live code does the same via `.keys().duplicate()`) to allow erasing
# entries mid-iteration. Returns the count of removed entries.
#
# Defensive: missing `created_ms` defaults to `now_msec` (matches the
# live `result.get("created_ms", now_msec)` default), so an entry
# without a timestamp survives one cleanup pass.
static func prune_expired_action_results(results: Dictionary, now_msec: int, ttl_msec: int) -> int:
    var removed: int = 0
    for key in results.keys().duplicate():
        var result: Dictionary = results.get(key, {})
        var created_ms: int = int(result.get("created_ms", now_msec))
        if is_action_result_expired(created_ms, now_msec, ttl_msec):
            results.erase(key)
            removed += 1
    return removed


# purge_action_results_for_peer: pure form of one of the two loops
# inside `_purge_recent_action_results_for_peer` (L11109-11118).
#
# Removes every entry in `results` whose key begins with
# `"<peer_id>:"` (the live prefix). Returns the count removed.
#
# Defensive: peer_id <= 0 is a no-op (matches the live L11110 guard).
# `results` is mutated in place via `.keys().duplicate()` iteration.
static func purge_action_results_for_peer(results: Dictionary, peer_id: int) -> int:
    if peer_id <= 0:
        return 0
    var prefix: String = "%s:" % peer_id
    var removed: int = 0
    for key in results.keys().duplicate():
        if str(key).begins_with(prefix):
            results.erase(key)
            removed += 1
    return removed
