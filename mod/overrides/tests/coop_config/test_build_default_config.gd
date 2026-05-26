extends RefCounted


func run(t: CoopTester) -> void:
    var policy: Dictionary = {"give": "owner"}

    var cfg: Dictionary = CoopConfig.build_default_config(
        12345,
        "default_blocky",
        true,
        false,
        true,
        false,
        180,
        96.0,
        72.0,
        policy,
    )

    t.begin("CoopConfig.build_default_config returns the canonical wire shape")
    t.assert_eq("127.0.0.1", cfg.get("address"))
    t.assert_eq(12345, cfg.get("port"))
    t.assert_eq("default_blocky", cfg.get("avatar_id"))
    t.assert_eq("", cfg.get("server_registry_url"))
    t.assert_eq("", cfg.get("server_registry_heartbeat_url"))
    t.assert_eq("", cfg.get("server_registry_token"))
    t.assert_eq("", cfg.get("server_public_address"))
    t.assert_eq("", cfg.get("server_public_name"))
    t.assert_eq("public", cfg.get("server_public_region"))
    t.assert_eq(false, cfg.get("show_direct_connect_tab"))
    t.assert_eq(true, cfg.get("enable_debug_console_commands"))
    t.assert_eq(false, cfg.get("enable_client_visual_mod"))
    t.assert_eq(true, cfg.get("enable_avatar_customization"))
    t.assert_eq(false, cfg.get("enable_avatar_alias_command"))
    t.assert_eq(180, cfg.get("server_registry_cache_ttl_sec"))
    t.assert_eq(96.0, cfg.get("server_entity_view_radius"))
    t.assert_eq(72.0, cfg.get("server_entity_simulation_radius"))
    t.assert_eq(policy, cfg.get("server_command_policy"))
    t.assert_eq([], cfg.get("server_admin_keys"))

    t.begin("CoopConfig.build_default_config returns the expected key set (no extras)")
    var expected_keys: Array = [
        "address",
        "port",
        "avatar_id",
        "server_registry_url",
        "server_registry_heartbeat_url",
        "server_registry_token",
        "server_public_address",
        "server_public_name",
        "server_public_region",
        "show_direct_connect_tab",
        "enable_debug_console_commands",
        "enable_client_visual_mod",
        "enable_avatar_customization",
        "enable_avatar_alias_command",
        "server_registry_cache_ttl_sec",
        "server_entity_view_radius",
        "server_entity_simulation_radius",
        "server_command_policy",
        "server_admin_keys",
    ]
    t.assert_eq(expected_keys.size(), cfg.size())
    for key in expected_keys:
        t.assert_true(cfg.has(key), "missing default config key: %s" % key)

    t.begin("CoopConfig.build_default_config passes the policy dict through by reference")
    # The forwarder deep-duplicates DEFAULT_SERVER_COMMAND_POLICY before
    # threading it in, but the module itself does NOT duplicate - that contract
    # lives on coop_manager.gd. Verify same identity here.
    t.assert_eq(true, cfg.get("server_command_policy") == policy)
