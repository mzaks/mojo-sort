
from memory import memset_zero, memcpy

fn counting_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
    let size = len(vector)
    var output = DynamicVector[SIMD[D, 1]](size)
    var max_value = 0
    for i in range(size):
        if vector[i] > max_value:
            max_value = vector[i].to_int()
        output.push_back(0)

    var counts = DynamicVector[Int](max_value + 1)
    memset_zero(counts.data, max_value + 1)
    counts.resize(max_value + 1)

    for i in range(size):
        counts[vector[i].to_int()] += 1
    
    for i in range(1, len(counts)):
        counts[i] += counts[i - 1]

    var i = size - 1
    while i >= 0:
        output[counts[vector[i].to_int()] - 1] = vector[i]
        counts[vector[i].to_int()] -= 1
        i -= 1
    
    memcpy(vector.data, output.data, size)