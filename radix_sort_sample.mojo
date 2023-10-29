from my_utils import *
from radix_sorting import radix_sort, radix_sort11, radix_sort13, radix_sort16


fn test_radix():
    var v1 = DynamicVector[UInt32]()
    v1.push_back(13)
    v1.push_back(31)
    v1.push_back(1)
    v1.push_back(7)
    v1.push_back(7)
    v1.push_back(4513)
    v1.push_back(45)

    print_v[DType.uint32](v1)

    radix_sort[DType.uint32](v1)
    print_v[DType.uint32](v1)

    var v2 = DynamicVector[Int8]()
    v2.push_back(0)
    v2.push_back(-23)
    v2.push_back(123)
    v2.push_back(-48)
    print_v[DType.int8](v2)

    radix_sort[DType.int8](v2)
    print_v[DType.int8](v2)

    var v3 = DynamicVector[Float32]()
    v3.push_back(0)
    v3.push_back(-23)
    v3.push_back(123)
    v3.push_back(-48)
    v3.push_back(-48.1)
    v3.push_back(48.111)
    v3.push_back(48.101)
    v3.push_back(48.10111)
    v3.push_back(-0.10111)
    v3.push_back(0.10111)
    print_v[DType.float32](v3)

    radix_sort[DType.float32](v3)
    print_v[DType.float32](v3)

    var v4 = DynamicVector[Float64]()
    v4.push_back(0)
    v4.push_back(-23)
    v4.push_back(123)
    v4.push_back(-48)
    v4.push_back(-48.1)
    v4.push_back(48.111)
    v4.push_back(48.101)
    v4.push_back(48.10111)
    v4.push_back(-0.10111)
    v4.push_back(0.10111)
    print_v[DType.float64](v4)

    radix_sort[DType.float64](v4)
    print_v[DType.float64](v4)

fn test_11():
    var v3 = DynamicVector[Float32]()
    v3.push_back(0)
    v3.push_back(-23)
    v3.push_back(123)
    v3.push_back(-48)
    v3.push_back(-48.1)
    v3.push_back(48.111)
    v3.push_back(48.101)
    v3.push_back(48.10111)
    v3.push_back(-0.10111)
    v3.push_back(0.10111)
    print_v[DType.float32](v3)

    radix_sort11(v3)
    print_v[DType.float32](v3)

fn test_13():
    var v3 = DynamicVector[Float64]()
    v3.push_back(0)
    v3.push_back(-23)
    v3.push_back(123)
    v3.push_back(-48)
    v3.push_back(-48.1)
    v3.push_back(48.111)
    v3.push_back(48.101)
    v3.push_back(48.10111)
    v3.push_back(-0.10111)
    v3.push_back(0.10111)
    print_v[DType.float64](v3)

    radix_sort13(v3)
    print_v[DType.float64](v3)

fn test_16():
    var v3 = DynamicVector[Float64]()
    v3.push_back(0)
    v3.push_back(-23)
    v3.push_back(123)
    v3.push_back(-48)
    v3.push_back(-48.1)
    v3.push_back(48.111)
    v3.push_back(48.101)
    v3.push_back(48.10111)
    v3.push_back(-0.10111)
    v3.push_back(0.10111)
    print_v[DType.float64](v3)

    radix_sort16(v3)
    print_v[DType.float64](v3)


fn main():
    test_radix()
    test_11()
    test_13()
    test_16()
