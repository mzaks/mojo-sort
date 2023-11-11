from my_utils import print_v, vector
from insertion_sort import insertion_sort
from string_compare import lt, lt2, lt3
from hash_utils import corpus4, corpus7
from time import now


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

    insertion_sort[DType.uint32](v1)
    print_v[DType.uint32](v1)

    var v2 = vector("d", "a", "bb", "ab", "dfg", "efgds")
    print_v(v2)
    insertion_sort[StringLiteral, lt](v2)
    print_v(v2)

    var corpus = corpus7()
    var tik = now()
    insertion_sort[StringLiteral, lt3](corpus)
    var tok = now()
    print_v(corpus)
    print(tok - tik)

    corpus = corpus4()
    tik = now()
    insertion_sort[StringLiteral, lt3](corpus)
    tok = now()
    print_v(corpus)
    print(tok - tik)
