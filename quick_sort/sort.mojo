
@always_inline
fn _partition[D: DType](inout vector: List[SIMD[D, 1]], low: Int, high: Int) -> Int:
    var pivot = vector[high]
    var i = low - 1
    for j in range(low, high):
        if vector[j] <= pivot:
            i += 1
            vector[j], vector[i] = vector[i], vector[j]
    vector[i + 1], vector[high] = vector[high], vector[i + 1]
    return i + 1

fn _quick_sort[D: DType](inout vector: List[SIMD[D, 1]], low: Int, high: Int):
    if low < high:
        var pi = _partition(vector, low, high)
        _quick_sort(vector, low, pi - 1)
        _quick_sort(vector, pi + 1, high)

fn quick_sort[D: DType](inout vector: List[SIMD[D, 1]]):
    _quick_sort[D](vector, 0, len(vector) - 1)

@always_inline
fn swap[D: CollectionElement](inout vector: List[D], a: Int, b: Int):
    vector[a], vector[b] = vector[b], vector[a]

@always_inline
fn _partition[D: CollectionElement, lte: fn (D, D) -> Bool](inout vector: List[D], low: Int, high: Int) -> Int:
    var pivot = vector[high]
    var i = low - 1
    for j in range(low, high):
        if lte(vector[j], pivot):
            i += 1
            swap(vector, i, j)
    
    swap(vector, i + 1, high)
    return i + 1

fn _quick_sort[D: CollectionElement, lte: fn (D, D) -> Bool](inout vector: List[D], low: Int, high: Int):
    if low < high:
        var pi = _partition[D, lte](vector, low, high)
        _quick_sort[D, lte](vector, low, pi - 1)
        _quick_sort[D, lte](vector, pi + 1, high)

fn quick_sort[D: CollectionElement, lt: fn (D, D) -> Bool](inout vector: List[D]):
    _quick_sort[D, lt](vector, 0, len(vector) - 1)
