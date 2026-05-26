extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopRevive.is_fake_dead_or_respawning all false -> false")
    t.assert_false(CoopRevive.is_fake_dead_or_respawning(false, false, false, false))

    t.begin("CoopRevive.is_fake_dead_or_respawning local_fake_death_pending=true -> true")
    t.assert_true(CoopRevive.is_fake_dead_or_respawning(true, false, false, false))

    t.begin("CoopRevive.is_fake_dead_or_respawning handling_host_respawn=true -> true")
    t.assert_true(CoopRevive.is_fake_dead_or_respawning(false, true, false, false))

    t.begin("CoopRevive.is_fake_dead_or_respawning handling_client_respawn=true -> true")
    t.assert_true(CoopRevive.is_fake_dead_or_respawning(false, false, true, false))

    t.begin("CoopRevive.is_fake_dead_or_respawning host_respawning=true -> true")
    t.assert_true(CoopRevive.is_fake_dead_or_respawning(false, false, false, true))

    t.begin("CoopRevive.is_fake_dead_or_respawning all true -> true")
    t.assert_true(CoopRevive.is_fake_dead_or_respawning(true, true, true, true))
