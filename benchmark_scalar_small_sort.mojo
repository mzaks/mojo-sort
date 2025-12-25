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
from builtin.sort import _insertion_sort, _small_sort, sort
from algorithm._sorting_network import _sort as network_sort

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
fn insertion_sort[dtype: DType](mut list: List[Scalar[dtype]]):
    @parameter
    fn _less_than(lhs: Scalar[dtype], rhs: Scalar[dtype]) -> Bool:
        return lhs < rhs

    _insertion_sort[_less_than](list)


@always_inline
fn small_sort[size: Int, dtype: DType](mut list: List[Scalar[dtype]]):
    @parameter
    fn _less_than(lhs: Scalar[dtype], rhs: Scalar[dtype]) -> Bool:
        return lhs < rhs

    _small_sort[size, Scalar[dtype], _less_than](list)


@always_inline
fn assert_sorted[dtype: DType](list: List[Scalar[dtype]]) raises:
    for i in range(1, len(list)):
        if list[i] < list[i - 1]:
            raise i

# ===-----------------------------------------------------------------------===#
# Benchmark sort functions with a tiny list size
# ===-----------------------------------------------------------------------===#


fn bench_tiny_list_sort[dtype: DType](mut m: Bench) raises:
    comptime small_list_size = 5

    @parameter
    for count in range(2, small_list_size + 1):

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
        fn bench_small_sort(mut b: Bencher) raises:
            seed(1)
            var list = List(length=count, fill=Scalar[dtype]())

            @always_inline
            @parameter
            fn preproc():
                randomize_list(list, count)

            @always_inline
            @parameter
            fn call_fn():
                small_sort[count](list)

            b.iter_preproc[call_fn, preproc]()
            assert_sorted(list)
            _ = list^
        
        @parameter
        fn bench_network_sort(mut b: Bencher) raises:
            seed(1)
            var list = List(length=count, fill=Scalar[dtype]())

            @always_inline
            @parameter
            fn preproc():
                randomize_list(list, count)

            @always_inline
            @parameter
            fn call_fn():
                network_sort[count](list)

            b.iter_preproc[call_fn, preproc]()
            assert_sorted(list)
            _ = list^

        @parameter
        fn bench_insertion_sort(mut b: Bencher) raises:
            seed(1)
            var list = List(length=count, fill=Scalar[dtype]())

            @always_inline
            @parameter
            fn preproc():
                randomize_list(list, count)

            @always_inline
            @parameter
            fn call_fn():
                insertion_sort(list)

            b.iter_preproc[call_fn, preproc]()
            assert_sorted(list)
            _ = list^

        m.bench_function[bench_sort_list](
            BenchId(String("std_sort_random_", count, "_", dtype))
        )
        m.bench_function[bench_small_sort](
            BenchId(String("sml_sort_random_", count, "_", dtype))
        )
        m.bench_function[bench_network_sort](
            BenchId(String("ntw_sort_random_", count, "_", dtype))
        )
        m.bench_function[bench_insertion_sort](
            BenchId(String("ins_sort_random_", count, "_", dtype))
        )


# ===-----------------------------------------------------------------------===#
# Benchmark sort functions with a small list size
# ===-----------------------------------------------------------------------===#


fn bench_small_list_sort[dtype: DType](mut m: Bench, count: Int) raises:
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
    fn bench_insertion_sort(mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=Scalar[dtype]())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count)

        @always_inline
        @parameter
        fn call_fn():
            insertion_sort(list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^

    @parameter
    fn bench_network_sort[count: Int](mut b: Bencher) raises:
        seed(1)
        var list = List(length=count, fill=Scalar[dtype]())

        @always_inline
        @parameter
        fn preproc():
            randomize_list(list, count)

        @always_inline
        @parameter
        fn call_fn():
            network_sort[count](list)

        b.iter_preproc[call_fn, preproc]()
        assert_sorted(list)
        _ = list^

    m.bench_function[bench_sort_list](
        BenchId(String("std_sort_random_", count, "_", dtype))
    )
    m.bench_function[bench_insertion_sort](
        BenchId(String("ins_sort_random_", count, "_", dtype))
    )
    if count == 10:
        m.bench_function[bench_network_sort[10]](
            BenchId(String("ntw_sort_random_", count, "_", dtype))
        )
    elif count == 20:
        m.bench_function[bench_network_sort[20]](
            BenchId(String("ntw_sort_random_", count, "_", dtype))
        )
    elif count == 32:
        m.bench_function[bench_network_sort[32]](
            BenchId(String("ntw_sort_random_", count, "_", dtype))
        )
    elif count == 64:
        m.bench_function[bench_network_sort[64]](
            BenchId(String("ntw_sort_random_", count, "_", dtype))
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
        # DType.bfloat16,
        DType.uint32,
        DType.int32,
        DType.float32,
        DType.uint64,
        DType.int64,
        DType.float64,
    ]
    var small_counts = [10, 20, 32, 64, 100]

    @parameter
    for dtype in dtypes:
        bench_tiny_list_sort[dtype](m)

    @parameter
    for dtype in dtypes:
        for count1 in small_counts:
            bench_small_list_sort[dtype](m, count1)

    m.dump_report()
