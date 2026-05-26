extends RefCounted

# CoopBuilderRuntime constants - lock the canonical values so a future
# rename or accidental tweak surfaces in CI immediately.


func run(t: CoopTester) -> void:
    t.begin("CoopBuilderRuntime.DAY_TIME_OF_DAY pins the /daylock value at 0.25 (mid-day)")
    t.assert_eq(0.25, CoopBuilderRuntime.DAY_TIME_OF_DAY)

    t.begin("CoopBuilderRuntime.PEACEFUL_SWEEP_INTERVAL_SEC pins the peaceful sweep cadence at 1.0s")
    t.assert_eq(1.0, CoopBuilderRuntime.PEACEFUL_SWEEP_INTERVAL_SEC)

    t.begin("CoopBuilderRuntime.DAY_LOCK_RESPONSE keeps the canonical chat-feedback string")
    t.assert_eq("Time locked to day", CoopBuilderRuntime.DAY_LOCK_RESPONSE)
