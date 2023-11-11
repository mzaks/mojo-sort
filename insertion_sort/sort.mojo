fn insertion_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
    for i in range(1, len(vector)):
        let key = vector[i]
        var j = i - 1
        while j >= 0 and key < vector[j]:
            vector[j + 1] = vector[j]
            j -= 1
        vector[j + 1] = key

fn insertion_sort[D: AnyType, lt: fn(D, D) -> Bool](inout vector: Pointer[D], length: Int):
    for i in range(1, length):
        let key = vector[i]
        var j = i - 1
        while j >= 0 and lt(key, vector[j]):
            vector.store(j + 1, vector[j])
            j -= 1
        vector.store(j + 1, key)

fn insertion_sort[D: AnyType, lt: fn(D, D) -> Bool](inout vector: DynamicVector[D]):
    insertion_sort[D, lt](vector.data, len(vector))

fn insertion_sort[D: AnyType, lt: fn(D, D) -> Bool](inout vector: UnsafeFixedVector[D]):
    insertion_sort[D, lt](vector.data, len(vector))