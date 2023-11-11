
@always_inline
fn _partition[D: DType](inout vector: DynamicVector[SIMD[D, 1]], low: Int, high: Int) -> Int:
    let pivot = vector[high]
    var i = low - 1
    for j in range(low, high):
        if vector[j] <= pivot:
            i += 1
            vector[j], vector[i] = vector[i], vector[j]
    vector[i + 1], vector[high] = vector[high], vector[i + 1]
    return i + 1

fn _quick_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]], low: Int, high: Int):
    if low < high:
        let pi = _partition[D](vector, low, high)
        _quick_sort[D](vector, low, pi - 1)
        _quick_sort[D](vector, pi + 1, high)

fn quick_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
    _quick_sort[D](vector, 0, len(vector) - 1)

@always_inline
fn swap[D: AnyType](inout vector: Pointer[D], a: Int, b: Int):
    let tmp = vector[a]
    vector.store(a, vector[b])
    vector.store(b, tmp)

@always_inline
fn _partition[D: AnyType, lt: fn (D, D) -> Bool](inout vector: Pointer[D], low: Int, high: Int) -> Int:
    let pivot = vector[high]
    var i = low - 1
    for j in range(low, high):
        if lt(vector[j], pivot):
            i += 1
            swap(vector, i, j)
    
    swap(vector, i + 1, high)
    return i + 1

fn _quick_sort[D: AnyType, lt: fn (D, D) -> Bool](inout vector: Pointer[D], low: Int, high: Int):
    if low < high:
        let pi = _partition[D, lt](vector, low, high)
        _quick_sort[D, lt](vector, low, pi - 1)
        _quick_sort[D, lt](vector, pi + 1, high)

fn quick_sort[D: AnyType, lt: fn (D, D) -> Bool](inout vector: Pointer[D], length: Int):
     _quick_sort[D, lt](vector, 0, length - 1)

fn quick_sort[D: AnyType, lt: fn (D, D) -> Bool](inout vector: UnsafeFixedVector[D]):
     _quick_sort[D, lt](vector.data, 0, len(vector) - 1)

fn quick_sort[D: AnyType, lt: fn (D, D) -> Bool](inout vector: DynamicVector[D]):
     _quick_sort[D, lt](vector.data, 0, len(vector) - 1)
