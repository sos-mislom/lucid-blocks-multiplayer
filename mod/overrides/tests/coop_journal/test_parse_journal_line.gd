extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJournal.parse_journal_line returns ok=false on a blank line")
    var blank: Dictionary = CoopJournal.parse_journal_line("")
    t.assert_false(bool(blank.get("ok", true)), "blank line must be ok=false")
    t.assert_true((blank.get("record") as Dictionary).is_empty(), "blank line record must be empty")

    t.begin("CoopJournal.parse_journal_line returns ok=false on whitespace-only")
    t.assert_false(bool(CoopJournal.parse_journal_line("   \t\n").get("ok", true)))

    t.begin("CoopJournal.parse_journal_line returns ok=false on malformed JSON")
    t.assert_false(bool(CoopJournal.parse_journal_line("{not_json").get("ok", true)))
    t.assert_false(bool(CoopJournal.parse_journal_line("garbage").get("ok", true)))

    t.begin("CoopJournal.parse_journal_line returns ok=false on non-dictionary JSON")
    t.assert_false(bool(CoopJournal.parse_journal_line("[1,2,3]").get("ok", true)), "array json must fail")
    t.assert_false(bool(CoopJournal.parse_journal_line("42").get("ok", true)), "scalar json must fail")
    t.assert_false(bool(CoopJournal.parse_journal_line("\"string\"").get("ok", true)), "string json must fail")

    t.begin("CoopJournal.parse_journal_line returns ok=true on a valid record")
    var parsed: Dictionary = CoopJournal.parse_journal_line("{\"seq\":7,\"action\":\"place\"}")
    t.assert_true(bool(parsed.get("ok", false)), "valid record must be ok=true")
    var record: Dictionary = parsed.get("record", {})
    t.assert_eq(7, int(record.get("seq", 0)))
    t.assert_eq("place", str(record.get("action", "")))

    t.begin("CoopJournal.parse_journal_line tolerates surrounding whitespace")
    var trimmed: Dictionary = CoopJournal.parse_journal_line("   {\"a\":1}\n")
    t.assert_true(bool(trimmed.get("ok", false)))
    t.assert_eq(1, int((trimmed.get("record") as Dictionary).get("a", 0)))
