extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDedicatedBootstrap.build_server_world_seal_payload pins fields and order")
    var payload: String = CoopDedicatedBootstrap.build_server_world_seal_payload(
        1,
        "abc-123",
        ["file_a=hashA", "file_b=hashB"],
    )
    var parsed = JSON.parse_string(payload)
    t.assert_eq(true, parsed is Dictionary)
    var dict: Dictionary = parsed as Dictionary
    t.assert_eq(1, int(dict.get("version", 0)))
    t.assert_eq("abc-123", str(dict.get("uuid", "")))
    var files: Array = dict.get("files", []) as Array
    t.assert_eq(2, files.size())
    t.assert_eq("file_a=hashA", files[0])
    t.assert_eq("file_b=hashB", files[1])

    t.begin("CoopDedicatedBootstrap.build_server_world_seal_payload empty file list yields empty array")
    payload = CoopDedicatedBootstrap.build_server_world_seal_payload(1, "abc-123", [])
    parsed = JSON.parse_string(payload)
    t.assert_eq(0, ((parsed as Dictionary).get("files", []) as Array).size())

    t.begin("CoopDedicatedBootstrap.compute_server_world_seal_hash deterministic for fixed inputs")
    var hash_a: String = CoopDedicatedBootstrap.compute_server_world_seal_hash("secret", "payload")
    var hash_b: String = CoopDedicatedBootstrap.compute_server_world_seal_hash("secret", "payload")
    t.assert_eq(hash_a, hash_b)
    t.assert_eq(64, hash_a.length())

    t.begin("CoopDedicatedBootstrap.compute_server_world_seal_hash secret change -> different hash")
    var hash_with_secret_a: String = CoopDedicatedBootstrap.compute_server_world_seal_hash("alpha", "payload")
    var hash_with_secret_b: String = CoopDedicatedBootstrap.compute_server_world_seal_hash("beta", "payload")
    t.assert_eq(true, hash_with_secret_a != hash_with_secret_b)

    t.begin("CoopDedicatedBootstrap.compute_server_world_seal_hash payload change -> different hash")
    var hash_with_payload_a: String = CoopDedicatedBootstrap.compute_server_world_seal_hash("secret", "alpha")
    var hash_with_payload_b: String = CoopDedicatedBootstrap.compute_server_world_seal_hash("secret", "beta")
    t.assert_eq(true, hash_with_payload_a != hash_with_payload_b)

    t.begin("CoopDedicatedBootstrap.compute_server_world_seal_hash includes newline separator")
    # If implementation accidentally drops the newline, "ab\ncd" would
    # collide with "abcd".  Verify they produce different hashes.
    var hash_with_newline: String = CoopDedicatedBootstrap.compute_server_world_seal_hash("ab", "cd")
    var hash_without_newline: String = ("abcd").sha256_text()
    t.assert_eq(true, hash_with_newline != hash_without_newline)
