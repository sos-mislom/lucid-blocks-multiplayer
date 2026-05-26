extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopAdmin.slugify passes through lowercase alphanumeric input")
    t.assert_eq("stone", CoopAdmin.slugify("stone"))
    t.assert_eq("block123", CoopAdmin.slugify("block123"))

    t.begin("CoopAdmin.slugify lowercases mixed-case input")
    t.assert_eq("redstone", CoopAdmin.slugify("RedStone"))
    t.assert_eq("redstone", CoopAdmin.slugify("REDSTONE"))

    t.begin("CoopAdmin.slugify collapses runs of non-alnum chars into a single underscore")
    t.assert_eq("red_stone", CoopAdmin.slugify("red stone"))
    t.assert_eq("red_stone", CoopAdmin.slugify("red---stone"))
    t.assert_eq("red_stone", CoopAdmin.slugify("red...stone"))

    t.begin("CoopAdmin.slugify trims leading and trailing underscores")
    t.assert_eq("stone", CoopAdmin.slugify("  stone  "))
    t.assert_eq("stone", CoopAdmin.slugify("__stone__"))
    t.assert_eq("stone", CoopAdmin.slugify("!!stone??"))

    t.begin("CoopAdmin.slugify returns empty for blank input")
    t.assert_eq("", CoopAdmin.slugify(""))
    t.assert_eq("", CoopAdmin.slugify("   "))
    t.assert_eq("", CoopAdmin.slugify("!!!"))

    t.begin("CoopAdmin.slugify keeps digits intact")
    t.assert_eq("3_4_5", CoopAdmin.slugify("3.4.5"))
