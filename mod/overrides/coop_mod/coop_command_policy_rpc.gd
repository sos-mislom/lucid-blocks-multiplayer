class_name CoopCommandPolicyRPC
extends RefCounted

# CoopCommandPolicyRPC - phase 8 extraction from coop_manager.gd.
#
# Pure helpers for the server-side command-policy surface: which policy
# the host should read at a given moment, how a single toggle propagates
# through alias pairs, when the host should broadcast policy changes,
# and how rejections are phrased back to the user.
#
# The `@rpc("authority", "call_remote", "reliable")` handler
# `sync_server_command_policy` itself stays on coop_manager.gd - the
# decorator binds to the script's NodePath on the multiplayer authority
# and cannot be relocated without breaking the wire protocol. Same goes
# for the engine-mutating side (config dict writes, _save_config(),
# multiplayer.get_peers(), .rpc_id, status_message, _update_status_text).
#
# This module knows NOTHING about:
#   - multiplayer.* / scene tree / @rpc - the caller passes is_server +
#     has_live_peer booleans into choose_effective / should_broadcast,
#     and owns the actual rpc_id() loop.
#   - config persistence - apply_value returns a NEW dictionary; the
#     forwarder is responsible for writing it back and calling
#     _save_config().
#   - DEFAULT_SERVER_COMMAND_POLICY - passed in by the caller so the
#     source-of-truth dict stays in one place on coop_manager.gd.
#
# CoopAdmin (phase 5) owns the deep normalisation; this module only
# performs the lighter "apply one toggle + mirror the alias pair"
# mutation and defers the canonicalisation back to the caller (which
# re-normalises via _normalize_server_command_policy, matching the
# pre-refactor behaviour at coop_manager.gd line 6726).


# --- Constants (canonical strings referenced from coop_manager.gd) ---

# REJECTION_MESSAGE_TEMPLATE: client-facing format used when a command
# is denied by the server-side policy. Single %s substitution slot for
# the command name (already normalised by the caller).
const REJECTION_MESSAGE_TEMPLATE: String = "%s is disabled by server command policy"

# RESET_RESPONSE: feedback shown after `/server-commands reset` wipes
# the policy back to DEFAULT_SERVER_COMMAND_POLICY.
const RESET_RESPONSE: String = "Server command policy reset"

# CLIENT_REJECTION_RESPONSE: feedback shown when a non-server peer
# tries to mutate the server-side policy via `/server-commands`. The
# server is the authority on policy state; clients only mirror it.
const CLIENT_REJECTION_RESPONSE: String = "Only the server can change command policy"


# --- Effective-policy decision ---

# choose_effective: pure form of _get_effective_server_command_policy
# (coop_manager.gd 6693-6696). The host (is_server=true) and any
# singleplayer session (has_live_peer=false) both read the local
# config-backed policy. Connected clients read the cached `active`
# policy that the server last broadcast - normalised against
# `default_policy` to defend against drift / partial RPC payloads.
#
# `active_policy` is `Variant` because the live state can be null or
# a non-Dictionary if a buggy peer sends garbage; CoopAdmin.normalize_*
# treats anything-but-Dictionary as "use defaults".
static func choose_effective(local_policy: Dictionary, active_policy: Variant, default_policy: Dictionary, is_server: bool, has_live_peer: bool) -> Dictionary:
    if is_server or not has_live_peer:
        return local_policy
    return CoopAdmin.normalize_command_policy(active_policy, default_policy)


# --- Single-toggle apply ---

# apply_value: pure form of the in-body mutation of
# _set_server_command_policy_value (coop_manager.gd 6716-6725). Returns
# a NEW dictionary (deep-copied from the input) so callers can stage a
# write before persisting; the original `policy` is never mutated.
#
# command_name is expected to already be normalised by the caller via
# _normalize_server_command_name(...). An empty string returns the input
# untouched - matches the early-return guard at coop_manager.gd 6713-6715
# (`if command_name == "": return`).
#
# Alias mirroring (`gamemode` <-> `gm`, `spawnmenu` <-> `mobs`) keeps the
# returned dictionary internally consistent so callers can look up policy
# by either spelling without a separate normalize pass. The forwarder
# still pipes the result through CoopAdmin.normalize_command_policy
# afterwards (matching today's behaviour at line 6726) so any structural
# drift in the upstream policy is canonicalised in one place.
static func apply_value(policy: Dictionary, command_name: String, allowed: bool) -> Dictionary:
    if command_name == "":
        return policy
    var updated: Dictionary = policy.duplicate(true)
    updated[command_name] = allowed
    if command_name == "gamemode":
        updated["gm"] = allowed
    elif command_name == "gm":
        updated["gamemode"] = allowed
    elif command_name == "spawnmenu":
        updated["mobs"] = allowed
    elif command_name == "mobs":
        updated["spawnmenu"] = allowed
    return updated


# --- Broadcast gate ---

# should_broadcast: pure form of the top-of-function gate in
# _broadcast_server_command_policy (coop_manager.gd 6733-6734). Returns
# true only when the host is the multiplayer authority AND a live peer
# is connected - we never RPC during singleplayer (no peers to receive
# it) or from a client (clients are not the policy authority).
static func should_broadcast(is_server: bool, has_live_peer: bool) -> bool:
    return is_server and has_live_peer


# --- Rejection message ---

# rejection_message: pure form of the format string at
# _reject_command_by_server_policy (coop_manager.gd 6708). The forwarder
# writes the returned string to `status_message` and calls
# `_update_status_text()`.
static func rejection_message(command: String) -> String:
    return REJECTION_MESSAGE_TEMPLATE % command
