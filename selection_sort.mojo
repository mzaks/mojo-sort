from vec import print_v

fn selection_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
    for i in range(len(vector)):
        var min_idx = i
        for j in range(i + 1, len(vector)):
            if vector[j] < vector[min_idx]:
                min_idx = j
        vector[i], vector[min_idx] = vector[min_idx], vector[i]

fn main():
    var v1 = DynamicVector[UInt32]()
    v1.push_back(13)
    v1.push_back(31)
    v1.push_back(1)
    v1.push_back(7)
    v1.push_back(7)
    v1.push_back(4513)
    v1.push_back(45)

    print_v[DType.uint32](v1)

    selection_sort[DType.uint32](v1)
    print_v[DType.uint32](v1)



