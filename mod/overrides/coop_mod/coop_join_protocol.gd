class_name CoopJoinProtocol
extends RefCounted

# CoopJoinProtocol - phase 16a extraction from coop_manager.gd.
#
# Pure helpers for the join-time protocol negotiation that:
#   - builds the canonical `{protocol, version, min, features,
#     required_features, game_version}` info Dictionary from the
#     `COOP_PROTOCOL_*` constants (`coop_manager.gd` keeps the
#     constants as the single source of truth and threads them
#     in via the forwarder);
#   - extracts the same shape from a UDP status JSON payload
#     (returns `{}` when the payload has none of the
#     `coop_protocol*` keys - that is the "vanilla / non-coop
#     server" case the server-browser uses to fall through to
#     legacy compatibility);
#   - normalizes a feature list (Variant -> Array<String>) by
#     stripping each entry, dropping empties, deduping;
#   - checks feature-set inclusion (does the available set cover
#     every entry in required?);
#   - validates compatibility between the local protocol and the
#     remote info Dictionary - the four-line gate that gives
#     `_is_coop_protocol_compatible` its shape:
#       1. protocol names must match;
#       2. remote version >= local min;
#       3. local version >= remote min;
#       4. each set's required features must be covered by the
#          other set's available features.
#   - formats a human-readable one-liner for logs / status banner.
#
# Engine-bound bodies stay on coop_manager.gd as thin forwarders:
#   - `_get_coop_protocol_info` reads
#     `ProjectSettings.get("application/config/version")` for the
#     `game_version` field; the pure form
#     (`build_protocol_info`) takes the resolved version string.
#   - `_request_join_protocol_check` / `_reset_join_protocol_state`
#     / the `request_join_protocol` / `receive_join_protocol_result`
#     @rpc handlers stay on `coop_manager.gd` (NodePath bound).
#   - The protocol constants `COOP_PROTOCOL_NAME` /
#     `COOP_PROTOCOL_VERSION` / `COOP_PROTOCOL_MIN_COMPATIBLE` /
#     `COOP_PROTOCOL_FEATURES` / `COOP_PROTOCOL_REQUIRED_FEATURES`
#     stay on `coop_manager.gd` as the single source of truth -
#     wire protocol regression risk; the forwarder threads them
#     in.
#
# This module knows NOTHING about:
#   - `class_name Player` / `class_name SaveFile`.
#   - `Ref.*` / `multiplayer.*`.
#   - `COOP_PROTOCOL_*` constants - threaded in via the forwarder.


# --- Protocol info builders ---

# build_protocol_info: pure form of `_get_coop_protocol_info`
# (coop_manager.gd L14706-14714). The forwarder threads in the
# four `COOP_PROTOCOL_*` constants + the
# `ProjectSettings.get("application/config/version")` game_version
# string so this module stays oblivious to engine state.
static func build_protocol_info(
    protocol_name: String,
    version: int,
    min_compatible: int,
    features: Array,
    required_features: Array,
    game_version: String,
) -> Dictionary:
    return {
        "protocol": protocol_name,
        "version": version,
        "min": min_compatible,
        "features": features,
        "required_features": required_features,
        "game_version": game_version,
    }


# extract_protocol_info_from_status: pure form of
# `_get_coop_protocol_info_from_status` (coop_manager.gd
# L14717-14728).
#
# Returns `{}` when the status payload has none of the
# `coop_protocol` / `coop_protocol_version` / `coop_protocol_min`
# keys - that is the "vanilla server / no protocol info" case the
# server-browser uses to fall through to legacy compatibility.
#
# When at least one key is present the function returns the same
# six-field Dictionary as `build_protocol_info`, defaulting `min`
# to `version` (matches the live "no min -> assume same as version"
# fallback) and pulling `game_version` from the status payload's
# `version` field.
static func extract_protocol_info_from_status(data: Dictionary) -> Dictionary:
    if not data.has("coop_protocol") and not data.has("coop_protocol_version") and not data.has("coop_protocol_min"):
        return {}
    var remote_version: int = int(data.get("coop_protocol_version", 0))
    return {
        "protocol": str(data.get("coop_protocol", "")),
        "version": remote_version,
        "min": int(data.get("coop_protocol_min", remote_version)),
        "features": data.get("coop_protocol_features", []),
        "required_features": data.get("coop_protocol_required_features", []),
        "game_version": str(data.get("version", "")),
    }


# --- Feature-set helpers ---

# protocol_feature_list: pure form of `_protocol_feature_list`
# (coop_manager.gd L14731-14738). Coerces a Variant (Array or
# anything else) into a deduped Array<String> by stripping each
# entry and dropping empties.
static func protocol_feature_list(value: Variant) -> Array:
    var result: Array = []
    if value is Array:
        for item in value:
            var feature: String = str(item).strip_edges()
            if feature != "" and not result.has(feature):
                result.append(feature)
    return result


# has_protocol_features: pure form of `_has_protocol_features`
# (coop_manager.gd L14741-14746). Returns true when every entry in
# `required_value` appears in `available_value` (both coerced via
# `protocol_feature_list`).
#
# Empty required -> true (no requirement to satisfy).
static func has_protocol_features(available_value: Variant, required_value: Variant) -> bool:
    var available: Array = protocol_feature_list(available_value)
    for feature in protocol_feature_list(required_value):
        if not available.has(feature):
            return false
    return true


# format_protocol_features: pure form of `_format_protocol_features`
# (coop_manager.gd L14749-14756). Returns `","`-joined feature
# list, or `"-"` when empty.
static func format_protocol_features(value: Variant) -> String:
    var features: Array = protocol_feature_list(value)
    if features.is_empty():
        return "-"
    var parts: PackedStringArray = PackedStringArray()
    for feature in features:
        parts.append(str(feature))
    return ",".join(parts)


# --- Compatibility check ---

# is_protocol_compatible: pure form of
# `_is_coop_protocol_compatible` (coop_manager.gd L14759-14770).
#
# The four-gate compatibility check the wire protocol depends on:
#   1. protocol names must match exactly (case-sensitive);
#   2. remote.version >= local.min (we're not too new for them);
#   3. local.version >= remote.min (they're not too new for us);
#   4. local features cover remote required_features AND
#      remote features cover local required_features (the dual
#      direction check catches required-feature regressions on
#      either side).
#
# The forwarder threads in the local
# `protocol_name` / `version` / `min_compatible` / `features` /
# `required_features` from the `COOP_PROTOCOL_*` constants.
static func is_protocol_compatible(
    remote_info: Dictionary,
    local_protocol_name: String,
    local_version: int,
    local_min_compatible: int,
    local_features: Array,
    local_required_features: Array,
) -> bool:
    if str(remote_info.get("protocol", "")) != local_protocol_name:
        return false
    var remote_version: int = int(remote_info.get("version", 0))
    var remote_min: int = int(remote_info.get("min", remote_version))
    if remote_version < local_min_compatible or local_version < remote_min:
        return false
    if not has_protocol_features(local_features, remote_info.get("required_features", [])):
        return false
    if not has_protocol_features(remote_info.get("features", []), local_required_features):
        return false
    return true


# --- Human-readable banner ---

# format_protocol_info_line: pure form of
# `_format_coop_protocol_info` (coop_manager.gd L14773-14779).
# One-line summary used in logs and the status banner.
static func format_protocol_info_line(info: Dictionary) -> String:
    return "%s p%s min%s features[%s]" % [
        str(info.get("protocol", "unknown")),
        int(info.get("version", 0)),
        int(info.get("min", 0)),
        format_protocol_features(info.get("features", [])),
    ]
