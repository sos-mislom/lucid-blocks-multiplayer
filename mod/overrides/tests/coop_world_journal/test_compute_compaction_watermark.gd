extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopWorldJournal.compute_compaction_watermark uses saved_seq_high_water when positive")
    t.assert_eq(42, CoopWorldJournal.compute_compaction_watermark(42, 99))

    t.begin("CoopWorldJournal.compute_compaction_watermark falls back to current_sequence when saved_seq_high_water == 0")
    t.assert_eq(99, CoopWorldJournal.compute_compaction_watermark(0, 99))

    t.begin("CoopWorldJournal.compute_compaction_watermark falls back to current_sequence when saved_seq_high_water == -1 (default)")
    t.assert_eq(99, CoopWorldJournal.compute_compaction_watermark(-1, 99))

    t.begin("CoopWorldJournal.compute_compaction_watermark falls back to current_sequence for any negative input")
    t.assert_eq(99, CoopWorldJournal.compute_compaction_watermark(-100, 99))

    t.begin("CoopWorldJournal.compute_compaction_watermark saved=1 (smallest positive) still wins")
    t.assert_eq(1, CoopWorldJournal.compute_compaction_watermark(1, 99))
