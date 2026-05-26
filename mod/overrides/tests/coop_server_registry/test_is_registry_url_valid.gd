extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerRegistry.is_registry_url_valid accepts https://")
    t.assert_eq(true, CoopServerRegistry.is_registry_url_valid("https://example.org/registry"))

    t.begin("CoopServerRegistry.is_registry_url_valid accepts http://")
    t.assert_eq(true, CoopServerRegistry.is_registry_url_valid("http://example.org/registry"))

    t.begin("CoopServerRegistry.is_registry_url_valid rejects empty")
    t.assert_eq(false, CoopServerRegistry.is_registry_url_valid(""))

    t.begin("CoopServerRegistry.is_registry_url_valid rejects whitespace")
    # Live behavior: the URL is stripped by the caller before this is invoked,
    # so a leading-whitespace URL still fails. This module doesn't strip.
    t.assert_eq(false, CoopServerRegistry.is_registry_url_valid("  https://example.org  "))

    t.begin("CoopServerRegistry.is_registry_url_valid rejects file:// / steam:// / //")
    t.assert_eq(false, CoopServerRegistry.is_registry_url_valid("file:///etc/passwd"))
    t.assert_eq(false, CoopServerRegistry.is_registry_url_valid("steam://join/foo"))
    t.assert_eq(false, CoopServerRegistry.is_registry_url_valid("//example.org/registry"))

    t.begin("CoopServerRegistry.is_registry_url_valid rejects host-only string")
    t.assert_eq(false, CoopServerRegistry.is_registry_url_valid("example.org"))

    t.begin("CoopServerRegistry.is_registry_url_valid rejects uppercase scheme (case-sensitive)")
    # Live behavior: `begins_with` is case-sensitive, so the URL must be lower
    # case. Matches what the live coop_manager.gd does.
    t.assert_eq(false, CoopServerRegistry.is_registry_url_valid("HTTPS://example.org/registry"))
