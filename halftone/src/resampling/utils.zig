const zigimg = @import("zigimg");
const Image = @import("zigimg").Image;
const PixelFormat = @import("zigimg").PixelFormat;
const Colorf32 = @import("zigimg").color.Colorf32;

pub fn getColorF32(x: usize, y: usize, image: Image) Colorf32 {
    const index = y * image.width + x;

    return switch (image.pixels) {
            .invalid => Colorf32.initRgb(0.0, 0.0, 0.0),
            .indexed1 => |data| data.palette[data.indices[index]].toColorf32(),
            .indexed2 => |data| data.palette[data.indices[index]].toColorf32(),
            .indexed4 => |data| data.palette[data.indices[index]].toColorf32(),
            .indexed8 => |data| data.palette[data.indices[index]].toColorf32(),
            .indexed16 => |data| data.palette[data.indices[index]].toColorf32(),
            .grayscale1 => |data| data[index].toColorf32(),
            .grayscale2 => |data| data[index].toColorf32(),
            .grayscale4 => |data| data[index].toColorf32(),
            .grayscale8 => |data| data[index].toColorf32(),
            .grayscale8Alpha => |data| data[index].toColorf32(),
            .grayscale16 => |data| data[index].toColorf32(),
            .grayscale16Alpha => |data| data[index].toColorf32(),
            .rgb24 => |data| data[index].toColorf32(),
            .rgba32 => |data| data[index].toColorf32(),
            .rgb565 => |data| data[index].toColorf32(),
            .rgb555 => |data| data[index].toColorf32(),
            .bgr555 => |data| data[index].toColorf32(),
            .bgr24 => |data| data[index].toColorf32(),
            .bgra32 => |data| data[index].toColorf32(),
            .rgb48 => |data| data[index].toColorf32(),
            .rgba64 => |data| data[index].toColorf32(),
            .float32 => |data| data[index],
        };
}