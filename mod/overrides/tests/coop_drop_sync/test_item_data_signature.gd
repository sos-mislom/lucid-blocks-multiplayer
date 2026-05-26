extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopDropSync.item_data_signature empty array -> empty string")
    t.assert_eq("", CoopDropSync.item_data_signature(PackedInt32Array()))

    t.begin("CoopDropSync.item_data_signature single element -> int")
    t.assert_eq("42", CoopDropSync.item_data_signature(PackedInt32Array([42])))

    t.begin("CoopDropSync.item_data_signature multi-element -> colon-joined")
    t.assert_eq("1:2:3", CoopDropSync.item_data_signature(PackedInt32Array([1, 2, 3])))
    t.assert_eq("-5:0:99", CoopDropSync.item_data_signature(PackedInt32Array([-5, 0, 99])))

    t.begin("CoopDropSync.item_data_signature ordering matters")
    var a: String = CoopDropSync.item_data_signature(PackedInt32Array([1, 2]))
    var b: String = CoopDropSync.item_data_signature(PackedInt32Array([2, 1]))
    t.assert_ne(a, b)
