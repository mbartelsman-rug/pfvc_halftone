pub const QuantizeFn = fn(GrayImage, usize, usize, f32, *const ThresholderFn) f32;
pub const ThresholderFn = fn(GrayImage, usize, usize, f32) f32;
pub const DiffuseFn = fn(GrayImage, GrayImage, *GrayImage, PathDirection, usize, usize, f32) void;
pub const ErrorDiffusionFn = fn(allocator: Allocator, original: Image, thresholder: *const ThresholderFn) anyerror!struct { Image, Image };

pub const PathDirection = enum {
    left,
    right
};

pub const GenericErrorDiffusionOpts = struct {
    thresholder: *const ThresholderFn,
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
    genericOpts: GenericErrorDiffusionOpts) anyerror!struct { Image, Image }
{
    // Setup
    var oldValues = try GrayImage.fromBytes(allocator, original.width, original.height, original.rawBytes());
    defer oldValues.deinit();
    
    var newValues = try GrayImage.init(allocator, original.width, original.height);
    defer newValues.deinit();

    var errorValues = try GrayImage.init(allocator, original.width, original.height);
    defer errorValues.deinit();

    var errors = try GrayImage.init(allocator, original.width, original.height);
    defer errors.deinit();

    // Error-diffusion
    for (0..newValues.height) |y| {
        for (0..newValues.width) |xPrime| {
            const x = switch (genericOpts.path) {
                .scanline => xPrime,
                .serpentine => if (y % 2 == 0) xPrime else original.width - xPrime - 1,
            };

            const oldValue = oldValues.get(x, y);
            const oldError = errors.get(x, y);
            const newValue = oldValue + oldError;
            const quantValue = genericOpts.quantize(oldValues, x, y, newValue, genericOpts.thresholder);
            const quantError = newValue - quantValue;

            newValues.set(x, y, quantValue);
            errorValues.set(x, y, oldError + 0.5);

            const direction = switch (genericOpts.path) {
                .scanline => PathDirection.right,
                .serpentine => if (y % 2 == 0) PathDirection.right else PathDirection.left,
            };
            genericOpts.diffuse(oldValues, newValues, &errors, direction, x, y, quantError);
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

const GrayImage = @import("../images.zig").GrayImage;
const ErrorImage = @import("../images.zig").ErrorImage;


