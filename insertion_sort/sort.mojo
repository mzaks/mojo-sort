fn insertion_sort[D: DType](inout vector: List[SIMD[D, 1]]):
    for i in range(1, len(vector)):
        var key = vector[i]
        var j = i - 1
        while j >= 0 and key < vector[j]:
            vector[j + 1] = vector[j]
            j -= 1
        vector[j + 1] = key

fn insertion_sort[D: CollectionElement, lt: fn(D, D) -> Bool](inout vector: List[D]):
    for i in range(1, len(vector)):
        var key = vector[i]
        var j = i - 1
        while j >= 0 and lt(key, vector[j]):
            vector[j + 1] = vector[j]
            j -= 1
        vector[j + 1] = key
