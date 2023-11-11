# based on https://github.com/rantala/string-sorting/blob/master/external/multikey.c

from math import min
from random import random_ui64

@always_inline
fn _vec_swap(inout values: Pointer[StringLiteral], a: Int, b: Int, n: Int):
    var n1 = n
    var a1 = a
    var b1 = b
    while n1 > 0:
        _exchange(values, a1, b1)
        a1 +=1
        b1 +=1
        n1 -= 1

@always_inline
fn _exchange(inout values: Pointer[StringLiteral], a: Int, b: Int):
    let tmp = values.load(a)
    values.store(a, values.load(b))
    values.store(b, tmp)

@always_inline
fn _char_at(s: StringLiteral, index: Int) -> Int:
    if len(s) <= index:
        return 0
    return s.data().bitcast[DType.uint8]().load(index).to_int()

fn _mk_sort(inout values: Pointer[StringLiteral], n: Int, depth: Int):
    if n <= 1:
        return
    var a = random_ui64(0, n - 1).to_int()
    _exchange(values, 0, a)
    let v = _char_at(values[0], depth)
    a = 1
    var b = 1
    var c = n - 1
    var d = n - 1
    var r: Int
    while True:
        while b <= c and _char_at(values[b], depth) - v <= 0:
            if _char_at(values[b], depth) - v == 0:
                _exchange(values, a, b)
                a += 1
            b += 1
        while b <= c and _char_at(values[c], depth) - v >= 0:
            if _char_at(values[c], depth) - v == 0:
                _exchange(values, c, d)
                d -= 1
            c -= 1
        if b > c:
            break
        _exchange(values, b, c)
        b += 1
        c -= 1
    r = min(a, b - a)
    _vec_swap(values, 0, b-r, r)
    r = min(d-c, n-d-1)
    _vec_swap(values, b, n-r, r)
    r = b-a
    _mk_sort(values, r, depth)
    if _char_at(values[r], depth) != 0:
        var sub_values = values.offset(r)
        _mk_sort(sub_values, a + n-d-1, depth + 1)
    r = d-c
    var sub_values = values.offset(n-r)
    _mk_sort(sub_values, r, depth)

fn multi_key_quicksort(inout values: DynamicVector[StringLiteral]):
    _mk_sort(values.data, len(values), 0)

fn multi_key_quicksort(inout values: UnsafeFixedVector[StringLiteral]):
    _mk_sort(values.data, len(values), 0)