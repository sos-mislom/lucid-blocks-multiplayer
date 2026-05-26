extends RefCounted

# PackedStringArray(...) is not a constant expression in GDScript 4, so we
# build the typed array at instantiation time. `is_safe_resource_path`
# requires a typed PackedStringArray parameter.
var PREFIXES: PackedStringArray = PackedStringArray(["res://main/entity/"])
const PLAYER_PREFIX: String = "res://main/entity/player/"


func run(t: CoopTester) -> void:
    var loader_all_ok: Callable = func(_p: String) -> bool: return true
    var loader_none: Callable = func(_p: String) -> bool: return false

    t.begin("CoopAuthorityValidator.is_safe_resource_path rejects empty / whitespace")
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("", PREFIXES, true, loader_all_ok))
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("    ", PREFIXES, true, loader_all_ok))

    t.begin("CoopAuthorityValidator.is_safe_resource_path rejects path traversal and backslash")
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("res://main/entity/../foo.tscn", PREFIXES, true, loader_all_ok))
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("res://main/entity\\sheep.tscn", PREFIXES, true, loader_all_ok))

    t.begin("CoopAuthorityValidator.is_safe_resource_path rejects paths outside res://")
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("user://foo.tscn", PREFIXES, true, loader_all_ok))
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("/etc/passwd", PREFIXES, true, loader_all_ok))

    t.begin("CoopAuthorityValidator.is_safe_resource_path enforces scene-only when requested")
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("res://main/entity/sheep/sheep.gd", PREFIXES, true, loader_all_ok))
    t.assert_true(CoopAuthorityValidator.is_safe_resource_path("res://main/entity/sheep/sheep.gd", PREFIXES, false, loader_all_ok))

    t.begin("CoopAuthorityValidator.is_safe_resource_path rejects paths outside allowed prefixes")
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("res://addons/foo.tscn", PREFIXES, true, loader_all_ok))

    t.begin("CoopAuthorityValidator.is_safe_resource_path always rejects the player prefix")
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("res://main/entity/player/player.tscn", PREFIXES, true, loader_all_ok))

    t.begin("CoopAuthorityValidator.is_safe_resource_path rejects overlong paths")
    var long_path: String = "res://main/entity/" + "a".repeat(300) + ".tscn"
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path(long_path, PREFIXES, true, loader_all_ok))

    t.begin("CoopAuthorityValidator.is_safe_resource_path falls through to the loader stub")
    t.assert_true(CoopAuthorityValidator.is_safe_resource_path("res://main/entity/sheep/sheep.tscn", PREFIXES, true, loader_all_ok))
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("res://main/entity/sheep/sheep.tscn", PREFIXES, true, loader_none))

    t.begin("CoopAuthorityValidator.is_safe_resource_path rejects when loader callable is invalid")
    t.assert_false(CoopAuthorityValidator.is_safe_resource_path("res://main/entity/sheep/sheep.tscn", PREFIXES, true, Callable()))
