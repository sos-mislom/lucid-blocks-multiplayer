extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopServerRegistry.extract_servers_list_from_data dict.servers Array")
    var entries: Array = [{"name": "alpha"}, {"name": "beta"}]
    var result: Array = CoopServerRegistry.extract_servers_list_from_data({"servers": entries})
    t.assert_eq(2, result.size())
    t.assert_eq("alpha", (result[0] as Dictionary).get("name"))
    t.assert_eq("beta", (result[1] as Dictionary).get("name"))

    t.begin("CoopServerRegistry.extract_servers_list_from_data dict.servers result is deep duplicate")
    var source: Array = [{"name": "alpha"}]
    var dup_result: Array = CoopServerRegistry.extract_servers_list_from_data({"servers": source})
    (dup_result[0] as Dictionary)["name"] = "mutated"
    t.assert_eq("alpha", (source[0] as Dictionary).get("name"))

    t.begin("CoopServerRegistry.extract_servers_list_from_data bare Array -> deep duplicate")
    var bare_source: Array = [{"name": "gamma"}]
    var bare_result: Array = CoopServerRegistry.extract_servers_list_from_data(bare_source)
    t.assert_eq(1, bare_result.size())
    (bare_result[0] as Dictionary)["name"] = "mutated"
    t.assert_eq("gamma", (bare_source[0] as Dictionary).get("name"))

    t.begin("CoopServerRegistry.extract_servers_list_from_data missing servers key -> empty")
    result = CoopServerRegistry.extract_servers_list_from_data({"other": "stuff"})
    t.assert_eq(0, result.size())

    t.begin("CoopServerRegistry.extract_servers_list_from_data servers value not an Array -> empty")
    result = CoopServerRegistry.extract_servers_list_from_data({"servers": "not_array"})
    t.assert_eq(0, result.size())

    t.begin("CoopServerRegistry.extract_servers_list_from_data null -> empty")
    result = CoopServerRegistry.extract_servers_list_from_data(null)
    t.assert_eq(0, result.size())

    t.begin("CoopServerRegistry.extract_servers_list_from_data scalar -> empty")
    result = CoopServerRegistry.extract_servers_list_from_data("string")
    t.assert_eq(0, result.size())
    result = CoopServerRegistry.extract_servers_list_from_data(42)
    t.assert_eq(0, result.size())
