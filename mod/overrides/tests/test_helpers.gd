class_name CoopTester
extends RefCounted

# Tiny zero-dependency assertion runner used by mod/overrides/tests/runner.gd.
# A single instance is shared across all test files in a run so we can roll
# pass/fail counters up to the runner without leaking global state.
#
# Tests look like:
#   extends RefCounted
#   func run(t: CoopTester) -> void:
#       t.begin("CoopIO.bounded_dict_set evicts FIFO at cap")
#       t.assert_eq(2, dict.size())

var current_file: String = ""
var current_label: String = ""
var file_failed: bool = false
var total_asserts: int = 0
var failed_asserts: int = 0
var failure_log: Array = []


func begin_file(file_path: String) -> void:
    current_file = file_path
    file_failed = false


func end_file() -> void:
    current_file = ""
    current_label = ""


func begin(label: String) -> void:
    current_label = label


func _fail(message: String) -> void:
    file_failed = true
    failed_asserts += 1
    var line: String = "[tests] FAIL %s :: %s :: %s" % [current_file, current_label, message]
    failure_log.append(line)
    printerr(line)


func assert_true(condition: bool, message: String = "expected true") -> void:
    total_asserts += 1
    if not condition:
        _fail(message)


func assert_false(condition: bool, message: String = "expected false") -> void:
    total_asserts += 1
    if condition:
        _fail(message)


func assert_eq(expected: Variant, actual: Variant, message: String = "") -> void:
    total_asserts += 1
    if not _values_equal(expected, actual):
        var detail: String = " :: " + message if message != "" else ""
        _fail("expected %s, got %s%s" % [_format(expected), _format(actual), detail])


func assert_ne(forbidden: Variant, actual: Variant, message: String = "") -> void:
    total_asserts += 1
    if _values_equal(forbidden, actual):
        var detail: String = " :: " + message if message != "" else ""
        _fail("expected != %s, got identical%s" % [_format(forbidden), detail])


func assert_eq_dict(expected: Dictionary, actual: Dictionary, message: String = "") -> void:
    total_asserts += 1
    if expected.size() != actual.size():
        _fail((message + " :: " if message != "" else "") + "dict size mismatch: expected %d keys, got %d" % [expected.size(), actual.size()])
        return
    for key in expected.keys():
        if not actual.has(key):
            _fail((message + " :: " if message != "" else "") + "missing key %s" % str(key))
            return
        if not _values_equal(expected[key], actual[key]):
            _fail((message + " :: " if message != "" else "") + "key %s: expected %s, got %s" % [str(key), _format(expected[key]), _format(actual[key])])
            return


func assert_eq_packed_string_array(expected: PackedStringArray, actual: PackedStringArray, message: String = "") -> void:
    total_asserts += 1
    if expected.size() != actual.size():
        _fail((message + " :: " if message != "" else "") + "PackedStringArray size mismatch: expected %d, got %d" % [expected.size(), actual.size()])
        return
    for i in range(expected.size()):
        if expected[i] != actual[i]:
            _fail((message + " :: " if message != "" else "") + "index %d: expected %s, got %s" % [i, expected[i], actual[i]])
            return


func assert_eq_packed_int32_array(expected: PackedInt32Array, actual: PackedInt32Array, message: String = "") -> void:
    total_asserts += 1
    if expected.size() != actual.size():
        _fail((message + " :: " if message != "" else "") + "PackedInt32Array size mismatch: expected %d, got %d" % [expected.size(), actual.size()])
        return
    for i in range(expected.size()):
        if expected[i] != actual[i]:
            _fail((message + " :: " if message != "" else "") + "index %d: expected %d, got %d" % [i, expected[i], actual[i]])
            return


static func _values_equal(a: Variant, b: Variant) -> bool:
    if typeof(a) != typeof(b):
        return false
    return a == b


static func _format(v: Variant) -> String:
    if v is String:
        return "\"%s\"" % v
    return str(v)
