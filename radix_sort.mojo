from algorithm import unroll
from memory import memset_zero, memcpy, stack_allocation
from memory.unsafe import bitcast
from math.limit import max_or_inf
from vec import print_v, print_iv

alias last_bit_8 = 1 << 7
alias last_bit_16 = 1 << 15
alias last_bit_32 = 1 << 31
alias last_bit_64 = 1 << 63

@always_inline
fn _get_index[D: DType, place: Int](vector: DynamicVector[SIMD[D, 1]], v_index: Int) -> Int:
    @parameter
    if D == DType.int8:
        return ((bitcast[DType.uint8, 1](vector[v_index]) ^ last_bit_8) >> place).to_int() & 255
    elif D == DType.int16:
        return ((bitcast[DType.uint16, 1](vector[v_index]) ^ last_bit_16) >> place).to_int() & 255
    elif D == DType.float16:
        let f = bitcast[DType.uint16, 1](vector[v_index])
        let mask = bitcast[DType.uint16, 1](-bitcast[DType.int16, 1](f >> 15) | last_bit_16)
        return ((f ^ mask) >> place).to_int() & 255
    elif D == DType.int32:
        return ((bitcast[DType.uint32, 1](vector[v_index]) ^ last_bit_32) >> place).to_int() & 255
    elif D == DType.float32:
        let f = bitcast[DType.uint32, 1](vector[v_index])
        let mask = bitcast[DType.uint32, 1](-bitcast[DType.int32, 1](f >> 31) | last_bit_32)
        return ((f ^ mask) >> place).to_int() & 255
    elif D == DType.int64:
        return ((bitcast[DType.uint64, 1](vector[v_index]) ^ last_bit_64) >> place).to_int() & 255
    elif D == DType.float64:
        let f = bitcast[DType.uint64, 1](vector[v_index])
        let mask = bitcast[DType.uint64, 1](-bitcast[DType.int64, 1](f >> 63) | last_bit_64)
        return ((f ^ mask) >> place).to_int() & 255
    else:
        return (vector[v_index] >> place).to_int() & 255

@always_inline
fn _counting_sort[D: DType, CD:DType, place: Int](inout vector: DynamicVector[SIMD[D, 1]]):
    let size = len(vector)
    var output = DynamicVector[SIMD[D, 1]](size)
    memset_zero(output.data, size)
    output.resize(size)

    let counts = stack_allocation[256, CD]()
    memset_zero(counts, 256)
    
    for i in range(size):
        let index = _get_index[D, place](vector, i)
        counts.offset(index).store(counts.offset(index).load() + 1)
    
    # var count = counts.offset(0).load()
    # for i in range(1, 256):
    #     count += counts.offset(i).load()
    #     counts.offset(i).store(count)

    var part = counts.simd_load[256]()
    part += part.shift_right[1]()
    part += part.shift_right[2]()
    part += part.shift_right[4]()
    part += part.shift_right[8]()
    part += part.shift_right[16]()
    part += part.shift_right[32]()
    part += part.shift_right[64]()
    part += part.shift_right[128]()

    counts.simd_store(part)
        

    var i = size - 1
    while i >= 0:
        let index = _get_index[D, place](vector, i)
        output[(counts.offset(index).load() - 1).to_int()] = vector[i]
        counts.offset(index).store(counts.offset(index).load() - 1)
        i -= 1
    
    memcpy(vector.data, output.data, size)

@always_inline
fn _radix_sort[D: DType, CD: DType](inout vector: DynamicVector[SIMD[D, 1]]):

    @parameter
    fn call_counting_sort[index: Int]():
        _counting_sort[D, CD, index * 8](vector)
    
    @parameter
    if D.bitwidth() == 8:
        unroll[1, call_counting_sort]()
    elif D.bitwidth() == 16:
        unroll[2, call_counting_sort]()
    elif D.bitwidth() == 32:
        unroll[4, call_counting_sort]()
    else:
        unroll[8, call_counting_sort]()

@always_inline
fn radix_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
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


fn main():
    var v1 = DynamicVector[UInt32]()
    v1.push_back(13)
    v1.push_back(31)
    v1.push_back(1)
    v1.push_back(7)
    v1.push_back(7)
    v1.push_back(4513)
    v1.push_back(45)

    print_v[DType.uint32](v1)

    radix_sort[DType.uint32](v1)
    print_v[DType.uint32](v1)

    var v2 = DynamicVector[Int8]()
    v2.push_back(0)
    v2.push_back(-23)
    v2.push_back(123)
    v2.push_back(-48)
    print_v[DType.int8](v2)

    radix_sort[DType.int8](v2)
    print_v[DType.int8](v2)

    var v3 = DynamicVector[Float32]()
    v3.push_back(0)
    v3.push_back(-23)
    v3.push_back(123)
    v3.push_back(-48)
    v3.push_back(-48.1)
    v3.push_back(48.111)
    v3.push_back(48.101)
    v3.push_back(48.10111)
    v3.push_back(-0.10111)
    v3.push_back(0.10111)
    print_v[DType.float32](v3)

    radix_sort[DType.float32](v3)
    print_v[DType.float32](v3)

    var v4 = DynamicVector[Float64]()
    v4.push_back(0)
    v4.push_back(-23)
    v4.push_back(123)
    v4.push_back(-48)
    v4.push_back(-48.1)
    v4.push_back(48.111)
    v4.push_back(48.101)
    v4.push_back(48.10111)
    v4.push_back(-0.10111)
    v4.push_back(0.10111)
    print_v[DType.float64](v4)

    radix_sort[DType.float64](v4)
    print_v[DType.float64](v4)