const std = @import("std");
const Allocator = std.mem.Allocator;

const zigimg = @import("zigimg");
const Image = @import("zigimg").Image;
const PixelFormat = @import("zigimg").PixelFormat;

const Cast = @import("cast.zig");
const uint = Cast.uint;

pub fn toLinearGrayscale(alloc: std.mem.Allocator, colorImage: Image, gamma: f32) !Image {
    var grayImage = try Image.create(alloc, colorImage.width, colorImage.height, PixelFormat.grayscale8);

    var i: usize = 0;
    var color_it = colorImage.iterator();
    while (color_it.next()) |color| {
        const r_lin = if (color.r <= 0.03928) color.r / 12.92 else std.math.pow(f32, (color.r + 0.055) / 1.055, 2.4);
        const g_lin = if (color.g <= 0.03928) color.g / 12.92 else std.math.pow(f32, (color.g + 0.055) / 1.055, 2.4);
        const b_lin = if (color.b <= 0.03928) color.b / 12.92 else std.math.pow(f32, (color.b + 0.055) / 1.055, 2.4);
        const l_lin = 0.2126 * r_lin + 0.7152 * g_lin + 0.0722 * b_lin;
        const l_gamma = std.math.pow(f32, l_lin, 1.0 / gamma);

        grayImage.pixels.grayscale8[i].value = uint(8, std.math.clamp(l_gamma, 0.0, 1.0) * 255.0);

        i += 1;
    }

    return grayImage;
}