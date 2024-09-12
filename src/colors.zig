const math = @import("std").math;
const fmt = @import("std").fmt;

/// RGB color, represented by unsigned integers in the range [0, 256)
pub const Rgb = struct {
    /// Red component, from 0 to <256
    r: u8,

    /// Green component, from 0 to <256
    g: u8,

    /// Blue component, from 0 to <256
    b: u8,

    /// Parses an RGB color from a valid CSS hex code
    pub fn parse_hex(hex: []u8) !Rgb {
        if (hex[0] != '#') return error.ParseHexCodeError;

        if (hex.len == 7) {
            const r = try fmt.parseInt(u8, hex[1..3], 16);
            const g = try fmt.parseInt(u8, hex[3..5], 16);
            const b = try fmt.parseInt(u8, hex[5..7], 16);

            return Rgb{ .r = r, .g = g, .b = b };
        }
        if (hex.len == 4) {
            const r = try fmt.parseInt(u8, .{ hex[1], hex[1] }, 16);
            const g = try fmt.parseInt(u8, .{ hex[2], hex[2] }, 16);
            const b = try fmt.parseInt(u8, .{ hex[3], hex[3] }, 16);

            return Rgb{ .r = r, .g = g, .b = b };
        }
    }

    /// Convert to CIE XYZ
    pub fn to_xyz(self: @This()) Xyz {
        return rgb_to_xyz(self);
    }
};

/// CIE XYZ color, represented by floats with valid values in the range of [0,1]
pub const Xyz = struct {
    /// X component, from 0.0 to 1.0
    x: f32,

    /// Y component, from 0.0 to 1.0
    y: f32,

    /// Z component, from 0.0 to 1.0
    z: f32,

    /// Convert to RGB
    pub fn to_rgb(self: @This()) Rgb {
        return xyz_to_rgb(self);
    }

    /// Convert to CIE LUV
    pub fn to_luv(self: @This()) Luv {
        return xyz_to_luv(self);
    }

    /// Convert to HCL
    pub fn to_hcl(self: @This()) Hcl {
        return luv_to_hcl(xyz_to_luv(self));
    }
};

/// CIE LUV color, represdented by floats.
pub const Luv = struct {
    /// Luminance, from 0.0 to 100.0
    l: f32,

    /// U component, from -134.0 to 220.0
    u: f32,

    /// V component, from -140.0 to 122.0
    v: f32,

    /// Convert to CIE XYZ
    pub fn to_xyz(self: @This()) Xyz {
        return luv_to_xyz(self);
    }

    /// Convert to HCL (CIE LUV polar form)
    pub fn to_hcl(self: @This()) Hcl {
        return luv_to_hcl(self);
    }
};

/// HCL color (CIE LUV polar form), represented by three floats.
pub const Hcl = struct {
    /// Hue, from 0.0 to <360.0
    h: f32,

    /// Chroma, from 0.0 to 180.0
    c: f32,

    /// Luminance, from 0.0 to 100.0
    l: f32,

    /// Convert to CIE XYZ
    pub fn to_xyz(self: @This()) Xyz {
        return hcl_to_luv(luv_to_xyz(self));
    }

    /// Convert to CIE LUV
    pub fn to_luv(self: @This()) Luv {
        return hcl_to_luv(self);
    }
};

pub fn rgb_to_xyz(rgb: Rgb) Xyz {
    // Adapted from https://docs.nvidia.com/cuda/archive/9.2/npp/group__rgbtoxyz.html

    // Convert to XYZ
    const nR = @as(f32, @floatFromInt(rgb.r)) * 0.003921569; // / 255.0
    const nG = @as(f32, @floatFromInt(rgb.g)) * 0.003921569;
    const nB = @as(f32, @floatFromInt(rgb.b)) * 0.003921569;

    const nX = @min(1.0, 0.412453 * nR + 0.35758 * nG + 0.180423 * nB);
    const nY = @min(1.0, 0.212671 * nR + 0.71516 * nG + 0.072169 * nB);
    const nZ = @min(1.0, 0.019334 * nR + 0.119193 * nG + 0.950227 * nB);

    return Xyz{ .x = nX, .y = nY, .z = nZ };
}

pub fn xyz_to_rgb(xyz: Xyz) Rgb {
    // Adapted from https://docs.nvidia.com/cuda/archive/9.2/npp/group__xyztorgb.html

    // Convert to RGB
    const nR = math.clamp(3.240479 * xyz.x - 1.537150 * xyz.y - 0.498535 * xyz.z, 0.0, 1.0);
    const nG = math.clamp(-0.969256 * xyz.x + 1.875991 * xyz.y + 0.041556 * xyz.z, 0.0, 1.0);
    const nB = math.clamp(0.055648 * xyz.x - 0.204043 * xyz.y + 1.057311 * xyz.z, 0.0, 1.0);

    const r = @as(u8, @intFromFloat(nR * 255));
    const g = @as(u8, @intFromFloat(nG * 255));
    const b = @as(u8, @intFromFloat(nB * 255));

    return Rgb{ .r = r, .g = g, .b = b };
}

pub fn xyz_to_luv(xyz: Xyz) Luv {
    // Adapted from http://www.brucelindbloom.com/index.html?Eqn_XYZ_to_Luv.html

    const x_r = 95.047;
    const y_r = 100.0;
    const z_r = 108.883;
    const k = 24389.0 / 27.0;
    const e = 216.0 / 24389.0;

    const y_ratio = xyz.y / y_r;

    const den = xyz.x + (15 * xyz.y) + (3 * xyz.z);
    const nu = (4 * xyz.x) / den;
    const nv = (9 * xyz.y) / den;

    const den_r = x_r + (15 * y_r) + (3 * z_r);
    const nu_r = (4 * x_r) / den_r;
    const nv_r = (9 * y_r) / den_r;

    const l = if (y_ratio > e) 116 * math.cbrt(@as(f32, y_r)) - 16 else k * y_ratio;
    const u = 13 * l * (nu - nu_r);
    const v = 13 * l * (nv - nv_r);

    return Luv{ .l = l, .u = u, .v = v };
}

pub fn luv_to_xyz(luv: Luv) Xyz {
    // Adapted from http://www.brucelindbloom.com/index.html

    const x_r = 95.047;
    const y_r = 100.0;
    const z_r = 108.883;
    const k = 24389.0 / 27.0;
    const e = 216.0 / 24389.0;

    const den_r = x_r + (15 * y_r) + (3 * z_r);
    const u_0 = 4 * x_r / den_r;
    const v_0 = 9 * y_r / den_r;

    const y = if (luv.l > k * e) math.pow(f32, (luv.l + 16) / 116, 3.0) else luv.l / k;

    const a = ((52 * luv.l / (luv.u + 13 * luv.l * u_0)) - 1.0) / 3.0;
    const b = -5.0 * y;
    const c = -1.0 / 3.0;
    const d = y * ((39 * luv.l / (luv.v + 13 * luv.l * v_0)) - 5.0);

    const x = (d - b) / (a - c);
    const z = x * a + b;

    return Xyz{ .x = x, .y = y, .z = z };
}

pub fn luv_to_hcl(luv: Luv) Hcl {
    // Adapted from https://observablehq.com/@mbostock/luv-and-hcl

    // To polar form
    const h = math.radiansToDegrees(math.atan2(luv.v, luv.u)) % 360.0;
    const c = math.hypot(luv.u, luv.v);
    const l = luv.l;

    return Hcl{ .h = h, .c = c, .l = l };
}

pub fn hcl_to_luv(hcl: Hcl) Luv {
    // Adapted from https://observablehq.com/@mbostock/luv-and-hcl

    // To cartesian form
    const h = math.degreesToRadians(hcl.h);

    const l = hcl.l;
    const u = hcl.c * math.cos(h);
    const v = hcl.c * math.sin(h);

    return Luv{ .l = l, .u = u, .v = v };
}

const testing = @import("std").testing;

test "hcl to luv roundtrip" {
    const start = Hcl{ .h = 271, .c = 101, .l = 85.5 };
    const result = start.to_luv().to_hcl();

    try testing.expectApproxEqAbs(start.h, result.h, 1.0);
    try testing.expectApproxEqAbs(start.c, result.c, 1.0);
    try testing.expectApproxEqAbs(start.l, result.l, 1.0);
}

test "rgb to xyz roundtrip" {
    const start = Rgb{ .r = 123, .g = 45, .b = 56 };
    const result = start.to_xyz().to_rgb();

    try testing.expectApproxEqAbs(start.r, result.r, 5);
    try testing.expectApproxEqAbs(start.g, result.g, 5);
    try testing.expectApproxEqAbs(start.b, result.b, 5);
}

test "luv to xyz roundtrip" {
    const start = Luv{ .l = 12.5, .u = -32, .v = 98.1 };
    const result = start.to_xyz().to_luv();

    try testing.expectApproxEqAbs(start.l, result.l, 1.0);
    try testing.expectApproxEqAbs(start.u, result.u, 1.0);
    try testing.expectApproxEqAbs(start.v, result.v, 1.0);
}
