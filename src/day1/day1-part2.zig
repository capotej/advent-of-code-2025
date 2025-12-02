const std = @import("std");

const Safe = struct {
    dial: i32 = 50,
    clicks: u32 = 0,

    pub fn left(self: *Safe, amt: u16) void {
        for (0..amt) |_| {
            self.dial -= 1;
            if (self.reading() == 0) {
                self.clicks += 1;
            }
        }
    }

    pub fn right(self: *Safe, amt: u16) void {
        for (0..amt) |_| {
            self.dial += 1;
            if (self.reading() == 0) {
                self.clicks += 1;
            }
        }
    }

    pub fn reading(self: *Safe) i32 {
        return @mod(self.dial, 100);
    }
};

test "testing the safe" {
    var s: Safe = .{};
    s.left(68);
    try std.testing.expectEqual(1, s.clicks);
    try std.testing.expectEqual(82, s.reading());
    s.left(30);
    try std.testing.expectEqual(52, s.reading());
    s.right(48);
    try std.testing.expectEqual(2, s.clicks);
    try std.testing.expectEqual(0, s.reading());
}

pub fn run(input: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const cwd = std.fs.cwd();
    const file = try cwd.openFile(input, .{ .mode = .read_only });
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, 20000);
    defer allocator.free(contents);
    var it = std.mem.splitAny(u8, contents, "\n");

    var s: Safe = .{};
    while (it.next()) |x| {
        const direction: u8 = x[0];
        const raw_amt = x[1..];
        const amt = try std.fmt.parseInt(u16, raw_amt, 10);
        if (direction == 'L') {
            s.left(amt);
        }
        if (direction == 'R') {
            s.right(amt);
        }
    }
    std.debug.print("{d} clicks\n", .{s.clicks});
}
