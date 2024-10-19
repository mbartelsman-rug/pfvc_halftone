const coeffWeight = 1.0;

const coeffValues = [128][3]f32{
    [3]f32{ 13, 0, 5 },
    [3]f32{ 13, 0, 5 },
    [3]f32{ 21, 0, 10 },
    [3]f32{ 7, 0, 4 },
    [3]f32{ 8, 0, 5 },
    [3]f32{ 47, 3, 28 },
    [3]f32{ 23, 3, 13 },
    [3]f32{ 15, 3, 8 },
    [3]f32{ 22, 6, 11 },
    [3]f32{ 43, 15, 20 },
    [3]f32{ 7, 3, 3 },
    [3]f32{ 501, 224, 211 },
    [3]f32{ 249, 116, 103 },
    [3]f32{ 165, 80, 67 },
    [3]f32{ 123, 62, 49 },
    [3]f32{ 489, 256, 191 },
    [3]f32{ 81, 44, 31 },
    [3]f32{ 483, 272, 181 },
    [3]f32{ 60, 35, 22 },
    [3]f32{ 53, 32, 19 },
    [3]f32{ 237, 148, 83 },
    [3]f32{ 471, 304, 161 },
    [3]f32{ 3, 2, 1 },
    [3]f32{ 481, 314, 185 },
    [3]f32{ 354, 226, 155 },
    [3]f32{ 1389, 866, 685 },
    [3]f32{ 227, 138, 125 },
    [3]f32{ 267, 158, 163 },
    [3]f32{ 327, 188, 220 },
    [3]f32{ 61, 34, 45 },
    [3]f32{ 627, 338, 505 },
    [3]f32{ 1227, 638, 1075 },
    [3]f32{ 20, 10, 19 },
    [3]f32{ 1937, 1000, 1767 },
    [3]f32{ 977, 520, 855 },
    [3]f32{ 657, 360, 551 },
    [3]f32{ 71, 40, 57 },
    [3]f32{ 2005, 1160, 1539 },
    [3]f32{ 337, 200, 247 },
    [3]f32{ 2039, 1240, 1425 },
    [3]f32{ 257, 160, 171 },
    [3]f32{ 691, 440, 437 },
    [3]f32{ 1045, 680, 627 },
    [3]f32{ 301, 200, 171 },
    [3]f32{ 177, 120, 95 },
    [3]f32{ 2141, 1480, 1083 },
    [3]f32{ 1079, 760, 513 },
    [3]f32{ 725, 520, 323 },
    [3]f32{ 137, 100, 57 },
    [3]f32{ 2209, 1640, 855 },
    [3]f32{ 53, 40, 19 },
    [3]f32{ 2243, 1720, 741 },
    [3]f32{ 565, 440, 171 },
    [3]f32{ 759, 600, 209 },
    [3]f32{ 1147, 920, 285 },
    [3]f32{ 2311, 1880, 513 },
    [3]f32{ 97, 80, 19 },
    [3]f32{ 335, 280, 57 },
    [3]f32{ 1181, 1000, 171 },
    [3]f32{ 793, 680, 95 },
    [3]f32{ 599, 520, 57 },
    [3]f32{ 2413, 2120, 171 },
    [3]f32{ 405, 360, 19 },
    [3]f32{ 2447, 2200, 57 },
    [3]f32{ 11, 10, 0 },
    [3]f32{ 158, 151, 3 },
    [3]f32{ 178, 179, 7 },
    [3]f32{ 1030, 1091, 63 },
    [3]f32{ 248, 277, 21 },
    [3]f32{ 318, 375, 35 },
    [3]f32{ 458, 571, 63 },
    [3]f32{ 878, 1159, 147 },
    [3]f32{ 5, 7, 1 },
    [3]f32{ 172, 181, 37 },
    [3]f32{ 97, 76, 22 },
    [3]f32{ 72, 41, 17 },
    [3]f32{ 119, 47, 29 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 4, 1, 1 },
    [3]f32{ 65, 18, 17 },
    [3]f32{ 95, 29, 26 },
    [3]f32{ 185, 62, 53 },
    [3]f32{ 30, 11, 9 },
    [3]f32{ 35, 14, 11 },
    [3]f32{ 85, 37, 28 },
    [3]f32{ 55, 26, 19 },
    [3]f32{ 80, 41, 29 },
    [3]f32{ 155, 86, 59 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 5, 3, 2 },
    [3]f32{ 305, 176, 119 },
    [3]f32{ 155, 86, 59 },
    [3]f32{ 105, 56, 39 },
    [3]f32{ 80, 41, 29 },
    [3]f32{ 65, 32, 23 },
    [3]f32{ 55, 26, 19 },
    [3]f32{ 335, 152, 113 },
    [3]f32{ 85, 37, 28 },
    [3]f32{ 115, 48, 37 },
    [3]f32{ 35, 14, 11 },
    [3]f32{ 355, 136, 109 },
    [3]f32{ 30, 11, 9 },
    [3]f32{ 365, 128, 107 },
    [3]f32{ 185, 62, 53 },
    [3]f32{ 25, 8, 7 },
    [3]f32{ 95, 29, 26 },
    [3]f32{ 385, 112, 103 },
    [3]f32{ 65, 18, 17 },
    [3]f32{ 395, 104, 101 },
    [3]f32{ 4, 1, 1 },
};

const xOffsets = [3]isize{ -1, 0, 1 };
const yOffsets = [3]isize{ 1, 1, 0 };

fn quantize(image: GrayImage, x: usize, y: usize, value: f32, tHolder: *const generic.ThresholderFn) f32 {
    return if (value <= tHolder(image, x, y, value)) 0.0 else 1.0;
}

fn diffuse(_: GrayImage, quantized: GrayImage, residuals: *GrayImage, direction: generic.PathDirection, x: usize, y: usize, residual: f32) void {
    const value = (quantized.get(x, y) + residual) * 255.0;
    const coeffIndex = if (value <= 127.5) value else 255.0 - value;
    const coeffs = coeffValues[uint(0, std.math.clamp(coeffIndex, 0, 255.0))];

    var coeffDivisor: f32 = 0.0;
    for (coeffs) |coeff| {
        coeffDivisor += coeff;
    }
    coeffDivisor /= coeffWeight;

    for (xOffsets, yOffsets, 0..) |iOffset, jOffset, index| {
        const i = switch (direction) {
            .left => int(0, x) - iOffset,
            .right => int(0, x) + iOffset,
        };
        const j = int(0, y) + jOffset;

        if (i < 0 or quantized.width - 1 < i) {
            continue;
        }
        if (j < 0 or quantized.height - 1 < j) {
            continue;
        }

        const oldResidual = residuals.get(uint(0, i), uint(0, j));
        const currResidual = residual * coeffs[index] / coeffDivisor;
        residuals.set(uint(0, i), uint(0, j), oldResidual + currResidual);
    }
}

pub fn errorDiffusion(allocator: Allocator, original: Image, thresholder: *const generic.ThresholderFn) anyerror!struct { Image, Image } {
    return generic.errorDiffusion(allocator, original, generic.GenericErrorDiffusionOpts{ .quantize = quantize, .diffuse = diffuse, .thresholder = thresholder, .path = .serpentine });
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
