from random import random_ui64
from my_utils import print_v
from tim_sort import tim_sort, parallel_tim_sort

from time import now

fn assert_sorted[D: DType](vector: List[Scalar[D]]):
    for i in range(1, len(vector)):
        if vector[i] < vector[i - 1]:
            print("!!!! " + str(i))
            print_v(vector[:i+1])
            return

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
    for _ in range(2000000):
        v2.append(random_ui64(0, 100000000))

    var v3 = List(v2)
    var tik = now()
    tim_sort(v3)
    var tok = now()
    # print_v(v3)
    var ser_d = tok - tik
    print("Ser  in", ser_d)

    var v5 = List(v2)
    tik = now()
    parallel_tim_sort(v5)
    tok = now()
    # print_v(v4)
    print("Par  in", tok - tik)
    print(ser_d / (tok - tik))

    assert_sorted(v3)