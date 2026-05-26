extends RefCounted


func run(t: CoopTester) -> void:
    var base_payload: Dictionary = {
        "protocol": "lucid-blocks-coop-udp",
        "world_title": "Original Title",
        "ok": true,
    }

    t.begin("CoopStatus.enrich_heartbeat_payload overrides name and world_title from public name")
    var full_config: Dictionary = {
        "server_public_name": "My Server",
        "server_public_address": "1.2.3.4:7777",
        "server_public_region": "eu-west",
    }
    var enriched: Dictionary = CoopStatus.enrich_heartbeat_payload(base_payload, full_config)
    t.assert_eq("My Server", str(enriched.get("name", "")))
    t.assert_eq("My Server", str(enriched.get("world_title", "")))
    t.assert_eq("1.2.3.4:7777", str(enriched.get("address", "")))
    t.assert_eq("eu-west", str(enriched.get("region", "")))

    t.begin("CoopStatus.enrich_heartbeat_payload always rewrites protocol to lucid-blocks-coop-master")
    t.assert_eq("lucid-blocks-coop-master", str(enriched.get("protocol", "")))

    t.begin("CoopStatus.enrich_heartbeat_payload preserves unrelated payload fields")
    t.assert_true(bool(enriched.get("ok", false)))

    t.begin("CoopStatus.enrich_heartbeat_payload returns a copy and does not mutate the input")
    t.assert_eq("Original Title", str(base_payload.get("world_title", "")))
    t.assert_false(base_payload.has("name"))

    t.begin("CoopStatus.enrich_heartbeat_payload leaves name/world_title/address alone for empty config values")
    var empty_config: Dictionary = {"server_public_name": "", "server_public_address": "", "server_public_region": ""}
    var no_overrides: Dictionary = CoopStatus.enrich_heartbeat_payload(base_payload, empty_config)
    t.assert_false(no_overrides.has("name"))
    t.assert_false(no_overrides.has("address"))
    t.assert_eq("Original Title", str(no_overrides.get("world_title", "")))
    t.assert_eq("", str(no_overrides.get("region", "")))
    t.assert_eq("lucid-blocks-coop-master", str(no_overrides.get("protocol", "")))

    t.begin("CoopStatus.enrich_heartbeat_payload defaults region to 'public' when key is missing")
    var defaulted: Dictionary = CoopStatus.enrich_heartbeat_payload(base_payload, {})
    t.assert_eq("public", str(defaulted.get("region", "")))
