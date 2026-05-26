class_name CoopJournal
extends RefCounted

# CoopJournal — phase 2 extraction from coop_manager.gd (audit follow-up).
#
# Pure, static helpers for the dedicated-server chunk journal:
#   - record (de)serialization
#   - applied-seq watermark IO
#   - crash-safe append and compact
#
# This module deliberately knows NOTHING about:
#   - Ref.world / Ref.save_file_manager (callers resolve world_id first)
#   - server_dirty_chunk_keys / server_chunk_journal_sequence (state stays
#     on coop_manager; callers manage it before/after the helper call)
#   - multiplayer.is_server() (callers gate)
#
# Keeping it state-free makes every helper directly unit-testable without
# spinning up a SceneTree or a multiplayer peer.


# Map an arbitrary world UUID to a path-safe slug. Empty input degrades to
# "active" so the chunk-journal path is always well-formed even before a
# save register exists.
static func make_world_id_safe(uuid: String) -> String:
    var trimmed: String = uuid.strip_edges()
    if trimmed == "":
        return "active"
    return trimmed.replace("/", "_").replace("\\", "_")


# Resolve the journal and applied-seq paths for a given user-dir prefix
# (typically "user://") and world id.
static func journal_paths(user_dir: String, world_id: String) -> Dictionary:
    var safe_id: String = make_world_id_safe(world_id)
    var prefix: String = user_dir
    if prefix == "":
        prefix = "user://"
    if not prefix.ends_with("/"):
        prefix += "/"
    var journal: String = "%slucid_blocks_coop_chunk_journal_%s.jsonl" % [prefix, safe_id]
    return {
        "journal": journal,
        "applied_seq": journal + ".applied_seq",
    }


# --- Vector3i (de)serialization ---

static func vector3i_to_array(value: Vector3i) -> Array:
    return [value.x, value.y, value.z]


static func array_to_vector3i(value: Variant) -> Vector3i:
    if value is Vector3i:
        return value
    if value is Vector3:
        return Vector3i(value)
    if value is Array and (value as Array).size() >= 3:
        var arr: Array = value
        return Vector3i(int(arr[0]), int(arr[1]), int(arr[2]))
    return Vector3i.ZERO


# --- Storage items (de)serialization ---

static func storage_items_to_json(serialized_items: Array) -> Array:
    var result: Array = []
    for item_data in serialized_items:
        if item_data is PackedInt32Array:
            var values: Array = []
            for raw_value in item_data:
                values.append(int(raw_value))
            result.append(values)
        elif item_data is Array:
            var values_from_array: Array = []
            for raw_value in item_data:
                values_from_array.append(int(raw_value))
            result.append(values_from_array)
        else:
            result.append([])
    return result


static func storage_items_from_json(value: Variant) -> Array:
    var result: Array = []
    if not (value is Array):
        return result
    for item_entry in value:
        var item_data: PackedInt32Array = PackedInt32Array()
        if item_entry is Array:
            for raw_value in item_entry:
                item_data.append(int(raw_value))
        elif item_entry is PackedInt32Array:
            item_data = item_entry
        result.append(item_data)
    return result


# --- Record parsing ---

# Parse a single journal line and return { ok: bool, record: Dictionary }.
# Blank lines, malformed JSON and non-dictionary JSON all yield ok=false
# with an empty record. This centralises the skipped_count++ branch from
# coop_manager._replay_server_chunk_journal.
static func parse_journal_line(line: String) -> Dictionary:
    var stripped: String = line.strip_edges()
    if stripped == "":
        return {"ok": false, "record": {}}
    var parsed: Variant = JSON.parse_string(stripped)
    if not (parsed is Dictionary):
        return {"ok": false, "record": {}}
    return {"ok": true, "record": parsed}


# True when a journal record belongs to `world_id`. Records that omit the
# `world` field are treated as belonging to the active world (historical
# behaviour from coop_manager).
static func is_record_for_world(record: Dictionary, world_id: String) -> bool:
    var record_world: String = str(record.get("world", world_id))
    return record_world == world_id


# --- Compact ---

# Pure, side-effect-free filter for the compact step. Given the raw text of
# a journal file and the watermark seq the autosave committed, return the
# lines that MUST be carried forward (records with seq > watermark). Blank
# lines and non-dictionary records are dropped. Ordering is preserved.
#
# This is the audit-critical helper: today the only way to verify "we keep
# lines written while the save was in flight" is to crash a dedicated
# server mid-save. With this extraction the invariant is a unit test.
static func compute_keep_lines(text: String, watermark_seq: int) -> PackedStringArray:
    var keep: PackedStringArray = PackedStringArray()
    for raw_line in text.split("\n"):
        var stripped: String = raw_line.strip_edges()
        if stripped == "":
            continue
        var parsed: Variant = JSON.parse_string(stripped)
        if parsed is Dictionary and int((parsed as Dictionary).get("seq", 0)) > watermark_seq:
            keep.append(stripped)
    return keep


# --- Applied-seq watermark IO ---

# Read the watermark seq stored alongside the journal. Returns 0 when the
# file is missing, unreadable, or contains a non-integer.
static func read_applied_seq(applied_seq_path: String) -> int:
    if applied_seq_path == "" or not FileAccess.file_exists(applied_seq_path):
        return 0
    var file: FileAccess = FileAccess.open(applied_seq_path, FileAccess.READ)
    if file == null:
        return 0
    var raw: String = file.get_as_text().strip_edges()
    file.close()
    return int(raw) if raw.is_valid_int() else 0


# Persist the watermark seq atomically. Negative / zero values are ignored
# so a partial save never regresses the watermark.
static func write_applied_seq(applied_seq_path: String, seq: int) -> bool:
    if applied_seq_path == "" or seq <= 0:
        return false
    return CoopIO.atomic_write_file(applied_seq_path, str(seq))


# --- Append + compact ---

# Crash-safe append: JSON-stringify `record` and atomically append the line.
static func append_record(journal_path: String, record: Dictionary) -> bool:
    if journal_path == "":
        return false
    return CoopIO.atomic_append_line(journal_path, JSON.stringify(record))


# Crash-safe compact. Persists the watermark first (so even a rename failure
# does not double-apply on next boot), then atomically rewrites the journal
# keeping only the records that were appended while the save was in flight
# (seq > watermark_seq).
#
# Returns { ok: bool, kept_lines: int, watermark_seq: int }. `ok` is false
# only when the atomic rewrite fails; the watermark is always persisted
# regardless.
static func compact_after_save(journal_path: String, applied_seq_path: String, watermark_seq: int) -> Dictionary:
    var result: Dictionary = {
        "ok": true,
        "kept_lines": 0,
        "watermark_seq": watermark_seq,
    }
    if watermark_seq > 0:
        write_applied_seq(applied_seq_path, watermark_seq)
    if journal_path == "" or not FileAccess.file_exists(journal_path):
        return result

    var text: String = ""
    var read_file: FileAccess = FileAccess.open(journal_path, FileAccess.READ)
    if read_file != null:
        text = read_file.get_as_text()
        read_file.close()

    var keep_lines: PackedStringArray = compute_keep_lines(text, watermark_seq)
    var content: String = ""
    for line_text in keep_lines:
        content += line_text + "\n"
    if not CoopIO.atomic_write_file(journal_path, content):
        result["ok"] = false
        return result
    result["kept_lines"] = keep_lines.size()
    return result
