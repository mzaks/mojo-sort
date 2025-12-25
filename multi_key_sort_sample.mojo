from multi_key_quicksort import multi_key_quicksort
from my_utils import corpus4, corpus7
from time import perf_counter_ns as now


fn main():
    var v1: List[String] = ["a", "d"]
    print(v1)
    multi_key_quicksort(v1)
    print(v1)

    v1 = ["sam", "same", "her", "make", "zebra"]
    print(v1)
    multi_key_quicksort(v1)
    print(v1)

    v1 = ["d", "a", "bb", "ab", "dfg", "efgds"]
    var start = now()
    print(v1)
    multi_key_quicksort(v1)
    print(v1)
    print(now() - start)

    var corpus = corpus7()
    print(corpus)
    var tik = now()
    multi_key_quicksort(corpus)
    var tok = now()
    print("----")
    print(corpus)
    print(tok - tik)

    print("===")
    corpus = corpus4()
    print(corpus)
    tik = now()
    multi_key_quicksort(corpus)
    tok = now()
    print("----")
    print(corpus)
    print(tok - tik)