const coeffWeight = 1.0;

const coeffValues = [4]f32 { 3, 5, 1, 7 };
const xOffsets = [4]isize { -1, 0, 1, 1 };
const yOffsets = [4]isize { 1, 1, 1, 0 };

pub fn quantize(image: GrayImage, x: usize, y: usize, value: f32, tHolder: *const generic.ThresholderFn) f32 {
    return if (value <= tHolder(image, x, y, value)) 0 else 1.0;
}

fn diffuse (
    image: GrayImage, 
    _: GrayImage, 
    residuals: *GrayImage, 
    _: generic.PathDirection,
    x: usize, 
    y: usize, 
    residual: f32) void 
{
    for (xOffsets, yOffsets, 0..) |iOffset, jOffset, index| {
        const i = int(0, x) + iOffset;
        const j = int(0, y) + jOffset;

        if (i < 0 or image.width - 1 < i) { continue; }
        if (j < 0 or image.height - 1 < j) { continue; }

        const oldResidual = residuals.get(uint(0, i), uint(0, j));
        const currResidual = residual * coeffValues[index] / 16.0;
        residuals.set(uint(0, i), uint(0, j), oldResidual + currResidual);
    }
}

pub fn errorDiffusion(allocator: Allocator, original: Image, thresholder: *const generic.ThresholderFn) anyerror!struct { Image, Image } {
    return generic.errorDiffusion(allocator, original, .{ .quantize = quantize, .diffuse = diffuse, .thresholder = thresholder, .path = .scanline });
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

const generic = @import("generic.zig");