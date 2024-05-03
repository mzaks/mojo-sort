from multi_key_quicksort import multi_key_quicksort
from my_utils import print_v, corpus4, corpus7
from time import now


fn main():
    var v1 = List[String]("a", "d")
    print_v(v1)
    multi_key_quicksort(v1)
    print_v(v1)

    v1 = List[String]("sam", "same", "her", "make", "zebra")
    print_v(v1)
    multi_key_quicksort(v1)
    print_v(v1)

    v1 = List[String]("d", "a", "bb", "ab", "dfg", "efgds")
    var start = now()
    print_v(v1)
    multi_key_quicksort(v1)
    print_v(v1)
    print(now() - start)

    var corpus = corpus7()
    print_v(corpus)
    var tik = now()
    multi_key_quicksort(corpus)
    var tok = now()
    print("----")
    print_v(corpus)
    print(tok - tik)

    print("===")
    corpus = corpus4()
    print_v(corpus)
    tik = now()
    multi_key_quicksort(corpus)
    tok = now()
    print("----")
    print_v(corpus)
    print(tok - tik)