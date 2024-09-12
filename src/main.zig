const std = @import("std");
const rl = @import("raylib");
const colors = @import("colors.zig");

pub fn main() anyerror!void {
    var allocator = std.heap.GeneralPurposeAllocator(.{}){};
    var argsIterator = try std.process.ArgIterator.initWithAllocator(allocator.allocator());
    defer argsIterator.deinit();

    // Skip executable
    _ = argsIterator.skip();

    var input: [:0]const u8 = "";
    var output: [:0]const u8 = "";

    // Handle cases accordingly
    while (argsIterator.next()) |arg| {

        // Input
        if (std.mem.eql(u8, arg, "-i") or std.mem.eql(u8, arg, "--input")) {
            input = argsIterator.next() orelse return error.ExpectedArgument;
        }

        // Output
        if (std.mem.eql(u8, arg, "-o") or std.mem.eql(u8, arg, "--output")) {
            output = argsIterator.next() orelse return error.ExpectedArgument;
        }
    }

    // Initialization
    //--------------------------------------------------------------------------------------
    var image = rl.loadImage(input);
    defer rl.unloadImage(image);

    if (image.height <= 0 or image.width <= 0)
        return error.InvalidImage;

    const screenWidth: i32 = @intCast(image.width);
    const screenHeight: i32 = @intCast(image.height);

    rl.initWindow(screenWidth, screenHeight, "Halftone");
    defer rl.closeWindow();

    const data = try rl.loadImageColors(image);
    for (0..@intCast(image.width)) |i| {
        for (0..@intCast(image.height)) |j| {
            const color = data[@as(usize, @intCast(image.width)) * j + i];
            const rgb = colors.Rgb{ .r = color.r, .g = color.g, .b = color.b };
            // const luv = rgb.to_xyz().to_luv();
            // const luv_2 = colors.Luv{ .l = luv.l, .u = luv.u, .v = luv.v };
            const rgb_2 = rgb.to_xyz().to_luv().to_xyz().to_rgb();

            rl.imageDrawPixel(&image, @intCast(i), @intCast(j), rl.Color{ .r = rgb_2.r, .g = rgb_2.g, .b = rgb_2.b, .a = 255 });
        }
    }

    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    const texture = rl.loadTextureFromImage(image);
    defer rl.unloadTexture(texture);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        rl.drawTexture(texture, 0, 0, rl.Color.white);

        rl.drawText("Congrats! You created your first window!", 190, 200, 20, rl.Color.light_gray);
        rl.drawText(input, 190, 230, 14, rl.Color.light_gray);
        rl.drawText(output, 190, 250, 14, rl.Color.light_gray);
        //----------------------------------------------------------------------------------
    }
}
