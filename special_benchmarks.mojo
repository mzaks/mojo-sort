from radix_sorting import aflag_sort, radix_sort, aflag_copy_sort
from benchmark import run, keep
from random import random_ui64


def main():
    comptime size = 2_000
    var input = [UInt32(12390)] * size
    var result1: List[UInt32] = []
    var result2: List[UInt32] = []
    var result3: List[UInt32] = []
    var result4: List[UInt32] = []
    for i in range(size):
        # input[i] = i
        input[i] = UInt32(random_ui64(0, UInt64(UInt32.MAX)))
    
    print("----------AFlag----------")

    @parameter
    fn aflag_bench():
        var v = input.copy()
        var s = Span(v)
        aflag_sort(s)
        result1 = v^
    
    var report = run[aflag_bench](max_runtime_secs=2)
    report.print("ns")
    print(report.mean("ns") / size)

    @parameter
    fn aflag_copy_bench():
        var v = input.copy()
        var s = Span(v)
        aflag_copy_sort(s)
        result2 = v^

    print("----------AFlag Copy----------")

    report = run[aflag_copy_bench](max_runtime_secs=2)
    report.print("ns")
    print(report.mean("ns") / size)
    
    @parameter
    fn radix_bench():
        var v = input.copy()
        radix_sort(v)
        result2 = v^

    print("----------Radix----------")

    report = run[radix_bench](max_runtime_secs=2)
    report.print("ns")
    print(report.mean("ns") / size)

    @parameter
    fn std_bench():
        var v = input.copy()
        sort(v)
        result3 = v^ 

    print("----------STD-Sort----------")

    report = run[std_bench](max_runtime_secs=2)
    report.print("ns")
    print(report.mean("ns") / size)


    print("----------Validation----------")

    print(result1 == result2)
    print(result2 == result3)
    print(result3 == result4)