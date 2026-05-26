extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldSnapshot.build_peer_persistent_snapshot_overrides both slots present")
    var out: Dictionary = CoopWorldSnapshot.build_peer_persistent_snapshot_overrides(
        {"items": [1, 2, 3], "tiamana": 50},
        {"position": Vector3(5, 5, 5)},
        "dim_overworld",
    )
    t.assert_eq(2, out.size())
    t.assert_true(out.has("node/player"))
    t.assert_true(out.has("dim_overworld/node/player"))
    var global_slot: Dictionary = out["node/player"]
    t.assert_eq(50, int(global_slot.get("tiamana", 0)))
    var dim_slot: Dictionary = out["dim_overworld/node/player"]
    t.assert_eq(Vector3(5, 5, 5), dim_slot.get("position", Vector3.ZERO))

    t.begin("CoopWorldSnapshot.build_peer_persistent_snapshot_overrides empty namespace omits dimensional slot")
    var no_ns: Dictionary = CoopWorldSnapshot.build_peer_persistent_snapshot_overrides(
        {"items": [1]}, {"items": [2]}, "",
    )
    t.assert_eq(1, no_ns.size())
    t.assert_true(no_ns.has("node/player"))
    t.assert_false(no_ns.has("/node/player"), "no leading-slash path leaks when namespace is empty")

    t.begin("CoopWorldSnapshot.build_peer_persistent_snapshot_overrides global slot missing -> dimensional only")
    var dim_only: Dictionary = CoopWorldSnapshot.build_peer_persistent_snapshot_overrides(
        null, {"position": Vector3(1, 1, 1)}, "dim_overworld",
    )
    t.assert_eq(1, dim_only.size())
    t.assert_false(dim_only.has("node/player"))
    t.assert_true(dim_only.has("dim_overworld/node/player"))

    t.begin("CoopWorldSnapshot.build_peer_persistent_snapshot_overrides both slots missing -> {}")
    var none: Dictionary = CoopWorldSnapshot.build_peer_persistent_snapshot_overrides(null, null, "dim_overworld")
    t.assert_eq(0, none.size())

    t.begin("CoopWorldSnapshot.build_peer_persistent_snapshot_overrides non-Dictionary inputs are skipped")
    var with_junk: Dictionary = CoopWorldSnapshot.build_peer_persistent_snapshot_overrides(
        "garbage", 42, "dim_overworld",
    )
    t.assert_eq(0, with_junk.size())

    t.begin("CoopWorldSnapshot.build_peer_persistent_snapshot_overrides values are deep-copied (source-poison safety)")
    var source_global: Dictionary = {"items": [1, 2, 3]}
    var out_safety: Dictionary = CoopWorldSnapshot.build_peer_persistent_snapshot_overrides(
        source_global, null, "",
    )
    out_safety["node/player"]["items"][0] = 999
    t.assert_eq(1, int(source_global["items"][0]), "mutating override must not poison source")
