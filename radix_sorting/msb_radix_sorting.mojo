from memory import memset_zero, memcpy, memcmp, stack_allocation

@always_inline
fn _max(mut x: Int, y: Int):
    x = x ^ ((x ^ y) & -Int(x < y))

@always_inline
fn lt(a: String, b: String, depth: Int) -> Bool:
    var min_len = min(len(a), len(b)) - depth
    var res = memcmp(a.unsafe_ptr().offset(depth), b.unsafe_ptr().offset(depth), min_len)
    return len(a) <= len(b) if res == 0 else res < 0

@always_inline
fn _insertion_sort(mut values: List[String], start: Int, end: Int, depth: Int):
    for i in range(start, end):
        var key = values[i]
        var j = i - 1
        while j >= start and lt(key, values[j], depth):
            values[j + 1] = values[j]
            j -= 1
        values[j + 1] = key

fn _msb_radix_sort(mut values: List[String], start: Int, end: Int, depth: Int):
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
        var p = v.unsafe_ptr().load(depth)
        _max(max_len, len(v))
        # var c = bitcast[DType.uint8](buf[depth])
        counts[Int(p)] += 1
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
        _msb_radix_sort(values, Int(start), Int(end), depth + 1)
    else:
        var i = end - 1
        while i >= start:
            # print(i)
            var c = Int(values[i].unsafe_ptr().load(depth))
            out[Int(sums[c] - 1) + start] = values[i]
            sums[c] -= 1
            i -= 1

        # for o in out:
        #     print(o[], end=", ")
        # print()
        values = out^

        for p in partitions:
            var start = start + sums[p]
            var end = start + counts[p] 
            _msb_radix_sort(values, Int(start), Int(end), depth + 1)


fn msb_radix_sort(mut values: List[String]):
    _msb_radix_sort(values, 0, len(values), 0)
