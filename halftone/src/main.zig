const std = @import("std");
const zigimg = @import("zigimg");
const zargs = @import("zargs");

const coloring = @import("coloring.zig");
const toLinearGrayscale = coloring.toLinearGrayscale;

const ed = @import("errorDiffusion.zig");

pub const Args = struct {
    input: ?[]const u8 = null,
    output: ?[]const u8 = null,
    gamma: f32 = 2.2,
    mode: Options.Mode = Options.Mode.@"floyd-steinberg",

    // This declares short-hand options for single hyphen
    pub const shorthands = .{
        .i = "input",
        .o = "output",
        .g = "gamma",
        .m = "mode",
    };
};

pub const Options = struct {
    input: []const u8,
    output: []const u8,
    gamma: f32,
    mode: Mode,

    allocator: std.mem.Allocator,

    const Mode = enum (u8) {
        none,
        grayscale,
        threshold,
        @"floyd-steinberg",
        atkinson,
        jarvis,
        _,
    };

    pub fn parseArgs(allocator: std.mem.Allocator) !Options {
        const parsedArgs = try zargs.parseForCurrentProcess(Args, allocator, .print);
        defer parsedArgs.deinit();

        if (parsedArgs.options.input == null) {
            std.debug.print("Input not specified", .{});
            return error.NoInput;
        }

        if (parsedArgs.options.output == null) {
            std.debug.print("Output not specified", .{});
            return error.NoOutput;
        }

        const options = Options {
            .input = try allocator.dupe(u8, parsedArgs.options.input.?),
            .output = try allocator.dupe(u8, parsedArgs.options.output.?),
            .gamma = parsedArgs.options.gamma,
            .mode = parsedArgs.options.mode,
            .allocator = allocator,
        };

        return options;
    }

    pub fn deinit(self: @This()) void {
        self.allocator.free(self.input);
        self.allocator.free(self.output);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const options = try Options.parseArgs(gpa.allocator());
    defer options.deinit();
        
    var colorImg = try zigimg.Image.fromFilePath(gpa.allocator(), options.input);
    defer colorImg.deinit();

    if (options.mode == .none) {
        try colorImg.writeToFilePath(options.output, .{ .png = .{} });
        return;
    }

    var grayImg = try toLinearGrayscale(gpa.allocator(), colorImg, options.gamma);
    defer grayImg.deinit();

    if (options.mode == .grayscale) {
        try grayImg.writeToFilePath(options.output, .{ .png = .{} });
        return;
    }

    const edOpts = switch (options.mode) {
        .threshold => ed.ErrorDiffusionOpts {
            .diffuser = ed.Diffusers.none,
            .diffuserLimits = ed.Diffusers.noneLimits,
            .quantizer = ed.Quantizers.thresholder,
        },
        .@"floyd-steinberg" => ed.ErrorDiffusionOpts {
            .diffuser = ed.Diffusers.floydSteinberg,
            .diffuserLimits = ed.Diffusers.floydSteinbergLimits,
            .quantizer = ed.Quantizers.thresholder,
        },
        .atkinson => ed.ErrorDiffusionOpts {
            .diffuser = ed.Diffusers.atkinson,
            .diffuserLimits = ed.Diffusers.atkinsonLimits,
            .quantizer = ed.Quantizers.thresholder,
        },
        .jarvis => ed.ErrorDiffusionOpts {
            .diffuser = ed.Diffusers.jarvis,
            .diffuserLimits = ed.Diffusers.jarvisLimits,
            .quantizer = ed.Quantizers.thresholder,
        },
        else => @panic("Invalid mode"),
    };

    try ed.errorDiffusion(gpa.allocator(), grayImg, edOpts);

    try grayImg.writeToFilePath(options.output, .{ .png = .{} });
}