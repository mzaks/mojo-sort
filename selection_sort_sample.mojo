from selection_sort import selection_sort

fn main():
    var v1 = List[UInt32]()
    v1.append(13)
    v1.append(31)
    v1.append(1)
    v1.append(7)
    v1.append(7)
    v1.append(4513)
    v1.append(45)

    print(v1)

    selection_sort(v1)
    print(v1)



