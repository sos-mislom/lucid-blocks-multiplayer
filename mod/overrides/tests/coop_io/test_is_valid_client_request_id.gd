extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopIO.is_valid_client_request_id rejects 0 and negatives")
    t.assert_false(CoopIO.is_valid_client_request_id(0), "0 must be rejected")
    t.assert_false(CoopIO.is_valid_client_request_id(-1), "-1 must be rejected")
    t.assert_false(CoopIO.is_valid_client_request_id(-2147483647), "very-negative must be rejected")

    t.begin("CoopIO.is_valid_client_request_id accepts positive ints up to INT32_MAX-1")
    t.assert_true(CoopIO.is_valid_client_request_id(1), "1 must be accepted")
    t.assert_true(CoopIO.is_valid_client_request_id(42), "42 must be accepted")
    t.assert_true(CoopIO.is_valid_client_request_id(0x7ffffffe), "INT32_MAX-1 must be accepted")

    t.begin("CoopIO.is_valid_client_request_id rejects INT32_MAX")
    t.assert_false(CoopIO.is_valid_client_request_id(0x7fffffff), "INT32_MAX must be rejected")
