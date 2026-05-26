extends RefCounted

# CoopBuilderRuntime.select_entities_to_despawn - filter that decides
# which scene-tree nodes the peaceful sweep should queue_free.
#
# Tests use raw Node instances as the corpus and a simple "entity
# marker" set as the is_entity_value predicate. No CharacterBody3D
# instantiation needed - the pure module never names Entity.

var _entity_markers: Dictionary = {}


func _is_entity_value(value) -> bool:
    return _entity_markers.has(value)


func run(t: CoopTester) -> void:
    var player: Node = Node.new()
    var mob_a: Node = Node.new()
    var mob_b: Node = Node.new()
    var prop: Node = Node.new()
    _entity_markers = {mob_a: true, mob_b: true}

    t.begin("CoopBuilderRuntime.select_entities_to_despawn includes entities and excludes player")
    var picked: Array = CoopBuilderRuntime.select_entities_to_despawn(
        [player, mob_a, prop, mob_b],
        player,
        Callable(self, "_is_entity_value"),
    )
    t.assert_eq(2, picked.size())
    t.assert_true(picked.has(mob_a))
    t.assert_true(picked.has(mob_b))
    t.assert_false(picked.has(player), "player must be excluded even if it passes is_entity_value")
    t.assert_false(picked.has(prop), "non-entities skipped")

    t.begin("CoopBuilderRuntime.select_entities_to_despawn excludes player even when player is an entity marker")
    _entity_markers[player] = true
    var picked_with_player_entity: Array = CoopBuilderRuntime.select_entities_to_despawn(
        [player, mob_a],
        player,
        Callable(self, "_is_entity_value"),
    )
    t.assert_eq(1, picked_with_player_entity.size())
    t.assert_true(picked_with_player_entity.has(mob_a))
    t.assert_false(picked_with_player_entity.has(player), "player exclusion is identity-based, not predicate-based")
    _entity_markers.erase(player)

    t.begin("CoopBuilderRuntime.select_entities_to_despawn handles empty input")
    t.assert_eq(0, CoopBuilderRuntime.select_entities_to_despawn([], player, Callable(self, "_is_entity_value")).size())

    t.begin("CoopBuilderRuntime.select_entities_to_despawn returns empty when is_entity_value callable is invalid")
    t.assert_eq(0, CoopBuilderRuntime.select_entities_to_despawn([mob_a, mob_b], player, Callable()).size(), "defensive guard prevents accidental scene-wide despawn")

    t.begin("CoopBuilderRuntime.select_entities_to_despawn preserves input order")
    var ordered: Array = CoopBuilderRuntime.select_entities_to_despawn(
        [mob_b, prop, mob_a, player],
        player,
        Callable(self, "_is_entity_value"),
    )
    t.assert_eq(2, ordered.size())
    t.assert_eq(mob_b, ordered[0])
    t.assert_eq(mob_a, ordered[1])

    player.free()
    mob_a.free()
    mob_b.free()
    prop.free()
