from random import random_ui64
# from my_utils import print_v
from tim_sort import tim_sort, tim_sort_scalar, parallel_tim_sort, parallel_tim_sort_scalar

# from time import now
from time import perf_counter_ns

fn assert_sorted[D: DType](vector: List[Scalar[D]]):
    for i in range(1, len(vector)):
        if vector[i] < vector[i - 1]:
            print("!!!! " + String(i))
            # print(vector[:i+1])
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

    print(v1) 

    tim_sort_scalar(v1)
    print(v1)

    var v2 = List[UInt64]()
    for _ in range(1_000_000):
        v2.append(random_ui64(0, 100000000))

    var v3 = List(v2)
    var tik = perf_counter_ns()
    tim_sort(v3)
    # print(v3)
    var tok = perf_counter_ns()
    # print_v(v3)
    var ser_d = tok - tik
    print("Ser  in", ser_d, "ns")

    var v5 = List(v2)
    tik = perf_counter_ns()
    parallel_tim_sort_scalar(v5)
    tok = perf_counter_ns()
    # print_v(v4)
    print("Par  in", tok - tik, "ns")
    print(ser_d / (tok - tik))

    assert_sorted(v3)
    assert_sorted(v5)