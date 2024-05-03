from my_utils import *
from radix_sorting import radix_sort, radix_sort11, radix_sort13, radix_sort16


fn test_radix():
    var v1 = List[UInt32]()
    v1.append(13)
    v1.append(31)
    v1.append(1)
    v1.append(7)
    v1.append(7)
    v1.append(4513)
    v1.append(45)

    print_v(v1)

    radix_sort(v1)
    print_v(v1)

    var v2 = List[Int8]()
    v2.append(0)
    v2.append(-23)
    v2.append(123)
    v2.append(-48)
    print_v(v2)

    radix_sort(v2)
    print_v(v2)

    var v3 = List[Float32]()
    v3.append(0)
    v3.append(-23)
    v3.append(123)
    v3.append(-48)
    v3.append(-48.1)
    v3.append(48.111)
    v3.append(48.101)
    v3.append(48.10111)
    v3.append(-0.10111)
    v3.append(0.10111)
    print_v(v3)

    radix_sort(v3)
    print_v(v3)

    var v4 = List[Float64]()
    v4.append(0)
    v4.append(-23)
    v4.append(123)
    v4.append(-48)
    v4.append(-48.1)
    v4.append(48.111)
    v4.append(48.101)
    v4.append(48.10111)
    v4.append(-0.10111)
    v4.append(0.10111)
    print_v(v4)

    radix_sort(v4)
    print_v(v4)

    print("DONE!!")

fn test_11():
    var v3 = List[Float32]()
    v3.append(0)
    v3.append(-23)
    v3.append(123)
    v3.append(-48)
    v3.append(-48.1)
    v3.append(48.111)
    v3.append(48.101)
    v3.append(48.10111)
    v3.append(-0.10111)
    v3.append(0.10111)
    print_v(v3)

    radix_sort11(v3)
    print_v(v3)

fn test_13():
    var v3 = List[Float64]()
    v3.append(0)
    v3.append(-23)
    v3.append(123)
    v3.append(-48)
    v3.append(-48.1)
    v3.append(48.111)
    v3.append(48.101)
    v3.append(48.10111)
    v3.append(-0.10111)
    v3.append(0.10111)
    print_v(v3)

    radix_sort13(v3)
    print_v(v3)

fn test_16():
    var v3 = List[Float64]()
    v3.append(0)
    v3.append(-23)
    v3.append(123)
    v3.append(-48)
    v3.append(-48.1)
    v3.append(48.111)
    v3.append(48.101)
    v3.append(48.10111)
    v3.append(-0.10111)
    v3.append(0.10111)
    print_v(v3)

    radix_sort16(v3)
    print_v(v3)


fn main():
    test_radix()
    test_11()
    test_13()
    test_16()
