from math.bit import bswap
from memory import memcmp

@always_inline
fn _align_down(value: Int, alignment: Int) -> Int:
    return value._positive_div(alignment) * alignment

@always_inline
fn _memcmp_impl(s1: DTypePointer, s2: __type_of(s1), count: Int) -> Int:
    constrained[s1.type.is_integral(), "the input dtype must be integral"]()
    alias simd_width = simdwidthof[s1.type]()
    if count < simd_width:
        var result = 0
        var i = 0
        while i < count:
            var s1i = s1[i]
            var s2i = s2[i]
            var smaller = s1i < s2i
            var bigger = s1i > s2i
            i += 1 + count * int(smaller or bigger)
            result = -1 * int(smaller) + 1 * int(bigger)
        return result
        # for i in range(count):
        #     var s1i = s1[i]
        #     var s2i = s2[i]
        #     if s1i != s2i:
        #         return 1 if s1i > s2i else -1
        # return 0

    var iota = llvm_intrinsic[
        "llvm.experimental.stepvector",
        SIMD[DType.uint8, simd_width],
        has_side_effect=False,
    ]()

    var vector_end_simd = _align_down(count, simd_width)
    for i in range(0, vector_end_simd, simd_width):
        var s1i = s1.load[width=simd_width](i)
        var s2i = s2.load[width=simd_width](i)
        var diff = s1i != s2i
        if diff.reduce_or():
            var index = int(
                diff.select(
                    iota, SIMD[DType.uint8, simd_width](255)
                ).reduce_min()
            )
            return -1 if s1i[index] < s2i[index] else 1

    var last = count - simd_width
    if last <= 0:
        return 0

    var s1i = s1.load[width=simd_width](last)
    var s2i = s2.load[width=simd_width](last)
    var diff = s1i != s2i
    if diff.reduce_or():
        var index = int(
            diff.select(iota, SIMD[DType.uint8, simd_width](255)).reduce_min()
        )
        return -1 if s1i[index] < s2i[index] else 1
    return 0

@always_inline
fn lt(a: String, b: String) -> Bool:
    var min_len = min(len(a), len(b))
    var res = memcmp(a.unsafe_uint8_ptr(), b.unsafe_uint8_ptr(), min_len)
    return len(a) <= len(b) if res == 0 else res < 0


# fn lt(a: StringLiteral, b: StringLiteral) -> Bool:
#     var p1 = a.data().bitcast[DType.uint8]()
#     var p2 = b.data().bitcast[DType.uint8]()
#     var min_len = min(len(a), len(b))
#     for i in range(min_len):
#         var ai = p1.load(i)
#         var bi = p2.load(i)
#         if ai > bi:
#             return False
#         if ai < bi:
#             return True

#     return len(a) <= len(b)

# fn lt2(a: StringLiteral, b: StringLiteral) -> Bool:
#     """This is much simpler but also slower based on some simple benchmarks."""
#     var min_len = min(len(a), len(b))
#     var res = memcmp(a.data(), b.data(), min_len)
#     return len(a) <= len(b) if res == 0 else res < 0

# fn lt3(a: StringLiteral, b: StringLiteral) -> Bool:
#     var p1 = a.data().bitcast[DType.uint8]()
#     var p2 = b.data().bitcast[DType.uint8]()
#     var rest_len = min(len(a), len(b))
#     while rest_len >= 8:
#         var ai = bswap(p1.bitcast[DType.uint64]().load())
#         var bi = bswap(p2.bitcast[DType.uint64]().load())
#         if ai > bi:
#             return False
#         if ai < bi:
#             return True
#         p1 = p1.offset(8)
#         p2 = p2.offset(8)
#         rest_len -= 8
    
#     if rest_len >= 4:
#         var ai = bswap(p1.bitcast[DType.uint32]().load())
#         var bi = bswap(p2.bitcast[DType.uint32]().load())
#         if ai > bi:
#             return False
#         if ai < bi:
#             return True
#         p1 = p1.offset(4)
#         p2 = p2.offset(4)
#         rest_len -= 4
    
#     if rest_len >= 2:
#         var ai = bswap(p1.bitcast[DType.uint16]().load())
#         var bi = bswap(p2.bitcast[DType.uint16]().load())
#         if ai > bi:
#             return False
#         if ai < bi:
#             return True
#         p1 = p1.offset(2)
#         p2 = p2.offset(2)
#         rest_len -= 2

#     if rest_len == 1:
#         var ai = p1.load()
#         var bi = p2.load()
#         if ai > bi:
#             return False
#         if ai < bi:
#             return True

#     return len(a) <= len(b)