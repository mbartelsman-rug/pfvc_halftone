const std = @import("std");
const Allocator = @import("std").mem.Allocator;
const float = @import("cast.zig").float;
const uint = @import("cast.zig").uint;
const int = @import("cast.zig").int;


/// 8-bit grayscale image struct
pub const Gray8Image = struct {
    const Self = @This();

    pixels: []f32,
    width: usize,
    height: usize,
    allocator: Allocator,

    /// Initialize a new Gray8Image to 0 values.
    /// `deinit()` must be called to avoid leaking memory.
    pub fn init(allocator: Allocator, width: usize, height: usize) !Self {
        const pixels = try allocator.alloc(f32, width * height);
        @memset(pixels, 0);

        return Gray8Image {
            .pixels = pixels,
            .width = width,
            .height = height,
            .allocator = allocator,
        };
    }

    /// Initialize a new Gray8Image by copying a byte buffer.
    /// `deinit()` must be called to avoid leaking memory.
    pub fn fromBytes(allocator: Allocator, width: usize, height: usize, bytes: []const u8) !Self {
        std.debug.assert(bytes.len == width * height);

        const pixels = try allocator.alloc(f32, bytes.len);
        for (0..bytes.len) |i| {
            pixels[i] = float(32, bytes[i]) / 255.0;
        }

        const image = Gray8Image {
            .pixels = pixels,
            .width = width,
            .height = height,
            .allocator = allocator,
        };

        return image;
    }

    /// Initialize a new Gray8Image by copying a byte buffer.
    /// `deinit()` must be called to avoid leaking memory.
    pub fn toBytes(self: *Self) ![]const u8 {
        const pixels = try self.allocator.alloc(u8, self.pixels.len);
        for (0..self.pixels.len) |i| {
            pixels[i] = uint(8, std.math.clamp(self.pixels[i] * 255.0, 0.0, 255.0));
        }

        return pixels;
    }

    /// Frees the allocated memory for this image.
    pub fn deinit(self: *Self) void {
        self.allocator.free(self.pixels);
        self.pixels = undefined;
        self.width = 0;
        self.height = 0;
    }
    
    /// Returns the pixel at the specified location
    pub fn get(self: Self, x: usize, y: usize) f32 {
        std.debug.assert(x < self.width);
        std.debug.assert(y < self.height);
        
        return self.pixels[y * self.width + x];
    }

    /// Sets the pixel at the specified location
    pub fn set(self: *Self, x: usize, y: usize, value: f32) void {
        std.debug.assert(x < self.width);
        std.debug.assert(y < self.height);
        
        self.pixels[y * self.width + x] = value;
    }
};


/// Image struct for quantization errors in the range [-256, 255]
pub const ErrorImage = struct {
    const Self = @This();

    pixels: []i9,
    width: usize,
    height: usize,
    allocator: Allocator,

    /// Initialize a new ErrorImage to 0 values.
    /// `deinit()` must be called to avoid leaking memory.
    pub fn init(allocator: Allocator, width: usize, height: usize) !Self {
        const pixels = try allocator.alloc(i9, width * height);
        @memset(pixels, 0);

        return ErrorImage {
            .pixels = pixels,
            .width = width,
            .height = height,
            .allocator = allocator,
        };
    }

    /// Frees the allocated memory for this image.
    pub fn deinit(self: *Self) void {
        self.allocator.free(self.pixels);
        self.pixels = undefined;
        self.width = 0;
        self.height = 0;
    }
    
    /// Returns the pixel at the specified location
    pub fn get(self: Self, x: usize, y: usize) i9 {
        std.debug.assert(x < self.width);
        std.debug.assert(y < self.height);
        
        return self.pixels[y * self.width + x];
    }

    /// Sets the pixel at the specified location
    pub fn set(self: *Self, x: usize, y: usize, value: i9) void {
        std.debug.assert(x < self.width);
        std.debug.assert(y < self.height);
        
        self.pixels[y * self.width + x] = value;
    }
};