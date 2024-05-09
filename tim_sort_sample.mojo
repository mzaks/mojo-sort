from random import random_ui64
from my_utils import print_v
from tim_sort import tim_sort

fn main():
    var v1 = List[UInt32]()
    v1.append(13)
    v1.append(31)
    v1.append(1)
    v1.append(7)
    v1.append(7)
    v1.append(4513)
    v1.append(45)

    print_v(v1) 

    tim_sort(v1)
    print_v(v1)

    var v2 = List[UInt64]()
    for _ in range(100):
        v2.append(random_ui64(0, 1000))

    print_v(v2) 
    tim_sort(v2)
    print_v(v2)