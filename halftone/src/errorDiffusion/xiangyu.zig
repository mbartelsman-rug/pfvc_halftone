const coeffWeight = 1.0;

const coeffValues = [4]f32 { 3, 5, 1, 7 };
const xOffsets = [4]isize { -1, 0, 1, 1 };
const yOffsets = [4]isize { 1, 1, 1, 0 };

pub fn quantize(image: GrayImage, x: usize, y: usize, value: f32, tHolder: *const generic.ThresholderFn) f32 {
    return if (value <= tHolder(image, x, y, value)) 0 else 1.0;
}

pub fn getGradient(image: GrayImage, a: f32, x0: usize, y0: usize) f32 {
    const x1 = if (x0 + 1 == image.width) x0 else x0 + 1;
    const y1 = if (y0 + 1 == image.height) y0 else y0 + 1;

    const g00 = image.get(x0, y0);
    const g10 = image.get(x1, y0);
    const g01 = image.get(x0, y1);
    const g11 = image.get(x1, y1);

    const term1 = (g00 - g10) * (g00 - g10);
    const term2 = (g00 - g01) * (g00 - g01);
    const term3 = (g10 + g01 - g00 - g11) * (g10 + g01 - g00 - g11);
    const gradient = (term1 + term2 + term3) / 3.0;

    const gradientPrime = (1 - a) * gradient;
    return gradientPrime;
}

fn getFlatCoefficients(a: f32, x0: usize, y0: usize) [4]f32 {
    const wN1 = coeffValues[0] / 16.0;
    const w01 = coeffValues[1] / 16.0;
    const w11 = coeffValues[2] / 16.0;
    const w10 = coeffValues[3] / 16.0;

    var rng = std.rand.DefaultPrng.init(@shlWithOverflow(x0, 16)[0] + y0);
    const r1 = float(32, rng.next()) / float(32, std.math.maxInt(u64) / 2) - 1.0;
    const r2 = float(32, rng.next()) / float(32, std.math.maxInt(u64) / 2) - 1.0;
    
    const a01 = w01 * (1 + a * r1);
    const a10 = w10 * (1 + a * r1);
    const aN1 = wN1 * (1 + a * r2);
    const a11 = w11 * (1 + a * r2);
    const aSum = a01 + a10 + aN1 + a11;

    const w01Prime = a01 / aSum;
    const w10Prime = a10 / aSum;
    const wN1Prime = aN1 / aSum;
    const w11Prime = a11 / aSum;
    
    return [4]f32 { wN1Prime, w01Prime, w11Prime, w10Prime, };
}

fn getDetailedCoefficients(image: GrayImage, quantizedImage: GrayImage, p: f32, eps: f32, x0: usize, y0: usize) [4]f32 {
    const wN1 = coeffValues[0] / 16.0;
    const w01 = coeffValues[1] / 16.0;
    const w11 = coeffValues[2] / 16.0;
    const w10 = coeffValues[3] / 16.0;

    const xN = if (x0 == 0) 0 else x0 - 1;
    const x1 = if (x0 + 1 == image.width) x0 else x0 + 1;
    const y1 = if (y0 + 1 == image.height) y0 else y0 + 1;

    const g00Hat = quantizedImage.get(x0, y0);
    const g01 = image.get(x0, y1);
    const g10 = image.get(x1, y0);
    const gN1 = image.get(xN, y1);
    const g11 = image.get(x1, y1);

    const s01 = std.math.pow(f32, (g00Hat - g01) * (g00Hat - g01) + eps, p);
    const s10 = std.math.pow(f32, (g00Hat - g10) * (g00Hat - g10) + eps, p);
    const sN1 = std.math.pow(f32, (g00Hat - gN1) * (g00Hat - gN1) + eps, p);
    const s11 = std.math.pow(f32, (g00Hat - g11) * (g00Hat - g11) + eps, p);
    
    const a01 = w01 * s01;
    const a10 = w10 * s10;
    const aN1 = wN1 * sN1;
    const a11 = w11 * s11;
    const aSum = a01 + a10 + aN1 + a11;

    const w01Prime = a01 / aSum;
    const w10Prime = a10 / aSum;
    const wN1Prime = aN1 / aSum;
    const w11Prime = a11 / aSum;
    
    return [4]f32 { wN1Prime, w01Prime, w11Prime, w10Prime, };
}

fn diffuse (
    image: GrayImage, 
    quantizedImage: GrayImage, 
    residuals: *GrayImage, 
    _: generic.PathDirection,
    x: usize, 
    y: usize, 
    residual: f32) void 
{
    const eps = 0.1;
    const p = 3;

    const g00 = image.get(x, y);
    const gPrime = @abs(1 - 2 * g00);
    const a = (1 - gPrime) * (1 - gPrime) * (1 + 2 * gPrime);

    const coefficients = if (getGradient(image, a, x, y) > eps)
        getDetailedCoefficients(image, quantizedImage, p, eps, x, y)
        else getFlatCoefficients(a, x, y);

    for (xOffsets, yOffsets, 0..) |iOffset, jOffset, index| {
        const i = int(0, x) + iOffset;
        const j = int(0, y) + jOffset;

        if (i < 0 or image.width - 1 < i) { continue; }
        if (j < 0 or image.height - 1 < j) { continue; }

        const oldResidual = residuals.get(uint(0, i), uint(0, j));
        const currResidual = residual * coefficients[index];
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