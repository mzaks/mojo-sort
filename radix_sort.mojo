from memory import memset_zero, memcpy, stack_allocation
from vec import print_v, print_iv

@always_inline
fn _counting_sort[D: DType, place: Int](inout vector: DynamicVector[SIMD[D, 1]]):
    let size = len(vector)
    var output = DynamicVector[SIMD[D, 1]](size)
    memset_zero(output.data, size)
    output.resize(size)

    let counts = stack_allocation[256, DType.uint64]()
    memset_zero(counts, 256)

    for i in range(size):
        let index = (vector[i] >> place).to_int()
        counts.offset(index & 255).store(counts.offset(index & 255).load() + 1)
    
    for i in range(1, 256):
        counts.offset(i).store(counts.offset(i).load() + counts.offset(i - 1).load())

    var i = size - 1
    while i >= 0:
        let index = (vector[i] >> place).to_int() & 255
        output[(counts.offset(index).load() - 1).to_int()] = vector[i]
        counts.offset(index).store(counts.offset(index).load() - 1)
        i -= 1
    
    memcpy(vector.data, output.data, size)

@always_inline
fn radix_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
    @parameter
    if D.bitwidth() == 8:
        _counting_sort[D, 0](vector)
    elif D.bitwidth() == 16:
        _counting_sort[D, 0](vector)
        _counting_sort[D, 8](vector)
    elif D.bitwidth() == 32:
        _counting_sort[D, 0](vector)
        _counting_sort[D, 8](vector)
        _counting_sort[D, 16](vector)
        _counting_sort[D, 24](vector)
    else:
        _counting_sort[D, 0](vector)
        _counting_sort[D, 8](vector)
        _counting_sort[D, 16](vector)
        _counting_sort[D, 24](vector)
        _counting_sort[D, 32](vector)
        _counting_sort[D, 40](vector)
        _counting_sort[D, 48](vector)
        _counting_sort[D, 56](vector)

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