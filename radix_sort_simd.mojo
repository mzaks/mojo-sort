from memory import memset_zero, memcpy, stack_allocation
from tensor import Tensor, TensorSpec
from utils.index import Index
from vec import print_v, print_iv


fn radix_sort_u64(inout vector: DynamicVector[UInt64]):
    let size = len(vector)
    var output = DynamicVector[UInt64](size)
    memset_zero(output.data, size)
    output.resize(size)
    memcpy(vector.data, output.data, size)

    let counts_spec = TensorSpec(DType.uint32, 256, 8)
    var counts = Tensor[DType.uint32](counts_spec)
    memset_zero(counts.data(), 8 * 256)
    

    let p = DTypePointer[DType.uint64](vector.data).bitcast[DType.uint8]()    
    for i in range(0, size * 8, 8):
        let indeces = p.offset(i).simd_load[8]()
        for j in range(8):
            counts[Index(indeces[j].to_int(), j)] += 1
    
    var c0 = counts.simd_load[8](0)
    for i in range(8, 256 * 8, 8):
        c0 += counts.simd_load[8](i)
        counts.simd_store[8](i, c0)

    for i in range(0, 256 * 8, 8):
        let c0 = counts.simd_load[8](i)
        print(i//8, ":", c0)

    for j in range(8):
        var i = size - 1
        while i >= 0:
            let index = p.offset(i).simd_load[8]()[j].to_int()
            print(j, i, index)
            let new_index = (counts[Index(j, index)] - 1).to_int()
            print(new_index)
            output[new_index] = vector[i]
            counts[Index(j, index)] -= 1
            i -= 1
        memcpy(vector.data, output.data, size)
    
    # print_v[DType.uint64](output)
    # 
    
    

fn main():
    var v1 = DynamicVector[UInt64]()
    v1.push_back(13)
    v1.push_back(31)
    v1.push_back(1)
    v1.push_back(7)
    v1.push_back(7)
    v1.push_back(4513)
    v1.push_back(45)


    radix_sort_u64(v1)
    print_v[DType.uint64](v1)