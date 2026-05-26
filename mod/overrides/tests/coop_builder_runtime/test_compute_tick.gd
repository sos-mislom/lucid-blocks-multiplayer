extends RefCounted

# CoopBuilderRuntime.compute_tick - server gating, day-lock action,
# peaceful timer arithmetic, default-interval fallback.

var _has_live_peer_value: bool = false
var _is_server_value: bool = true


func _has_live_peer() -> bool:
    return _has_live_peer_value


func _is_server() -> bool:
    return _is_server_value


func _deps() -> Dictionary:
    return {
        "has_live_peer": Callable(self, "_has_live_peer"),
        "is_server": Callable(self, "_is_server"),
    }


func run(t: CoopTester) -> void:
    t.begin("CoopBuilderRuntime.compute_tick no-ops when a live peer exists and we are not the server")
    _has_live_peer_value = true
    _is_server_value = false
    var gated: Dictionary = CoopBuilderRuntime.compute_tick(0.5, {
        "peaceful_enabled": true,
        "day_lock_enabled": true,
        "peaceful_sweep_timer": 0.3,
        "peaceful_sweep_interval": 1.0,
    }, _deps())
    t.assert_false(bool(gated["actions"]["apply_day_lock"]))
    t.assert_false(bool(gated["actions"]["apply_peaceful"]))
    t.assert_eq(0.3, float(gated["state"]["peaceful_sweep_timer"]), "timer must not decrement when gated")

    t.begin("CoopBuilderRuntime.compute_tick fires regardless of is_server when no live peer (singleplayer)")
    _has_live_peer_value = false
    _is_server_value = false
    var single: Dictionary = CoopBuilderRuntime.compute_tick(0.1, {
        "peaceful_enabled": false,
        "day_lock_enabled": true,
        "peaceful_sweep_timer": 0.0,
    }, _deps())
    t.assert_true(bool(single["actions"]["apply_day_lock"]), "day-lock fires in singleplayer")

    t.begin("CoopBuilderRuntime.compute_tick fires day-lock every tick when enabled (server-side)")
    _has_live_peer_value = true
    _is_server_value = true
    var server_tick: Dictionary = CoopBuilderRuntime.compute_tick(0.1, {
        "peaceful_enabled": false,
        "day_lock_enabled": true,
        "peaceful_sweep_timer": 5.0,
    }, _deps())
    t.assert_true(bool(server_tick["actions"]["apply_day_lock"]))
    t.assert_false(bool(server_tick["actions"]["apply_peaceful"]))
    t.assert_eq(5.0, float(server_tick["state"]["peaceful_sweep_timer"]), "timer unchanged when peaceful disabled")

    t.begin("CoopBuilderRuntime.compute_tick decrements peaceful timer by delta and skips the sweep until <= 0")
    _is_server_value = true
    var ticking: Dictionary = CoopBuilderRuntime.compute_tick(0.25, {
        "peaceful_enabled": true,
        "day_lock_enabled": false,
        "peaceful_sweep_timer": 1.0,
        "peaceful_sweep_interval": 1.0,
    }, _deps())
    t.assert_eq(0.75, float(ticking["state"]["peaceful_sweep_timer"]))
    t.assert_false(bool(ticking["actions"]["apply_peaceful"]))

    t.begin("CoopBuilderRuntime.compute_tick fires peaceful sweep and resets timer when delta drains it")
    var firing: Dictionary = CoopBuilderRuntime.compute_tick(2.0, {
        "peaceful_enabled": true,
        "day_lock_enabled": false,
        "peaceful_sweep_timer": 0.5,
        "peaceful_sweep_interval": 1.5,
    }, _deps())
    t.assert_true(bool(firing["actions"]["apply_peaceful"]))
    t.assert_eq(1.5, float(firing["state"]["peaceful_sweep_timer"]), "timer resets to peaceful_sweep_interval")

    t.begin("CoopBuilderRuntime.compute_tick falls back to PEACEFUL_SWEEP_INTERVAL_SEC when interval key absent")
    var defaulting: Dictionary = CoopBuilderRuntime.compute_tick(1.0, {
        "peaceful_enabled": true,
        "day_lock_enabled": false,
        "peaceful_sweep_timer": 0.0,
    }, _deps())
    t.assert_true(bool(defaulting["actions"]["apply_peaceful"]))
    t.assert_eq(CoopBuilderRuntime.PEACEFUL_SWEEP_INTERVAL_SEC, float(defaulting["state"]["peaceful_sweep_timer"]))

    t.begin("CoopBuilderRuntime.compute_tick treats invalid is_server callable as server (singleplayer fallback)")
    _has_live_peer_value = true
    var invalid_server: Dictionary = CoopBuilderRuntime.compute_tick(0.1, {
        "peaceful_enabled": false,
        "day_lock_enabled": true,
        "peaceful_sweep_timer": 0.0,
    }, {
        "has_live_peer": Callable(self, "_has_live_peer"),
        "is_server": Callable(),
    })
    t.assert_true(bool(invalid_server["actions"]["apply_day_lock"]), "invalid is_server defaults to true so the gate falls through")

    t.begin("CoopBuilderRuntime.compute_tick treats invalid has_live_peer callable as no live peer")
    _has_live_peer_value = true
    _is_server_value = false
    var invalid_live: Dictionary = CoopBuilderRuntime.compute_tick(0.1, {
        "peaceful_enabled": false,
        "day_lock_enabled": true,
        "peaceful_sweep_timer": 0.0,
    }, {
        "has_live_peer": Callable(),
        "is_server": Callable(self, "_is_server"),
    })
    t.assert_true(bool(invalid_live["actions"]["apply_day_lock"]), "invalid has_live_peer defaults to false so the gate is bypassed")
