const std = @import("std");

fn invalid_id(uinput: usize) bool {
    var buf: [20]u8 = undefined;
    const str = std.fmt.bufPrint(&buf, "{}", .{uinput}) catch unreachable;
    if (str.len % 2 != 0) return false;

    const mid = str.len / 2;
    const first = str[0..mid];
    const last = str[mid..str.len];

    return std.mem.eql(u8, first, last);
}

test "invalid_id odd" {
    const input: usize = 123;
    try std.testing.expectEqual(false, invalid_id(input));
}

test "invalid_id even" {
    const input: usize = 1234;
    try std.testing.expectEqual(false, invalid_id(input));
}

test "invalid_id invalid even" {
    const input: usize = 1212;
    try std.testing.expectEqual(true, invalid_id(input));
}

pub fn run(input: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const cwd = std.fs.cwd();
    const file = try cwd.openFile(input, .{ .mode = .read_only });
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, 20000);
    defer allocator.free(contents);
    var it = std.mem.splitAny(u8, contents, ",");

    var final_result: u64 = 0;

    while (it.next()) |x| {
        var range_parts = std.mem.splitAny(u8, x, "-");
        const start = range_parts.next().?;
        const end = range_parts.next().?;
        const starti = try std.fmt.parseInt(u64, start, 10);
        const endi = try std.fmt.parseInt(u64, end, 10);
        for (starti..(endi + 1)) |i| {
            if (invalid_id(i)) {
                final_result += i;
            }
        }
    }
    std.debug.print("sum of invalid ids {d}", .{final_result});
}
