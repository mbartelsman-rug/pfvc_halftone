const std = @import("std");
const Allocator = std.mem.Allocator;

const zigimg = @import("zigimg");
const Image = @import("zigimg").Image;
const PixelFormat = @import("zigimg").PixelFormat;

const Cast = @import("cast.zig");
const int = Cast.int;
const uint = Cast.uint;
const float = Cast.float;

pub const Diffusers = struct {
    pub const Diffuser: type = fn (quantError: i16, params: Params) i16;

    pub const Params = struct {
        image: Image,
        baseX: usize,
        baseY: usize,
        relX: usize,
        relY: usize,
        opts: ?[*]u8 = null,
    };

    pub const Limits = struct {
        up: u8 = 0,
        down: u8 = 1,
        left: u8 = 1,
        right: u8 = 1,
    };

    pub const noneLimits = Limits {
        .up = 0,
        .down = 0,
        .left = 0,
        .right = 0,
    };

    pub fn none(_: i16, _: Params) i16 {
        return 0;
    }

    pub const floydSteinbergLimits = Limits {
        .up = 0,
        .down = 1,
        .left = 1,
        .right = 1,
    };

    pub fn floydSteinberg(quantError: i16, params: Params) i16 {
        const offsetX = int(0, params.relX) - int(0, params.baseX);
        const offsetY = int(0, params.relY) - int(0, params.baseY);

        if (@abs(offsetX) > 1) return 0;
        if (@abs(offsetY) > 1) return 0;

        const coeffs = [3][3]f32{
            [3]f32{ 0.0 / 16.0, 0.0 / 16.0, 0.0 / 16.0 },
            [3]f32{ 0.0 / 16.0, 0.0 / 16.0, 7.0 / 16.0 },
            [3]f32{ 3.0 / 16.0, 5.0 / 16.0, 1.0 / 16.0 },
        };

        const indexX = uint(0, offsetX + 1);
        const indexY = uint(0, offsetY + 1);
        const diffusedError = coeffs[indexY][indexX] * float(32, quantError);

        return int(16, diffusedError);
    }

    pub const atkinsonLimits = Limits {
        .up = 0,
        .down = 2,
        .left = 1,
        .right = 2,
    };

    pub fn atkinson(quantError: i16, params: Params) i16 {
        const offsetX = int(0, params.relX) - int(0, params.baseX);
        const offsetY = int(0, params.relY) - int(0, params.baseY);

        if (offsetX < -1 or 2 < offsetX) return 0;
        if (offsetY < 0 or 2 < offsetY) return 0;

        const coeffs = [3][4]f32{
            [4]f32{    0.0    ,    0.0    , 1.0 / 8.0 , 1.0 / 8.0 },
            [4]f32{ 1.0 / 8.0 , 1.0 / 8.0 , 1.0 / 8.0 ,    0.0    },
            [4]f32{    0.0    , 1.0 / 8.0 ,    0.0    ,    0.0    },
        };

        const indexX = uint(0, offsetX + 1);
        const indexY = uint(0, offsetY);
        const diffusedError = coeffs[indexY][indexX] * float(32, quantError);

        return int(16, diffusedError);
    }

    pub const jarvisLimits = Limits {
        .up = 0,
        .down = 2,
        .left = 2,
        .right = 2,
    };

    pub fn jarvis(quantError: i16, params: Params) i16 {
        const offsetX = int(0, params.relX) - int(0, params.baseX);
        const offsetY = int(0, params.relY) - int(0, params.baseY);

        if (offsetX < -2 or 2 < offsetX) return 0;
        if (offsetY < 0 or 2 < offsetY) return 0;

        const coeffs = [3][5]f32{
            [5]f32{     0.0    ,     0.0    ,     0.0    , 7.0 / 48.0 , 5.0 / 48.0 },
            [5]f32{ 3.0 / 48.0 , 5.0 / 48.0 , 7.0 / 48.0 , 5.0 / 48.0 , 3.0 / 48.0 },
            [5]f32{ 1.0 / 48.0 , 3.0 / 48.0 , 4.0 / 48.0 , 3.0 / 48.0 , 1.0 / 48.0 },
        };

        const indexX = uint(0, offsetX + 2);
        const indexY = uint(0, offsetY);
        const diffusedError = coeffs[indexY][indexX] * float(32, quantError);

        return int(16, diffusedError);
    }
};

pub const Quantizers = struct {
    pub const Quantizer: type = fn (value: u8, params: QuantizerParams) u8;

    pub const QuantizerParams = struct {
        image: Image,
        baseX: usize,
        baseY: usize,
        opts: ?[*]u8 = null,
    };

    pub const ThresholderOpts = packed struct {
        threshold: u8 = 127,
    };

    pub fn thresholder(value: u8, params: QuantizerParams) u8 {
        const thresholdParams = if (params.opts != null)
            std.mem.bytesAsValue(ThresholderOpts, params.opts.?).*
        else
            ThresholderOpts{};

        return if (value <= thresholdParams.threshold) 0 else 255;
    }
};

pub const ErrorDiffusionOpts = struct {
    quantizer: *const Quantizers.Quantizer = Quantizers.thresholder,
    quantizerOpts: ?[*]u8 = null,

    diffuser: *const Diffusers.Diffuser = Diffusers.floydSteinberg,
    diffuserLimits: Diffusers.Limits,
    diffuserOpts: ?[*]u8 = null,
};

pub fn errorDiffusion(allocator: Allocator, image: Image, opts: ErrorDiffusionOpts) !void {
    var data = image.pixels.grayscale8;
    var errors = try allocator.alloc(i16, image.width * image.height);
    defer allocator.free(errors);

    for (0..image.width * image.height) |i| {
        errors[i] = 0;
    }

    for (0..image.height) |j| {
        for (0..image.width) |i| {
            const index: usize = j * image.width + i;
            const quantizerParams = Quantizers.QuantizerParams{ .image = image, .baseX = i, .baseY = j, .opts = opts.quantizerOpts };

            const originalValue: u8 = data[index].value;
            const originalError: i16 = errors[index];
            const correctedValue: u8 = uint(8, std.math.clamp(int(16, originalValue) + originalError, 0, 255));
            const quantizedValue: u8 = opts.quantizer(correctedValue, quantizerParams);
            const quantizedError: i16 = int(16, correctedValue) - int(16, quantizedValue);
            data[index].value = quantizedValue;

            const iMin: usize = @max(opts.diffuserLimits.left, i) - opts.diffuserLimits.left;
            const jMin: usize = @max(opts.diffuserLimits.up, j) - opts.diffuserLimits.up;

            const iMax: usize = @min(image.width - 1, i + opts.diffuserLimits.right);
            const jMax: usize = @min(image.height - 1, j + opts.diffuserLimits.down);

            for (jMin..jMax + 1) |jRel| {
                for (iMin..iMax + 1) |iRel| {
                    const indexRel: usize = jRel * image.width + iRel;
                    const diffuserParams = Diffusers.Params{ .image = image, .baseX = i, .baseY = j, .relX = iRel, .relY = jRel, .opts = opts.diffuserOpts };

                    const diffusedError = opts.diffuser(quantizedError, diffuserParams);
                    errors[indexRel] += diffusedError;
                }
            }
        }
    }
}
