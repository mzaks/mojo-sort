from my_utils import *
from string_compare import lt
from insertion_sort import insertion_sort
from quick_sort import quick_sort
from radix_sorting import msb_radix_sort
from multi_key_quicksort import multi_key_quicksort

fn is_sorted(elements: List[String]) -> Bool:
    var current = elements[0]
    for i in range(1, len(elements)):
        if elements[i] != current and lt(elements[i], current):
            print("!!!", current, elements[i])
            return False
    return True 

fn main():
    # var n = 0b01101001

    # var mask = SIMD[DType.bool, 8](True, False, False, True, False, True, True, False)
    # var res = bitcast[DType.uint8](mask)
    # print(res, n)

    # var a = Int32(-1)
    # print(rebind[SIMD[DType.uint32, 1]](a))


    # for i in range(len(s)):
    #     print(s._as_ptr().bitcast[DType.uint8]().load(i))
    # _ = s
    print("+++++IN+++++")
    var corpus = corpus4()
    insertion_sort[String, lt](corpus)
    print_v(corpus)
    if not is_sorted(corpus):
        print("NO!!!!")

    print("+++++QK+++++")
    corpus = corpus2()
    quick_sort[String, lt](corpus)
    print_v(corpus)
    if not is_sorted(corpus):
        print("NO!!!!")

    print("+++++RX+++++")
    corpus = corpus2()
    msb_radix_sort(corpus)
    print_v(corpus)
    if not is_sorted(corpus):
        print("NO!!!!")

    print("+++++MK+++++")
    corpus = corpus2()
    multi_key_quicksort(corpus)
    print_v(corpus)
    if not is_sorted(corpus):
        print("NO!!!!")