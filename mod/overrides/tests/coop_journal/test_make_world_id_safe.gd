extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJournal.make_world_id_safe returns 'active' for empty input")
    t.assert_eq("active", CoopJournal.make_world_id_safe(""))
    t.assert_eq("active", CoopJournal.make_world_id_safe("   "), "whitespace must collapse to 'active'")

    t.begin("CoopJournal.make_world_id_safe preserves alphanumeric and dash/dot")
    t.assert_eq("abc-123.world", CoopJournal.make_world_id_safe("abc-123.world"))

    t.begin("CoopJournal.make_world_id_safe replaces forward and back slashes")
    t.assert_eq("a_b_c", CoopJournal.make_world_id_safe("a/b/c"))
    t.assert_eq("a_b_c", CoopJournal.make_world_id_safe("a\\b\\c"))
    t.assert_eq("a_b_c", CoopJournal.make_world_id_safe("a/b\\c"))

    t.begin("CoopJournal.make_world_id_safe trims surrounding whitespace before slug")
    t.assert_eq("world1", CoopJournal.make_world_id_safe("  world1  "))

    t.begin("CoopJournal.journal_paths returns matched journal + applied_seq paths")
    var paths: Dictionary = CoopJournal.journal_paths("user://", "abc")
    t.assert_eq("user://lucid_blocks_coop_chunk_journal_abc.jsonl", str(paths.get("journal", "")))
    t.assert_eq("user://lucid_blocks_coop_chunk_journal_abc.jsonl.applied_seq", str(paths.get("applied_seq", "")))

    t.begin("CoopJournal.journal_paths defaults to user:// when user_dir is empty")
    paths = CoopJournal.journal_paths("", "abc")
    t.assert_eq("user://lucid_blocks_coop_chunk_journal_abc.jsonl", str(paths.get("journal", "")))

    t.begin("CoopJournal.journal_paths normalises a user_dir missing the trailing slash")
    paths = CoopJournal.journal_paths("user:/", "abc")
    t.assert_eq("user:/lucid_blocks_coop_chunk_journal_abc.jsonl".replace("//", "/"), str(paths.get("journal", "")).replace("//", "/"))

    t.begin("CoopJournal.journal_paths slugs the world id")
    paths = CoopJournal.journal_paths("user://", "a/b")
    t.assert_eq("user://lucid_blocks_coop_chunk_journal_a_b.jsonl", str(paths.get("journal", "")))
