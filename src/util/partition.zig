const std = @import("std");

pub const PartitionIterator = struct {
    input: []const u8,
    index: usize = 0,
    returned: u64 = 0,

    pub fn next(self: *PartitionIterator, comptime N: u8) ?[]const u8 {
        var end = self.index + N;
        if (self.returned < self.input.len and end > self.input.len) {
            end = self.input.len;
        }
        if (end > self.input.len) return null;
        const slice = self.input[self.index..end];
        self.index += N;
        self.returned += slice.len;
        return slice;
    }
};

test "partition by 2" {
    const input = [_]u8{ '1', '3', '1', '2' };
    var p: PartitionIterator = .{ .input = &input };
    var items = p.next(2).?;
    try std.testing.expectEqual('1', items[0]);
    try std.testing.expectEqual('3', items[1]);
    items = p.next(2).?;
    try std.testing.expectEqual('1', items[0]);
    try std.testing.expectEqual('2', items[1]);
    const other_items = p.next(1);
    try std.testing.expect(other_items == null);
}

test "partition 1" {
    const input = [_]u8{ '1', '3', '1', '2' };
    var p: PartitionIterator = .{ .input = &input };
    var items = p.next(1).?;
    try std.testing.expectEqual('1', items[0]);
    items = p.next(1).?;
    try std.testing.expectEqual('3', items[0]);
    items = p.next(1).?;
    try std.testing.expectEqual('1', items[0]);
    items = p.next(1).?;
    try std.testing.expectEqual('2', items[0]);
    const other_items = p.next(1);
    try std.testing.expect(other_items == null);
}

test "partition 4" {
    const input = [_]u8{ '1', '3', '1', '2' };
    var p: PartitionIterator = .{ .input = &input };
    const items = p.next(4).?;
    try std.testing.expectEqual('1', items[0]);
    try std.testing.expectEqual('3', items[1]);
    try std.testing.expectEqual('1', items[2]);
    try std.testing.expectEqual('2', items[3]);
    const other_items = p.next(1);
    try std.testing.expect(other_items == null);
}

test "partition leftover" {
    const input = [_]u8{ '1', '3', '1' };
    var p: PartitionIterator = .{ .input = &input };
    var items = p.next(2).?;
    try std.testing.expectEqual('1', items[0]);
    try std.testing.expectEqual('3', items[1]);
    items = p.next(10).?;
    try std.testing.expectEqual('1', items[0]);
    try std.testing.expectEqual(1, items.len);
    const other_items = p.next(1);
    try std.testing.expect(other_items == null);
}

test "partition null" {
    const input = [_]u8{ '1', '3' };
    var p: PartitionIterator = .{ .input = &input };
    const items = p.next(2).?;
    try std.testing.expectEqual('1', items[0]);
    try std.testing.expectEqual('3', items[1]);
    const other_items = p.next(1);
    try std.testing.expect(other_items == null);
}
