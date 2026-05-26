class_name CoopServerBrowserUI
extends RefCounted

# CoopServerBrowserUI - phase 15a extraction from coop_manager.gd.
#
# Pure helpers for the server-browser UI panel that:
#   - formats the per-card status banner, presence chip, detail
#     line, region tag and meta footer used by both the vanilla
#     SaveFileCard overlay and the QUALIA-themed card variant;
#   - normalizes raw registry entries (built-in defaults + local
#     `user://lucid_blocks_server_registry.json` +
#     remote registry HTTP fetch) into a single canonical shape
#     before they are merged into `server_browser_entries`;
#   - merges raw arrays / dicts of registry entries into the live
#     `server_browser_entries` array (preserves per-entry state
#     such as `status` / `tps` / `message` learned from the UDP
#     status endpoint);
#   - locates the right entry index for an incoming UDP status
#     packet and applies the parsed status fields onto the entry.
#
# Engine-bound bodies stay on coop_manager.gd as thin forwarders:
#   - `_format_server_browser_meta_line` reads
#     `ProjectSettings.get("application/config/version")`; the
#     forwarder threads the resolved version string in.
#   - `_apply_server_browser_status` delegates protocol parsing /
#     compatibility to `_get_coop_protocol_info_from_status` /
#     `_is_coop_protocol_compatible` (which will move to
#     `CoopJoinProtocol` in Phase 16a); we pass those as
#     `Callable`s so the pure module stays oblivious to the
#     protocol constants.
#   - `_merge_server_browser_registry` mutates the live
#     `server_browser_entries` array; the pure form returns the
#     `{entries, changed}` snapshot and the forwarder swaps it in.
#   - `_find_server_browser_entry_index` reads
#     `server_browser_pending` (mutated by the UDP tick); we pass
#     the dict in as an immutable snapshot.
#
# Constants pinned in this module (defaults; live `coop_manager.gd`
# threads in the canonical values):
#   - `MAX_CLIENTS_DEFAULT`            = 4
#   - `DEFAULT_PORT_DEFAULT`           = 24667
#   - `DEFAULT_STATUS_PORT_OFFSET`     = 1
#   - `FALLBACK_REGION`                = "public"
#   - `FALLBACK_NAME`                  = "Server"
# Live coop_manager.gd keeps its own copies on lines 9 / 10 / 12;
# the forwarders thread them in via the optional arguments below.


# --- Constants ---

const MAX_CLIENTS_DEFAULT: int = 4
const DEFAULT_PORT_DEFAULT: int = 24667
const DEFAULT_STATUS_PORT_OFFSET: int = 1
const FALLBACK_REGION: String = "public"
const FALLBACK_NAME: String = "Server"


# --- Presence / detail / region / meta formatters ---

# format_presence_text: pure form of
# `_format_server_browser_presence_text` (coop_manager.gd
# L2229-2241). Maps the lower-cased `status` field on the entry to
# the six fixed presence chips: ONLINE / CHECKING / RELAY / UPDATE /
# OFFLINE / IDLE.
#
# Empty / unknown status falls through to IDLE (the default
# "registered but never probed" state).
static func format_presence_text(entry: Dictionary) -> String:
    var status: String = str(entry.get("status", "unknown")).strip_edges().to_lower()
    if status == "online" or status == "ready":
        return "ONLINE"
    if status == "checking":
        return "CHECKING"
    if status == "relay":
        return "RELAY"
    if status == "incompatible":
        return "UPDATE"
    if status == "offline":
        return "OFFLINE"
    return "IDLE"


# format_detail_line: pure form of
# `_format_server_browser_detail_line` (coop_manager.gd
# L2244-2266).
#
# Produces the right-hand text on the card overlay:
#   - online/ready: "<players>/<max>  |  <tps> TPS  |  <REG>" where
#     <REG> is the first three letters of the region uppercased
#     (default "public" -> "PUB"). Missing `tps` falls back to "? TPS".
#   - checking: "WAITING  <REG>"
#   - relay:    "WAITING"
#   - incompatible: "PROTOCOL"
#   - offline / idle / unknown: "<REG>"
#
# `max_clients_default` lets the forwarder thread in the canonical
# `MAX_CLIENTS` constant from `coop_manager.gd`.
static func format_detail_line(entry: Dictionary, max_clients_default: int = MAX_CLIENTS_DEFAULT) -> String:
    var status: String = str(entry.get("status", "unknown")).strip_edges().to_lower()
    var region: String = str(entry.get("region", FALLBACK_REGION)).strip_edges()
    var region_text: String = region if region != "" else FALLBACK_REGION
    if status == "online" or status == "ready":
        var tps_text: String = "? TPS"
        if entry.has("tps"):
            tps_text = "%s TPS" % int(round(float(entry.get("tps", 0.0))))
        return "%s/%s  |  %s  |  %s" % [
            int(entry.get("players", 0)),
            int(entry.get("max_players", max_clients_default)),
            tps_text,
            region_text.substr(0, 3).to_upper(),
        ]
    if status == "checking":
        return "WAITING  %s" % region_text.substr(0, 3).to_upper()
    if status == "relay":
        return "WAITING"
    if status == "incompatible":
        return "PROTOCOL"
    if status == "offline":
        return region_text.substr(0, 3).to_upper()
    return region_text.substr(0, 3).to_upper()


# format_status_line: pure form of
# `_format_server_browser_status_line` (coop_manager.gd L2225-2226).
# Joins presence + two spaces + detail.
static func format_status_line(entry: Dictionary, max_clients_default: int = MAX_CLIENTS_DEFAULT) -> String:
    return "%s  %s" % [format_presence_text(entry), format_detail_line(entry, max_clients_default)]


# format_region_line: pure form of
# `_format_server_browser_region_line` (coop_manager.gd L2269-2271).
# Returns uppercased region (with a "preta" fallback for the
# QUALIA-themed card variant).
static func format_region_line(entry: Dictionary, fallback_region: String = "preta") -> String:
    var region: String = str(entry.get("region", fallback_region)).strip_edges()
    return (region if region != "" else fallback_region).to_upper()


# format_meta_line: pure form of
# `_format_server_browser_meta_line` (coop_manager.gd L2274-2280).
# `current_version` is the forwarder-resolved
# `ProjectSettings.get("application/config/version")` value.
static func format_meta_line(entry: Dictionary, current_version: String, max_clients_default: int = MAX_CLIENTS_DEFAULT) -> String:
    var version: String = str(entry.get("version", current_version)).strip_edges()
    if version == "":
        version = current_version
    var presence: String = format_presence_text(entry)
    var details: String = format_detail_line(entry, max_clients_default)
    return "V%s   %s   %s" % [version, presence, details]


# --- Card-parts / entry formatters (QUALIA card variant) ---

# format_card_parts: pure form of
# `_format_server_browser_card_parts` (coop_manager.gd L4122-4142).
# Returns the structured parts list the QUALIA card variant
# displays as separate lines.
static func format_card_parts(entry: Dictionary, max_clients_default: int = MAX_CLIENTS_DEFAULT) -> PackedStringArray:
    var status: String = str(entry.get("status", "unknown"))
    var region: String = str(entry.get("region", FALLBACK_REGION)).strip_edges()
    var region_text: String = region if region != "" else FALLBACK_REGION
    if status == "online":
        var tps_text: String = "?"
        if entry.has("tps"):
            tps_text = str(int(round(float(entry.get("tps", 0.0)))))
        return PackedStringArray([
            "online",
            "%s/%s players" % [int(entry.get("players", 0)), int(entry.get("max_players", max_clients_default))],
            "%s tps" % tps_text,
            region_text,
        ])
    if status == "checking":
        return PackedStringArray(["checking", region_text])
    if status == "relay":
        return PackedStringArray(["relay", "waiting"])
    if status == "offline":
        return PackedStringArray(["offline", region_text])
    return PackedStringArray(["idle", region_text])


# format_browser_entry: pure form of
# `_format_server_browser_entry` (coop_manager.gd L4145-4157).
static func format_browser_entry(entry: Dictionary, max_clients_default: int = MAX_CLIENTS_DEFAULT) -> String:
    var status: String = str(entry.get("status", "unknown"))
    var region: String = str(entry.get("region", FALLBACK_REGION)).strip_edges()
    var region_text: String = region if region != "" else FALLBACK_REGION
    if status == "online":
        return " ".join(format_card_parts(entry, max_clients_default))
    if status == "checking":
        return "checking   %s" % region_text
    if status == "relay":
        return "relay online   waiting"
    if status == "offline":
        return "offline   %s" % region_text
    return "not checked   %s" % region_text


# --- Entry key / normalize / merge ---

# make_entry_key: pure form of
# `_make_server_browser_entry_key` (coop_manager.gd L3807-3815).
#
# Priority:
#   1. `endpoint_key` / `hidden_endpoint_key` -> "key:<endpoint_key>"
#      (used by hidden / relay-only servers)
#   2. address + status_port -> "udp:<address>:<status_port>"
#   3. fallback: lower-cased name / world_title -> "name:<lower>"
static func make_entry_key(
    entry: Dictionary,
    default_port: int = DEFAULT_PORT_DEFAULT,
    status_port_offset: int = DEFAULT_STATUS_PORT_OFFSET,
) -> String:
    var endpoint_key: String = str(entry.get("endpoint_key", entry.get("hidden_endpoint_key", ""))).strip_edges()
    if endpoint_key != "":
        return "key:" + endpoint_key
    var address: String = str(entry.get("address", "")).strip_edges()
    var status_port: int = int(entry.get("status_port", int(entry.get("port", default_port)) + status_port_offset))
    if address != "":
        return "udp:%s:%s" % [address, status_port]
    return "name:" + str(entry.get("name", entry.get("world_title", FALLBACK_NAME))).strip_edges().to_lower()


# normalize_browser_entry: pure form of
# `_normalize_server_browser_entry` (coop_manager.gd L3818-3848).
#
# Returns the canonical shape used by `server_browser_entries`:
#   {
#     name, world_title, address, port, status_port,
#     region, status, players, max_players, message,
#     allow_status_endpoint_update, file_color_1, file_color_2,
#     <plus the original raw fields preserved via duplicate(true)>
#   }
#
# Returns an empty Dictionary when the entry has no address - the
# merge pass skips empty results.
static func normalize_browser_entry(
    raw_entry: Dictionary,
    default_port: int = DEFAULT_PORT_DEFAULT,
    status_port_offset: int = DEFAULT_STATUS_PORT_OFFSET,
    max_clients_default: int = MAX_CLIENTS_DEFAULT,
) -> Dictionary:
    var address: String = str(raw_entry.get("address", raw_entry.get("host", ""))).strip_edges()
    if address == "":
        return {}

    var port: int = int(raw_entry.get("port", default_port))
    var status_port: int = int(raw_entry.get("status_port", port + status_port_offset))
    var name: String = str(raw_entry.get("name", raw_entry.get("world_title", FALLBACK_NAME))).strip_edges()
    if name == "":
        name = FALLBACK_NAME

    var entry: Dictionary = raw_entry.duplicate(true)
    entry["name"] = name
    entry["world_title"] = str(entry.get("world_title", name))
    entry["address"] = address
    entry["port"] = clampi(port, 1, 65535)
    entry["status_port"] = clampi(status_port, 1, 65535)
    entry["region"] = str(entry.get("region", FALLBACK_REGION)).strip_edges()
    entry["status"] = str(entry.get("status", "unknown"))
    entry["players"] = int(entry.get("players", 0))
    entry["max_players"] = int(entry.get("max_players", max_clients_default))
    entry["message"] = str(entry.get("message", ""))
    entry["allow_status_endpoint_update"] = bool(entry.get(
        "allow_status_endpoint_update",
        raw_entry.has("endpoint_key") or raw_entry.has("status_port") or raw_entry.has("game_port")
    ))
    var file_color_1: Variant = entry.get("file_color_1", Color.from_hsv(0.58, 0.32, 0.95))
    var file_color_2: Variant = entry.get("file_color_2", Color.from_hsv(0.09, 0.62, 0.8))
    entry["file_color_1"] = file_color_1 if file_color_1 is Color else Color.from_hsv(0.58, 0.32, 0.95)
    entry["file_color_2"] = file_color_2 if file_color_2 is Color else Color.from_hsv(0.09, 0.62, 0.8)
    return entry


# merge_browser_registry: pure form of
# `_merge_server_browser_registry` (coop_manager.gd L3851-3875).
#
# Takes the current entries array + a raw `servers` array, returns
# `{entries, changed}` so the forwarder can swap in the merged
# entries dict in one assignment.
#
# Behavior matches the live code:
#   - `raw_servers` not an Array -> `{entries, false}` (no-op).
#   - For each raw_entry: normalize; skip if empty; if an existing
#     entry shares the same key -> merge (raw fields win); else
#     append.
#   - Returns `changed=true` if any entry was normalized
#     successfully (even if no field actually changed - matches the
#     live "we tried to merge something" semantic).
static func merge_browser_registry(
    current_entries: Array,
    raw_servers: Variant,
    default_port: int = DEFAULT_PORT_DEFAULT,
    status_port_offset: int = DEFAULT_STATUS_PORT_OFFSET,
    max_clients_default: int = MAX_CLIENTS_DEFAULT,
) -> Dictionary:
    var entries: Array = current_entries.duplicate(true)
    if not (raw_servers is Array):
        return {"entries": entries, "changed": false}

    var changed: bool = false
    for raw_entry in raw_servers:
        if not (raw_entry is Dictionary):
            continue
        var entry: Dictionary = normalize_browser_entry(raw_entry, default_port, status_port_offset, max_clients_default)
        if entry.is_empty():
            continue
        var entry_key: String = make_entry_key(entry, default_port, status_port_offset)
        var existing_index: int = -1
        for index in range(entries.size()):
            if make_entry_key(entries[index], default_port, status_port_offset) == entry_key:
                existing_index = index
                break
        if existing_index >= 0:
            var merged_entry: Dictionary = entries[existing_index]
            merged_entry.merge(entry, true)
            entries[existing_index] = merged_entry
        else:
            entries.append(entry)
        changed = true
    return {"entries": entries, "changed": changed}


# --- UDP status response application ---

# find_browser_entry_index: pure form of
# `_find_server_browser_entry_index` (coop_manager.gd L4258-4266).
#
# `pending_lookup` is a snapshot of `server_browser_pending`
# ("<ip>:<port>" -> int(index)).
static func find_browser_entry_index(
    entries: Array,
    pending_lookup: Dictionary,
    source_ip: String,
    source_port: int,
    default_port: int = DEFAULT_PORT_DEFAULT,
    status_port_offset: int = DEFAULT_STATUS_PORT_OFFSET,
) -> int:
    var direct_key: String = "%s:%s" % [source_ip, source_port]
    if pending_lookup.has(direct_key):
        return int(pending_lookup[direct_key])
    for index in range(entries.size()):
        var entry: Dictionary = entries[index]
        if source_ip == str(entry.get("address", "")) and source_port == int(entry.get("status_port", default_port + status_port_offset)):
            return index
    return -1


# apply_status_to_entry: pure form of
# `_apply_server_browser_status` (coop_manager.gd L4269-4309).
#
# Returns the updated entry as a fresh dict (the forwarder writes
# back to `server_browser_entries[index]`).
#
# `get_coop_protocol_info_from_status` (Callable that takes a
# status Dictionary and returns the {protocol, version, min,
# features, required_features} info dict, or `{}` on miss) and
# `is_coop_protocol_compatible` (Callable that takes the info dict
# and returns a bool) are threaded in from the forwarder so this
# module stays oblivious to the protocol constants. Both default
# to "no protocol info" so the function works in unit tests.
static func apply_status_to_entry(
    entry: Dictionary,
    data: Dictionary,
    get_coop_protocol_info_from_status: Callable = Callable(),
    is_coop_protocol_compatible: Callable = Callable(),
    max_clients_default: int = MAX_CLIENTS_DEFAULT,
    default_port: int = DEFAULT_PORT_DEFAULT,
    status_port_offset: int = DEFAULT_STATUS_PORT_OFFSET,
) -> Dictionary:
    var next_entry: Dictionary = entry.duplicate(true)
    var remote_status: String = str(data.get("status", "")).strip_edges().to_lower()
    var protocol_info: Dictionary = {}
    if get_coop_protocol_info_from_status.is_valid():
        var info_variant: Variant = get_coop_protocol_info_from_status.call(data)
        if info_variant is Dictionary:
            protocol_info = info_variant
    var has_protocol_info: bool = not protocol_info.is_empty()
    if has_protocol_info:
        next_entry["coop_protocol"] = str(protocol_info.get("protocol", ""))
        next_entry["coop_protocol_version"] = int(protocol_info.get("version", 0))
        next_entry["coop_protocol_min"] = int(protocol_info.get("min", 0))
        next_entry["coop_protocol_features"] = protocol_info.get("features", [])
        next_entry["coop_protocol_required_features"] = protocol_info.get("required_features", [])

    var ok_flag: bool = bool(data.get("ok", false))
    var compatible: bool = true
    if has_protocol_info and is_coop_protocol_compatible.is_valid():
        compatible = bool(is_coop_protocol_compatible.call(protocol_info))

    if ok_flag and has_protocol_info and not compatible:
        next_entry["status"] = "incompatible"
        next_entry["message"] = "Server protocol is incompatible"
    elif ok_flag:
        next_entry["status"] = "online"
        next_entry["message"] = str(data.get("message", "Server online"))
    elif remote_status == "starting" or remote_status == "waiting_main" or remote_status == "waiting_world" or remote_status == "loading_world" or remote_status == "starting_host" or remote_status == "replaying_journal":
        next_entry["status"] = "checking"
        next_entry["message"] = str(data.get("message", "Server is starting"))
    elif data.has("backend_connected") and not bool(data.get("backend_connected", false)):
        next_entry["status"] = "relay"
        next_entry["message"] = str(data.get("message", "Relay online, host is not connected"))
    else:
        next_entry["status"] = "offline"
        next_entry["message"] = str(data.get("message", "Server unavailable"))

    next_entry["players"] = int(data.get("players", next_entry.get("players", 0)))
    next_entry["max_players"] = int(data.get("max_players", next_entry.get("max_players", max_clients_default)))
    next_entry["world_title"] = str(data.get("world_title", next_entry.get("world_title", next_entry.get("name", FALLBACK_NAME))))
    if data.has("tps"):
        next_entry["tps"] = float(data.get("tps", next_entry.get("tps", 0.0)))
    if data.has("tps_health"):
        next_entry["tps_health"] = str(data.get("tps_health", next_entry.get("tps_health", "")))

    var allow_endpoint_update: bool = bool(next_entry.get("allow_status_endpoint_update", false))
    if allow_endpoint_update and int(data.get("game_port", 0)) > 0:
        next_entry["port"] = int(data.get("game_port", next_entry.get("port", default_port)))
    if allow_endpoint_update and int(data.get("status_port", 0)) > 0:
        next_entry["status_port"] = int(data.get("status_port", next_entry.get("status_port", default_port + status_port_offset)))

    return next_entry
