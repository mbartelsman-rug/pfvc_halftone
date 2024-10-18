const std = @import("std");
const zigimg = @import("zigimg");
const zargs = @import("zargs");

const args = @import("arguments.zig");
const Options = args.Options;

const coloring = @import("coloring.zig");
const toLinearGrayscale = coloring.toLinearGrayscale;

const bilinear = @import("resampling/bilinear.zig");
const nearestNeighbour = @import("resampling/nearestNeighbour.zig");

const ed = @import("errorDiffusion.zig");


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const options = try Options.parseArgs(gpa.allocator());
    defer options.deinit();
    
    // Read base image
    var colorImg = try zigimg.Image.fromFilePath(gpa.allocator(), options.input);
    defer colorImg.deinit();

    if (options.mode == .none) {
        try colorImg.writeToFilePath(options.output, .{ .png = .{} });
        return;
    }

    // Convert to grayscale
    var grayImg = try toLinearGrayscale(gpa.allocator(), colorImg, options.gamma);
    defer grayImg.deinit();

    if (options.mode == .grayscale) {
        try grayImg.writeToFilePath(options.output, .{ .png = .{} });
        return;
    }

    // Downsample image
    var resizedGrayImg = try bilinear.resample(gpa.allocator(), grayImg, grayImg.width / options.scale);
    defer resizedGrayImg.deinit();

    // try resizedGrayImg.writeToFilePath(options.output, .{ .png = .{} });

    // Apply error-diffusion
    var edImages = try switch (options.mode) {
        .@"floyd-steinberg" => ed.floydSteinberg.errorDiffusion(gpa.allocator(), resizedGrayImg),
        .atkinson           => ed.atkinson.errorDiffusion(gpa.allocator(), resizedGrayImg),
        .ostromoukhov       => ed.ostromoukhov.errorDiffusion(gpa.allocator(), resizedGrayImg),
        .@"zhou-fang"       => ed.zhouFang.errorDiffusion(gpa.allocator(), resizedGrayImg),
        .@"zhou-fang-ectm"  => ed.zhouFangEctm.errorDiffusion(gpa.allocator(), resizedGrayImg),

        .none, .grayscale => unreachable,
        else => |mode| std.debug.panic("Mode '{s}' not implemented", .{ @tagName(mode) }),
    };
    defer edImages[0].deinit();
    defer edImages[1].deinit();

    // try edImage.writeToFilePath(options.output, .{ .png = .{} });

    // Upscale image
    var finalImg = try nearestNeighbour.resample(gpa.allocator(), edImages[0], edImages[0].width * options.scale);
    defer finalImg.deinit();

    var finalErr = try nearestNeighbour.resample(gpa.allocator(), edImages[1], edImages[1].width * options.scale);
    defer finalErr.deinit();

    try finalImg.writeToFilePath(options.output, .{ .png = .{} });

    if (options.@"error") |err| {
        try finalErr.writeToFilePath(err, .{ .png = .{} });
    }
}