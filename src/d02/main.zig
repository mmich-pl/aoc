const std = @import("std");

const Move = enum(u8) {
    rock = 1,
    paper,
    scissors,
    pub fn charToMove(c: u8) Move {
        return switch (c) {
            'A', 'X' => .rock,
            'B', 'Y' => .paper,
            'C', 'Z' => .scissors,
            else => unreachable,
        };
    }
};

const Outcome = enum(u8) {
    lose = 0,
    draw = 3,
    win = 6,
    fn charToOutcome(c: u8) Outcome {
        return switch (c) {
            'X' => .lose,
            'Y' => .draw,
            'Z' => .win,
            else => unreachable,
        };
    }
};

const Round = struct {
    opponent_move: Move,
    our_move: Move,
    outcome: Outcome,

    pub fn part1(their: u8, our: u8) Round {
        const outcome = ([_]Outcome{ .win, .lose, .draw })[(our - their) % 3];
        return .{ .opponent_move = Move.charToMove(their), .our_move = Move.charToMove(our), .outcome = outcome };
    }

    pub fn part2(their: u8, outcome: u8) Round {
        return .{
            .opponent_move = Move.charToMove(their),
            .our_move = ([_]Move{ .scissors, .rock, .paper })[(their + outcome) % 3],
            .outcome = Outcome.charToOutcome(outcome),
        };
    }

    pub fn score(self: *const Round) u32 {
        return @intFromEnum(self.outcome) + @intFromEnum(self.our_move);
    }
};

fn solve(input: []const u8) [2]u32 {
    var it = std.mem.tokenize(u8, input, "\n");
    var score_part_1: u32 = 0;
    var score_part_2: u32 = 0;

    while (it.next()) |line| {
        const round1 = Round.part1(line[0], line[2]);
        const round2 = Round.part2(line[0], line[2]);
        score_part_1 += round1.score();
        score_part_2 += round2.score();
    }

    return .{ score_part_1, score_part_2 };
}

pub fn main() !void {
    const score = solve(@embedFile("input.txt"));
    std.debug.print("Part 1: {d}\n", .{score[0]});
    std.debug.print("Part 2: {d}\n", .{score[1]});
}

test "test-input" {
    const score = solve(@embedFile("sample.txt"));
    try std.testing.expect(
        score[0] == 15,
    );
    try std.testing.expect(
        score[1] == 12,
    );
}
