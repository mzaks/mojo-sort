from random import random_ui64
from my_utils import print_v
from tim_sort import tim_sort, parallel_tim_sort

from time import now

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
        v2.append(random_ui64(0, 100000000))

    print_v(v2)
    var v3 = List(v2)
    var tik = now()
    tim_sort(v3)
    var tok = now()
    print_v(v3)
    print("Ser in", tok - tik)

    var v4 = List(v2)
    tik = now()
    parallel_tim_sort(v4)
    tok = now()
    print_v(v4)
    print("Par in", tok - tik)