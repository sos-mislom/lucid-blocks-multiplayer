extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerRegistry.is_response_code_ok accepts 200/204/299")
    t.assert_eq(true, CoopServerRegistry.is_response_code_ok(200))
    t.assert_eq(true, CoopServerRegistry.is_response_code_ok(201))
    t.assert_eq(true, CoopServerRegistry.is_response_code_ok(204))
    t.assert_eq(true, CoopServerRegistry.is_response_code_ok(299))

    t.begin("CoopServerRegistry.is_response_code_ok rejects 199 / 300+ / 0")
    t.assert_eq(false, CoopServerRegistry.is_response_code_ok(199))
    t.assert_eq(false, CoopServerRegistry.is_response_code_ok(300))
    t.assert_eq(false, CoopServerRegistry.is_response_code_ok(404))
    t.assert_eq(false, CoopServerRegistry.is_response_code_ok(500))
    t.assert_eq(false, CoopServerRegistry.is_response_code_ok(0))

    t.begin("CoopServerRegistry.is_response_code_ok rejects negative")
    t.assert_eq(false, CoopServerRegistry.is_response_code_ok(-1))
