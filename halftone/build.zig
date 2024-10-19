const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "halftone_2",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const batch = b.addExecutable(.{
        .name = "halftone_2_batch",
        .root_source_file = b.path("src/batch.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zigimg_dependency = b.dependency("zigimg", .{
        .target = target,
        .optimize = optimize,
    });

    const zargs_dependency = b.dependency("zargs", .{
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("zigimg", zigimg_dependency.module("zigimg"));
    exe.root_module.addImport("zargs", zargs_dependency.module("args"));

    batch.root_module.addImport("zigimg", zigimg_dependency.module("zigimg"));
    batch.root_module.addImport("zargs", zargs_dependency.module("args"));

    exe_unit_tests.root_module.addImport("zigimg", zigimg_dependency.module("zigimg"));
    exe_unit_tests.root_module.addImport("zargs", zargs_dependency.module("args"));
    
    b.installArtifact(exe);
    b.installArtifact(batch);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const batch_cmd = b.addRunArtifact(batch);
    batch_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
        batch_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const batch_step = b.step("batch", "Run the app in batch mode");
    batch_step.dependOn(&batch_cmd.step);

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
