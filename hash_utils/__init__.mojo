from math import min

fn int_cmp(a: UInt32, b: UInt32) -> Int:
    return int(a) - int(b)

fn int_cmp64(a: UInt64, b: UInt64) -> Int:
    return int(a) - int(b)

fn int_to_str(a: UInt32) -> String:
    return String(a)

fn int_to_str64(a: UInt64) -> String:
    return String(a)

fn cmp_strl(a: StringLiteral, b: StringLiteral) -> Int:
    var l = min(len(a), len(b))
    var p1 = a.data().bitcast[DType.uint8]()
    var p2 = b.data().bitcast[DType.uint8]()
    var diff = memcmp(p1, p2, l)

    return diff if diff != 0 else len(a) - len(b)

fn stsl(a: StringLiteral) -> String:
    return a

