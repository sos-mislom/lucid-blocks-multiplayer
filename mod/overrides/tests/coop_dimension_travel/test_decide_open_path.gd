extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDimensionTravel.decide_open_path singleplayer (no live peer) -> local_load, no flush")
    var sp: Dictionary = CoopDimensionTravel.decide_open_path("pocket:alice", "dimension:0", {}, true, false, false)
    t.assert_eq("local_load", str(sp.get("path", "")))
    t.assert_false(bool(sp.get("await_guest_flush", true)))

    t.begin("CoopDimensionTravel.decide_open_path client + host_in_target -> request_world_snapshot")
    var host_state: Dictionary = {"dimension_instance_key": "pocket:alice"}
    var ct: Dictionary = CoopDimensionTravel.decide_open_path("pocket:alice", "dimension:0", host_state, false, true, false)
    t.assert_eq("request_world_snapshot", str(ct.get("path", "")))

    t.begin("CoopDimensionTravel.decide_open_path client + visiting_remote_private (host NOT in target) -> request_world_snapshot")
    var other_host: Dictionary = {"dimension_instance_key": "dimension:0"}
    var crp: Dictionary = CoopDimensionTravel.decide_open_path("pocket:bob", "dimension:0", other_host, false, true, true)
    t.assert_eq("request_world_snapshot", str(crp.get("path", "")))

    t.begin("CoopDimensionTravel.decide_open_path server + cross-instance -> local_load + await_guest_flush=true")
    var sxi: Dictionary = CoopDimensionTravel.decide_open_path("pocket:alice", "dimension:0", {}, true, true, false)
    t.assert_eq("local_load", str(sxi.get("path", "")))
    t.assert_true(bool(sxi.get("await_guest_flush", false)))

    t.begin("CoopDimensionTravel.decide_open_path server + same-instance -> local_load + await_guest_flush=false")
    var ssi: Dictionary = CoopDimensionTravel.decide_open_path("dimension:0", "dimension:0", {}, true, true, false)
    t.assert_eq("local_load", str(ssi.get("path", "")))
    t.assert_false(bool(ssi.get("await_guest_flush", true)))

    t.begin("CoopDimensionTravel.decide_open_path client + cross-instance + host NOT in target + NOT visiting_remote_private -> local_load")
    var cl: Dictionary = CoopDimensionTravel.decide_open_path("dimension:7", "dimension:0", other_host, false, true, false)
    t.assert_eq("local_load", str(cl.get("path", "")))
    t.assert_false(bool(cl.get("await_guest_flush", true)), "client never sets await_guest_flush (server-only flag)")

    t.begin("CoopDimensionTravel.decide_open_path server NEVER takes request_world_snapshot branch (guard)")
    var srv_host_in_target: Dictionary = CoopDimensionTravel.decide_open_path("pocket:alice", "dimension:0", {"dimension_instance_key": "pocket:alice"}, true, true, true)
    t.assert_eq("local_load", str(srv_host_in_target.get("path", "")), "server-side never takes snapshot-request path")
