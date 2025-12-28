const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("xzb", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

    demo("xcb", b, b.path("demo/01-xcb.zig"), target, optimize);
    demo("hello", b, b.path("demo/02-hello.zig"), target, optimize);

    const tests = b.addTest(.{ .root_module = mod });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run tests");

    test_step.dependOn(&run_tests.step);
}

fn demo(
    comptime name: []const u8,
    b: *std.Build,
    src_path: std.Build.LazyPath,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) void {
    const exe = b.addExecutable(.{
        .name = "xzb" ++ name,
        .root_module = b.createModule(.{
            .root_source_file = src_path,
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "xzb", .module = b.modules.get("xzb").? },
            },
        }),
    });

    exe.linkLibC();
    exe.linkSystemLibrary("xcb");
    b.installArtifact(exe);

    const step = b.step(name ++ "-demo", "Run the '" ++ name ++ "' demo");
    const cmd = b.addRunArtifact(exe);

    step.dependOn(&cmd.step);
    cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        cmd.addArgs(args);
    }
}
