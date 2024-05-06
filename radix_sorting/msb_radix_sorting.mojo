@always_inline
fn _max(inout x: Int, y: Int):
    x = x ^ ((x ^ y) & -int(x < y))

@always_inline
fn _align_down(value: Int, alignment: Int) -> Int:
    return value._positive_div(alignment) * alignment

@always_inline
fn _memcmp_impl(s1: DTypePointer, s2: __type_of(s1), count: Int) -> Int:
    constrained[s1.type.is_integral(), "the input dtype must be integral"]()
    alias simd_width = simdwidthof[s1.type]()
    if count < simd_width:
        for i in range(count):
            var s1i = s1[i]
            var s2i = s2[i]
            if s1i != s2i:
                return 1 if s1i > s2i else -1
        return 0

    var iota = llvm_intrinsic[
        "llvm.experimental.stepvector",
        SIMD[DType.uint8, simd_width],
        has_side_effect=False,
    ]()

    var vector_end_simd = _align_down(count, simd_width)
    for i in range(0, vector_end_simd, simd_width):
        var s1i = s1.load[width=simd_width](i)
        var s2i = s2.load[width=simd_width](i)
        var diff = s1i != s2i
        if diff.reduce_or():
            var index = int(
                diff.select(
                    iota, SIMD[DType.uint8, simd_width](255)
                ).reduce_min()
            )
            return -1 if s1i[index] < s2i[index] else 1

    var last = count - simd_width
    if last <= 0:
        return 0

    var s1i = s1.load[width=simd_width](last)
    var s2i = s2.load[width=simd_width](last)
    var diff = s1i != s2i
    if diff.reduce_or():
        var index = int(
            diff.select(iota, SIMD[DType.uint8, simd_width](255)).reduce_min()
        )
        return -1 if s1i[index] < s2i[index] else 1
    return 0

@always_inline
fn lt(a: String, b: String, depth: Int) -> Bool:
    var min_len = min(len(a), len(b)) - depth
    var res = _memcmp_impl(a._as_uint8_ptr().offset(depth), b._as_uint8_ptr().offset(depth), min_len)
    return len(a) <= len(b) if res == 0 else res < 0

@always_inline
fn _insertion_sort(inout values: List[String], start: Int, end: Int, depth: Int):
    for i in range(start, end):
        var key = values[i]
        var j = i - 1
        while j >= start and lt(key, values[j], depth):
            values[j + 1] = values[j]
            j -= 1
        values[j + 1] = key

fn _msb_radix_sort(inout values: List[String], start: Int, end: Int, depth: Int):
    # print(start, end, depth)
    if end - start <= 32:
        _insertion_sort(values, start, end, depth)
        return
    var counts = stack_allocation[256 * 2, DType.uint32]()
    var out = List(values)
    memset_zero(counts, 256 * 2)
    var sums = counts.offset(256)
    var max_len = 0
    for i in range(start, end):
        var v = values[i]
        var p = v._as_uint8_ptr().load(depth)
        _max(max_len, len(v))
        # var c = bitcast[DType.uint8](buf[depth])
        counts[p] += 1
    if depth >= max_len:
        return
    
    # for i in range(256):
    #     print(counts.load(i), end="\n" if i == 255 else ", ")
    
    var element = counts[0]
    sums[0] = element
    var partitions = List[Int]()
    if element > 1:
        partitions.append(0)
    for i in range(1, 256):
        if counts[i] > 1:
            partitions.append(i)
        sums[i] = counts[i] + element
        element = sums[i]
    
    # for i in range(256):
    #     print(sums.load(i), end="\n" if i == 255 else ", ")
    
    # for p in partitions:
    #     print(p[], ", ")
    # print()
    if len(partitions) == 1 and partitions[0] == end - start:
        _msb_radix_sort(values, int(start), int(end), depth + 1)
    else:
        var i = end - 1
        while i >= start:
            # print(i)
            var c = values[i]._buffer[depth]
            out[int(sums[c] - 1) + start] = values[i]
            sums[c] -= 1
            i -= 1

        # for o in out:
        #     print(o[], end=", ")
        # print()
        values = out

        for p in partitions:
            var start = start + sums[p[]]
            var end = start + counts[p[]] 
            _msb_radix_sort(values, int(start), int(end), depth + 1)


fn msb_radix_sort(inout values: List[String]):
    _msb_radix_sort(values, 0, len(values), 0)
