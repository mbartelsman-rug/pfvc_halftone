const std = @import("std");
const Allocator = @import("std").mem.Allocator;

const zigimg = @import("zigimg");
const Image = @import("zigimg").Image;
const PixelFormat = @import("zigimg").PixelFormat;

const utils = @import("utils.zig");

const cast = @import("../cast.zig");
const int = cast.int;
const uint = cast.uint;
const float = cast.float;

pub fn resample(allocator: Allocator, image: Image, newWidth: usize) !Image {
    if (newWidth == image.width) {
        return Image.fromRawPixels(
            allocator,
            image.width,
            image.height,
            image.rawBytes(),
            image.pixelFormat());
    }
    else {
        return resampleImpl(allocator, image, newWidth);
    }
}

fn resampleImpl(allocator: Allocator, image: Image, newWidth: usize) !Image {
    const aspectRatio = float(32, image.width) / float(32, image.height);
    const newHeight = uint(0, float(32, newWidth) / aspectRatio);

    var result = try Image.create(allocator, newWidth, newHeight, .float32);

    const factorWidth = float(32, image.width) / float(32, newWidth);
    const factorHeight = float(32, image.height) / float(32, newHeight);

    for (0..newWidth) |i| {
        for (0..newHeight) |j| {
            const x = float(32, i) * factorWidth;
            const y = float(32, j) * factorHeight;

            const nearestX = @min(uint(0, @max(@round(x - 0.5), 0)), image.width - 1);
            const nearestY = @min(uint(0, @max(@round(y - 0.5), 0)), image.height - 1);
            const nearestColor = utils.getColorF32(nearestX, nearestY, image);
            
            result.pixels.float32[result.width * j + i] = nearestColor;
        }
    }

    try result.convert(image.pixelFormat());
    return result;
}