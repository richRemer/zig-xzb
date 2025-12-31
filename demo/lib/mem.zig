/// Create a slice of T from a pointer and length.
pub fn slice(comptime T: type, ptr: [*]T, len: usize) []T {
    var result: []T = undefined;

    result.len = len;
    result.ptr = @ptrCast(ptr);

    return result;
}
