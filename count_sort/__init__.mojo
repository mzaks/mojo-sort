
from memory import memset_zero, memcpy

fn counting_sort[D: DType](mut vector: List[SIMD[D, 1]]):
    var size = len(vector)
    var output = List[SIMD[D, 1]](capacity=size)
    var max_value = 0
    for i in range(size):
        if vector[i] > max_value:
            max_value = Int(vector[i])
        output.append(0)

    var counts = List[Int](capacity=max_value + 1)
    counts.resize(max_value + 1, 0)

    for i in range(size):
        counts[vector[i]] += 1
    
    for i in range(1, len(counts)):
        counts[i] += counts[i - 1]

    var i = size - 1
    while i >= 0:
        output[counts[vector[i]] - 1] = vector[i]
        counts[vector[i]] -= 1
        i -= 1
    
    vector = output^