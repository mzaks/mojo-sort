from vec import print_v

fn insertion_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
    for i in range(1, len(vector)):
        let key = vector[i]
        var j = i - 1
        while j >= 0 and key < vector[j]:
            vector[j + 1] = vector[j]
            j -= 1
        vector[j + 1] = key

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

    insertion_sort[DType.uint32](v1)
    print_v[DType.uint32](v1)



