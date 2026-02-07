fn bubble_sort[D: DType, //](mut list: List[Scalar[D]]):
    var n = len(list)
    for i in range(1, n):
        var sorted = True
        for j in range(n-i):
            if (list[j] > list[j + 1]):
                list[j], list[j + 1] = list[j + 1], list[j]
                sorted = False
            
        if sorted:
            break