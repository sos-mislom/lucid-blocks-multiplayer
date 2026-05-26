extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopIO.bounded_dict_set inserts when under cap")
    var d: Dictionary = {}
    t.assert_true(CoopIO.bounded_dict_set(d, "a", 1, 3), "insert should succeed")
    t.assert_eq(1, d.size(), "size after first insert")
    t.assert_eq(1, d.get("a"), "value at key a")

    t.begin("CoopIO.bounded_dict_set FIFO-evicts at cap")
    d = {}
    CoopIO.bounded_dict_set(d, "a", 1, 2)
    CoopIO.bounded_dict_set(d, "b", 2, 2)
    CoopIO.bounded_dict_set(d, "c", 3, 2)
    t.assert_eq(2, d.size(), "size should remain at cap")
    t.assert_false(d.has("a"), "oldest key a should have been evicted")
    t.assert_true(d.has("b"), "b should remain")
    t.assert_true(d.has("c"), "c should remain")

    t.begin("CoopIO.bounded_dict_set does not evict when updating existing key at cap")
    d = {}
    CoopIO.bounded_dict_set(d, "a", 1, 2)
    CoopIO.bounded_dict_set(d, "b", 2, 2)
    CoopIO.bounded_dict_set(d, "a", 999, 2)
    t.assert_eq(2, d.size(), "size unchanged when updating existing key")
    t.assert_eq(999, d.get("a"), "value should be updated")
    t.assert_eq(2, d.get("b"), "b should remain")

    t.begin("CoopIO.bounded_dict_set treats max_entries <= 0 as uncapped")
    d = {}
    CoopIO.bounded_dict_set(d, "a", 1, 0)
    CoopIO.bounded_dict_set(d, "b", 2, 0)
    CoopIO.bounded_dict_set(d, "c", 3, -5)
    t.assert_eq(3, d.size(), "no eviction when max_entries <= 0")

    t.begin("CoopIO.bounded_dict_set evicts multiple entries when already over cap")
    d = {}
    CoopIO.bounded_dict_set(d, "a", 1, 10)
    CoopIO.bounded_dict_set(d, "b", 2, 10)
    CoopIO.bounded_dict_set(d, "c", 3, 10)
    CoopIO.bounded_dict_set(d, "d", 4, 10)
    CoopIO.bounded_dict_set(d, "e", 5, 2)
    t.assert_eq(2, d.size(), "should shrink to new cap")
    t.assert_true(d.has("e"), "newest key must be present")
