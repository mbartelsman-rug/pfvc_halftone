const math = @import("std").math;
const fmt = @import("std").fmt;

/// RGB color, represented by unsigned integers in the range [0, 256)
const Rgb = struct {
    
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

            return Rgb { .r = r, .g = g, .b = b };
        }
        if (hex.len == 4) {
            const r = try fmt.parseInt(u8, .{ hex[1], hex[1] }, 16);
            const g = try fmt.parseInt(u8, .{ hex[2], hex[2] }, 16);
            const b = try fmt.parseInt(u8, .{ hex[3], hex[3] }, 16);

            return Rgb { .r = r , .g = g , .b = b  };
        }
    }

    /// Convert to CIE XYZ
    pub fn to_xyz(self: @This()) Xyz {
        return rgb_to_xyz(self);
    }
};

/// CIE XYZ color, represented by floats with valid values in the range of [0,1]
const Xyz = struct {
    
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
const Luv = struct {

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
const Hcl = struct {

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
    const nR = @as(f32, rgb.r) * 0.003921569; // / 255.0
    const nG = @as(f32, rgb.g) * 0.003921569;
    const nB = @as(f32, rgb.b) * 0.003921569;

    const nX = @min(1.0, 0.412453 * nR + 0.35758  * nG + 0.180423 * nB);
    const nY = @min(1.0, 0.212671 * nR + 0.71516  * nG + 0.072169 * nB);
    const nZ = @min(1.0, 0.019334 * nR + 0.119193 * nG + 0.950227 * nB);

    return Xyz { .x = nX, .y = nY, .z = nZ };
}

pub fn xyz_to_rgb(xyz: Xyz) Rgb {
    // Adapted from https://docs.nvidia.com/cuda/archive/9.2/npp/group__xyztorgb.html

    // Convert to RGB
    const nR = @min(1.0,  3.240479 * xyz.x - 1.537150 * xyz.y - 0.498535 * xyz.z);
    const nG = @min(1.0, -0.969256 * xyz.x + 1.875991 * xyz.y + 0.041556 * xyz.z);
    const nB = @min(1.0,  0.055648 * xyz.x - 0.204043 * xyz.y + 1.057311 * xyz.z);

    const r = @as(u8, nR * 255);
    const g = @as(u8, nG * 255);
    const b = @as(u8, nB * 255);

    return Rgb { .r = r, .g = g, .b = b };
}

pub fn xyz_to_luv(xyz: Xyz) Luv {
    // Adapted from https://docs.nvidia.com/cuda/archive/9.2/npp/group__rgbtoluv.html
    
    // CIE D65 chromaticity coordinates
    const nCIE_XYZ_D65_xn = 0.312713;
    const nCIE_XYZ_D65_yn = 0.329016;
    const nn_DIVISOR = (-2.0 * nCIE_XYZ_D65_xn + 12.0 * nCIE_XYZ_D65_yn + 3.0);
    const nun = (4.0 * nCIE_XYZ_D65_xn / nn_DIVISOR);
    const nvn = (9.0 * nCIE_XYZ_D65_yn / nn_DIVISOR);

    // Convert to LUV
    const nTemp = xyz.x + 15.0 * xyz.y + 3.0 * xyz.z;
    const nu = 4.0 * xyz.x / nTemp;
    const nv = 9.0 * xyz.y / nTemp;
    const nL = math.clamp(116.0 * math.pow(xyz.y, 3.0) - 16.0, 0.0, 100.0);

    nTemp = 13.0 * nL;
    const nU = math.clamp(nTemp * (nu - nun), -134.0, 220.0);
    const nV = math.clamp(nTemp * (nv - nvn), -140.0, 122.0);
    
    return Luv { .l = nL, .u = nU, .v = nV };
}

pub fn luv_to_xyz(luv: Luv) Xyz {
    // Adapted from https://docs.nvidia.com/cuda/archive/9.2/npp/group__luvtorgb.html
    
    const nCIE_XYZ_D65_xn = 0.312713;
    const nCIE_XYZ_D65_yn = 0.329016;
    const nn_DIVISOR = (-2.0 * nCIE_XYZ_D65_xn + 12.0 * nCIE_XYZ_D65_yn + 3.0);
    const nun = (4.0 * nCIE_XYZ_D65_xn / nn_DIVISOR);
    const nvn = (9.0 * nCIE_XYZ_D65_yn / nn_DIVISOR);

    // Now convert LUV to CIE XYZ
    const nTemp = 13.0 * luv.l;
    const nu = luv.u / nTemp + nun;
    const nv = luv.v / nTemp + nvn;

    const nY = if (luv.l > 7.9996248) math.powi((luv.l + 16.0) * 0.008621, 3) else luv.l * 0.001107;
    const nX = (-9.0 * nY * nu) / ((nu - 4.0) * nv - nu * nv);
    const nZ = (9.0 * nY - 15.0 * nv * nY - nv * nX) / (3.0 * nv);

    return Xyz { .x = nX, .y = nY, .z = nZ };
}

pub fn luv_to_hcl(luv: Luv) Hcl {
    // Adapted from https://observablehq.com/@mbostock/luv-and-hcl

    // To polar form
    const h = math.radiansToDegrees(math.atan2(luv.v, luv.u)) % 360.0;
    const c = math.hypot(luv.u, luv.v);
    const l = luv.l;

    return Hcl { .h = h, .c = c, .l = l };
}

pub fn hcl_to_luv(hcl: Hcl) Luv {
    // Adapted from https://observablehq.com/@mbostock/luv-and-hcl

    // To cartesian form
    const h = math.degreesToRadians(hcl.h);

    const l = hcl.l;
    const u = hcl.c * math.cos(h);
    const v = hcl.c * math.sin(h);

    return Luv { .l = l, .u = u, .v = v };
}


const testing = @import("std").testing;

test "hcl to luv roundtrip" {
    const start = Hcl { .h = 271, .c = 101, .l = 85.5 };
    const result = start.to_luv().to_hcl();

    try testing.expectApproxEqAbs(start.h, result.h, 1.0);
    try testing.expectApproxEqAbs(start.c, result.c, 1.0);
    try testing.expectApproxEqAbs(start.l, result.l, 1.0);
}

test "rgb to xyz roundtrip" {
    const start = Rgb { .r = 123, .g = 45, .b = 56 };
    const result = start.to_xyz().to_rgb();

    try testing.expectApproxEqAbs(start.r, result.r, 5);
    try testing.expectApproxEqAbs(start.g, result.g, 5);
    try testing.expectApproxEqAbs(start.b, result.b, 5);
}

test "luv to xyz roundtrip" {
    const start = Luv { .l = 12.5, .u = -32, .v = 98.1 };
    const result = start.to_xyz().to_luv();

    try testing.expectApproxEqAbs(start.l, result.l, 1.0);
    try testing.expectApproxEqAbs(start.u, result.u, 1.0);
    try testing.expectApproxEqAbs(start.v, result.v, 1.0);
}
