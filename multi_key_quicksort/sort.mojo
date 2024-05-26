# based on https://github.com/rantala/string-sorting/blob/master/external/multikey.c

from random import random_ui64

@always_inline
fn _vec_swap(inout values: List[String], a: Int, b: Int, n: Int):
    var n1 = n
    var a1 = a
    var b1 = b
    while n1 > 0:
        _exchange(values, a1, b1)
        a1 +=1
        b1 +=1
        n1 -= 1

@always_inline
fn _exchange(inout values: List[String], a: Int, b: Int):
    values[a], values[b] = values[b], values[a]

@always_inline
fn _char_at(s: String, index: Int) -> Int:
    if len(s) <= index:
        return 0
    return int(DTypePointer(s.unsafe_uint8_ptr()).load(index))

fn _mk_sort(inout values: List[String], n: Int, depth: Int, offset: Int):
    if n <= 1:
        return
    var a = offset + int(random_ui64(0, n - 1))
    _exchange(values, offset, a)
    var v = _char_at(values[offset], depth)
    a = offset + 1
    var b = offset + 1
    var c = offset + n - 1
    var d = offset + n - 1
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
    _vec_swap(values, offset, b-r, r)
    r = min(d-c, n-d-1)
    _vec_swap(values, b, n-r, r)
    r = b-a
    _mk_sort(values, r, depth, offset)
    if _char_at(values[r], depth) != 0:
        _mk_sort(values, a + n-d-1, depth + 1, offset + r)
    r = d-c
    _mk_sort(values, r, depth, offset + n - r)

fn multi_key_quicksort(inout values: List[String]):
    _mk_sort(values, len(values), 0, 0)