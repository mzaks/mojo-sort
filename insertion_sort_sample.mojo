from my_utils import print_v, corpus4, corpus7, lte_s
from insertion_sort import insertion_sort
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

    insertion_sort[DType.uint32](v1)
    
    print_v(v1)

    var v2 = List(str("d"), str("a"), str("bb"), str("ab"), str("dfg"), str("efgds"))
    print_v(v2)
    
    insertion_sort[String, lte_s](v2)
    print_v(v2)

    var corpus = corpus7()
    var tik = now()
    insertion_sort[String, lte_s](corpus)
    var tok = now()
    print_v(corpus)
    print(tok - tik)

    corpus = corpus4()
    tik = now()
    insertion_sort[String, lte_s](corpus)
    tok = now()
    print_v(corpus)
    print(tok - tik)
