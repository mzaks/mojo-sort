from memory import memset_zero, memcpy, stack_allocation
from memory.unsafe import bitcast, bit_width_of


@always_inline
fn _get_index[D: DType, //](v_index: Int, place: Int, list: UnsafePointer[Scalar[D]]) -> UInt8:
    comptime shift_value = (bit_width_of[D]() - 1)
    comptime last_bit = 1 << shift_value
    @parameter
    if D == DType.int8:
        return bitcast[DType.uint8, 1](list[v_index]) ^ last_bit
    elif D == DType.int16:
        return UInt8((bitcast[DType.uint16, 1](list[v_index]) ^ last_bit) >> place)
    elif D == DType.float16 or D == DType.bfloat16:
        var f = bitcast[DType.uint16, 1](list[v_index])
        var mask = bitcast[DType.uint16, 1](-bitcast[DType.int16, 1](f >> shift_value) | last_bit)
        return UInt8((f ^ mask) >> place)
    elif D == DType.int32:
        return UInt8((bitcast[DType.uint32, 1](list[v_index]) ^ last_bit) >> place)
    elif D == DType.float32:
        var f = bitcast[DType.uint32, 1](list[v_index])
        var mask = bitcast[DType.uint32, 1](-bitcast[DType.int32, 1](f >> shift_value) | last_bit)
        return UInt8((f ^ mask) >> place)
    elif D == DType.int64:
        return UInt8((bitcast[DType.uint64, 1](list[v_index]) ^ last_bit) >> place)
    elif D == DType.float64:
        var f = bitcast[DType.uint64, 1](list[v_index])
        var mask = bitcast[DType.uint64, 1](-bitcast[DType.int64, 1](f >> shift_value) | last_bit)
        return UInt8((f ^ mask) >> place)
    else:
        return UInt8(list[v_index] >> place)

fn _aflag_sort[origin: MutOrigin, D: DType, //](mut list: Span[Scalar[D], origin], level: Int):

    var size = len(list)
    if size < 2:
        return

    var counts = stack_allocation[256, DType.uint32]()
    memset_zero(counts, 256)
    
    needsSorting = False
    var place = level * 8
    var index =  Int(_get_index(0, place, list.unsafe_ptr()))
    counts[index] += 1

    for i in range(1, size):
        var index = Int(_get_index(i, place, list.unsafe_ptr()))
        needsSorting = needsSorting or list.unsafe_get(i) < list.unsafe_get(i-1) 
        counts[index] += 1
    
    if needsSorting == False and level == 0:
        return

    var partitions_count = 0
    var partitions = stack_allocation[256, DType.uint8]()
    
    var total_count = counts[0]
    if total_count > 1:
        partitions[partitions_count] = 0
        partitions_count += 1
    
    for i in range(1, 256):
        var current_count = counts[i]
        total_count += current_count
        if current_count > 1:
            partitions[partitions_count] = i
            partitions_count += 1
        counts[i] = total_count
    
    if needsSorting:
        var copy = alloc[Scalar[D]](size)
        memcpy(dest=copy, src=list.unsafe_ptr(), count=size)
        var i = size - 1
        while i >= 0:
            var index = _get_index(i, place, copy)
            list.unsafe_get(Int(counts.offset(index).load() - 1)) = copy[i]
            counts.offset(index).store(counts.offset(index).load() - 1)
            i -= 1
        copy.free()
    
    if partitions_count == 0 or level == 0:
        return

    for i in range(0, partitions_count):
        var bucket = partitions[i]
        var start = counts[bucket]
        var end = size if bucket == 255 else counts[bucket + 1]
        var count = end - start
        var s = list.unsafe_subspan(offset=Int(start), length=Int(count))
        if count <= 256:
            sort(s)
        else:
            _aflag_sort(s, level - 1)


fn aflag_copy_sort[origin: MutOrigin,//,D: DType](mut list: Span[Scalar[D], origin]):
    _aflag_sort(list, (bit_width_of[D]() >> 3) - 1)
