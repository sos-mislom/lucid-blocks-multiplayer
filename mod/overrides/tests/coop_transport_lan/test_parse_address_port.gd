extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopTransportLAN.parse_address_port empty target returns defaults")
    var result: Dictionary = CoopTransportLAN.parse_address_port("", "10.0.0.1", 7777)
    t.assert_eq("10.0.0.1", result.get("address"))
    t.assert_eq(7777, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port whitespace-only target returns defaults")
    result = CoopTransportLAN.parse_address_port("   ", "10.0.0.1", 7777)
    t.assert_eq("10.0.0.1", result.get("address"))
    t.assert_eq(7777, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port host-only keeps default port")
    result = CoopTransportLAN.parse_address_port("example.org", "127.0.0.1", 8888)
    t.assert_eq("example.org", result.get("address"))
    t.assert_eq(8888, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port host:port splits and parses")
    result = CoopTransportLAN.parse_address_port("example.org:9999", "127.0.0.1", 8888)
    t.assert_eq("example.org", result.get("address"))
    t.assert_eq(9999, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port strips edge whitespace before parse")
    result = CoopTransportLAN.parse_address_port("  example.org:9999  ", "127.0.0.1", 8888)
    t.assert_eq("example.org", result.get("address"))
    t.assert_eq(9999, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port port out of range is clamped high")
    result = CoopTransportLAN.parse_address_port("example.org:99999", "127.0.0.1", 8888)
    t.assert_eq("example.org", result.get("address"))
    t.assert_eq(65535, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port port out of range is clamped low")
    result = CoopTransportLAN.parse_address_port("example.org:0", "127.0.0.1", 8888)
    t.assert_eq("example.org", result.get("address"))
    t.assert_eq(1, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port host-only path clamps invalid default port")
    result = CoopTransportLAN.parse_address_port("example.org", "127.0.0.1", 0)
    t.assert_eq("example.org", result.get("address"))
    # Live behavior: non-empty target reaches the final clampi(port, 1, 65535),
    # so a 0 default is normalized to 1 (the empty-target early return is the
    # only path that returns the raw default).
    t.assert_eq(1, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port empty-target early return keeps invalid default port raw")
    result = CoopTransportLAN.parse_address_port("", "127.0.0.1", 0)
    t.assert_eq("127.0.0.1", result.get("address"))
    t.assert_eq(0, result.get("port"))


    t.begin("CoopTransportLAN.parse_address_port non-numeric trailing token is part of address")
    result = CoopTransportLAN.parse_address_port("example.org:notaport", "127.0.0.1", 8888)
    # Live behavior: invalid trailing token keeps target intact as the address.
    t.assert_eq("example.org:notaport", result.get("address"))
    t.assert_eq(8888, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port IPv6 bracketed without port")
    result = CoopTransportLAN.parse_address_port("[::1]", "127.0.0.1", 8888)
    t.assert_eq("::1", result.get("address"))
    t.assert_eq(8888, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port IPv6 bracketed with port")
    result = CoopTransportLAN.parse_address_port("[::1]:7777", "127.0.0.1", 8888)
    t.assert_eq("::1", result.get("address"))
    t.assert_eq(7777, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port IPv6 bracketed with invalid port keeps default")
    result = CoopTransportLAN.parse_address_port("[::1]:foo", "127.0.0.1", 8888)
    t.assert_eq("::1", result.get("address"))
    t.assert_eq(8888, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port multi-colon non-bracketed treated as opaque host")
    result = CoopTransportLAN.parse_address_port("a:b:c", "127.0.0.1", 8888)
    # Live behavior: multiple colons + no brackets short-circuits the
    # rfind/find equality check; whole string becomes the address.
    t.assert_eq("a:b:c", result.get("address"))
    t.assert_eq(8888, result.get("port"))

    t.begin("CoopTransportLAN.parse_address_port leading colon (rfind == 0) keeps target as address")
    result = CoopTransportLAN.parse_address_port(":7777", "127.0.0.1", 8888)
    t.assert_eq(":7777", result.get("address"))
    t.assert_eq(8888, result.get("port"))
