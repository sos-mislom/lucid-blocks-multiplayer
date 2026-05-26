extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropPredict.predicted_drop_signature_matches empty query -> false")
    t.assert_false(CoopDropPredict.predicted_drop_signature_matches("42:1", ""))
    t.assert_false(CoopDropPredict.predicted_drop_signature_matches("", ""))

    t.begin("CoopDropPredict.predicted_drop_signature_matches mismatched signature -> false")
    t.assert_false(CoopDropPredict.predicted_drop_signature_matches("42:1", "42:2"))
    t.assert_false(CoopDropPredict.predicted_drop_signature_matches("", "42:1"))

    t.begin("CoopDropPredict.predicted_drop_signature_matches identical signature -> true")
    t.assert_true(CoopDropPredict.predicted_drop_signature_matches("42:1", "42:1"))
    t.assert_true(CoopDropPredict.predicted_drop_signature_matches("hash", "hash"))

    t.begin("CoopDropPredict.is_predicted_drop_within_match_distance same position -> true")
    t.assert_true(CoopDropPredict.is_predicted_drop_within_match_distance(Vector3.ZERO, Vector3.ZERO))

    t.begin("CoopDropPredict.is_predicted_drop_within_match_distance within default radius (2.5m) -> true")
    t.assert_true(CoopDropPredict.is_predicted_drop_within_match_distance(Vector3.ZERO, Vector3(2.0, 0.0, 0.0)))
    t.assert_true(CoopDropPredict.is_predicted_drop_within_match_distance(Vector3.ZERO, Vector3(2.5, 0.0, 0.0)))

    t.begin("CoopDropPredict.is_predicted_drop_within_match_distance past default radius -> false")
    t.assert_false(CoopDropPredict.is_predicted_drop_within_match_distance(Vector3.ZERO, Vector3(2.6, 0.0, 0.0)))
    t.assert_false(CoopDropPredict.is_predicted_drop_within_match_distance(Vector3.ZERO, Vector3(10.0, 0.0, 0.0)))

    t.begin("CoopDropPredict.is_predicted_drop_within_match_distance honours override")
    t.assert_true(CoopDropPredict.is_predicted_drop_within_match_distance(Vector3.ZERO, Vector3(5.0, 0.0, 0.0), 10.0))
    t.assert_false(CoopDropPredict.is_predicted_drop_within_match_distance(Vector3.ZERO, Vector3(5.0, 0.0, 0.0), 1.0))
