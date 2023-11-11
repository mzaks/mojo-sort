from multi_key_quicksort import multi_key_quicksort
from my_utils import vector, print_v
from hash_utils import corpus4, corpus7
from time import now

fn main():
    var v1 = vector("a", "d")
    print_v(v1)
    multi_key_quicksort(v1)
    print_v(v1)

    v1 = vector("sam", "same", "her", "make", "zebra")
    print_v(v1)
    multi_key_quicksort(v1)
    print_v(v1)

    v1 = vector("d", "a", "bb", "ab", "dfg", "efgds")
    print_v(v1)
    multi_key_quicksort(v1)
    print_v(v1)

    var corpus = corpus7()
    print_v(corpus)
    var tik = now()
    multi_key_quicksort(corpus)
    var tok = now()
    print_v(corpus)
    print(tok - tik)

    corpus = corpus4()
    print_v(corpus)
    tik = now()
    multi_key_quicksort(corpus)
    tok = now()
    print_v(corpus)
    print(tok - tik)