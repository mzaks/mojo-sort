# from string_compare import lt
from insertion_sort import insertion_sort
from time import perf_counter_ns as now
from my_utils import *


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

    insertion_sort[DType.uint32](v1)
    
    print(v1)

    var v2: List[String] = ["d", "a", "bb", "ab", "dfg", "efgds"]
    print(v2)
    
    insertion_sort[String, String.__lt__](v2)
    print(v2)

    var corpus = corpus7()
    var tik = now()
    insertion_sort[String, String.__lt__](corpus)
    var tok = now()
    print(corpus)
    print(tok - tik, len(corpus))

    corpus = corpus3()
    tik = now()
    insertion_sort[String, String.__lt__](corpus)
    tok = now()
    print(corpus)
    print(tok - tik, len(corpus))
