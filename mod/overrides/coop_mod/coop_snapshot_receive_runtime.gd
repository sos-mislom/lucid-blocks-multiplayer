class_name CoopSnapshotReceiveRuntime
extends RefCounted

# Mutable receive buffer for the authority -> client host-world snapshot.
# RPC handlers and Godot save/world loading stay on coop_manager.gd.

var register_json: String = ""
var chunk_count: int = 0
var chunks: Dictionary = {}
var host_position: Vector3 = Vector3.ZERO
var follow_host_position: bool = false


func clear() -> void:
    register_json = ""
    chunk_count = 0
    chunks.clear()
    host_position = Vector3.ZERO
    follow_host_position = false


func begin(
    next_register_json: String,
    next_chunk_count: int,
    next_host_position: Vector3,
    next_follow_host_position: bool,
) -> void:
    register_json = next_register_json
    chunk_count = next_chunk_count
    chunks.clear()
    host_position = next_host_position
    follow_host_position = next_follow_host_position


func has_register() -> bool:
    return register_json != ""


func received_count() -> int:
    return chunks.size()


func add_chunk(chunk_index: int, data: PackedByteArray) -> void:
    chunks[chunk_index] = data


func total_compressed_bytes_with(next_data: PackedByteArray = PackedByteArray()) -> int:
    var total_bytes: int = next_data.size()
    for chunk in chunks.values():
        if chunk is PackedByteArray:
            total_bytes += (chunk as PackedByteArray).size()
    return total_bytes
