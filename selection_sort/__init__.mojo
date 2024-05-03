
fn selection_sort[D: DType](inout vector: List[SIMD[D, 1]]):
    for i in range(len(vector)):
        var min_idx = i
        for j in range(i + 1, len(vector)):
            if vector[j] < vector[min_idx]:
                min_idx = j
        vector[i], vector[min_idx] = vector[min_idx], vector[i]