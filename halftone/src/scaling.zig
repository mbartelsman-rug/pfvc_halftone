const std = @import("std");
const Allocator = @import("std").mem.Allocator;

const zigimg = @import("zigimg");
const Image = @import("zigimg").Image;
const PixelFormat = @import("zigimg").PixelFormat;

const Cast = @import("cast.zig");
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

pub fn downSample(allocator: Allocator, image: Image, newWidth: usize) !Image {
    const aspectRatio = float(32, image.width) / float(32, image.height);
    const newHeight = int(0, float(32, newWidth) / aspectRatio);

    var result = try Image.create(allocator, newWidth, newHeight, .float32);

    while (result.width >= newWidth * 2) {
        const rewResult = halfSize(allocator, result);
        result.deinit();
        result = rewResult;
    }

    const newResult = try bilinearResample(allocator, result, newWidth, newHeight);
    result.deinit();
    result = newResult;

    result.convert(image.pixelFormat());
    return result;
}

pub fn upSample(allocator: Allocator, image: Image, newWidth: usize) !Image {
    const aspectRatio = float(32, image.width) / float(32, image.height);
    const newHeight = int(0, float(32, newWidth) / aspectRatio);

    var result = try Image.create(allocator, newWidth, newHeight, .float32);

    while (result.width * 2 <= newWidth) {
        const rewResult = doubleSize(allocator, result);
        result.deinit();
        result = rewResult;
    }

    const newResult = try bilinearResample(allocator, result, newWidth, newHeight);
    result.deinit();
    result = newResult;

    result.convert(image.pixelFormat());
    return result;
}

fn blerp(nw: anytype, ne: anytype, sw: anytype, se: anytype, tx: anytype, ty: anytype) {
    return std.math.lerp(
        std.math.lerp(nw, ne, x - west),
        std.math.lerp(sw, se, x - west),
        y - south);
}

pub fn bilinearResample(allocator: Allocator, image: Image, newWidth: usize, newHeight: usize) !Image {
    var result = try Image.create(allocator, newWidth, newHeight, .float32);

    const factorWidth = float(32, image.width) / float(32, newWidth);
    const factorHeight = float(32, image.height) / float(32, newHeight);

    for (0..newWidth) |i| {
        for (0..newHeight) |j| {
            const x = float(32, i) * factorWidth;
            const y = float(32, j) * factorHeight;

            const west = @floor(x);
            const east = @min(@ceil(x), image.width - 1);
            const north = @floor(y);
            const south = @min(@ceil(y), image.height - 1);

            const nw = getColor(.float32, west, north, image);
            const ne = getColor(.float32, east, north, image);
            const sw = getColor(.float32, west, south, image);
            const se = getColor(.float32, east, south, image);

            const color = zigimg.color.Colorf32 {
                .r = blerp(nw.r, ne.r, sw.r, se.r, x - west, y - north),
                .g = blerp(nw.g, ne.g, sw.g, se.g, x - west, y - north),
                .b = blerp(nw.b, ne.b, sw.b, se.b, x - west, y - north),
                .a = blerp(nw.a, ne.a, sw.a, se.a, x - west, y - north),
            };
            
            result.pixels.float32[image.width * j + i] = color;
        }
    }

    result.convert(image.pixelFormat());
    return result;
}

pub fn halfSize(allocator: Allocator, image: Image) !Image {
    var result = try Image.create(
        allocator,
        image.width / 2,
        image.height / 2,
        .float32);

    for (0..result.height) |j| {
        for (0..result.width) |i| {
            const nw = getColor(.float32, (i * 2) + 1, (j * 2) + 0, image);
            const ne = getColor(.float32, (i * 2) + 0, (j * 2) + 0, image);
            const sw = getColor(.float32, (i * 2) + 1, (j * 2) + 1, image);
            const se = getColor(.float32, (i * 2) + 0, (j * 2) + 1, image);

            const color = zigimg.color.Colorf32 {
                .r = (nw.r + ne.r + sw.r + se.r) / 4.0,
                .g = (nw.g + ne.g + sw.g + se.g) / 4.0,
                .b = (nw.b + ne.b + sw.b + se.b) / 4.0,
                .a = (nw.a + ne.a + sw.a + se.a) / 4.0,
            };

            result.pixels.float32[image.width * j + i] = color;
        }
    }

    result.convert(image.pixelFormat());
    return result;
}

pub fn doubleSize(allocator: Allocator, image: Image) !Image {
    var result = try Image.create(
        allocator,
        image.width * 2,
        image.height * 2,
        .float32);

    for (0..result.height) |j| {
        for (0..result.width) |i| {
            const nw = getColor(.float32, (i / 2) + 1, (j / 2) + 0, image);
            const ne = getColor(.float32, (i / 2) + 0, (j / 2) + 0, image);
            const sw = getColor(.float32, (i / 2) + 1, (j / 2) + 1, image);
            const se = getColor(.float32, (i / 2) + 0, (j / 2) + 1, image);

            const color = zigimg.color.Colorf32 {
                .r = (nw.r + ne.r + sw.r + se.r) / 4.0,
                .g = (nw.g + ne.g + sw.g + se.g) / 4.0,
                .b = (nw.b + ne.b + sw.b + se.b) / 4.0,
                .a = (nw.a + ne.a + sw.a + se.a) / 4.0,
            };

            result.pixels.float32[image.width * j + i] = color;
        }
    }

    result.convert(image.pixelFormat());
    return result;
}

pub fn Format(comptime format: PixelFormat) type {
    return switch (format) {
        .invalid => @compileError("Invalid pixel format"),
        .indexed1 => u1,
        .indexed2 => u2,
        .indexed4 => u4,
        .indexed8 => u8,
        .indexed16 => u16,
        .grayscale1 => zigimg.color.Grayscale1,
        .grayscale2 => zigimg.color.Grayscale2,
        .grayscale4 => zigimg.color.Grayscale4,
        .grayscale8 => zigimg.color.Grayscale8,
        .grayscale16 => zigimg.color.Grayscale16,
        .grayscale8Alpha => zigimg.color.Grayscale8Alpha,
        .grayscale16Alpha => zigimg.color.Grayscale16Alpha,
        .rgb555 => zigimg.color.Rgb555,
        .rgb565 => zigimg.color.Rgb565,
        .rgb24 => zigimg.color.Rgb24,
        .rgba32 => zigimg.color.Rgba32,
        .bgr555 => zigimg.color.Bgr555,
        .bgr24 => zigimg.color.Bgr24,
        .bgra32 => zigimg.color.Bgra32,
        .rgb48 => zigimg.color.Rgb48,
        .rgba64 => zigimg.color.Rgba64,
        .float32 => zigimg.color.Colorf32,
    };
}

pub fn getColor(comptime format: PixelFormat, x: usize, y: usize, image: Image) Format(format) {
    const index = y * image.width + x;

    return switch (format) {
        .invalid => @compileError("Invalid pixel format"),
        .indexed1 => image.pixels.indexed1.indices[index],
        .indexed2 => image.pixels.indexed2.indices[index],
        .indexed4 => image.pixels.indexed4.indices[index],
        .indexed8 => image.pixels.indexed8.indices[index],
        .indexed16 => image.pixels.indexed16.indices[index],
        .grayscale1 => image.pixels.grayscale1[index],
        .grayscale2 => image.pixels.grayscale2[index],
        .grayscale4 => image.pixels.grayscale4[index],
        .grayscale8 => image.pixels.grayscale8[index],
        .grayscale16 => image.pixels.grayscale16[index],
        .grayscale8Alpha => image.pixels.grayscale8Alpha[index],
        .grayscale16Alpha => image.pixels.grayscale16Alpha[index],
        .rgb555 => image.pixels.rgb555[index],
        .rgb565 => image.pixels.rgb565[index],
        .rgb24 => image.pixels.rgb24[index],
        .rgba32 => image.pixels.rgba32[index],
        .bgr555 => image.pixels.bgr555[index],
        .bgr24 => image.pixels.bgr24[index],
        .bgra32 => image.pixels.bgra32[index],
        .rgb48 => image.pixels.rgb48[index],
        .rgba64 => image.pixels.rgba64[index],
        .float32 => image.pixels.float32[index],
    };
}