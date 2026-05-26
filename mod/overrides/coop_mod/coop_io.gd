class_name CoopIO
extends RefCounted

# CoopIO — phase 1 extraction from coop_manager.gd (audit fix).
#
# Houses *non-networked* helpers that the god-class coop_manager used to
# inline. Extracting them here lets unit tests reach them without spinning
# up the multiplayer authority node, and starts to draw the seams that the
# longer-term refactor will follow.
#
# Long-term split plan (do NOT do all at once — each move must keep the
# `@rpc(...)` decorators on the same NodePath or the network protocol
# breaks):
#   - CoopTransport         : multiplayer_peer create/destroy, peer connect
#                             /disconnect, join-protocol handshake.
#   - CoopAuthorityValidator: ingress validation, reach checks, admin/role
#                             helpers, request-id de-dup.
#   - CoopWorldSync         : block place/break/water/fire/storage RPCs.
#   - CoopEntitySync        : entity snapshot + attack RPCs.
#   - CoopDropSync          : dropped-item spawn/pickup/sync RPCs.
#   - CoopAdmin             : builder commands, /tp, /server-commands.
#   - CoopUI                : pause overlay, status banner, lobby panels.
#   - CoopJournal           : chunk journal append/replay/compact.
#   - CoopStatus            : UDP status server, registry heartbeat.
#
# Phase 1 (this file): pure helpers with no instance state — atomic IO,
#                      bounded-dict insertion, small validators.
# Phase 2: extract CoopJournal (no @rpc on its surface, easy lift).
# Phase 3: extract CoopAuthorityValidator (call-site swap only).
# Phase 4+: rest, behind a feature-flag rollout.


# Atomic file write: write to `<path>.tmp`, fsync (via close), then rename
# over the target. Returns true on success.
static func atomic_write_file(path: String, content: String) -> bool:
    if path == "":
        return false
    var tmp_path: String = path + ".tmp"
    var file: FileAccess = FileAccess.open(tmp_path, FileAccess.WRITE)
    if file == null:
        push_warning("[lucid-blocks-coop] CoopIO.atomic_write_file: could not open %s" % tmp_path)
        return false
    file.store_string(content)
    file.close()
    var err: int = DirAccess.rename_absolute(ProjectSettings.globalize_path(tmp_path), ProjectSettings.globalize_path(path))
    if err != OK:
        var fallback_err: int = DirAccess.rename_absolute(tmp_path, path)
        if fallback_err != OK:
            push_warning("[lucid-blocks-coop] CoopIO.atomic_write_file: rename failed (%s) for %s" % [err, path])
            return false
    return true


# Crash-safe append-line: read existing file (if any), append the new line,
# then atomically rewrite. Slower than raw FileAccess.store_line but never
# leaves a truncated tail behind on crash.
static func atomic_append_line(path: String, line: String) -> bool:
    if path == "":
        return false
    var existing: String = ""
    if FileAccess.file_exists(path):
        var rfile: FileAccess = FileAccess.open(path, FileAccess.READ)
        if rfile != null:
            existing = rfile.get_as_text()
            rfile.close()
    if existing != "" and not existing.ends_with("\n"):
        existing += "\n"
    existing += line
    if not existing.ends_with("\n"):
        existing += "\n"
    return atomic_write_file(path, existing)


# Bounded-dict insertion with FIFO eviction. If `target` already has
# `max_entries` keys, the oldest (insertion order) is evicted before insert.
# Returns true on insert.
static func bounded_dict_set(target: Dictionary, key: Variant, value: Variant, max_entries: int) -> bool:
    if max_entries <= 0:
        target[key] = value
        return true
    if not target.has(key) and target.size() >= max_entries:
        var keys: Array = target.keys()
        var to_evict: int = (target.size() - max_entries) + 1
        for i in range(to_evict):
            if i < keys.size():
                target.erase(keys[i])
    target[key] = value
    return true


# Returns true when the request_id is well-formed for client-issued
# mutations. Rejects 0 (legacy "fire-and-forget") and negative ids that
# would break dedupe.
static func is_valid_client_request_id(request_id: int) -> bool:
    return request_id > 0 and request_id < 0x7fffffff
