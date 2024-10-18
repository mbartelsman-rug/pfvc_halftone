const std = @import("std");
const Type = std.builtin.Type;

fn Int(comptime size: u16) type {
    return switch (size) {
        0 => isize,
        else => @Type(Type{ .Int = .{ .signedness = std.builtin.Signedness.signed, .bits = size } }),
    };
}

fn Uint(comptime size: u16) type {
    return switch (size) {
        0 => usize,
        else => @Type(Type{ .Int = .{ .signedness = std.builtin.Signedness.unsigned, .bits = size } }),
    };
}

fn Float(comptime size: u16) type {
    return switch (size) {
        16 => f16,
        32 => f32,
        64 => f64,
        80 => f80,
        128 => f128,
        else => @compileError("Unsupported float size"),
    };
}

pub fn int(comptime size: u16, value: anytype) Int(size) {
    return switch (@typeInfo(@TypeOf(value))) {
        .ComptimeInt, .Int => @as(Int(size), @intCast(value)),
        .Bool => @as(Int(size), @intFromBool(value)),
        .ComptimeFloat, .Float => @as(Int(size), @intFromFloat(value)),
        .Enum => @as(Int(size), @intFromEnum(value)),
        .Pointer => @as(Int(size), @intFromPtr(value)),
        .ErrorUnion, .ErrorSet => @as(Int(size), @intFromError(value)),
        else => @compileError("Unsupported source type"),
    };
}

pub fn uint(comptime size: u16, value: anytype) Uint(size) {
    return switch (@typeInfo(@TypeOf(value))) {
        .ComptimeInt, .Int => @as(Uint(size), @intCast(value)),
        .Bool => @as(Uint(size), @intFromBool(value)),
        .ComptimeFloat, .Float => @as(Uint(size), @intFromFloat(value)),
        .Enum => @as(Uint(size), @intFromEnum(value)),
        .Pointer => @as(Uint(size), @intFromPtr(value)),
        .ErrorUnion, .ErrorSet => @as(Uint(size), @intFromError(value)),
        else => @compileError("Unsupported source type"),
    };
}

pub fn float(comptime size: u16, value: anytype) Float(size) {
    return switch (@typeInfo(@TypeOf(value))) {
        .ComptimeInt, .Int => @as(Float(size), @floatFromInt(value)),
        .ComptimeFloat, .Float => @as(Float(size), @floatCast(value)),
        else => @compileError("Unsupported source type"),
    };
}
