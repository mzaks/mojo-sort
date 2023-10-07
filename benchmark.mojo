from random import random_ui64
from math import min
from math.limit import max_or_inf
from vec import print_v
from time import now
from algorithm.sort import sort
from quick_sort import quick_sort
from radix_sort import radix_sort
from selection_sort import selection_sort
from insertion_sort import insertion_sort
from counting_sort import counting_sort

fn random_uivec[D: DType](size: Int, max: Int = 3000) -> DynamicVector[SIMD[D, 1]]:
    var result = DynamicVector[SIMD[D, 1]](size)
    for _ in range(size):
        result.push_back(random_ui64(0, max).cast[D]())
    return result

fn assert_sorted[D: DType](vector: DynamicVector[SIMD[D, 1]]):
    for i in range(1, len(vector)):
        if vector[i] < vector[i - 1]:
            print(", 0")
            return
    print(", 1")

fn benchmark[D: DType, func: fn(inout DynamicVector[SIMD[D, 1]]) -> None](
    name: StringLiteral, size: Int, max: Int = 3000
):
    let v = random_uivec[D](size, max)
    var v1 = v.deepcopy()
    var min_duration = max_or_inf[DType.int64]()
    for _ in range(10):
        v1 = v.deepcopy()
        let tik = now()
        func(v1)
        let tok = now()
        min_duration = min(min_duration, tok - tik)
    print_no_newline(name, D)
    print_no_newline(",", size, ",", max, ",", min_duration)
    assert_sorted[D](v1)

fn std_sort[D: DType](inout vector: DynamicVector[SIMD[D, 1]]):
    sort[D](vector)

fn main():
    print("Operation, size, max_value, duration, sorted")
    benchmark[DType.uint8, selection_sort[DType.uint8]]("Selection sort", 300)
    benchmark[DType.uint8, insertion_sort[DType.uint8]]("Insertion sort", 300)
    benchmark[DType.uint8, std_sort[DType.uint8]]("Std sort", 300)
    benchmark[DType.uint8, quick_sort[DType.uint8]]("Quick sort", 300)
    benchmark[DType.uint8, counting_sort[DType.uint8]]("Counting sort", 300)
    benchmark[DType.uint8, radix_sort[DType.uint8]]("Radix sort", 300)

    benchmark[DType.uint16, selection_sort[DType.uint16]]("Selection sort", 3000)
    benchmark[DType.uint16, insertion_sort[DType.uint16]]("Insertion sort", 3000)
    benchmark[DType.uint16, std_sort[DType.uint16]]("Std sort", 3000)
    benchmark[DType.uint16, quick_sort[DType.uint16]]("Quick sort", 3000)
    benchmark[DType.uint16, counting_sort[DType.uint16]]("Counting sort", 3000)
    benchmark[DType.uint16, radix_sort[DType.uint16]]("Radix sort", 3000)

    # benchmark[DType.uint32, selection_sort[DType.uint32]]("Selection sort", 300000, 2_000_000_000)
    # benchmark[DType.uint32, insertion_sort[DType.uint32]]("Insertion sort", 300000, 2_000_000_000)
    benchmark[DType.uint32, std_sort[DType.uint32]]("Std sort", 300000, 2_000_000_000)
    benchmark[DType.uint32, quick_sort[DType.uint32]]("Quick sort", 300000, 2_000_000_000)
    # benchmark[DType.uint32, counting_sort[DType.uint32]]("Counting sort", 30000, 2_000_000_000)
    benchmark[DType.uint32, radix_sort[DType.uint32]]("Radix sort", 300000, 2_000_000_000)
