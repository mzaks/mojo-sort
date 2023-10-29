
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