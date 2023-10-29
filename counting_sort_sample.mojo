from my_utils import print_v, print_iv
from count_sort import counting_sort

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

    counting_sort[DType.uint32](v1)
    print_v[DType.uint32](v1)