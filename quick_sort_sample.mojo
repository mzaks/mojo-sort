
from my_utils import *
from string_compare import lt
from quick_sort import quick_sort
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

    quick_sort(v1)
    print_v(v1)

    var corpus = corpus7()
    var tik = now()
    quick_sort[String, lt](corpus)
    var tok = now()
    print_v(corpus)
    print(tok - tik)

    corpus = corpus3()
    tik = now()
    quick_sort[String, lt](corpus)
    tok = now()
    print_v(corpus)
    print(tok - tik)