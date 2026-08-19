-- Decompiled with Potassium's decompiler.

local u12 = {
    toPound = function(p1) -- Line: 65, Name: toPound
        return p1 * 2.20462;
    end,

    toOunce = function(p2) -- Line: 68, Name: toOunce
        return p2 * 35.27392;
    end,

    toStone = function(p3) -- Line: 71, Name: toStone
        return p3 * 30.864679999999996;
    end,

    toTon = function(p4) -- Line: 74, Name: toTon
        return p4 * 0.00110231;
    end,

    toKiloton = function(p5) -- Line: 77, Name: toKiloton
        return p5 * 1.10231e-6;
    end,

    toMegaton = function(p6) -- Line: 80, Name: toMegaton
        return p6 * 1.10231e-9;
    end,

    toGram = function(p7) -- Line: 83, Name: toGram
        return p7 * 1000;
    end,

    toMilligram = function(p8) -- Line: 86, Name: toMilligram
        return p8 * 1000000;
    end,

    toTonne = function(p9) -- Line: 89, Name: toTonne
        return p9 * 0.001;
    end,

    toKilotonne = function(p10) -- Line: 92, Name: toKilotonne
        return p10 * 1e-6;
    end,

    toMegatonne = function(p11) -- Line: 95, Name: toMegatonne
        return p11 * 9.999999999999999e-10;
    end
};
local u14 = {
    toKilogram = function(p13) -- Line: 100, Name: toKilogram
        return p13 / 35.27392;
    end
};

function u14.toPound(p15) -- Line: 103
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toPound(u14.toKilogram(p15));
end;

function u14.toStone(p16) -- Line: 106
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toStone(u14.toKilogram(p16));
end;

function u14.toTon(p17) -- Line: 109
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toTon(u14.toKilogram(p17));
end;

function u14.toKiloton(p18) -- Line: 112
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toKiloton(u14.toKilogram(p18));
end;

function u14.toMegaton(p19) -- Line: 115
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toMegaton(u14.toKilogram(p19));
end;

function u14.toGram(p20) -- Line: 118
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toGram(u14.toKilogram(p20));
end;

function u14.toMilligram(p21) -- Line: 121
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toMilligram(u14.toKilogram(p21));
end;

function u14.toTonne(p22) -- Line: 124
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toTonne(u14.toKilogram(p22));
end;

function u14.toKilotonne(p23) -- Line: 127
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toKilotonne(u14.toKilogram(p23));
end;

function u14.toMegatonne(p24) -- Line: 130
    -- upvalues: u12 (copy), u14 (copy)
    return u12.toMegatonne(u14.toKilogram(p24));
end;

local u26 = {
    toKilogram = function(p25) -- Line: 135, Name: toKilogram
        return p25 / 2.20462;
    end
};

function u26.toTon(p27) -- Line: 138
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toTon(u26.toKilogram(p27));
end;

function u26.toOunce(p28) -- Line: 141
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toOunce(u26.toKilogram(p28));
end;

function u26.toStone(p29) -- Line: 144
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toStone(u26.toKilogram(p29));
end;

function u26.toKiloton(p30) -- Line: 147
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toKiloton(u26.toKilogram(p30));
end;

function u26.toMegaton(p31) -- Line: 150
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toMegaton(u26.toKilogram(p31));
end;

function u26.toGram(p32) -- Line: 153
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toGram(u26.toKilogram(p32));
end;

function u26.toMilligram(p33) -- Line: 156
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toMilligram(u26.toKilogram(p33));
end;

function u26.toTonne(p34) -- Line: 159
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toTonne(u26.toKilogram(p34));
end;

function u26.toKilotonne(p35) -- Line: 162
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toKilotonne(u26.toKilogram(p35));
end;

function u26.toMegatonne(p36) -- Line: 165
    -- upvalues: u12 (copy), u26 (copy)
    return u12.toMegatonne(u26.toKilogram(p36));
end;

local u38 = {
    toKilogram = function(p37) -- Line: 170, Name: toKilogram
        return p37 / 2.20462;
    end
};

function u38.toTon(p39) -- Line: 173
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toTon(u38.toKilogram(p39));
end;

function u38.toOunce(p40) -- Line: 176
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toOunce(u38.toKilogram(p40));
end;

function u38.toPound(p41) -- Line: 179
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toPound(u38.toKilogram(p41));
end;

function u38.toKiloton(p42) -- Line: 182
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toKiloton(u38.toKilogram(p42));
end;

function u38.toMegaton(p43) -- Line: 185
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toMegaton(u38.toKilogram(p43));
end;

function u38.toGram(p44) -- Line: 188
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toGram(u38.toKilogram(p44));
end;

function u38.toMilligram(p45) -- Line: 191
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toMilligram(u38.toKilogram(p45));
end;

function u38.toTonne(p46) -- Line: 194
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toTonne(u38.toKilogram(p46));
end;

function u38.toKilotonne(p47) -- Line: 197
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toKilotonne(u38.toKilogram(p47));
end;

function u38.toMegatonne(p48) -- Line: 200
    -- upvalues: u12 (copy), u38 (copy)
    return u12.toMegatonne(u38.toKilogram(p48));
end;

local u50 = {
    toKilogram = function(p49) -- Line: 205, Name: toKilogram
        return p49 / 0.00110231;
    end
};

function u50.toOunce(p51) -- Line: 208
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toOunce(u50.toKilogram(p51));
end;

function u50.toPound(p52) -- Line: 211
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toPound(u50.toKilogram(p52));
end;

function u50.toStone(p53) -- Line: 214
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toStone(u50.toKilogram(p53));
end;

function u50.toKiloton(p54) -- Line: 217
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toKiloton(u50.toKilogram(p54));
end;

function u50.toMegaton(p55) -- Line: 220
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toMegaton(u50.toKilogram(p55));
end;

function u50.toGram(p56) -- Line: 223
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toGram(u50.toKilogram(p56));
end;

function u50.toMilligram(p57) -- Line: 226
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toMilligram(u50.toKilogram(p57));
end;

function u50.toTonne(p58) -- Line: 229
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toTonne(u50.toKilogram(p58));
end;

function u50.toKilotonne(p59) -- Line: 232
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toKilotonne(u50.toKilogram(p59));
end;

function u50.toMegatonne(p60) -- Line: 235
    -- upvalues: u12 (copy), u50 (copy)
    return u12.toMegatonne(u50.toKilogram(p60));
end;

local u62 = {
    toKilogram = function(p61) -- Line: 240, Name: toKilogram
        return p61 / 35.27392;
    end
};

function u62.toOunce(p63) -- Line: 243
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toKiloton(u62.toKilogram(p63));
end;

function u62.toPound(p64) -- Line: 246
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toPound(u62.toKilogram(p64));
end;

function u62.toStone(p65) -- Line: 249
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toStone(u62.toKilogram(p65));
end;

function u62.toTon(p66) -- Line: 252
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toTon(u62.toKilogram(p66));
end;

function u62.toMegaton(p67) -- Line: 255
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toMegaton(u62.toKilogram(p67));
end;

function u62.toGram(p68) -- Line: 258
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toGram(u62.toKilogram(p68));
end;

function u62.toMilligram(p69) -- Line: 261
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toMilligram(u62.toKilogram(p69));
end;

function u62.toTonne(p70) -- Line: 264
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toTonne(u62.toKilogram(p70));
end;

function u62.toKilotonne(p71) -- Line: 267
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toKilotonne(u62.toKilogram(p71));
end;

function u62.toMegatonne(p72) -- Line: 270
    -- upvalues: u12 (copy), u62 (copy)
    return u12.toMegatonne(u62.toKilogram(p72));
end;

local u74 = {
    toKilogram = function(p73) -- Line: 275, Name: toKilogram
        return p73 / 1.10231e-9;
    end
};

function u74.toOunce(p75) -- Line: 278
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toOunce(u74.toKilogram(p75));
end;

function u74.toPound(p76) -- Line: 281
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toPound(u74.toKilogram(p76));
end;

function u74.toStone(p77) -- Line: 284
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toStone(u74.toKilogram(p77));
end;

function u74.toTon(p78) -- Line: 287
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toTon(u74.toKilogram(p78));
end;

function u74.toKiloton(p79) -- Line: 290
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toKiloton(u74.toKilogram(p79));
end;

function u74.toGram(p80) -- Line: 293
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toGram(u74.toKilogram(p80));
end;

function u74.toMilligram(p81) -- Line: 296
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toMilligram(u74.toKilogram(p81));
end;

function u74.toTonne(p82) -- Line: 299
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toTonne(u74.toKilogram(p82));
end;

function u74.toKilotonne(p83) -- Line: 302
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toKilotonne(u74.toKilogram(p83));
end;

function u74.toMegatonne(p84) -- Line: 305
    -- upvalues: u12 (copy), u74 (copy)
    return u12.toMegatonne(u74.toKilogram(p84));
end;

local u86 = {
    toKilogram = function(p85) -- Line: 310, Name: toKilogram
        return p85 / 1000;
    end
};

function u86.toOunce(p87) -- Line: 313
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toOunce(u86.toKilogram(p87));
end;

function u86.toPound(p88) -- Line: 316
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toPound(u86.toKilogram(p88));
end;

function u86.toStone(p89) -- Line: 319
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toStone(u86.toKilogram(p89));
end;

function u86.toTon(p90) -- Line: 322
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toTon(u86.toKilogram(p90));
end;

function u86.toKiloton(p91) -- Line: 325
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toKiloton(u86.toKilogram(p91));
end;

function u86.toMegaton(p92) -- Line: 328
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toMegaton(u86.toKilogram(p92));
end;

function u86.toMilligram(p93) -- Line: 331
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toMilligram(u86.toKilogram(p93));
end;

function u86.toTonne(p94) -- Line: 334
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toTonne(u86.toKilogram(p94));
end;

function u86.toKilotonne(p95) -- Line: 337
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toKilotonne(u86.toKilogram(p95));
end;

function u86.toMegatonne(p96) -- Line: 340
    -- upvalues: u12 (copy), u86 (copy)
    return u12.toMegatonne(u86.toKilogram(p96));
end;

local u98 = {
    toKilogram = function(p97) -- Line: 345, Name: toKilogram
        return p97 / 1000000;
    end
};

function u98.toOunce(p99) -- Line: 348
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toOunce(u98.toKilogram(p99));
end;

function u98.toPound(p100) -- Line: 351
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toPound(u98.toKilogram(p100));
end;

function u98.toStone(p101) -- Line: 354
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toStone(u98.toKilogram(p101));
end;

function u98.toTon(p102) -- Line: 357
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toTon(u98.toKilogram(p102));
end;

function u98.toKiloton(p103) -- Line: 360
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toKiloton(u98.toKilogram(p103));
end;

function u98.toMegaton(p104) -- Line: 363
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toMegaton(u98.toKilogram(p104));
end;

function u98.toGram(p105) -- Line: 366
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toGram(u98.toKilogram(p105));
end;

function u98.toTonne(p106) -- Line: 369
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toTonne(u98.toKilogram(p106));
end;

function u98.toKilotonne(p107) -- Line: 372
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toKilotonne(u98.toKilogram(p107));
end;

function u98.toMegatonne(p108) -- Line: 375
    -- upvalues: u12 (copy), u98 (copy)
    return u12.toMegatonne(u98.toKilogram(p108));
end;

local u110 = {
    toKilogram = function(p109) -- Line: 380, Name: toKilogram
        return p109 / 0.001;
    end
};

function u110.toOunce(p111) -- Line: 383
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toOunce(u110.toKilogram(p111));
end;

function u110.toPound(p112) -- Line: 386
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toPound(u110.toKilogram(p112));
end;

function u110.toStone(p113) -- Line: 389
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toStone(u110.toKilogram(p113));
end;

function u110.toTon(p114) -- Line: 392
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toTon(u110.toKilogram(p114));
end;

function u110.toKiloton(p115) -- Line: 395
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toKiloton(u110.toKilogram(p115));
end;

function u110.toMegaton(p116) -- Line: 398
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toMegaton(u110.toKilogram(p116));
end;

function u110.toGram(p117) -- Line: 401
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toGram(u110.toKilogram(p117));
end;

function u110.toMilligram(p118) -- Line: 404
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toMilligram(u110.toKilogram(p118));
end;

function u110.toKilotonne(p119) -- Line: 407
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toKilotonne(u110.toKilogram(p119));
end;

function u110.toMegatonne(p120) -- Line: 410
    -- upvalues: u12 (copy), u110 (copy)
    return u12.toMegatonne(u110.toKilogram(p120));
end;

local u122 = {
    toKilogram = function(p121) -- Line: 415, Name: toKilogram
        return p121 / 1e-6;
    end
};

function u122.toOunce(p123) -- Line: 418
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toOunce(u122.toKilogram(p123));
end;

function u122.toPound(p124) -- Line: 421
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toPound(u122.toKilogram(p124));
end;

function u122.toStone(p125) -- Line: 424
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toStone(u122.toKilogram(p125));
end;

function u122.toTon(p126) -- Line: 427
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toTon(u122.toKilogram(p126));
end;

function u122.toKiloton(p127) -- Line: 430
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toKiloton(u122.toKilogram(p127));
end;

function u122.toMegaton(p128) -- Line: 433
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toMegaton(u122.toKilogram(p128));
end;

function u122.toGram(p129) -- Line: 436
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toGram(u122.toKilogram(p129));
end;

function u122.toMilligram(p130) -- Line: 439
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toMilligram(u122.toKilogram(p130));
end;

function u122.toTonne(p131) -- Line: 442
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toTonne(u122.toKilogram(p131));
end;

function u122.toMegatonne(p132) -- Line: 445
    -- upvalues: u12 (copy), u122 (copy)
    return u12.toMegatonne(u122.toKilogram(p132));
end;

local u134 = {
    toKilogram = function(p133) -- Line: 450, Name: toKilogram
        return p133 / 9.999999999999999e-10;
    end
};

function u134.toOunce(p135) -- Line: 453
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toOunce(u134.toKilogram(p135));
end;

function u134.toPound(p136) -- Line: 456
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toPound(u134.toKilogram(p136));
end;

function u134.toStone(p137) -- Line: 459
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toStone(u134.toKilogram(p137));
end;

function u134.toTon(p138) -- Line: 462
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toTon(u134.toKilogram(p138));
end;

function u134.toKiloton(p139) -- Line: 465
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toKiloton(u134.toKilogram(p139));
end;

function u134.toMegaton(p140) -- Line: 468
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toMegaton(u134.toKilogram(p140));
end;

function u134.toGram(p141) -- Line: 471
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toGram(u134.toKilogram(p141));
end;

function u134.toMilligram(p142) -- Line: 474
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toMilligram(u134.toKilogram(p142));
end;

function u134.toTonne(p143) -- Line: 477
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toTonne(u134.toKilogram(p143));
end;

function u134.toKilotonne(p144) -- Line: 480
    -- upvalues: u12 (copy), u134 (copy)
    return u12.toKilotonne(u134.toKilogram(p144));
end;

return {
    Ounce = u14,
    Pound = u26,
    Stone = u38,
    Ton = u50,
    Kiloton = u62,
    Megaton = u74,
    Gram = u86,
    Kilogram = u12,
    Milligram = u98,
    Tonne = u110,
    Kilotonne = u122,
    Megatonne = u134
};