fn print_v[D: DType, size: Int = 1](v: DynamicVector[SIMD[D, size]]):
    print_no_newline("(")
    print_no_newline(len(v))
    print_no_newline(")")
    print_no_newline("[")
    for i in range(len(v)):
        print_no_newline(v[i])
        print_no_newline(", ")
    print("]")

fn print_v[D: DType, size: Int = 1](v: UnsafeFixedVector[SIMD[D, size]]):
    print_no_newline("(")
    print_no_newline(len(v))
    print_no_newline(")")
    print_no_newline("[")
    for i in range(len(v)):
        print_no_newline(v[i])
        print_no_newline(", ")
    print("]")

fn print_iv(v: DynamicVector[Int]):
    print_no_newline("(")
    print_no_newline(len(v))
    print_no_newline(")")
    print_no_newline("[")
    for i in range(len(v)):
        print_no_newline(v[i])
        print_no_newline(", ")
    print("]")

fn vector[D: DType](*values: SIMD[D, 1]) -> UnsafeFixedVector[SIMD[D, 1]]:
    let elements_list: VariadicList[SIMD[D, 1]] = values
    var result = UnsafeFixedVector[SIMD[D, 1]](len(elements_list))
    result.clear()
    for i in range(len(elements_list)):
        result.append(values[i])
    return result