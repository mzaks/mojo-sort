from sys.intrinsics import PrefetchOptions

fn classic_binary_search[D: DType](b: DTypePointer[D], n: Int, x: SIMD[D, 1]) -> Int:
    var low = 0
    var high = n - 1
    while low <= high:
        var mid = (high + low) >> 1
        var mid_value = b.load(mid)
        if mid_value < x:
            low = mid + 1
        elif mid_value > x:
            high = mid - 1
        else:
            return mid
    return -1
        

fn classic_binary_search[D: AnyType, lt: fn(D, D) -> Bool](b: Pointer[D], n: Int, x: D) -> Int:
    var low = 0
    var high = n - 1
    while low <= high:
        var mid = (high + low) >> 1
        var mid_value = b.load(mid)
        if lt(mid_value, x):
            low = mid + 1
        elif lt(mid_value, x):
            high = mid - 1
        else:
            return mid
    return -1

# Binary search based on https://en.algorithmica.org/hpc/data-structures/binary-search/

fn binary_search[D: AnyType, lt: fn(D, D) -> Int, eq: fn(D, D) -> Bool](b: Pointer[D], n: Int, x: D) -> Int:
    var cursor = 0
    var length = n
    while length > 1:
        var half = length >> 1
        length -= half
        cursor += lt(b.load(cursor + half - 1), x) * half

    return cursor if eq(b.load(cursor), x) else -1

fn binary_search[D: DType, with_prefetch: Bool = False](b: DTypePointer[D], n: Int, x: SIMD[D, 1]) -> Int:
    var cursor = 0
    var length = n
    alias pfo = PrefetchOptions().for_read()
    while length > 1:
        var half = length >> 1
        length -= half
        var next_half = (length >> 1) - 1
        @parameter
        if with_prefetch:
            b.offset(cursor + next_half).prefetch[pfo]()
            b.offset(cursor + half + next_half).prefetch[pfo]()
        cursor += int(b.load(cursor + half - 1) < x) * half

    return cursor if b.load(cursor) == x else -1
