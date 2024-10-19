const coeffWeight = 1.0;

const coeffValues = [128][3]f32 {
    [3]f32 { 1444444, 0, 555555 },   
    [3]f32 { 1445123, 0, 554876 },   
    [3]f32 { 1364835, 1829, 633335 },
    [3]f32 { 1275251, 0, 724748 },
    [3]f32 { 1239997, 0, 760002 },
    [3]f32 { 1213139, 75967, 710893 },
    [3]f32 { 1186281, 151934, 661783 },
    [3]f32 { 1159422, 227902, 612674 },
    [3]f32 { 1132564, 303869, 563565 },
    [3]f32 { 1105706, 379837, 514456 },
    [3]f32 { 1078847, 455804, 465347 },
    [3]f32 { 1066632, 471016, 462350 },
    [3]f32 { 1054418, 486228, 459353 },
    [3]f32 { 1042203, 501439, 456356 },
    [3]f32 { 1029988, 516651, 453359 },
    [3]f32 { 1017773, 531863, 450362 },
    [3]f32 { 1005558, 547075, 447365 },
    [3]f32 { 993343, 562287, 444369 },
    [3]f32 { 981128, 577499, 441372 },
    [3]f32 { 968913, 592710, 438375 },
    [3]f32 { 956699, 607922, 435378 },
    [3]f32 { 944484, 623134, 432381 },
    [3]f32 { 932269, 638346, 429384 },
    [3]f32 { 934007, 635746, 430246 },
    [3]f32 { 935745, 633146, 431108 },
    [3]f32 { 937483, 630546, 431970 },
    [3]f32 { 939221, 627946, 432832 },
    [3]f32 { 940959, 625346, 433694 },
    [3]f32 { 942697, 622746, 434556 },
    [3]f32 { 944435, 620146, 435418 },
    [3]f32 { 946173, 617546, 436280 },
    [3]f32 { 947911, 614946, 437142 },
    [3]f32 { 949649, 612346, 438004 },
    [3]f32 { 942232, 631548, 426218 },
    [3]f32 { 934815, 650751, 414433 },
    [3]f32 { 927398, 669954, 402647 },
    [3]f32 { 919980, 689157, 390861 },
    [3]f32 { 912563, 708360, 379076 },
    [3]f32 { 905146, 727563, 367290 },
    [3]f32 { 897729, 746765, 355504 },
    [3]f32 { 890312, 765968, 343719 },
    [3]f32 { 882895, 785171, 331933 },
    [3]f32 { 875477, 804374, 320147 },
    [3]f32 { 868060, 823577, 308362 },
    [3]f32 { 860643, 842780, 296576 },
    [3]f32 { 854022, 843860, 302116 },
    [3]f32 { 847401, 844940, 307657 },
    [3]f32 { 840781, 846021, 313197 },
    [3]f32 { 834160, 847101, 318737 },
    [3]f32 { 827539, 848182, 324278 },
    [3]f32 { 820918, 849262, 329818 },
    [3]f32 { 814297, 850343, 335359 },
    [3]f32 { 807677, 851423, 340899 },
    [3]f32 { 801056, 852503, 346439 },
    [3]f32 { 794435, 853584, 351980 },
    [3]f32 { 787814, 854664, 357520 },
    [3]f32 { 781193, 855745, 363060 },
    [3]f32 { 774572, 856825, 368601 },
    [3]f32 { 767952, 857906, 374141 },
    [3]f32 { 761331, 858986, 379682 },
    [3]f32 { 754710, 860066, 385222 },
    [3]f32 { 748089, 861147, 390762 },
    [3]f32 { 741468, 862227, 396303 },
    [3]f32 { 734848, 863308, 401843 },
    [3]f32 { 728227, 864388, 407384 },
    [3]f32 { 733393, 890950, 375656 },
    [3]f32 { 738559, 917511, 343928 },
    [3]f32 { 743725, 944073, 312201 },
    [3]f32 { 748891, 970635, 280473 },
    [3]f32 { 754057, 997196, 248745 },
    [3]f32 { 759223, 1023758, 217018 },
    [3]f32 { 764389, 1050319, 185290 },
    [3]f32 { 769555, 1076881, 153563 },
    [3]f32 { 777659, 1067697, 154643 },
    [3]f32 { 785763, 1058513, 155723 },
    [3]f32 { 793867, 1049328, 156803 },
    [3]f32 { 801972, 1040144, 157883 },
    [3]f32 { 810076, 1030960, 158963 },
    [3]f32 { 798480, 987361, 214158 },
    [3]f32 { 786883, 943762, 269353 },
    [3]f32 { 775287, 900162, 324549 },
    [3]f32 { 763691, 856563, 379744 },
    [3]f32 { 752095, 812964, 434939 },
    [3]f32 { 740499, 769365, 490135 },
    [3]f32 { 728903, 725766, 545330 },
    [3]f32 { 717307, 682166, 600526 },
    [3]f32 { 713811, 687748, 598439 },
    [3]f32 { 710315, 693330, 596353 },
    [3]f32 { 706819, 698912, 594267 },
    [3]f32 { 703323, 704495, 592181 },
    [3]f32 { 699826, 710077, 590095 },
    [3]f32 { 696330, 715659, 588009 },
    [3]f32 { 692834, 721241, 585923 },
    [3]f32 { 689338, 726823, 583837 },
    [3]f32 { 685842, 732405, 581751 },
    [3]f32 { 682346, 737987, 579665 },
    [3]f32 { 686196, 732702, 581100 },
    [3]f32 { 690046, 727417, 582536 },
    [3]f32 { 693895, 722133, 583971 },
    [3]f32 { 697745, 716848, 585406 },
    [3]f32 { 701594, 711563, 586841 },
    [3]f32 { 705444, 706278, 588276 },
    [3]f32 { 709294, 700994, 589711 },
    [3]f32 { 699253, 711278, 589467 },
    [3]f32 { 689213, 721562, 589223 },
    [3]f32 { 679173, 731846, 588979 },
    [3]f32 { 669133, 742130, 588735 },
    [3]f32 { 659093, 752415, 588491 },
    [3]f32 { 660715, 753749, 585534 },
    [3]f32 { 662338, 755084, 582577 },
    [3]f32 { 663961, 756418, 579620 },
    [3]f32 { 665583, 757753, 576662 },
    [3]f32 { 667206, 759087, 573705 },
    [3]f32 { 669752, 756570, 573677 },
    [3]f32 { 672297, 754052, 573649 },
    [3]f32 { 674842, 751535, 573621 },
    [3]f32 { 677388, 749018, 573593 },
    [3]f32 { 679933, 746500, 573565 },
    [3]f32 { 682478, 743983, 573537 },
    [3]f32 { 685024, 741466, 573509 },
    [3]f32 { 687569, 738948, 573481 },
    [3]f32 { 690114, 736431, 573453 },
    [3]f32 { 692660, 733914, 573425 },
    [3]f32 { 695205, 731396, 573397 },
    [3]f32 { 697750, 728879, 573369 },
    [3]f32 { 700296, 726361, 573341 },
    [3]f32 { 702841, 723844, 573313 },
    [3]f32 { 705387, 721327, 573285 },
};

const modulationStrength = [9]f32 { 0.00, 0.34, 0.50, 1.00, 0.17, 0.50, 0.70, 0.79, 1.00, };
const modulationLevels = [9]f32 {
    0.0 / 255.0,
    44.0 / 255.0,
    64.0 / 255.0,
    85.0 / 255.0,
    95.0 / 255.0,
    102.0 / 255.0,
    107.0 / 255.0,
    112.0 / 255.0,
    127.5 / 255.0,
};

const xOffsets = [3]isize { -1, 0, 1 };
const yOffsets = [3]isize { 1, 1, 0 };

fn modulation(value: f32) f32 {
    const adjustedValue = if (value <= 0.5) value else 1.0 - value;

    var index: usize = 0;
    while (modulationLevels[index] < adjustedValue) { index += 1; }

    if (modulationLevels[index] == adjustedValue) {
        return modulationStrength[index];
    }
    else {
        const start = modulationLevels[index - 1];
        const end = modulationLevels[index];
        const current = adjustedValue;
        const fraction = (current - start) / (end - start);
        
        return std.math.lerp(
            modulationStrength[index - 1],
            modulationStrength[index],
            fraction);
    }
}

pub fn quantize(image: GrayImage, x: usize, y: usize, value: f32, tHolder: *const generic.ThresholderFn) f32 {
    var rng = std.rand.DefaultPrng.init(@shlWithOverflow(x, 16)[0] + y);
    const random = float(32, rng.next()) / float(32, std.math.maxInt(u64));
    const modulator = modulation(std.math.clamp(value, 0.0, 1.0));
    const modulatedThreshold = tHolder(image, x, y, value) + random * modulator;
    return if (value < modulatedThreshold) 0.0 else 1.0;
}

pub fn diffuse (
    _: GrayImage, 
    quantized: GrayImage, 
    residuals: *GrayImage, 
    direction: generic.PathDirection,
    x: usize, 
    y: usize, 
    residual: f32) void 
{
    const value = (quantized.get(x, y) + residual) * 255.0;
    const coeffIndex = if (value <= 127.5) value else 255.0 - value;
    const coeffs = coeffValues[uint(0, std.math.clamp(coeffIndex, 0, 255.0))];

    var coeffDivisor: f32 = 0;
    for (coeffs) |coeff| {
        coeffDivisor += coeff;
    }
    coeffDivisor /= coeffWeight;

    for (xOffsets, yOffsets, 0..) |iOffset, jOffset, index| {
        const i = switch (direction) {
            .left => int(0, x) - iOffset,
            .right => int(0, x) + iOffset,
        };
        const j = int(0, y) + jOffset;

        if (i < 0 or quantized.width - 1 < i) { continue; }
        if (j < 0 or quantized.height - 1 < j) { continue; }

        const oldResidual = residuals.get(uint(0, i), uint(0, j));
        const currResidual = residual * coeffs[index] / coeffDivisor;
        residuals.set(uint(0, i), uint(0, j), oldResidual + currResidual);
    }
}

pub fn errorDiffusion(allocator: Allocator, original: Image, thresholder: *const generic.ThresholderFn) anyerror!struct { Image, Image } {
    return generic.errorDiffusion(allocator, original, .{ .quantize = quantize, .diffuse = diffuse, .thresholder = thresholder, .path = .scanline });
}


// Imports

const std = @import("std");
const math = std.math;
const Allocator = std.mem.Allocator;

const Image = @import("zigimg").Image;
const PixelFormat = @import("zigimg").PixelFormat;

const int = @import("../cast.zig").int;
const uint = @import("../cast.zig").uint;
const float = @import("../cast.zig").float;

const GrayImage = @import("../images.zig").GrayImage;
const ErrorImage = @import("../images.zig").ErrorImage;

const generic = @import("generic.zig");