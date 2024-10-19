pub const ArgsBatch = struct {
    input: ?[]const u8 = null,
    output: ?[]const u8 = null,
    errors: bool = false,
    gamma: f32 = 2.2,

    pub const shorthands = .{
        .i = "input",
        .o = "output",
        .e = "errors",
        .g = "gamma",
    };
};

pub const OptionsBatch = struct {
    input: []const u8,
    output: []const u8,
    errors: bool,
    gamma: f32,

    allocator: std.mem.Allocator,

    pub fn parseArgs(allocator: std.mem.Allocator) !OptionsBatch {
        const parsedArgs = try zargs.parseForCurrentProcess(ArgsBatch, allocator, .print);
        defer parsedArgs.deinit();

        if (parsedArgs.options.input == null) {
            std.debug.print("Input not specified", .{});
            return error.NoInput;
        }

        if (parsedArgs.options.output == null) {
            std.debug.print("Output not specified", .{});
            return error.NoOutput;
        }

        const options = OptionsBatch {
            .input = try allocator.dupe(u8, parsedArgs.options.input.?),
            .output = try allocator.dupe(u8, parsedArgs.options.output.?),
            .gamma = parsedArgs.options.gamma,
            .errors = parsedArgs.options.errors,
            .allocator = allocator,
        };

        return options;
    }

    pub fn deinit(self: @This()) void {
        self.allocator.free(self.input);
        self.allocator.free(self.output);
    }
};

pub const ArgsExe = struct {
    input: ?[]const u8 = null,
    output: ?[]const u8 = null,
    @"error": ?[]const u8 = null,
    gamma: f32 = 2.2,
    scale: u8 = 4,
    mode: OptionsExe.Mode = OptionsExe.Mode.@"floyd-steinberg",
    threshold: OptionsExe.Threshold = OptionsExe.Threshold.constant,

    // This declares short-hand options for single hyphen
    pub const shorthands = .{
        .i = "input",
        .o = "output",
        .e = "error",
        .g = "gamma",
        .m = "mode",
        .s = "scale",
        .t = "threshold",
    };
};

pub const OptionsExe = struct {
    input: []const u8,
    output: []const u8,
    @"error": ?[]const u8,
    gamma: f32,
    scale: u8,
    mode: Mode,
    threshold: Threshold,

    allocator: std.mem.Allocator,

    pub const Mode = enum(u8) {
        none,
        grayscale,
        threshold,
        @"floyd-steinberg",
        atkinson,
        jarvis,
        ostromoukhov,
        @"zhou-fang",
        xiangyu,
        _,
    };

    pub const Threshold = enum {
        constant,
        entropy,
    };

    pub fn parseArgs(allocator: std.mem.Allocator) !OptionsExe {
        const parsedArgs = try zargs.parseForCurrentProcess(ArgsExe, allocator, .print);
        defer parsedArgs.deinit();

        if (parsedArgs.options.input == null) {
            std.debug.print("Input not specified", .{});
            return error.NoInput;
        }

        if (parsedArgs.options.output == null) {
            std.debug.print("Output not specified", .{});
            return error.NoOutput;
        }

        const options = OptionsExe{
            .input = try allocator.dupe(u8, parsedArgs.options.input.?),
            .output = try allocator.dupe(u8, parsedArgs.options.output.?),
            .@"error" = if (parsedArgs.options.@"error") |err| try allocator.dupe(u8, err) else null,
            .gamma = parsedArgs.options.gamma,
            .scale = parsedArgs.options.scale,
            .mode = parsedArgs.options.mode,
            .threshold = parsedArgs.options.threshold,
            .allocator = allocator,
        };

        return options;
    }

    pub fn deinit(self: @This()) void {
        self.allocator.free(self.input);
        self.allocator.free(self.output);
        if (self.@"error") |err| {
            self.allocator.free(err);
        }
    }
};

const std = @import("std");
const zargs = @import("zargs");
