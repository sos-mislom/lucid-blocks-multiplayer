extends RefCounted


# In-test predicate state: tests use a small RefCounted wrapper to expose
# Callables that close over the predicate's response. GDScript doesn't
# allow plain lambdas as static-method targets, so this is the cleanest
# way to drive the Callable branches.

class _AlwaysSafe extends RefCounted:
    func is_safe(_position: Vector3) -> bool:
        return true

class _NeverSafe extends RefCounted:
    func is_safe(_position: Vector3) -> bool:
        return false

class _FindSafeStub extends RefCounted:
    var last_anchor: Vector3 = Vector3.ZERO
    var last_fallback: Vector3 = Vector3.ZERO
    var return_value: Vector3 = Vector3(999.0, 999.0, 999.0)
    func find(anchor: Vector3, fallback: Vector3) -> Vector3:
        last_anchor = anchor
        last_fallback = fallback
        return return_value


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.compute_safe_downed_position returns fallback when current is below void_y")
    var below: Vector3 = CoopRevive.compute_safe_downed_position(
        Vector3(5.0, -200.0, 5.0),
        Vector3(0.0, 8.0, 0.0),
        -96.0,
        Callable(_AlwaysSafe.new(), "is_safe"),
        Callable(_FindSafeStub.new(), "find"),
    )
    t.assert_eq(Vector3(0.0, 8.0, 0.0), below)

    t.begin("CoopRevive.compute_safe_downed_position returns centered current when current is at void_y boundary (y == void_y -> fallback)")
    var on_void: Vector3 = CoopRevive.compute_safe_downed_position(
        Vector3(5.0, -96.0, 5.0),
        Vector3(0.0, 8.0, 0.0),
        -96.0,
        Callable(_AlwaysSafe.new(), "is_safe"),
        Callable(_FindSafeStub.new(), "find"),
    )
    t.assert_eq(Vector3(0.0, 8.0, 0.0), on_void, "y == void_y triggers fallback (live `<=` comparison)")

    t.begin("CoopRevive.compute_safe_downed_position above void with safe centered position returns centered current")
    var centered: Vector3 = CoopRevive.compute_safe_downed_position(
        Vector3(5.4, 12.3, 7.8),
        Vector3(0.0, 8.0, 0.0),
        -96.0,
        Callable(_AlwaysSafe.new(), "is_safe"),
        Callable(_FindSafeStub.new(), "find"),
    )
    t.assert_eq(Vector3(5.0 + 0.5, 12.0, 7.0 + 0.5), centered,
        "floor() + (0.5, 0, 0.5) preserves the live centering")

    t.begin("CoopRevive.compute_safe_downed_position above void with unsafe centered position calls find_safe_near")
    var find_stub: _FindSafeStub = _FindSafeStub.new()
    find_stub.return_value = Vector3(42.5, 42.0, 42.5)
    var refined: Vector3 = CoopRevive.compute_safe_downed_position(
        Vector3(5.4, 12.3, 7.8),
        Vector3(0.0, 8.0, 0.0),
        -96.0,
        Callable(_NeverSafe.new(), "is_safe"),
        Callable(find_stub, "find"),
    )
    t.assert_eq(Vector3(42.5, 42.0, 42.5), refined)
    t.assert_eq(Vector3(5.5, 12.0, 7.5), find_stub.last_anchor,
        "centered position passed as anchor to find_safe_near")
    t.assert_eq(Vector3(0.0, 8.0, 0.0), find_stub.last_fallback,
        "original fallback passed through to find_safe_near")

    t.begin("CoopRevive.compute_safe_downed_position invalid is_safe Callable treated as 'always safe' -> returns centered")
    var safe_default: Vector3 = CoopRevive.compute_safe_downed_position(
        Vector3(5.4, 12.3, 7.8),
        Vector3(0.0, 8.0, 0.0),
        -96.0,
        Callable(),
        Callable(_FindSafeStub.new(), "find"),
    )
    t.assert_eq(Vector3(5.5, 12.0, 7.5), safe_default,
        "no is_safe predicate -> treat as safe (matches `is_instance_valid(Ref.world)` early-return)")

    t.begin("CoopRevive.compute_safe_downed_position invalid find_safe_near Callable with unsafe centered -> returns fallback")
    var no_finder: Vector3 = CoopRevive.compute_safe_downed_position(
        Vector3(5.4, 12.3, 7.8),
        Vector3(11.0, 22.0, 33.0),
        -96.0,
        Callable(_NeverSafe.new(), "is_safe"),
        Callable(),
    )
    t.assert_eq(Vector3(11.0, 22.0, 33.0), no_finder,
        "no find_safe_near -> fall back to fallback_position")

    t.begin("CoopRevive.compute_safe_downed_position custom center_offset is honoured")
    var custom: Vector3 = CoopRevive.compute_safe_downed_position(
        Vector3(5.4, 12.3, 7.8),
        Vector3.ZERO,
        -96.0,
        Callable(_AlwaysSafe.new(), "is_safe"),
        Callable(_FindSafeStub.new(), "find"),
        Vector3(0.0, 0.0, 0.0),
    )
    t.assert_eq(Vector3(5.0, 12.0, 7.0), custom,
        "center_offset=ZERO -> result is plain floor()")
