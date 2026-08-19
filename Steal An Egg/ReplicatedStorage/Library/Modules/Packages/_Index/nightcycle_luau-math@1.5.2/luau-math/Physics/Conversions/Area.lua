-- Decompiled with Potassium's decompiler.

local u10 = {
    toSquareCentimeter = function(p1) -- Line: 54, Name: toSquareCentimeter
        return p1 * 10000;
    end,

    toSquareMillimeter = function(p2) -- Line: 57, Name: toSquareMillimeter
        return p2 * 1000000;
    end,

    toSquareKilometer = function(p3) -- Line: 60, Name: toSquareKilometer
        return p3 * 1e-6;
    end,

    toSquareMile = function(p4) -- Line: 63, Name: toSquareMile
        return p4 * 3.861e-7;
    end,

    toSquareYard = function(p5) -- Line: 66, Name: toSquareYard
        return p5 * 1.19599;
    end,

    toSquareFeet = function(p6) -- Line: 69, Name: toSquareFeet
        return p6 * 10.7639;
    end,

    toSquareInch = function(p7) -- Line: 72, Name: toSquareInch
        return p7 * 1550;
    end,

    toHectare = function(p8) -- Line: 75, Name: toHectare
        return p8 * 0.0001;
    end,

    toAcre = function(p9) -- Line: 78, Name: toAcre
        return p9 * 0.000247105;
    end
};
local u12 = {
    toSquareMeter = function(p11) -- Line: 83, Name: toSquareMeter
        return p11 / 10000;
    end
};

function u12.toSquareMillimeter(p13) -- Line: 86
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toSquareMillimeter(u12.toSquareMeter(p13));
end;

function u12.toSquareKilometer(p14) -- Line: 89
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toSquareKilometer(u12.toSquareMeter(p14));
end;

function u12.toSquareMile(p15) -- Line: 92
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toSquareMile(u12.toSquareMeter(p15));
end;

function u12.toSquareYard(p16) -- Line: 95
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toSquareYard(u12.toSquareMeter(p16));
end;

function u12.toSquareFeet(p17) -- Line: 98
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toSquareFeet(u12.toSquareMeter(p17));
end;

function u12.toSquareInch(p18) -- Line: 101
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toSquareInch(u12.toSquareMeter(p18));
end;

function u12.toHectare(p19) -- Line: 104
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toHectare(u12.toSquareMeter(p19));
end;

function u12.toAcre(p20) -- Line: 107
    -- upvalues: u10 (copy), u12 (copy)
    return u10.toAcre(u12.toSquareMeter(p20));
end;

local u22 = {
    toSquareMeter = function(p21) -- Line: 112, Name: toSquareMeter
        return p21 / 1000000;
    end
};

function u22.toSquareCentimeter(p23) -- Line: 115
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toSquareCentimeter(u22.toSquareMeter(p23));
end;

function u22.toSquareKilometer(p24) -- Line: 118
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toSquareKilometer(u22.toSquareMeter(p24));
end;

function u22.toSquareMile(p25) -- Line: 121
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toSquareMile(u22.toSquareMeter(p25));
end;

function u22.toSquareYard(p26) -- Line: 124
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toSquareYard(u22.toSquareMeter(p26));
end;

function u22.toSquareFeet(p27) -- Line: 127
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toSquareFeet(u22.toSquareMeter(p27));
end;

function u22.toSquareInch(p28) -- Line: 130
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toSquareInch(u22.toSquareMeter(p28));
end;

function u22.toHectare(p29) -- Line: 133
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toHectare(u22.toSquareMeter(p29));
end;

function u22.toAcre(p30) -- Line: 136
    -- upvalues: u10 (copy), u22 (copy)
    return u10.toAcre(u22.toSquareMeter(p30));
end;

local u32 = {
    toSquareMeter = function(p31) -- Line: 141, Name: toSquareMeter
        return p31 / 10.7639;
    end
};

function u32.toSquareMillimeter(p33) -- Line: 144
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toSquareMillimeter(u32.toSquareMeter(p33));
end;

function u32.toSquareKilometer(p34) -- Line: 147
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toSquareKilometer(u32.toSquareMeter(p34));
end;

function u32.toSquareMile(p35) -- Line: 150
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toSquareMile(u32.toSquareMeter(p35));
end;

function u32.toSquareYard(p36) -- Line: 153
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toSquareYard(u32.toSquareMeter(p36));
end;

function u32.toSquareCentimeter(p37) -- Line: 156
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toSquareCentimeter(u32.toSquareMeter(p37));
end;

function u32.toSquareInch(p38) -- Line: 159
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toSquareInch(u32.toSquareMeter(p38));
end;

function u32.toHectare(p39) -- Line: 162
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toHectare(u32.toSquareMeter(p39));
end;

function u32.toAcre(p40) -- Line: 165
    -- upvalues: u10 (copy), u32 (copy)
    return u10.toAcre(u32.toSquareMeter(p40));
end;

local u42 = {
    toSquareMeter = function(p41) -- Line: 170, Name: toSquareMeter
        return p41 / 1550;
    end
};

function u42.toSquareMillimeter(p43) -- Line: 173
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toSquareMillimeter(u42.toSquareMeter(p43));
end;

function u42.toSquareKilometer(p44) -- Line: 176
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toSquareKilometer(u42.toSquareMeter(p44));
end;

function u42.toSquareMile(p45) -- Line: 179
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toSquareMile(u42.toSquareMeter(p45));
end;

function u42.toSquareYard(p46) -- Line: 182
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toSquareYard(u42.toSquareMeter(p46));
end;

function u42.toSquareCentimeter(p47) -- Line: 185
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toSquareCentimeter(u42.toSquareMeter(p47));
end;

function u42.toSquareInch(p48) -- Line: 188
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toSquareInch(u42.toSquareMeter(p48));
end;

function u42.toHectare(p49) -- Line: 191
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toHectare(u42.toSquareMeter(p49));
end;

function u42.toAcre(p50) -- Line: 194
    -- upvalues: u10 (copy), u42 (copy)
    return u10.toAcre(u42.toSquareMeter(p50));
end;

local u52 = {
    toSquareMeter = function(p51) -- Line: 199, Name: toSquareMeter
        return p51 / 10000;
    end
};

function u52.toSquareMillimeter(p53) -- Line: 202
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toSquareMillimeter(u52.toSquareMeter(p53));
end;

function u52.toSquareKilometer(p54) -- Line: 205
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toSquareKilometer(u52.toSquareMeter(p54));
end;

function u52.toSquareMile(p55) -- Line: 208
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toSquareMile(u52.toSquareMeter(p55));
end;

function u52.toSquareCentimeter(p56) -- Line: 211
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toSquareCentimeter(u52.toSquareMeter(p56));
end;

function u52.toSquareFeet(p57) -- Line: 214
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toSquareFeet(u52.toSquareMeter(p57));
end;

function u52.toSquareInch(p58) -- Line: 217
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toSquareInch(u52.toSquareMeter(p58));
end;

function u52.toHectare(p59) -- Line: 220
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toHectare(u52.toSquareMeter(p59));
end;

function u52.toAcre(p60) -- Line: 223
    -- upvalues: u10 (copy), u52 (copy)
    return u10.toAcre(u52.toSquareMeter(p60));
end;

local u62 = {
    toSquareMeter = function(p61) -- Line: 228, Name: toSquareMeter
        return p61 / 1e-6;
    end
};

function u62.toSquareMillimeter(p63) -- Line: 231
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toSquareMillimeter(u62.toSquareMeter(p63));
end;

function u62.toSquareCentimeter(p64) -- Line: 234
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toSquareCentimeter(u62.toSquareMeter(p64));
end;

function u62.toSquareMile(p65) -- Line: 237
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toSquareMile(u62.toSquareMeter(p65));
end;

function u62.toSquareYard(p66) -- Line: 240
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toSquareYard(u62.toSquareMeter(p66));
end;

function u62.toSquareFeet(p67) -- Line: 243
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toSquareFeet(u62.toSquareMeter(p67));
end;

function u62.toSquareInch(p68) -- Line: 246
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toSquareInch(u62.toSquareMeter(p68));
end;

function u62.toHectare(p69) -- Line: 249
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toHectare(u62.toSquareMeter(p69));
end;

function u62.toAcre(p70) -- Line: 252
    -- upvalues: u10 (copy), u62 (copy)
    return u10.toAcre(u62.toSquareMeter(p70));
end;

local u72 = {
    toSquareMeter = function(p71) -- Line: 257, Name: toSquareMeter
        return p71 / 10000;
    end
};

function u72.toSquareMillimeter(p73) -- Line: 260
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toSquareMillimeter(u72.toSquareMeter(p73));
end;

function u72.toSquareKilometer(p74) -- Line: 263
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toSquareKilometer(u72.toSquareMeter(p74));
end;

function u72.toSquareCentimeter(p75) -- Line: 266
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toSquareCentimeter(u72.toSquareMeter(p75));
end;

function u72.toSquareYard(p76) -- Line: 269
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toSquareYard(u72.toSquareMeter(p76));
end;

function u72.toSquareFeet(p77) -- Line: 272
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toSquareFeet(u72.toSquareMeter(p77));
end;

function u72.toSquareInch(p78) -- Line: 275
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toSquareInch(u72.toSquareMeter(p78));
end;

function u72.toHectare(p79) -- Line: 278
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toHectare(u72.toSquareMeter(p79));
end;

function u72.toAcre(p80) -- Line: 281
    -- upvalues: u10 (copy), u72 (copy)
    return u10.toAcre(u72.toSquareMeter(p80));
end;

local u82 = {
    toSquareMeter = function(p81) -- Line: 286, Name: toSquareMeter
        return p81 / 0.000247105;
    end
};

function u82.toSquareMillimeter(p83) -- Line: 289
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toSquareMillimeter(u82.toSquareMeter(p83));
end;

function u82.toSquareKilometer(p84) -- Line: 292
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toSquareKilometer(u82.toSquareMeter(p84));
end;

function u82.toSquareMile(p85) -- Line: 295
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toSquareMile(u82.toSquareMeter(p85));
end;

function u82.toSquareYard(p86) -- Line: 298
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toSquareYard(u82.toSquareMeter(p86));
end;

function u82.toSquareFeet(p87) -- Line: 301
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toSquareFeet(u82.toSquareMeter(p87));
end;

function u82.toSquareInch(p88) -- Line: 304
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toSquareInch(u82.toSquareMeter(p88));
end;

function u82.toHectare(p89) -- Line: 307
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toHectare(u82.toSquareMeter(p89));
end;

function u82.toSquareCentimeter(p90) -- Line: 310
    -- upvalues: u10 (copy), u82 (copy)
    return u10.toAcre(u82.toSquareMeter(p90));
end;

local u92 = {
    toSquareMeter = function(p91) -- Line: 315, Name: toSquareMeter
        return p91 / 0.0001;
    end
};

function u92.toSquareMillimeter(p93) -- Line: 318
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toSquareMillimeter(u92.toSquareMeter(p93));
end;

function u92.toSquareKilometer(p94) -- Line: 321
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toSquareKilometer(u92.toSquareMeter(p94));
end;

function u92.toSquareMile(p95) -- Line: 324
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toSquareMile(u92.toSquareMeter(p95));
end;

function u92.toSquareYard(p96) -- Line: 327
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toSquareYard(u92.toSquareMeter(p96));
end;

function u92.toSquareFeet(p97) -- Line: 330
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toSquareFeet(u92.toSquareMeter(p97));
end;

function u92.toSquareInch(p98) -- Line: 333
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toSquareInch(u92.toSquareMeter(p98));
end;

function u92.toSquareCentimeter(p99) -- Line: 336
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toSquareCentimeter(u92.toSquareMeter(p99));
end;

function u92.toAcre(p100) -- Line: 339
    -- upvalues: u10 (copy), u92 (copy)
    return u10.toAcre(u92.toSquareMeter(p100));
end;

return {
    SquareMeter = u10,
    SquareCentimeter = u12,
    SquareMillimeter = u22,
    SquareFeet = u32,
    SquareInch = u42,
    SquareYard = u52,
    SquareKilometer = u62,
    SquareMile = u72,
    Acre = u82,
    Hectare = u92
};