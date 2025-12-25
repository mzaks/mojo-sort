from binary_search import binary_search, classic_binary_search
from benchmark import run
from random import random_ui64

def main():
    var l = List[UInt64]()
    var count = 200
    var searches = 5_000_000
    for i in range(count):
        l.append(i)
    
    var total = 0
    var random_elements = List[UInt64](capacity=searches)
    for _ in range(searches):
        var value = random_ui64(0, count - 1)
        total += Int(value)
        random_elements.append(value)

    var total1 = 0
    @parameter
    fn binary_search_random_items():
        total1 = 0
        for i in range(searches):
            total1 += binary_search[with_prefetch=False](l.data, len(l), random_elements[i])
    
    var total2 = 0
    @parameter
    fn classic_binary_search_random_items():
        total2 = 0
        for i in range(searches):
            total2 += classic_binary_search(l.data, len(l), random_elements[i])

    var result = run[binary_search_random_items]()
    result.print_full()

    var result_classic = run[classic_binary_search_random_items]()
    result_classic.print_full()

    print("Classic", result_classic.mean() / result.mean())
    print(total, total1, total2)