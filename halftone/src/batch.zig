pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const options = try OptionsBatch.parseArgs(gpa.allocator());
    defer options.deinit();

    return batch(gpa.allocator(), options);
}

const Config = struct {
    mode: OptionsExe.Mode,
    threshold: OptionsExe.Threshold,
    name: []const u8,
};

const configs = [_]Config {
    .{ .mode = .grayscale,          .threshold = .constant, .name = "base" },
    .{ .mode = .@"floyd-steinberg", .threshold = .constant, .name = "fs" },
    .{ .mode = .@"floyd-steinberg", .threshold = .entropy,  .name = "em-fs" },
    .{ .mode = .ostromoukhov,       .threshold = .constant, .name = "o" },
    .{ .mode = .@"zhou-fang",       .threshold = .constant, .name = "zf" },
    .{ .mode = .@"zhou-fang",       .threshold = .entropy,  .name = "em-zf" },
    .{ .mode = .xiangyu,            .threshold = .constant, .name = "x" },
};

fn batch(allocator: Allocator, options: OptionsBatch) !void {
    for (configs) |config| {
        
        const programOptions = OptionsExe {
            .input = options.input,
            .output = try std.fmt.allocPrint(allocator, "{s}/{s}.png", .{ options.output, config.name }),
            .@"error" = if (options.errors) try std.fmt.allocPrint(allocator, "{s}/{s}.err.png", .{ options.output, config.name }) else null,
            .gamma = options.gamma,
            .scale = 4,
            .mode = config.mode,
            .threshold = config.threshold,
            .allocator = allocator,
        };
        defer allocator.free(programOptions.output);
        
        if (programOptions.@"error" != null) {
            defer allocator.free(programOptions.@"error".?);
        }

        try program.program(allocator, programOptions);
    }

}


// Imports

const std = @import("std");
const Allocator = @import("std").mem.Allocator;

const zigimg = @import("zigimg");
const zargs = @import("zargs");

const program = @import("main.zig");

const opts = @import("options.zig");
const OptionsBatch = opts.OptionsBatch;
const OptionsExe = opts.OptionsExe;

const coloring = @import("coloring.zig");
const toLinearGrayscale = coloring.toLinearGrayscale;

const bilinear = @import("resampling/bilinear.zig");
const nearestNeighbour = @import("resampling/nearestNeighbour.zig");

const ed = @import("errorDiffusion.zig");