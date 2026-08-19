-- Decompiled with Potassium's decompiler.

local u10 = {
    toMilliliter = function(p1) -- Line: 54, Name: toMilliliter
        return p1 * 1000;
    end,

    toKiloliter = function(p2) -- Line: 57, Name: toKiloliter
        return p2 * 0.001;
    end,

    toCup = function(p3) -- Line: 60, Name: toCup
        return p3 * 4.16667;
    end,

    toPint = function(p4) -- Line: 63, Name: toPint
        return p4 * 2.11338;
    end,

    toQuart = function(p5) -- Line: 66, Name: toQuart
        return p5 * 1.05669;
    end,

    toGallon = function(p6) -- Line: 69, Name: toGallon
        return p6 * 0.264172;
    end,

    toCubicFeet = function(p7) -- Line: 72, Name: toCubicFeet
        return p7 * 0.0353147;
    end,

    toCubicInch = function(p8) -- Line: 75, Name: toCubicInch
        return p8 * 61.0237;
    end,

    toCubicMeter = function(p9) -- Line: 78, Name: toCubicMeter
        return p9 * 0.001;
    end
};
local u12 = {
    toLiter = function(p11) -- Line: 83, Name: toLiter
        return p11 / 1000;
    end
};

function u12.toKiloliter(p13) -- Line: 86
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toKiloliter(u12.toLiter(p13));
end;

function u12.toCup(p14) -- Line: 89
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toCup(u12.toLiter(p14));
end;

function u12.toPint(p15) -- Line: 92
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toPint(u12.toLiter(p15));
end;

function u12.toQuart(p16) -- Line: 95
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toQuart(u12.toLiter(p16));
end;

function u12.toGallon(p17) -- Line: 98
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toGallon(u12.toLiter(p17));
end;

function u12.toCubicFeet(p18) -- Line: 101
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toCubicFeet(u12.toLiter(p18));
end;

function u12.toCubicInch(p19) -- Line: 104
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toCubicInch(u12.toLiter(p19));
end;

function u12.toCubicMeter(p20) -- Line: 107
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toCubicMeter(u12.toLiter(p20));
end;

local u22 = {
    toLiter = function(p21) -- Line: 112, Name: toLiter
        return p21 / 0.001;
    end
};

function u22.toMilliliter(p23) -- Line: 115
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toMilliliter(u22.toLiter(p23));
end;

function u22.toCup(p24) -- Line: 118
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toCup(u22.toLiter(p24));
end;

function u22.toPint(p25) -- Line: 121
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toPint(u22.toLiter(p25));
end;

function u22.toQuart(p26) -- Line: 124
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toQuart(u22.toLiter(p26));
end;

function u22.toGallon(p27) -- Line: 127
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toGallon(u22.toLiter(p27));
end;

function u22.toCubicFeet(p28) -- Line: 130
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toCubicFeet(u22.toLiter(p28));
end;

function u22.toCubicInch(p29) -- Line: 133
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toCubicInch(u22.toLiter(p29));
end;

function u22.toCubicMeter(p30) -- Line: 136
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toCubicMeter(u22.toLiter(p30));
end;

local u32 = {
    toLiter = function(p31) -- Line: 141, Name: toLiter
        return p31 / 4.16667;
    end
};

function u32.toKiloliter(p33) -- Line: 144
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toKiloliter(u32.toLiter(p33));
end;

function u32.toMilliliter(p34) -- Line: 147
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toMilliliter(u32.toLiter(p34));
end;

function u32.toPint(p35) -- Line: 150
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toPint(u32.toLiter(p35));
end;

function u32.toQuart(p36) -- Line: 153
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toQuart(u32.toLiter(p36));
end;

function u32.toGallon(p37) -- Line: 156
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toGallon(u32.toLiter(p37));
end;

function u32.toCubicFeet(p38) -- Line: 159
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toCubicFeet(u32.toLiter(p38));
end;

function u32.toCubicInch(p39) -- Line: 162
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toCubicInch(u32.toLiter(p39));
end;

function u32.toCubicMeter(p40) -- Line: 165
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toCubicMeter(u32.toLiter(p40));
end;

local u42 = {
    toLiter = function(p41) -- Line: 170, Name: toLiter
        return p41 / 2.11338;
    end
};

function u42.toKiloliter(p43) -- Line: 173
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toKiloliter(u42.toLiter(p43));
end;

function u42.toCup(p44) -- Line: 176
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toCup(u42.toLiter(p44));
end;

function u42.toMilliliter(p45) -- Line: 179
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toMilliliter(u42.toLiter(p45));
end;

function u42.toQuart(p46) -- Line: 182
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toQuart(u42.toLiter(p46));
end;

function u42.toGallon(p47) -- Line: 185
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toGallon(u42.toLiter(p47));
end;

function u42.toCubicFeet(p48) -- Line: 188
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toCubicFeet(u42.toLiter(p48));
end;

function u42.toCubicInch(p49) -- Line: 191
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toCubicInch(u42.toLiter(p49));
end;

function u42.toCubicMeter(p50) -- Line: 194
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toCubicMeter(u42.toLiter(p50));
end;

local u52 = {
    toLiter = function(p51) -- Line: 199, Name: toLiter
        return p51 / 1.05669;
    end
};

function u52.toKiloliter(p53) -- Line: 202
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toKiloliter(u52.toLiter(p53));
end;

function u52.toCup(p54) -- Line: 205
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toCup(u52.toLiter(p54));
end;

function u52.toPint(p55) -- Line: 208
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toPint(u52.toLiter(p55));
end;

function u52.toMilliliter(p56) -- Line: 211
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toMilliliter(u52.toLiter(p56));
end;

function u52.toGallon(p57) -- Line: 214
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toGallon(u52.toLiter(p57));
end;

function u52.toCubicFeet(p58) -- Line: 217
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toCubicFeet(u52.toLiter(p58));
end;

function u52.toCubicInch(p59) -- Line: 220
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toCubicInch(u52.toLiter(p59));
end;

function u52.toCubicMeter(p60) -- Line: 223
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toCubicMeter(u52.toLiter(p60));
end;

local u62 = {
    toLiter = function(p61) -- Line: 228, Name: toLiter
        return p61 / 0.264172;
    end
};

function u62.toKiloliter(p63) -- Line: 231
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toKiloliter(u62.toLiter(p63));
end;

function u62.toCup(p64) -- Line: 234
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toCup(u62.toLiter(p64));
end;

function u62.toPint(p65) -- Line: 237
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toPint(u62.toLiter(p65));
end;

function u62.toQuart(p66) -- Line: 240
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toQuart(u62.toLiter(p66));
end;

function u62.toMilliliter(p67) -- Line: 243
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toMilliliter(u62.toLiter(p67));
end;

function u62.toCubicFeet(p68) -- Line: 246
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toCubicFeet(u62.toLiter(p68));
end;

function u62.toCubicInch(p69) -- Line: 249
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toCubicInch(u62.toLiter(p69));
end;

function u62.toCubicMeter(p70) -- Line: 252
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toCubicMeter(u62.toLiter(p70));
end;

local u72 = {
    toLiter = function(p71) -- Line: 257, Name: toLiter
        return p71 / 0.0353147;
    end
};

function u72.toKiloliter(p73) -- Line: 260
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toKiloliter(u72.toLiter(p73));
end;

function u72.toCup(p74) -- Line: 263
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toCup(u72.toLiter(p74));
end;

function u72.toPint(p75) -- Line: 266
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toPint(u72.toLiter(p75));
end;

function u72.toQuart(p76) -- Line: 269
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toQuart(u72.toLiter(p76));
end;

function u72.toGallon(p77) -- Line: 272
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toGallon(u72.toLiter(p77));
end;

function u72.toMilliliter(p78) -- Line: 275
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toMilliliter(u72.toLiter(p78));
end;

function u72.toCubicInch(p79) -- Line: 278
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toCubicInch(u72.toLiter(p79));
end;

function u72.toCubicMeter(p80) -- Line: 281
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toCubicMeter(u72.toLiter(p80));
end;

local u82 = {
    toLiter = function(p81) -- Line: 286, Name: toLiter
        return p81 / 1000;
    end
};

function u82.toKiloliter(p83) -- Line: 289
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toKiloliter(u82.toLiter(p83));
end;

function u82.toCup(p84) -- Line: 292
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toCup(u82.toLiter(p84));
end;

function u82.toPint(p85) -- Line: 295
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toPint(u82.toLiter(p85));
end;

function u82.toQuart(p86) -- Line: 298
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toQuart(u82.toLiter(p86));
end;

function u82.toGallon(p87) -- Line: 301
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toGallon(u82.toLiter(p87));
end;

function u82.toCubicFeet(p88) -- Line: 304
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toCubicFeet(u82.toLiter(p88));
end;

function u82.toMilliliter(p89) -- Line: 307
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toMilliliter(u82.toLiter(p89));
end;

function u82.toCubicMeter(p90) -- Line: 310
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toCubicMeter(u82.toLiter(p90));
end;

local u92 = {
    toLiter = function(p91) -- Line: 315, Name: toLiter
        return p91 / 0.001;
    end
};

function u92.toKiloliter(p93) -- Line: 318
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toKiloliter(u92.toLiter(p93));
end;

function u92.toCup(p94) -- Line: 321
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toCup(u92.toLiter(p94));
end;

function u92.toPint(p95) -- Line: 324
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toPint(u92.toLiter(p95));
end;

function u92.toQuart(p96) -- Line: 327
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toQuart(u92.toLiter(p96));
end;

function u92.toGallon(p97) -- Line: 330
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toGallon(u92.toLiter(p97));
end;

function u92.toCubicFeet(p98) -- Line: 333
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toCubicFeet(u92.toLiter(p98));
end;

function u92.toCubicInch(p99) -- Line: 336
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toCubicInch(u92.toLiter(p99));
end;

function u92.toMilliliter(p100) -- Line: 339
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toMilliliter(u92.toLiter(p100));
end;

return {
    Liter = u10,
    Milliliter = u12,
    Kiloliter = u22,
    Cup = u32,
    Pint = u42,
    Quart = u52,
    Gallon = u62,
    CubicFeet = u72,
    CubicInch = u82
};