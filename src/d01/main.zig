const std = @import("std");

pub fn updateMax(max: *[3]u32, current: u32) void {
    for (0..max.len) |i| {
        if (current > max[i]) {
            var j: u8 = 2;
            while (j > i) : (j -= 1) {
                max[j] = max[j - 1];
            }
            max[i] = current;
            return;
        }
    }
}

fn solve(input: []const u8) ![3]u32 {
    var max: [3]u32 = .{ 0, 0, 0 };
    var current: u32 = 0;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) {
            updateMax(&max, current);
            current = 0;
        } else {
            const num = try std.fmt.parseInt(u32, line, 10);
            current += num;
        }
    }
    // make sure we get the last elf
    updateMax(&max, current);
    return max;
}

pub fn main() !void {
    const max = try solve(@embedFile("input.txt"));
    const total = @reduce(.Add, @as(@Vector(3, u32), max));
    std.debug.print("Part 1: {d}\n", .{max[0]});
    std.debug.print("Part 2: {any} = {d}\n", .{ max, total });
}

test "test-input" {
    const max = try solve(@embedFile("sample.txt"));
    const total = @reduce(.Add, @as(@Vector(3, u32), max));
    try std.testing.expectEqual(max[0], 24000);
    try std.testing.expectEqual(total, 45000);
}
