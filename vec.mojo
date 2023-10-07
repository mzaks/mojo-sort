fn print_v[D: DType, size: Int = 1](v: DynamicVector[SIMD[D, size]]):
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