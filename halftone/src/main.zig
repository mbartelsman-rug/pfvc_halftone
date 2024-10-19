pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const options = try OptionsExe.parseArgs(gpa.allocator());
    defer options.deinit();

    return program(gpa.allocator(), options);
}

pub fn program(allocator: std.mem.Allocator, options: OptionsExe) !void {

    // Read image from disk
    var colorImg = try zigimg.Image.fromFilePath(allocator, options.input);
    defer colorImg.deinit();

    if (options.mode == .none) {
        try colorImg.writeToFilePath(options.output, .{ .png = .{} });
        return;
    }

    // Convert to grayscale
    var grayImg = try toLinearGrayscale(allocator, colorImg, options.gamma);
    defer grayImg.deinit();

    if (options.mode == .grayscale) {
        try grayImg.writeToFilePath(options.output, .{ .png = .{} });
        return;
    }

    // Downsample
    var resizedGrayImg = try bilinear.resample(allocator, grayImg, grayImg.width / options.scale);
    defer resizedGrayImg.deinit();

    // Get error diffusion functions
    const tHolder: *const ed.ThresholderFn = switch (options.threshold) {
        .constant => |_| ed.threshold.threshold(0.5),
        .entropy => |_| ed.threshold.entropyConstrained(0.5),
    };

    const errorDiffuser: *const ed.ErrorDiffuserFn = switch (options.mode) {
        .@"floyd-steinberg" => |_| ed.floydSteinberg,
        .atkinson => |_| ed.atkinson,
        .ostromoukhov => |_| ed.ostromoukhov,
        .@"zhou-fang" => |_| ed.zhouFang,
        .xiangyu => |_| ed.xiangyu,
        .none, .grayscale => |_| unreachable,
        else => |mode| {
            std.debug.panic("Mode '{s}' not implemented", .{@tagName(mode)});
        },
    };

    // Apply error-diffusion
    var edImages = try errorDiffuser(allocator, resizedGrayImg, tHolder);
    defer edImages[0].deinit();
    defer edImages[1].deinit();

    // Upscale
    var finalImg = try nearestNeighbour.resample(allocator, edImages[0], edImages[0].width * options.scale);
    defer finalImg.deinit();

    var finalErr = try nearestNeighbour.resample(allocator, edImages[1], edImages[1].width * options.scale);
    defer finalErr.deinit();

    // Write to disk
    try finalImg.writeToFilePath(options.output, .{ .png = .{} });

    if (options.@"error") |err| {
        try finalErr.writeToFilePath(err, .{ .png = .{} });
    }
}

// Imports

const std = @import("std");
const zigimg = @import("zigimg");
const zargs = @import("zargs");

const opts = @import("options.zig");
const OptionsExe = opts.OptionsExe;

const coloring = @import("coloring.zig");
const toLinearGrayscale = coloring.toLinearGrayscale;

const bilinear = @import("resampling/bilinear.zig");
const nearestNeighbour = @import("resampling/nearestNeighbour.zig");

const ed = @import("errorDiffusion.zig");
