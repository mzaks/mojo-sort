
fn insertion_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
    for i in range(1, len(vector)):
        let key = vector[i]
        var j = i - 1
        while j >= 0 and key < vector[j]:
            vector[j + 1] = vector[j]
            j -= 1
        vector[j + 1] = key