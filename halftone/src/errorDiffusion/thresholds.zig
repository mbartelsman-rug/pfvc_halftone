
pub fn threshold(comptime tValue: f32) *const generic.ThresholderFn {
    return struct {
        fn lambda(_: GrayImage, _: usize, _: usize, _: f32) f32 {
            return tValue;
        }
    }.lambda;
}

pub fn entropyConstrained(comptime tValue: f32) *const generic.ThresholderFn {
    return struct {
        fn getEntropy(value: f32) f32 {
            const a = if (value == 0) 0 else value * std.math.log(f32, 2.0, value);
            const b = if (1.0 - value == 0) 0 else (1.0 - value) * std.math.log(f32, 2.0, 1.0 - value);
            return -a - b;
        }

        fn norm(value_sq: f32, variance: f32) f32 {
            const exp = std.math.exp(-value_sq / (2 * variance));
            const den = std.math.sqrt(2 * std.math.pi * variance);
            return exp / den;
        }

        /// See https://www.desmos.com/calculator/ol62h4qrpz for a live demonstration
        /// and approximation of what the paper attempted
        pub fn lambda(image: GrayImage, x: usize, y: usize, value: f32) f32 {
            const factor = 10.0;

            const xStart = uint(0, @max(0, int(0, x) - 2));
            const xEnd = uint(0, @min(int(0, x) + 2, int(0, image.width) - 1));
            const yStart = uint(0, @max(0, int(0, y) - 2));
            const yEnd = uint(0, @min(int(0, y) + 2, int(0, image.height) - 1));

            var lowPassSum: f32 = 0.0;
            var lowPassWeights: f32 = 0.0;
            for (xStart..xEnd) |i| {
                for (yStart..yEnd) |j| {
                    const relX = int(0, i) - int(0, x);
                    const relY = int(0, j) - int(0, y);

                    const other = image.get(i, j);
                    const d = norm(float(32, (relX * relX) + (relY * relY)), 0.5);

                    lowPassSum += other * d;
                    lowPassWeights += d;
                }
            }
            
            const lowPassValue = lowPassSum / lowPassWeights;
            const highPassValue = value - lowPassValue;
            const entropy = getEntropy(std.math.clamp(value, 0, 1.0));
            const constrainedThreshold = -(highPassValue * entropy) * factor + tValue;
            return constrainedThreshold;
        }
    }.lambda;
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