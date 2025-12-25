fn insertion_sort[D: DType](mut vector: List[Scalar[D]]):
    for i in range(1, len(vector)):
        var key = vector[i]
        var j = i - 1
        while j >= 0 and key < vector[j]:
            vector[j + 1] = vector[j]
            j -= 1
        vector[j + 1] = key

fn insertion_sort[D: Copyable, lt: fn(D, D) -> Bool](mut vector: List[D]):
    for i in range(1, len(vector)):
        var key = vector[i].copy()
        var j = i - 1
        while j >= 0 and lt(key, vector[j]):
            vector[j + 1] = vector[j].copy()
            j -= 1
        vector[j + 1] = key.copy()
