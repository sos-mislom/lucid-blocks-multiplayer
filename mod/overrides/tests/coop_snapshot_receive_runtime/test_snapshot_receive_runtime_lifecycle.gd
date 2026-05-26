extends RefCounted


func run(t: CoopTester) -> void:
    var runtime_script: GDScript = load("res://coop_mod/coop_snapshot_receive_runtime.gd")

    t.begin("CoopSnapshotReceiveRuntime starts empty")
    var runtime = runtime_script.new()
    t.assert_eq(false, runtime.has_register())
    t.assert_eq(0, runtime.chunk_count)
    t.assert_eq(0, runtime.received_count())
    t.assert_eq(Vector3.ZERO, runtime.host_position)
    t.assert_eq(false, runtime.follow_host_position)

    t.begin("CoopSnapshotReceiveRuntime begin resets previous chunks")
    runtime.add_chunk(0, PackedByteArray([1, 2, 3]))
    runtime.begin("{\"title\":\"A\"}", 2, Vector3(1.0, 2.0, 3.0), true)
    t.assert_eq(true, runtime.has_register())
    t.assert_eq("{\"title\":\"A\"}", runtime.register_json)
    t.assert_eq(2, runtime.chunk_count)
    t.assert_eq(0, runtime.received_count())
    t.assert_eq(Vector3(1.0, 2.0, 3.0), runtime.host_position)
    t.assert_eq(true, runtime.follow_host_position)

    t.begin("CoopSnapshotReceiveRuntime add_chunk stores chunks and counts bytes")
    runtime.add_chunk(0, PackedByteArray([1, 2, 3, 4]))
    runtime.add_chunk(1, PackedByteArray([5, 6]))
    t.assert_eq(2, runtime.received_count())
    t.assert_eq(6, runtime.total_compressed_bytes_with())
    t.assert_eq(9, runtime.total_compressed_bytes_with(PackedByteArray([7, 8, 9])))

    t.begin("CoopSnapshotReceiveRuntime clear removes receive state")
    runtime.clear()
    t.assert_eq(false, runtime.has_register())
    t.assert_eq("", runtime.register_json)
    t.assert_eq(0, runtime.chunk_count)
    t.assert_eq(0, runtime.received_count())
    t.assert_eq(Vector3.ZERO, runtime.host_position)
    t.assert_eq(false, runtime.follow_host_position)
