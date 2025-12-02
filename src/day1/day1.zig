const std = @import("std");

pub fn run(input: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const cwd = std.fs.cwd();
    const file = try cwd.openFile(input, .{ .mode = .read_only });
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, 20000);
    defer allocator.free(contents);
    var it = std.mem.splitAny(u8, contents, "\n");

    var dial: i16 = 50;
    var times_at_zero: u16 = 0;

    while (it.next()) |x| {
        const direction: u8 = x[0];
        const raw_amt = x[1..];
        const amt = try std.fmt.parseInt(i16, raw_amt, 10);
        if (direction == 'L') {
            dial -= amt;
        }
        if (direction == 'R') {
            dial += amt;
        }
        const reading = @mod(dial, 100);
        if (reading == 0) {
            times_at_zero += 1;
        }
    }
    std.debug.print("{d} times read 0\n", .{times_at_zero});
}
