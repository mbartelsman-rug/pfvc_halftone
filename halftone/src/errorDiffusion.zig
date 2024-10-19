pub const atkinson = @import("errorDiffusion/atkinson.zig").errorDiffusion;
pub const floydSteinberg = @import("errorDiffusion/floydSteinberg.zig").errorDiffusion;
pub const ostromoukhov = @import("errorDiffusion/ostromoukhov.zig").errorDiffusion;
pub const zhouFang = @import("errorDiffusion/zhouFang.zig").errorDiffusion;
pub const xiangyu = @import("errorDiffusion/xiangyu.zig").errorDiffusion;

pub const threshold = @import("errorDiffusion/thresholds.zig");

pub const ThresholderFn = generic.ThresholderFn;
pub const ErrorDiffuserFn = generic.ErrorDiffusionFn;


// Imports

const std = @import("std");
const math = std.math;
const Allocator = std.mem.Allocator;

const Image = @import("zigimg").Image;
pub const generic = @import("errorDiffusion/generic.zig");