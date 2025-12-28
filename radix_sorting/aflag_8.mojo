from memory import memset_zero, memcpy, stack_allocation
from memory.unsafe import bitcast, bit_width_of

fn aflag_sort(mut list: List[UInt8]):
    var size = len(list)
    var counts = stack_allocation[256 * 2, DType.uint32]()
    memset_zero(counts, 256)
    var offsets = counts + 256

    for i in range(size):
        var bucket = list.unsafe_get(i)
        counts.store(bucket, counts.load(bucket) + 1)
    
    offsets.store(0)
    var count = counts.load()
    for i in range(1, 256):
        offsets.store(i, count)
        count += counts.offset(i).load()
        counts.store(i, count)
    
    var cursor = 0
    while cursor < size:
        var bucket = list.unsafe_get(cursor)
        var offset = offsets[bucket]
        if offset == counts[bucket]:
            cursor += 1
            continue
        if offset == cursor:
            cursor += 1
        else:
            list.unsafe_get(Int(offset)), list.unsafe_get(cursor) = list.unsafe_get(cursor), list.unsafe_get(Int(offset))
        offsets[bucket] += 1


