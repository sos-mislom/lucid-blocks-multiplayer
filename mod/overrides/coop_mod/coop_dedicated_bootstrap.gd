class_name CoopDedicatedBootstrap
extends RefCounted

# CoopDedicatedBootstrap - phase 17 extraction from coop_manager.gd.
#
# Pure helpers used by the dedicated-server bootstrap path:
#   - `merge_cmdline_args` (pure form of `_get_coop_cmdline_args`'s
#     dedup pass; the forwarder reads `OS.get_cmdline_args()` /
#     `OS.get_cmdline_user_args()` and threads the two arrays in);
#   - `cmdline_has_flag` (pure form of `_cmdline_has_flag` -
#     `--foo` literal match, `--foo=value` truthy-value match);
#   - `read_cmdline_value` (pure form of `_read_cmdline_value` -
#     `--foo bar` (next arg) and `--foo=bar` (inline) shapes);
#   - `read_cmdline_bool` (pure form of `_read_cmdline_bool` -
#     `"1"/"true"/"yes"/"on"` -> true,
#     `"0"/"false"/"no"/"off"` -> false, anything else -> default);
#   - `build_server_world_seal_payload` (the canonical JSON shape
#     fed into the seal hash from `_compute_server_world_seal_for_register`);
#   - `compute_server_world_seal_hash` (the `secret\npayload` ->
#     sha256_text step - pure given the payload and secret).
#
# Engine-bound state stays on `coop_manager.gd` as forwarders:
#   - `_get_coop_cmdline_args`: reads `OS.get_cmdline_args()` /
#     `OS.get_cmdline_user_args()`;
#   - `_read_env_value`: reads `OS.get_environment(name)`;
#   - `_configure_dedicated_server_from_args`: mutates
#     `dedicated_*` state + `config["..."]` entries;
#   - `_compute_server_world_seal_for_register`: depends on
#     `_get_server_save_secret` (reads `config`),
#     `_get_server_save_directory_for_register` (reads
#     `Ref.save_file_manager`), `_collect_server_world_file_hashes`
#     (filesystem walk via `DirAccess` / `FileAccess.get_sha256`),
#     and the `SERVER_WORLD_SEAL_VERSION` constant -
#     `coop_manager.gd` is the single source of truth for the
#     version constant due to wire/persistence regression risk;
#   - `_verify_dedicated_server_world_seal` /
#     `_seal_loaded_server_world_if_needed`: mutate save register
#     data + log via `print` / `push_warning`.
#
# This module knows NOTHING about:
#   - `OS.*` / `Ref.*` / `multiplayer.*`.
#   - `FileAccess` / `DirAccess`.
#   - `config["..."]` / `SaveFileRegister`.
#   - `SERVER_WORLD_SEAL_VERSION` - threaded in via the forwarder.


# --- Cmdline args merge ---

# merge_cmdline_args: pure form of `_get_coop_cmdline_args`'s
# dedup pass (coop_manager.gd L571-579). Concatenates `base_args`
# and `user_args` and returns a deduped Array<String> preserving
# first-seen order.
#
# Inputs are Variant so the forwarder can pass through whatever
# `OS.get_cmdline_args()` / `OS.get_cmdline_user_args()` return
# without forcing the caller to pre-coerce.
static func merge_cmdline_args(base_args: Variant, user_args: Variant) -> Array:
    var result: Array = []
    if base_args is Array:
        for arg in base_args:
            var arg_text: String = str(arg)
            if not result.has(arg_text):
                result.append(arg_text)
    if user_args is Array:
        for arg in user_args:
            var arg_text: String = str(arg)
            if not result.has(arg_text):
                result.append(arg_text)
    return result


# --- Flag / value lookups ---

# cmdline_has_flag: pure form of `_cmdline_has_flag`
# (coop_manager.gd L582-591).
#
# Returns true when ANY of:
#   - a stripped arg equals one of `names` (e.g. `--lb-dedicated`);
#   - a stripped arg begins with `name=` and the trailing value is
#     NOT one of `"0"/"false"/"no"/"off"` (case-insensitive).
#
# Live note: any arg matching `name=...` short-circuits the scan
# and returns. So `--lb-dedicated=0 --lb-dedicated` is treated as
# the first `=0` overriding everything - matches what the live
# coop_manager.gd does.
static func cmdline_has_flag(args: Array, names: Array) -> bool:
    for raw_arg in args:
        var arg: String = str(raw_arg).strip_edges()
        for name in names:
            var name_text: String = str(name)
            if arg == name_text:
                return true
            if arg.begins_with("%s=" % name_text):
                var value: String = arg.substr(name_text.length() + 1).strip_edges().to_lower()
                return not ["0", "false", "no", "off"].has(value)
    return false


# read_cmdline_value: pure form of `_read_cmdline_value`
# (coop_manager.gd L594-602).
#
# Scans `args` for the first arg that:
#   1. equals one of `names` and is followed by another arg
#      (the value is that next arg, stripped);
#   2. or begins with `name=` (the value is the substring after,
#      stripped).
# Falls back to `default_value` when nothing matches.
static func read_cmdline_value(args: Array, names: Array, default_value: String = "") -> String:
    for i in range(args.size()):
        var arg: String = str(args[i]).strip_edges()
        for name in names:
            var name_text: String = str(name)
            if arg == name_text and i + 1 < args.size():
                return str(args[i + 1]).strip_edges()
            if arg.begins_with("%s=" % name_text):
                return arg.substr(name_text.length() + 1).strip_edges()
    return default_value


# read_cmdline_bool: pure form of `_read_cmdline_bool`
# (coop_manager.gd L610-618).
#
# Returns true for `"1"/"true"/"yes"/"on"`, false for
# `"0"/"false"/"no"/"off"`, `default_value` otherwise (including
# the no-match-found case where `read_cmdline_value` returned its
# default `""`). All compares are case-insensitive (`to_lower()`).
static func read_cmdline_bool(args: Array, names: Array, default_value: bool) -> bool:
    var value: String = read_cmdline_value(args, names, "").strip_edges().to_lower()
    if value == "":
        return default_value
    if ["1", "true", "yes", "on"].has(value):
        return true
    if ["0", "false", "no", "off"].has(value):
        return false
    return default_value


# --- Server world seal ---

# build_server_world_seal_payload: pure form of the JSON-shape
# build at the heart of `_compute_server_world_seal_for_register`
# (coop_manager.gd L1163-1167).
#
# Returns the canonical JSON-serialized payload:
#   {
#     "version": <seal_version>,
#     "uuid":    <uuid>,
#     "files":   <file_hashes>,
#   }
# The forwarder threads in `SERVER_WORLD_SEAL_VERSION` so the
# version constant stays on `coop_manager.gd` as the single source
# of truth (persistence/wire regression risk).
static func build_server_world_seal_payload(
    seal_version: int,
    uuid: String,
    file_hashes: Array,
) -> String:
    return JSON.stringify({
        "version": seal_version,
        "uuid": uuid,
        "files": file_hashes,
    })


# compute_server_world_seal_hash: pure form of the
# `secret\npayload -> sha256_text` step at the tail of
# `_compute_server_world_seal_for_register` (coop_manager.gd
# L1168). Pure given the secret and payload; the forwarder owns
# the I/O steps that build the file-hash list and the JSON
# payload.
static func compute_server_world_seal_hash(secret: String, payload: String) -> String:
    return ("%s\n%s" % [secret, payload]).sha256_text()
