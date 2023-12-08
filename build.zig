const std = @import("std");

pub fn setup_day(
    b: *std.build.Builder,
    target: std.zig.CrossTarget,
    mode: std.builtin.OptimizeMode,
    day: u32,
) void {
    const path = b.fmt("d{:0>2}", .{day});
    const root_src = .{ .path = b.fmt("src/{s}/main.zig", .{path}) };
    const exe = b.addExecutable(.{ .name = path, .root_source_file = root_src, .target = target, .optimize = mode });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    std.debug.print("{s}", .{b.fmt("run_{s}", .{path})});
    const run_step = b.step(b.fmt("run_{s}", .{path}), "Run specified day");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{ .name = path, .root_source_file = root_src, .target = target, .optimize = mode });
    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    comptime var counter: usize = 2;
    inline while (counter <= 1) {
        setup_day(b, target, optimize, counter);
        counter += 1;
    }
}
