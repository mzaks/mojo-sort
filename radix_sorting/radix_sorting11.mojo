
from memory import memset_zero, memcpy, stack_allocation
from memory.unsafe import bitcast
from sys.intrinsics import PrefetchOptions
from buffer import Buffer

@always_inline
fn _float_flip(f: UInt32) -> UInt32:
    var mask = bitcast[DType.uint32, 1](-bitcast[DType.int32, 1](f >> 31) | 0x80_00_00_00)
    return f ^ mask

@always_inline
fn _float_flip_x(inout f: UInt32):
    var mask = bitcast[DType.uint32, 1](-bitcast[DType.int32, 1](f >> 31) | 0x80_00_00_00)
    f ^= mask

@always_inline
fn _inverse_float_flip(f: UInt32) -> UInt32:
    var mask = ((f >> 31) - 1) | 0x80_00_00_00
    return f ^ mask

@always_inline
fn _0(v: UInt32) -> Int:
    return int(v & 0x7ff)

@always_inline
fn _1(v: UInt32) -> Int:
    return int(v >> 11 & 0x7ff)

@always_inline
fn _2(v: UInt32) -> Int:
    return int(v >> 22)


# based on http://stereopsis.com/radix.html
fn radix_sort11(inout vector: List[Float32]):
    var elements = len(vector)
    var array = List[UInt32](capacity=elements)
    memcpy(array.data, vector.data.bitcast[UInt32](), elements)
    var sorted = List[UInt32](capacity=elements)
    alias histogram_size = 2048
    var histogram1 = stack_allocation[histogram_size * 3, DType.uint32]()
    memset_zero(histogram1, histogram_size * 3)

    var histogram2 = histogram1.offset(histogram_size)
    var histogram3 = histogram2.offset(histogram_size)

    for i in range(elements):
        # TODO: Prefetch
        # array.prefetch[PrefetchOptions().to_data_cache()](i+64)
        var fi = _float_flip(array[i])
        var i1 = _0(fi)
        var i2 = _1(fi)
        var i3 = _2(fi)
        
        var p1 = histogram1.offset(i1)
        var p2 = histogram2.offset(i2)
        var p3 = histogram3.offset(i3)

        # SIMD is a bit slower
        # let fi = _float_flip(array[i])
        # var fiv = SIMD[DType.uint32, 2](fi)
        # fiv >>= SIMD[DType.uint32, 2](0, 11, 22, 0)
        # fiv &= SIMD[DType.uint32, 2](0x7ff, 0x7ff, 0xffff, 0)

        # let p1 = histogram1.offset(fiv[0].to_int())
        # let p2 = histogram2.offset(fiv[1].to_int())
        # let p3 = histogram3.offset((fi >> 22).to_int())

        p1.store(p1.load() + 1)
        p2.store(p2.load() + 1)
        p3.store(p3.load() + 1)

    # for i in range(histogram_size):
    #     print(histogram1.offset(i).load(), histogram2.offset(i).load(), histogram3.offset(i).load())

    var sum1: UInt32 = 0 
    var sum2: UInt32 = 0
    var sum3: UInt32 = 0
    var tsum: UInt32 = 0

    for i in range(histogram_size):
        var p1 = histogram1.offset(i)
        var p2 = histogram2.offset(i)
        var p3 = histogram3.offset(i)

        tsum = p1.load() + sum1
        p1.store(sum1 - 1)
        sum1 = tsum

        tsum = p2.load() + sum2
        p2.store(sum2 - 1)
        sum2 = tsum

        tsum = p3.load() + sum3
        p3.store(sum3 - 1)
        sum3 = tsum

    for i in range(elements):
        var fi = array[i]
        _float_flip_x(fi)
        var p1 = histogram1.offset(_0(fi))
        var index = p1.load() + 1
        p1.store(index)
        sorted[int(index)] = fi

    for i in range(elements):
        var si = sorted[i]
        var pos = _1(si)
        var p2 = histogram2.offset(pos)
        var index = p2.load() + 1
        p2.store(index)
        array[int(index)] = si

    for i in range(elements):
        var ai = array[i]
        var pos = _2(ai)
        var p3 = histogram3.offset(pos)
        var index = p3.load() + 1
        p3.store(index)
        vector[int(index)] = _inverse_float_flip(ai)._bits_to_float[DType.float32]()

    
    # memcpy(vector.data, sorted.data.bitcast[Float32](), elements)
    # sorted.data.free()
