extends RefCounted


func run(t: CoopTester) -> void:
    t.begin("CoopJournal.vector3i_to_array serialises components in order")
    var a: Array = CoopJournal.vector3i_to_array(Vector3i(1, 2, 3))
    t.assert_eq(3, a.size())
    t.assert_eq(1, a[0])
    t.assert_eq(2, a[1])
    t.assert_eq(3, a[2])

    t.begin("CoopJournal.array_to_vector3i round-trips after vector3i_to_array")
    var v: Vector3i = CoopJournal.array_to_vector3i(a)
    t.assert_eq(Vector3i(1, 2, 3), v)

    t.begin("CoopJournal.array_to_vector3i accepts a Vector3i identity input")
    t.assert_eq(Vector3i(4, 5, 6), CoopJournal.array_to_vector3i(Vector3i(4, 5, 6)))

    t.begin("CoopJournal.array_to_vector3i floor-converts a Vector3")
    t.assert_eq(Vector3i(7, 8, 9), CoopJournal.array_to_vector3i(Vector3(7.4, 8.9, 9.0)))

    t.begin("CoopJournal.array_to_vector3i returns ZERO on garbage")
    t.assert_eq(Vector3i.ZERO, CoopJournal.array_to_vector3i("not-an-array"))
    t.assert_eq(Vector3i.ZERO, CoopJournal.array_to_vector3i(null))
    t.assert_eq(Vector3i.ZERO, CoopJournal.array_to_vector3i([1, 2]))

    t.begin("CoopJournal.array_to_vector3i casts non-int array entries")
    t.assert_eq(Vector3i(1, 2, 3), CoopJournal.array_to_vector3i([1.7, 2.3, "3"]))
