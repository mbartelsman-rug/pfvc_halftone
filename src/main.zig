const std = @import("std");
const rl = @import("raylib");

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
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

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

        rl.drawText("Congrats! You created your first window!", 190, 200, 20, rl.Color.light_gray);
        rl.drawText(input, 190, 230, 14, rl.Color.light_gray);
        rl.drawText(output, 190, 250, 14, rl.Color.light_gray);
        //----------------------------------------------------------------------------------
    }
}
