from binary_search import binary_search, classic_binary_search
from benchmark import run
from random import random_ui64

fn main():
    var l = DynamicVector[UInt64]()
    let count = 200
    let searches = 5_000_000
    for i in range(count):
        l.push_back(i)
    
    var total = 0

    @parameter
    fn binary_search_random_items():
        for _ in range(searches):
            total += binary_search[with_prefetch=True](l.data, len(l), random_ui64(0, count - 1))


    @parameter
    fn classic_binary_search_random_items():
        for _ in range(searches):
            total += classic_binary_search(l.data, len(l), random_ui64(0, count - 1))

    let result = run[binary_search_random_items]()
    result.print_full()

    let result_classic = run[classic_binary_search_random_items]()
    result_classic.print_full()

    print("Classic", result_classic.mean() / result.mean())
    print(total)