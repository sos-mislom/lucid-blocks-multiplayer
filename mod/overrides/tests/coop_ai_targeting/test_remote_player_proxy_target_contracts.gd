extends RefCounted


func _read_source(path: String) -> String:
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return ""
    var text := file.get_as_text()
    file.close()
    return text


func run(t: CoopTester) -> void:
    t.begin("RemotePlayerProxy is intentionally not an Entity")
    var proxy_source := _read_source("res://coop_mod/remote_player_proxy.gd")
    var proxy_scene := _read_source("res://coop_mod/remote_player_proxy.tscn")
    t.assert_true(proxy_source.contains("extends CharacterBody3D"))
    t.assert_false(proxy_source.contains("extends Entity"))
    t.assert_true(proxy_source.contains("var dead: bool"))
    t.assert_true(proxy_source.contains("var disabled: bool"))
    t.assert_true(proxy_source.contains("var direct_damage_cooldown: bool"))
    t.assert_true(proxy_scene.contains("name=\"Head\""))

    t.begin("Entity.attacked accepts remote-player proxy attackers")
    var entity_source := _read_source("res://main/entity/entity.gd")
    t.assert_true(entity_source.contains("signal on_attacked(attacker)"))
    t.assert_true(entity_source.contains("func attacked(attacker, damage: int)"))
    t.assert_false(entity_source.contains("func attacked(attacker: Entity"))

    t.begin("Hostile target entry points do not cast remote proxies away")
    var manikin_source := _read_source("res://main/entity/manikin/manikin.gd")
    var diatom_source := _read_source("res://main/entity/diatom/diatom.gd")
    var golem_source := _read_source("res://main/entity/golem/golem.gd")
    t.assert_false(manikin_source.contains("attack_target = body as Entity"))
    t.assert_true(manikin_source.contains("body is Entity or _is_session_player_entity(body)"))
    t.assert_true(diatom_source.contains("body is Entity or _is_session_player_entity(body)"))
    t.assert_true(golem_source.contains("entity is Entity or _is_session_player_entity(entity)"))
