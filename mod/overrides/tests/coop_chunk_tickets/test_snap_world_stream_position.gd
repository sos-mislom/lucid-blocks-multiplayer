extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopChunkTickets.snap_world_stream_position snaps to chunk centre")
    t.assert_eq(Vector3(8.0, 8.0, 8.0), CoopChunkTickets.snap_world_stream_position(Vector3(5.5, 1.0, 2.0)))

    t.begin("CoopChunkTickets.snap_world_stream_position handles negative coords")
    t.assert_eq(Vector3(-8.0, 8.0, -8.0), CoopChunkTickets.snap_world_stream_position(Vector3(-1.0, 1.0, -1.0)))

    t.begin("CoopChunkTickets.snap_world_stream_position snaps from chunk boundary")
    t.assert_eq(Vector3(24.0, 24.0, 24.0), CoopChunkTickets.snap_world_stream_position(Vector3(16.0, 16.0, 16.0)))

    t.begin("CoopChunkTickets.snap_world_stream_position lands inside chunk for non-aligned position")
    t.assert_eq(Vector3(40.0, -8.0, 8.0), CoopChunkTickets.snap_world_stream_position(Vector3(35.7, -5.0, 0.0)))
