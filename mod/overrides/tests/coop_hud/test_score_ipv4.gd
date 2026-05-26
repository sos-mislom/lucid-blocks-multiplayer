extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopHud.score_ipv4 192.168/16 is the best (lowest) score")
    t.assert_eq(0, CoopHud.score_ipv4("192.168.1.1"))
    t.assert_eq(0, CoopHud.score_ipv4("192.168.0.1"))
    t.assert_eq(0, CoopHud.score_ipv4("192.168.255.255"))

    t.begin("CoopHud.score_ipv4 10/8 is second")
    t.assert_eq(1, CoopHud.score_ipv4("10.0.0.1"))
    t.assert_eq(1, CoopHud.score_ipv4("10.255.255.255"))

    t.begin("CoopHud.score_ipv4 172.16-172.31 (excl 17/18) is third")
    t.assert_eq(2, CoopHud.score_ipv4("172.16.0.1"))
    t.assert_eq(2, CoopHud.score_ipv4("172.19.0.1"))
    t.assert_eq(2, CoopHud.score_ipv4("172.20.0.1"))
    t.assert_eq(2, CoopHud.score_ipv4("172.31.255.255"))

    t.begin("CoopHud.score_ipv4 100.64/10 (CGNAT) is fourth")
    t.assert_eq(3, CoopHud.score_ipv4("100.64.0.1"))
    t.assert_eq(3, CoopHud.score_ipv4("100.0.0.1"))

    t.begin("CoopHud.score_ipv4 Docker bridges (172.17/172.18) are penalized")
    t.assert_eq(4, CoopHud.score_ipv4("172.17.0.1"))
    t.assert_eq(4, CoopHud.score_ipv4("172.17.255.255"))
    t.assert_eq(4, CoopHud.score_ipv4("172.18.0.1"))
    t.assert_eq(4, CoopHud.score_ipv4("172.18.255.255"))

    t.begin("CoopHud.score_ipv4 172/8 outside 16..31 falls through to 5")
    t.assert_eq(5, CoopHud.score_ipv4("172.0.0.1"))
    t.assert_eq(5, CoopHud.score_ipv4("172.15.255.255"))
    t.assert_eq(5, CoopHud.score_ipv4("172.32.0.1"))

    t.begin("CoopHud.score_ipv4 anything else is 5")
    t.assert_eq(5, CoopHud.score_ipv4("8.8.8.8"))
    t.assert_eq(5, CoopHud.score_ipv4("169.254.1.1"))
    t.assert_eq(5, CoopHud.score_ipv4("203.0.113.1"))
    t.assert_eq(5, CoopHud.score_ipv4(""))
