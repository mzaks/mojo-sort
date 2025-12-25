# ===----------------------------------------------------------------------=== #
# Copyright (c) 2025, Modular Inc. All rights reserved.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions:
# https://llvm.org/LICENSE.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===----------------------------------------------------------------------=== #

from random import *

from benchmark import Bench, BenchConfig, Bencher, BenchId
from builtin.sort import sort
from radix_sorting import radix_sort, radix_sort11, radix_sort13, radix_sort16
from memory.unsafe import bit_width_of

# ===-----------------------------------------------------------------------===#
# Benchmark Utils
# ===-----------------------------------------------------------------------===#


@always_inline
fn randomize_list[
    dt: DType
](mut list: List[Scalar[dt]], size: Int, max: Scalar[dt] = Scalar[dt].MAX):
    @parameter
    if dt.is_integral():
        randint(list.unsafe_ptr(), size, 0, Int(max))
    else:
        for i in range(size):
            var res = random_float64()
            # GCC doesn't support cast from float64 to float16
            list[i] = res.cast[DType.float32]().cast[dt]()


@always_inline
fn assert_sorted[dtype: DType](list: List[Scalar[dtype]]) raises:
    for i in range(1, len(list)):
        if list[i] < list[i - 1]:
            raise i

# ===-----------------------------------------------------------------------===#
# Benchmark sort functions with a large list size
# ===-----------------------------------------------------------------------===#


fn bench_large_list_sort[dtype: DType](mut m: Bench, count: Int) raises:
    @parameter
    fn bench_sort_list(mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=Scalar[dtype]())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count)

        @always_inline
        @parameter
        fn call_fn():
            sort(list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^

    @parameter
    fn bench_radix_sort(mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=Scalar[dtype]())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count)

        @always_inline
        @parameter
        fn call_fn():
            radix_sort(list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^
    
    @parameter
    fn bench_radix11_sort(mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=Scalar[dtype]())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count)

        @always_inline
        @parameter
        fn call_fn():
            radix_sort11(list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^

    @parameter
    fn bench_radix13_sort(mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=Scalar[dtype]())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count)

        @always_inline
        @parameter
        fn call_fn():
            radix_sort13(list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^

    @parameter
    fn bench_radix16_sort(mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=Scalar[dtype]())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count)

        @always_inline
        @parameter
        fn call_fn():
            radix_sort16(list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^

    m.bench_function[bench_sort_list](
        BenchId(String("std_sort_random_", count, "_", dtype))
    )

    m.bench_function[bench_radix_sort](
        BenchId(String("radix_sort_random_", count, "_", dtype))
    )

    @parameter
    if bit_width_of[dtype]() == 32:
        m.bench_function[bench_radix11_sort](
            BenchId(String("radix11_sort_random_", count, "_", dtype))
        )

    @parameter
    if bit_width_of[dtype]() == 64:
        m.bench_function[bench_radix13_sort](
            BenchId(String("radix13_sort_random_", count, "_", dtype))
        )
        m.bench_function[bench_radix16_sort](
            BenchId(String("radix16_sort_random_", count, "_", dtype))
        )


# ===-----------------------------------------------------------------------===#
# Benchmark sort functions with low delta lists
# ===-----------------------------------------------------------------------===#


fn bench_low_cardinality_list_sort(mut m: Bench, count: Int, delta: Int) raises:
    @parameter
    fn bench_sort_list(mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=UInt8())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count, delta)

        @always_inline
        @parameter
        fn call_fn():
            sort(list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^

    @parameter
    fn bench_radix_sort(mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=UInt8())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count)

        @always_inline
        @parameter
        fn call_fn():
            radix_sort(list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^
    
    m.bench_function[bench_sort_list](
        BenchId(String("std_sort_low_card_", count, "_delta_", delta))
    )

    m.bench_function[bench_radix_sort](
        BenchId(String("std_radix_low_card_", count, "_delta_", delta))
    )


# ===-----------------------------------------------------------------------===#
# Benchmark Main
# ===-----------------------------------------------------------------------===#


def main():
    var m = Bench(BenchConfig(max_runtime_secs=0.1))

    comptime dtypes = [
        DType.uint8,
        DType.int8,
        DType.uint16,
        DType.int16,
        DType.float16,
        DType.bfloat16,
        DType.uint32,
        DType.int32,
        DType.float32,
        DType.uint64,
        DType.int64,
        DType.float64,
    ]
    var large_counts = [2**12, 2**16, 2**20]
    var deltas = [0, 2, 5, 20, 100]

    @parameter
    for i in range(len(dtypes)):
        comptime dtype = dtypes[i]
        for count2 in large_counts:
            bench_large_list_sort[dtype](m, count2)

    for count3 in large_counts:
        for delta2 in deltas:
            bench_low_cardinality_list_sort(m, count3, delta2)

    m.dump_report()
