extends RefCounted

# Regression coverage for the audit finding:
#   "compact stirs records appeared WHILE await save_file() was in flight"
# `compute_keep_lines` must keep every line with seq > watermark, and only
# those lines, in their original order.


func run(t: CoopTester) -> void:
    t.begin("CoopJournal.compute_keep_lines returns empty when all records are at or below watermark")
    var text: String = "{\"seq\":1}\n{\"seq\":2}\n{\"seq\":3}\n"
    var kept: PackedStringArray = CoopJournal.compute_keep_lines(text, 5)
    t.assert_eq(0, kept.size())

    t.begin("CoopJournal.compute_keep_lines keeps only the records with seq > watermark")
    kept = CoopJournal.compute_keep_lines(text, 2)
    t.assert_eq(1, kept.size())
    t.assert_eq("{\"seq\":3}", kept[0])

    t.begin("CoopJournal.compute_keep_lines keeps all records when watermark is 0")
    kept = CoopJournal.compute_keep_lines(text, 0)
    t.assert_eq(3, kept.size())
    t.assert_eq("{\"seq\":1}", kept[0])
    t.assert_eq("{\"seq\":2}", kept[1])
    t.assert_eq("{\"seq\":3}", kept[2])

    t.begin("CoopJournal.compute_keep_lines preserves insertion order")
    var unsorted: String = "{\"seq\":10}\n{\"seq\":3}\n{\"seq\":11}\n{\"seq\":4}\n"
    kept = CoopJournal.compute_keep_lines(unsorted, 5)
    t.assert_eq(2, kept.size())
    t.assert_eq("{\"seq\":10}", kept[0], "first kept line must remain first")
    t.assert_eq("{\"seq\":11}", kept[1], "second kept line must remain second")

    t.begin("CoopJournal.compute_keep_lines ignores blank and whitespace-only lines")
    var with_blanks: String = "\n{\"seq\":4}\n   \n{\"seq\":5}\n"
    kept = CoopJournal.compute_keep_lines(with_blanks, 3)
    t.assert_eq(2, kept.size())

    t.begin("CoopJournal.compute_keep_lines drops malformed and non-dictionary lines")
    var malformed: String = "{not_json}\n[1,2]\n{\"seq\":9}\nplain text\n"
    kept = CoopJournal.compute_keep_lines(malformed, 0)
    t.assert_eq(1, kept.size())
    t.assert_eq("{\"seq\":9}", kept[0])

    t.begin("CoopJournal.compute_keep_lines treats records without a seq field as seq=0")
    var no_seq: String = "{\"action\":\"place\"}\n{\"seq\":1}\n"
    kept = CoopJournal.compute_keep_lines(no_seq, 0)
    t.assert_eq(1, kept.size(), "only seq=1 should pass watermark=0")
    t.assert_eq("{\"seq\":1}", kept[0])
