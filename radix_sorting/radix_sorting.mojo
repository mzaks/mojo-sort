
# from algorithm import unroll
from memory import memset_zero, memcpy, stack_allocation
from memory.unsafe import bitcast
# from math.limit import max_or_inf


alias last_bit_8 = 1 << 7
alias last_bit_16 = 1 << 15
alias last_bit_32 = 1 << 31
alias last_bit_64 = 1 << 63

@always_inline
fn _get_index[D: DType, place: Int](vector: List[SIMD[D, 1]], v_index: Int) -> Int:
    @parameter
    if D == DType.int8:
        return int((bitcast[DType.uint8, 1](vector[v_index]) ^ last_bit_8) >> place) & 255
    elif D == DType.int16:
        return int((bitcast[DType.uint16, 1](vector[v_index]) ^ last_bit_16) >> place) & 255
    elif D == DType.float16:
        var f = bitcast[DType.uint16, 1](vector[v_index])
        var mask = bitcast[DType.uint16, 1](-bitcast[DType.int16, 1](f >> 15) | last_bit_16)
        return int((f ^ mask) >> place) & 255
    elif D == DType.int32:
        return int((bitcast[DType.uint32, 1](vector[v_index]) ^ last_bit_32) >> place) & 255
    elif D == DType.float32:
        var f = bitcast[DType.uint32, 1](vector[v_index])
        var mask = bitcast[DType.uint32, 1](-bitcast[DType.int32, 1](f >> 31) | last_bit_32)
        return int((f ^ mask) >> place) & 255
    elif D == DType.int64:
        return int((bitcast[DType.uint64, 1](vector[v_index]) ^ last_bit_64) >> place) & 255
    elif D == DType.float64:
        var f = bitcast[DType.uint64, 1](vector[v_index])
        var mask = bitcast[DType.uint64, 1](-bitcast[DType.int64, 1](f >> 63) | last_bit_64)
        return int((f ^ mask) >> place) & 255
    else:
        return int(vector[v_index] >> place) & 255

@always_inline
fn _counting_sort[D: DType, CD:DType, place: Int](inout vector: List[SIMD[D, 1]]):
    var size = len(vector)
    var output = List[SIMD[D, 1]](size)
    memset_zero(output.data, size)
    output.resize(size)

    var counts = stack_allocation[256, CD]()
    memset_zero(counts, 256)
    
    for i in range(size):
        var index = _get_index[D, place](vector, i)
        counts.offset(index).store(counts.offset(index).load() + 1)
    
    var count = counts.offset(0).load()
    for i in range(1, 256):
        count += counts.offset(i).load()
        counts.offset(i).store(count)

    # var part = counts.load[width=256]()
    # part += part.shift_right[1]()
    # part += part.shift_right[2]()
    # part += part.shift_right[4]()
    # part += part.shift_right[8]()
    # part += part.shift_right[16]()
    # part += part.shift_right[32]()
    # part += part.shift_right[64]()
    # part += part.shift_right[128]()

    # counts.simd_store(part)
        

    var i = size - 1
    while i >= 0:
        var index = _get_index[D, place](vector, i)
        output[int(counts.offset(index).load() - 1)] = vector[i]
        counts.offset(index).store(counts.offset(index).load() - 1)
        i -= 1
    vector = output 

@always_inline
fn _radix_sort[D: DType, CD: DType](inout vector: List[SIMD[D, 1]]):

    @parameter
    fn call_counting_sort[index: Int]():
        _counting_sort[D, CD, index * 8](vector)
    
    @parameter
    if D.bitwidth() == 8:
        unroll[call_counting_sort, 1]()
    elif D.bitwidth() == 16:
        unroll[call_counting_sort, 2]()
    elif D.bitwidth() == 32:
        unroll[call_counting_sort, 4]()
    else:
        unroll[call_counting_sort, 8]()

@always_inline
fn radix_sort[D: DType](inout vector: List[SIMD[D, 1]]):
    _radix_sort[D, DType.uint32](vector)

    # NOTE: I hoped that the code below would make the algorithm faster but it made it slower
    # let size = len(vector)
    # alias m8 = max_or_inf[DType.uint8]().to_int()
    # alias m16 = max_or_inf[DType.uint16]().to_int()
    # alias m32 = max_or_inf[DType.uint32]().to_int()

    # if size <= m16:
    #     if size > m8:
    #         return _radix_sort[D, DType.uint16](vector)
    #     return _radix_sort[D, DType.uint8](vector)
    # if size <= m32:
    #     return _radix_sort[D, DType.uint32](vector)
    # return _radix_sort[D, DType.uint64](vector)


