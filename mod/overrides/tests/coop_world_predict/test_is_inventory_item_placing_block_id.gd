extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldPredict.is_inventory_item_placing_block_id item_id == block_id -> true (regardless of flags)")
    t.assert_true(CoopWorldPredict.is_inventory_item_placing_block_id(5, 5, false, false))
    t.assert_true(CoopWorldPredict.is_inventory_item_placing_block_id(5, 5, true, true))

    t.begin("CoopWorldPredict.is_inventory_item_placing_block_id item does not resolve to Block -> false")
    t.assert_false(CoopWorldPredict.is_inventory_item_placing_block_id(5, 6, false, true))

    t.begin("CoopWorldPredict.is_inventory_item_placing_block_id non-directional Block -> false (only exact match works)")
    t.assert_false(CoopWorldPredict.is_inventory_item_placing_block_id(5, 6, true, false))

    t.begin("CoopWorldPredict.is_inventory_item_placing_block_id directional Block with block_id in [item+1, item+6] -> true")
    for variant in range(1, 7):
        t.assert_true(CoopWorldPredict.is_inventory_item_placing_block_id(5, 5 + variant, true, true),
            "block_id = item_id + %d should match" % variant)

    t.begin("CoopWorldPredict.is_inventory_item_placing_block_id directional Block with block_id at item+7 -> false")
    t.assert_false(CoopWorldPredict.is_inventory_item_placing_block_id(5, 12, true, true))

    t.begin("CoopWorldPredict.is_inventory_item_placing_block_id custom directional_variant_count honored")
    t.assert_true(CoopWorldPredict.is_inventory_item_placing_block_id(5, 8, true, true, 3))
    t.assert_false(CoopWorldPredict.is_inventory_item_placing_block_id(5, 9, true, true, 3))
