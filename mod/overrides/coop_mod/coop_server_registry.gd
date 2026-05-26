class_name CoopServerRegistry
extends RefCounted

# CoopServerRegistry - phase 18 extraction from coop_manager.gd.
#
# Pure helpers for the server-registry I/O pipeline:
#   - `extract_servers_list_from_data` (pure shape coercion: a
#     registry payload may arrive as either `{servers: [...]}` or
#     a bare `[...]`; this returns a fresh duplicated Array<Dict>
#     in both cases, or [] for any other shape);
#   - `is_registry_url_valid` (the `https://` / `http://` guard
#     used before kicking off HTTPRequest);
#   - `is_response_code_ok` (the 200..299 success-code check used
#     by every registry HTTP callback);
#   - `build_cache_payload` (the canonical
#     `{fetched_unix, data}` envelope written to the on-disk cache);
#   - `is_cache_payload_fresh` (the TTL check used when loading
#     the cache - returns true when:
#       1. `ttl_sec <= 0` (caller disabled the TTL gate);
#       2. or `fetched_unix <= 0` (caller treats payload as
#          unsigned-age - matches the live "don't expire when we
#          don't know when it was written" behavior);
#       3. or `now_unix - fetched_unix <= ttl_sec`);
#   - `is_local_registry_path` (predicate for "is this the
#     user-saved registry path?" - used by the save UI to decide
#     whether to merge into the local file).
#
# Engine-bound state stays on `coop_manager.gd` as forwarders:
#   - `_load_local_server_browser_registry` /
#     `_read_local_server_browser_registry_entries` /
#     `_write_local_server_browser_registry_entries`: read/write
#     `SERVER_REGISTRY_PATH` via `FileAccess`;
#   - `_load_cached_server_browser_registry` /
#     `_write_cached_server_browser_registry`: read/write
#     `SERVER_REGISTRY_CACHE_PATH` via `FileAccess` +
#     `Time.get_unix_time_from_system()`;
#   - `_request_remote_server_browser_registry` /
#     `_on_server_browser_registry_completed`:
#     `HTTPRequest.new()`, signal connections, `add_child`,
#     `queue_free`, `push_warning`;
#   - `SERVER_REGISTRY_PATH` / `SERVER_REGISTRY_CACHE_PATH` /
#     `SERVER_REGISTRY_CACHE_TTL_SEC` /
#     `SERVER_REGISTRY_HEARTBEAT_INTERVAL_SEC` constants live on
#     `coop_manager.gd` as the on-disk path / TTL contract.
#
# This module knows NOTHING about:
#   - `FileAccess` / `DirAccess` / `Time.*` / `HTTPRequest`.
#   - `Ref.*` / `multiplayer.*`.
#   - The browser entry merge/normalize logic (that lives in
#     `CoopServerBrowserUI` - this module sits below it, just
#     coerces the "outer envelope" before handing the raw list off
#     to the browser UI module).


# --- Envelope -> list coercion ---

# extract_servers_list_from_data: pure form of the envelope
# coercion used by `_read_local_server_browser_registry_entries`
# (coop_manager.gd L3707-3721) and the data branch of
# `_merge_server_browser_registry_data` (L3684-3689).
#
# Accepts:
#   - `Dictionary` with a `servers` key holding an Array -> returns
#     a deep-duplicated copy of that array;
#   - `Dictionary` without a `servers` key (or with a non-Array
#     value) -> returns `[]`;
#   - `Array` -> returns a deep-duplicated copy;
#   - anything else (null, scalar, etc.) -> returns `[]`.
#
# The deep duplicate matches the live behavior - the caller can
# safely mutate the returned array without affecting the on-disk
# state that the FileAccess pipeline parsed from.
static func extract_servers_list_from_data(data: Variant) -> Array:
    if data is Dictionary:
        var servers: Variant = (data as Dictionary).get("servers", [])
        if servers is Array:
            return (servers as Array).duplicate(true)
        return []
    if data is Array:
        return (data as Array).duplicate(true)
    return []


# --- URL / HTTP gates ---

# is_registry_url_valid: pure form of the URL guard at
# `_request_remote_server_browser_registry` (coop_manager.gd
# L3824). Returns true iff the (already-stripped) URL begins with
# `http://` or `https://`. Empty / file:// / steam:// URLs are
# rejected because the registry path goes through `HTTPRequest`.
static func is_registry_url_valid(url: String) -> bool:
    return url.begins_with("https://") or url.begins_with("http://")


# is_response_code_ok: pure form of the 200..299 success-code
# check used by `_on_server_browser_registry_completed`
# (coop_manager.gd L3845) and `_on_dedicated_registry_heartbeat_completed`
# (coop_manager.gd L1395-1396).
static func is_response_code_ok(response_code: int) -> bool:
    return response_code >= 200 and response_code < 300


# --- Cache envelope ---

# build_cache_payload: pure form of the `{fetched_unix, data}`
# envelope built in `_write_cached_server_browser_registry`
# (coop_manager.gd L3806-3810). The forwarder threads in the live
# `Time.get_unix_time_from_system()` value so this module stays
# oblivious to time.
static func build_cache_payload(fetched_unix: int, data: Variant) -> Dictionary:
    return {
        "fetched_unix": fetched_unix,
        "data": data,
    }


# is_cache_payload_fresh: pure form of the TTL check in
# `_load_cached_server_browser_registry` (coop_manager.gd
# L3797-3800).
#
# Returns true when the cache is still considered fresh:
#   - `ttl_sec <= 0` -> caller disabled the TTL gate, always
#     fresh;
#   - `fetched_unix <= 0` -> caller treats payload as
#     unsigned-age and accepts it (matches live behavior where
#     "no fetched_unix means we don't expire");
#   - else `now_unix - fetched_unix <= ttl_sec`.
#
# Live note: the live check was `> ttl_sec -> return` (i.e. stale
# -> skip merge). This function returns the inverse - true means
# "still fresh, merge it".
static func is_cache_payload_fresh(payload: Dictionary, now_unix: int, ttl_sec: int) -> bool:
    if ttl_sec <= 0:
        return true
    var fetched_unix: int = int(payload.get("fetched_unix", 0))
    if fetched_unix <= 0:
        return true
    return (now_unix - fetched_unix) <= ttl_sec
