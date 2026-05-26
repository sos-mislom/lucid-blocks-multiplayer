extends RefCounted


func run(t: CoopTester) -> void:
    const PREFIX: String = "+connect_lobby "

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string empty -> 0")
    t.assert_eq(0, CoopTransportSteam.extract_lobby_id_from_connect_string("", PREFIX))

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string whitespace-only -> 0")
    t.assert_eq(0, CoopTransportSteam.extract_lobby_id_from_connect_string("   ", PREFIX))

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string plain integer -> int")
    t.assert_eq(109775240000000000, CoopTransportSteam.extract_lobby_id_from_connect_string("109775240000000000", PREFIX))

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string strips edges before int parse")
    t.assert_eq(42, CoopTransportSteam.extract_lobby_id_from_connect_string("   42   ", PREFIX))

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string +connect_lobby prefix")
    t.assert_eq(
        123456,
        CoopTransportSteam.extract_lobby_id_from_connect_string("+connect_lobby 123456", PREFIX)
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string +connect_lobby embedded in longer cmdline")
    t.assert_eq(
        987654321,
        CoopTransportSteam.extract_lobby_id_from_connect_string(
            "game.exe --foo bar +connect_lobby 987654321 --baz",
            PREFIX,
        )
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string +connect_lobby with non-numeric suffix -> 0")
    t.assert_eq(
        0,
        CoopTransportSteam.extract_lobby_id_from_connect_string("+connect_lobby abc", PREFIX)
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string steam_lobby= marker")
    t.assert_eq(
        555,
        CoopTransportSteam.extract_lobby_id_from_connect_string("steam_lobby=555", PREFIX)
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string steam_lobby= marker embedded")
    t.assert_eq(
        7777,
        CoopTransportSteam.extract_lobby_id_from_connect_string("foo bar steam_lobby=7777 baz", PREFIX)
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string steam_lobby= marker with non-numeric -> 0")
    t.assert_eq(
        0,
        CoopTransportSteam.extract_lobby_id_from_connect_string("steam_lobby=oops", PREFIX)
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string +connect_lobby wins over steam_lobby= when both present")
    # Live behavior: the prefix-form is checked first; whichever yields
    # a valid integer along that path wins.
    t.assert_eq(
        111,
        CoopTransportSteam.extract_lobby_id_from_connect_string(
            "+connect_lobby 111 steam_lobby=222",
            PREFIX,
        )
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string custom prefix is honored")
    t.assert_eq(
        42,
        CoopTransportSteam.extract_lobby_id_from_connect_string(
            "join_lobby_alias 42",
            "join_lobby_alias ",
        )
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string empty prefix skips +connect_lobby branch")
    t.assert_eq(
        555,
        CoopTransportSteam.extract_lobby_id_from_connect_string("+connect_lobby 999 steam_lobby=555", "")
    )

    t.begin("CoopTransportSteam.extract_lobby_id_from_connect_string no matches -> 0")
    t.assert_eq(
        0,
        CoopTransportSteam.extract_lobby_id_from_connect_string("--something --else", PREFIX)
    )
