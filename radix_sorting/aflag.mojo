from memory import memset_zero, memcpy, stack_allocation
from memory.unsafe import bitcast, bit_width_of

fn _aflag_sort[origin: MutOrigin, D: DType, //](mut list: Span[Scalar[D], origin], level: Int):

    @always_inline
    fn _get_index(v_index: Int, place: Int) -> UInt8:
        comptime shift_value = (bit_width_of[D]() - 1)
        comptime last_bit = 1 << shift_value
        @parameter
        if D == DType.int8:
            return bitcast[DType.uint8, 1](list.unsafe_get(v_index)) ^ last_bit
        elif D == DType.int16:
            return UInt8((bitcast[DType.uint16, 1](list.unsafe_get(v_index)) ^ last_bit) >> place)
        elif D == DType.float16 or D == DType.bfloat16:
            var f = bitcast[DType.uint16, 1](list.unsafe_get(v_index))
            var mask = bitcast[DType.uint16, 1](-bitcast[DType.int16, 1](f >> shift_value) | last_bit)
            return UInt8((f ^ mask) >> place)
        elif D == DType.int32:
            return UInt8((bitcast[DType.uint32, 1](list.unsafe_get(v_index)) ^ last_bit) >> place)
        elif D == DType.float32:
            var f = bitcast[DType.uint32, 1](list.unsafe_get(v_index))
            var mask = bitcast[DType.uint32, 1](-bitcast[DType.int32, 1](f >> shift_value) | last_bit)
            return UInt8((f ^ mask) >> place)
        elif D == DType.int64:
            return UInt8((bitcast[DType.uint64, 1](list.unsafe_get(v_index)) ^ last_bit) >> place)
        elif D == DType.float64:
            var f = bitcast[DType.uint64, 1](list.unsafe_get(v_index))
            var mask = bitcast[DType.uint64, 1](-bitcast[DType.int64, 1](f >> shift_value) | last_bit)
            return UInt8((f ^ mask) >> place)
        else:
            return UInt8(list.unsafe_get(v_index) >> place)

    var size = len(list)
    var counts = stack_allocation[256 * 2, DType.uint32]()
    memset_zero(counts, 256)
    var offsets = counts + 256

    var needsSorting = False
    var place = level * 8
    var prev_bucket =  Int(_get_index(0, place))
    counts.store(prev_bucket, counts.load(prev_bucket) + 1)
    for i in range(1, size):
        var bucket = Int(_get_index(i, place))
        needsSorting = needsSorting or prev_bucket > bucket 
        counts.store(bucket, counts.load(bucket) + 1)
        prev_bucket = bucket
    
    if needsSorting == False and level == 0:
        return

    var partitions_count = 0
    var partitions = stack_allocation[256, DType.uint8]()
    offsets.store(0)
    
    var total_count = counts.load()
    if total_count > 1:
        partitions[partitions_count] = 0
        partitions_count += 1
    
    for i in range(1, 256):
        offsets.store(i, total_count)
        var current_count = counts.offset(i).load()
        if current_count > 1:
            partitions[partitions_count] = i
            partitions_count += 1
        total_count += current_count
        counts.store(i, total_count)
    
    if needsSorting:
        var cursor = 0
        while cursor < size:
            var bucket = Int(_get_index(cursor, place))
            var offset = offsets[bucket]
            if offset == counts[bucket]:
                cursor += 1
                continue
            if offset == cursor:
                cursor += 1
            else:
                list.unsafe_swap_elements(Int(cursor), Int(offset))
            offsets[bucket] += 1
    
    if partitions_count == 0 or level == 0:
        return

    for i in range(0, partitions_count):
        var prev_count = Int(0 if partitions[i] == 0 else counts[partitions[i] - 1])
        var cur_count = Int(counts[partitions[i]])
        var count = cur_count - prev_count
        var s = list.unsafe_subspan(offset=prev_count, length=count)
        # TODO: use other sort for smaller partitions
        _aflag_sort(s, level - 1)


fn aflag_sort[origin: MutOrigin,//,D: DType](mut list: Span[Scalar[D], origin]):
    _aflag_sort(list, (bit_width_of[D]() >> 3) - 1)
