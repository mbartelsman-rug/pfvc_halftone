const std = @import("std");
const Allocator = @import("std").mem.Allocator;

const zigimg = @import("zigimg");
const Image = @import("zigimg").Image;
const PixelFormat = @import("zigimg").PixelFormat;

const utils = @import("utils.zig");

const Cast = @import("../cast.zig");
const int = Cast.int;
const uint = Cast.uint;
const float = Cast.float;

pub fn resample(allocator: Allocator, image: Image, newWidth: usize) !Image {
    if (newWidth < image.width) {
        return downSample(allocator, image, newWidth);
    }
    else if (newWidth > image.width) {
        return upSample(allocator, image, newWidth);
    }
    else {
        return Image.fromRawPixels(
            allocator,
            image.width,
            image.height,
            image.rawBytes(),
            image.pixelFormat());
    }
}

fn downSample(allocator: Allocator, image: Image, newWidth: usize) !Image {
    const aspectRatio = float(32, image.width) / float(32, image.height);
    const newHeight = uint(0, float(32, newWidth) / aspectRatio);

    var result = try Image.fromRawPixels(allocator, image.width, image.height, image.rawBytes(), image.pixelFormat());

    while (result.width >= newWidth * 2) {
        const rewResult = try halfSize(allocator, result);
        result.deinit();
        result = rewResult;
    }

    const newResult = try resampleImpl(allocator, result, newWidth, newHeight);
    result.deinit();
    result = newResult;

    try result.convert(image.pixelFormat());
    return result;
}

fn upSample(allocator: Allocator, image: Image, newWidth: usize) !Image {
    const aspectRatio = float(32, image.width) / float(32, image.height);
    const newHeight = uint(0, float(32, newWidth) / aspectRatio);

    var result = try Image.fromRawPixels(allocator, image.width, image.height, image.rawBytes(), image.pixelFormat());

    while (result.width * 2 <= newWidth) {
        const rewResult = try doubleSize(allocator, result);
        result.deinit();
        result = rewResult;
    }

    const newResult = try resampleImpl(allocator, result, newWidth, newHeight);
    result.deinit();
    result = newResult;

    try result.convert(image.pixelFormat());
    return result;
}

fn blerp(nw: anytype, ne: anytype, sw: anytype, se: anytype, tx: anytype, ty: anytype) @TypeOf(nw, ne, sw, se, tx, ty) {
    return std.math.lerp(
        std.math.lerp(nw, ne, tx),
        std.math.lerp(sw, se, tx),
        ty);
}

fn resampleImpl(allocator: Allocator, image: Image, newWidth: usize, newHeight: usize) !Image {
    var result = try Image.create(allocator, newWidth, newHeight, .float32);

    const factorWidth = float(32, image.width) / float(32, newWidth);
    const factorHeight = float(32, image.height) / float(32, newHeight);

    for (0..newWidth) |i| {
        for (0..newHeight) |j| {
            const x = float(32, i) * factorWidth;
            const y = float(32, j) * factorHeight;

            const west = @floor(x);
            const east = @min(@ceil(x), float(32, image.width - 1));
            const north = @floor(y);
            const south = @min(@ceil(y), float(32, image.height - 1));

            const nw = utils.getColorF32(uint(0, west), uint(0, north), image);
            const ne = utils.getColorF32(uint(0, east), uint(0, north), image);
            const sw = utils.getColorF32(uint(0, west), uint(0, south), image);
            const se = utils.getColorF32(uint(0, east), uint(0, south), image);

            const color = zigimg.color.Colorf32 {
                .r = blerp(nw.r, ne.r, sw.r, se.r, x - west, y - north),
                .g = blerp(nw.g, ne.g, sw.g, se.g, x - west, y - north),
                .b = blerp(nw.b, ne.b, sw.b, se.b, x - west, y - north),
                .a = blerp(nw.a, ne.a, sw.a, se.a, x - west, y - north),
            };
            
            result.pixels.float32[image.width * j + i] = color;
        }
    }

    try result.convert(image.pixelFormat());
    return result;
}

fn halfSize(allocator: Allocator, image: Image) !Image {
    var result = try Image.create(
        allocator,
        image.width / 2,
        image.height / 2,
        .float32);

    for (0..result.height) |j| {
        for (0..result.width) |i| {
            const nw = utils.getColorF32(@min((i * 2) + 1, image.width), (j * 2) + 0, image);
            const ne = utils.getColorF32((i * 2) + 0, (j * 2) + 0, image);
            const sw = utils.getColorF32(@min((i * 2) + 1, image.width), @min((j * 2) + 1, image.height), image);
            const se = utils.getColorF32((i * 2) + 0, @min((j * 2) + 1, image.height), image);

            const color = zigimg.color.Colorf32 {
                .r = (nw.r + ne.r + sw.r + se.r) / 4.0,
                .g = (nw.g + ne.g + sw.g + se.g) / 4.0,
                .b = (nw.b + ne.b + sw.b + se.b) / 4.0,
                .a = (nw.a + ne.a + sw.a + se.a) / 4.0,
            };

            result.pixels.float32[result.width * j + i] = color;
        }
    }

    try result.convert(image.pixelFormat());
    return result;
}

fn doubleSize(allocator: Allocator, image: Image) !Image {
    var result = try Image.create(
        allocator,
        image.width * 2,
        image.height * 2,
        .float32);

    for (0..result.height) |j| {
        for (0..result.width) |i| {
            const nw = utils.getColorF32((i / 2) + 1, (j / 2) + 0, image);
            const ne = utils.getColorF32((i / 2) + 0, (j / 2) + 0, image);
            const sw = utils.getColorF32((i / 2) + 1, (j / 2) + 1, image);
            const se = utils.getColorF32((i / 2) + 0, (j / 2) + 1, image);

            const color = zigimg.color.Colorf32 {
                .r = (nw.r + ne.r + sw.r + se.r) / 4.0,
                .g = (nw.g + ne.g + sw.g + se.g) / 4.0,
                .b = (nw.b + ne.b + sw.b + se.b) / 4.0,
                .a = (nw.a + ne.a + sw.a + se.a) / 4.0,
            };

            result.pixels.float32[image.width * j + i] = color;
        }
    }

    try result.convert(image.pixelFormat());
    return result;
}