from algorithm import parallelize

alias group_size = 32

@always_inline
fn _insertion_sort[dt: DType](inout values: List[Scalar[dt]], start: Int, end: Int):
    for i in range(start, end):
        var key = values[i]
        var j = i - 1
        while j >= start and key <= values[j]:
            values[j + 1] = values[j]
            j -= 1
        values[j + 1] = key

@always_inline
fn _merge[dt: DType](inout values: List[Scalar[dt]], start: Int, mid: Int, end: Int):
    var left = values[start:mid]
    var right = values[mid:end]

    var lenl = len(left)
    var lenr = len(right)

    var cur = start
    var curl = 0
    var curr = 0
    while curl < lenl and curr < lenr:
        if left[curl] <= right[curr]:
            values[cur] = left[curl]
            curl += 1
        else:
            values[cur] = right[curr]
            curr += 1
        cur += 1

    while curl < lenl:
        values[cur] = left[curl]
        curl += 1
        cur += 1
    
    while curr < lenr:
        values[cur] = right[curr]
        curr += 1
        cur += 1

fn tim_sort[dt: DType](inout values: List[Scalar[dt]]):
    var count = len(values)
    for i in range(0, count, group_size):
        _insertion_sort[dt](values, i, min(i + group_size, count))
    
    var size = group_size
    while size < count:
        for start in range(0, count, 2 * size):
            var mid = min(count, start + size) 
            var end = min((start + 2 * size), count)
            if mid < end:
                _merge(values, start, mid, end)
        size *= 2
    

fn parallel_tim_sort[dt: DType](inout values: List[Scalar[dt]]):
    var count = len(values)
    var groups_count = -(-count // group_size)
    
    @parameter
    fn call_insertion_sort(i: Int):
        _insertion_sort[dt](values, i * group_size, min((i + 1) * group_size, count))
    
    parallelize[call_insertion_sort](groups_count)
    
    var size = group_size
    while size < count:
        @parameter
        fn call_merge(i: Int):
            var start = i * 2 * size
            var mid = min(count, start + size)
            var end = min((start + 2 * size), count)
            if mid < end:
                _merge(values, start, mid, end)
        
        var chunks_count = -(-count // (2 * size))
        parallelize[call_merge](chunks_count)
        size *= 2