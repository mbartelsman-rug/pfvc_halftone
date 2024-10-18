pub const QuantizeFn = fn(Gray8Image, usize, usize, f32) f32;
pub const DiffuseFn = fn(Gray8Image, Gray8Image, *Gray8Image, PathDirection, usize, usize, f32) void;

pub const PathDirection = enum {
    left,
    right
};

pub const GenericErrorDiffusionOpts = struct {
    quantize: *const QuantizeFn,
    diffuse: *const DiffuseFn,
    path: enum {
        scanline,
        serpentine
    }
};

pub fn errorDiffusion(
    allocator: Allocator,
    original: Image,
    genericOpts: GenericErrorDiffusionOpts) !struct { Image, Image }
{
    // Setup
    var oldValues = try Gray8Image.fromBytes(allocator, original.width, original.height, original.rawBytes());
    defer oldValues.deinit();
    
    var newValues = try Gray8Image.init(allocator, original.width, original.height);
    defer newValues.deinit();

    var errorValues = try Gray8Image.init(allocator, original.width, original.height);
    defer errorValues.deinit();

    var errors = try Gray8Image.init(allocator, original.width, original.height);
    defer errors.deinit();

    // Error-diffusion
    for (0..newValues.height) |j| {
        for (0..newValues.width) |i| {
            const x = switch (genericOpts.path) {
                .scanline => i,
                .serpentine => if (j % 2 == 0) i else original.width - i - 1,
            };

            const oldValue = oldValues.get(x, j);
            const oldError = errors.get(x, j);
            const newValue = oldValue + oldError;
            const quantValue = genericOpts.quantize(oldValues, x, j, newValue);
            const quantError = newValue - quantValue;

            newValues.set(x, j, quantValue);
            errorValues.set(x, j, oldError + 0.5);

            const direction = switch (genericOpts.path) {
                .scanline => PathDirection.right,
                .serpentine => if (j % 2 == 0) PathDirection.right else PathDirection.left,
            };
            genericOpts.diffuse(oldValues, newValues, &errors, direction, x, j, quantError);
        }
    }

    const finalPixels = try newValues.toBytes();
    defer newValues.allocator.free(finalPixels);

    // Wrapup
    const finalImage = try Image.fromRawPixels(
        allocator,
        original.width,
        original.height,
        finalPixels,
        PixelFormat.grayscale8);

    const errorPixels = try errorValues.toBytes();
    defer errorValues.allocator.free(errorPixels);

    const errorImage = try Image.fromRawPixels(
        allocator,
        original.width,
        original.height,
        errorPixels,
        PixelFormat.grayscale8);

    return .{ finalImage, errorImage };
}


// Imports

const std = @import("std");
const math = std.math;
const Allocator = std.mem.Allocator;

const Image = @import("zigimg").Image;
const PixelFormat = @import("zigimg").PixelFormat;

const int = @import("../cast.zig").int;
const uint = @import("../cast.zig").uint;
const float = @import("../cast.zig").float;

const Gray8Image = @import("../images.zig").Gray8Image;
const ErrorImage = @import("../images.zig").ErrorImage;


