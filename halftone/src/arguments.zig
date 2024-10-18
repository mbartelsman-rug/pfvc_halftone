pub const Args = struct {
    input: ?[]const u8 = null,
    output: ?[]const u8 = null,
    @"error": ?[]const u8 = null,
    gamma: f32 = 2.2,
    scale: u8 = 4,
    mode: Options.Mode = Options.Mode.@"floyd-steinberg",

    // This declares short-hand options for single hyphen
    pub const shorthands = .{
        .i = "input",
        .o = "output",
        .e = "error",
        .g = "gamma",
        .m = "mode",
        .s = "scale"
    };
};

pub const Options = struct {
    input: []const u8,
    output: []const u8,
    @"error": ?[]const u8,
    gamma: f32,
    scale: u8,
    mode: Mode,

    allocator: std.mem.Allocator,

    const Mode = enum (u8) {
        none,
        grayscale,
        threshold,
        @"floyd-steinberg",
        atkinson,
        jarvis,
        ostromoukhov,
        @"zhou-fang",
        @"zhou-fang-ectm",
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
            .@"error" = if (parsedArgs.options.@"error") |err| try allocator.dupe(u8, err) else null,
            .gamma = parsedArgs.options.gamma,
            .scale = parsedArgs.options.scale,
            .mode = parsedArgs.options.mode,
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