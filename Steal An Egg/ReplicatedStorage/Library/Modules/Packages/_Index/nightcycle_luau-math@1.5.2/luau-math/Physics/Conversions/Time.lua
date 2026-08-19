-- Decompiled with Potassium's decompiler.

local u4 = {
    toMinute = function(p1) -- Line: 73, Name: toMinute
        return p1 / 60;
    end,

    toHour = function(p2) -- Line: 76, Name: toHour
        return p2 / 3600;
    end,

    toDay = function(p3) -- Line: 79, Name: toDay
        return p3 / 86400;
    end
};

function u4.toWeek(p5) -- Line: 82
    -- upvalues: u4 (copy)
    return u4.toDay(p5) / 7;
end;

function u4.toYear(p6) -- Line: 85
    -- upvalues: u4 (copy)
    return u4.toDay(p6) / 365.25;
end;

function u4.toDecade(p7) -- Line: 88
    -- upvalues: u4 (copy)
    return u4.toYear(p7) / 10;
end;

function u4.toCentury(p8) -- Line: 91
    -- upvalues: u4 (copy)
    return u4.toYear(p8) / 100;
end;

function u4.toMillenia(p9) -- Line: 94
    -- upvalues: u4 (copy)
    return u4.toYear(p9) / 1000;
end;

function u4.toMicrosecond(p10) -- Line: 97
    return p10 * 1000000;
end;

function u4.toMillisecond(p11) -- Line: 100
    -- upvalues: u4 (copy)
    return u4.toMicrosecond(p11) / 1000;
end;

function u4.toPicosecond(p12) -- Line: 103
    -- upvalues: u4 (copy)
    return u4.toMicrosecond(p12) * 1000000;
end;

function u4.toNanosecond(p13) -- Line: 106
    -- upvalues: u4 (copy)
    return u4.toPicosecond(p13) / 1000;
end;

local u15 = {
    toSecond = function(p14) -- Line: 111, Name: toSecond
        return p14 * 86400;
    end
};

function u15.toMinute(p16) -- Line: 114
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toMinute(u15.toSecond(p16));
end;

function u15.toHour(p17) -- Line: 117
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toHour(u15.toSecond(p17));
end;

function u15.toWeek(p18) -- Line: 120
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toWeek(u15.toSecond(p18));
end;

function u15.toYear(p19) -- Line: 123
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toYear(u15.toSecond(p19));
end;

function u15.toDecade(p20) -- Line: 126
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toDecade(u15.toSecond(p20));
end;

function u15.toCentury(p21) -- Line: 129
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toCentury(u15.toSecond(p21));
end;

function u15.toMillenia(p22) -- Line: 132
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toMillenia(u15.toSecond(p22));
end;

function u15.toMicrosecond(p23) -- Line: 135
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toMicrosecond(u15.toSecond(p23));
end;

function u15.toMillisecond(p24) -- Line: 138
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toMillisecond(u15.toSecond(p24));
end;

function u15.toPicosecond(p25) -- Line: 141
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toPicosecond(u15.toSecond(p25));
end;

function u15.toNanosecond(p26) -- Line: 144
    -- upvalues: u4 (copy), u15 (copy)
    return u4.toNanosecond(u15.toSecond(p26));
end;

local u28 = {
    toDay = function(p27) -- Line: 149, Name: toDay
        return p27 * 365.25;
    end
};

function u28.toSecond(p29) -- Line: 152
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toMinute(u28.toDay(p29));
end;

function u28.toMinute(p30) -- Line: 155
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toMinute(u28.toDay(p30));
end;

function u28.toHour(p31) -- Line: 158
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toHour(u28.toDay(p31));
end;

function u28.toWeek(p32) -- Line: 161
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toWeek(u28.toDay(p32));
end;

function u28.toDecade(p33) -- Line: 164
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toDecade(u28.toDay(p33));
end;

function u28.toCentury(p34) -- Line: 167
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toCentury(u28.toDay(p34));
end;

function u28.toMillenia(p35) -- Line: 170
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toMillenia(u28.toDay(p35));
end;

function u28.toMicrosecond(p36) -- Line: 173
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toMicrosecond(u28.toDay(p36));
end;

function u28.toMillisecond(p37) -- Line: 176
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toMillisecond(u28.toDay(p37));
end;

function u28.toPicosecond(p38) -- Line: 179
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toPicosecond(u28.toDay(p38));
end;

function u28.toNanosecond(p39) -- Line: 182
    -- upvalues: u15 (copy), u28 (copy)
    return u15.toNanosecond(u28.toDay(p39));
end;

local u42 = {
    toSecond = function(p40) -- Line: 187, Name: toSecond
        return p40 / 1000000;
    end,

    toMillisecond = function(p41) -- Line: 190, Name: toMillisecond
        return p41 / 1000;
    end
};

function u42.toMinute(p43) -- Line: 193
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toMinute(u42.toSecond(p43));
end;

function u42.toHour(p44) -- Line: 196
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toHour(u42.toSecond(p44));
end;

function u42.toDay(p45) -- Line: 199
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toDay(u42.toSecond(p45));
end;

function u42.toWeek(p46) -- Line: 202
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toWeek(u42.toSecond(p46));
end;

function u42.toYear(p47) -- Line: 205
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toYear(u42.toSecond(p47));
end;

function u42.toDecade(p48) -- Line: 208
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toDecade(u42.toSecond(p48));
end;

function u42.toCentury(p49) -- Line: 211
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toCentury(u42.toSecond(p49));
end;

function u42.toMillenia(p50) -- Line: 214
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toMillenia(u42.toSecond(p50));
end;

function u42.toPicosecond(p51) -- Line: 217
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toPicosecond(u42.toSecond(p51));
end;

function u42.toNanosecond(p52) -- Line: 220
    -- upvalues: u4 (copy), u42 (copy)
    return u4.toNanosecond(u42.toSecond(p52));
end;

local u55 = {
    toMicrosecond = function(p53) -- Line: 225, Name: toMicrosecond
        return p53 / 1000000;
    end,

    toNanosecond = function(p54) -- Line: 228, Name: toNanosecond
        return p54 / 1000;
    end
};

function u55.toSecond(p56) -- Line: 231
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toSecond(u55.toMicrosecond(p56));
end;

function u55.toMillisecond(p57) -- Line: 234
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toMillisecond(u55.toMicrosecond(p57));
end;

function u55.toMinute(p58) -- Line: 237
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toMinute(u55.toMicrosecond(p58));
end;

function u55.toHour(p59) -- Line: 240
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toHour(u55.toMicrosecond(p59));
end;

function u55.toDay(p60) -- Line: 243
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toDay(u55.toMicrosecond(p60));
end;

function u55.toWeek(p61) -- Line: 246
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toWeek(u55.toMicrosecond(p61));
end;

function u55.toYear(p62) -- Line: 249
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toYear(u55.toMicrosecond(p62));
end;

function u55.toDecade(p63) -- Line: 252
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toDecade(u55.toMicrosecond(p63));
end;

function u55.toCentury(p64) -- Line: 255
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toCentury(u55.toMicrosecond(p64));
end;

function u55.toMillenia(p65) -- Line: 258
    -- upvalues: u42 (copy), u55 (copy)
    return u42.toMillenia(u55.toMicrosecond(p65));
end;

local u67 = {
    toPicosecond = function(p66) -- Line: 263, Name: toPicosecond
        return p66 * 1000;
    end
};

function u67.toMicrosecond(p68) -- Line: 266
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toMicrosecond(u67.toPicosecond(p68));
end;

function u67.toSecond(p69) -- Line: 269
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toSecond(u67.toPicosecond(p69));
end;

function u67.toMillisecond(p70) -- Line: 272
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toMillisecond(u67.toPicosecond(p70));
end;

function u67.toMinute(p71) -- Line: 275
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toMinute(u67.toPicosecond(p71));
end;

function u67.toHour(p72) -- Line: 278
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toHour(u67.toPicosecond(p72));
end;

function u67.toDay(p73) -- Line: 281
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toDay(u67.toPicosecond(p73));
end;

function u67.toWeek(p74) -- Line: 284
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toWeek(u67.toPicosecond(p74));
end;

function u67.toYear(p75) -- Line: 287
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toYear(u67.toPicosecond(p75));
end;

function u67.toDecade(p76) -- Line: 290
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toDecade(u67.toPicosecond(p76));
end;

function u67.toCentury(p77) -- Line: 293
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toCentury(u67.toPicosecond(p77));
end;

function u67.toMillenia(p78) -- Line: 296
    -- upvalues: u55 (copy), u67 (copy)
    return u55.toMillenia(u67.toPicosecond(p78));
end;

local u80 = {
    toMicrosecond = function(p79) -- Line: 301, Name: toMicrosecond
        return p79 * 1000;
    end
};

function u80.toSecond(p81) -- Line: 304
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toMinute(u80.toMicrosecond(p81));
end;

function u80.toMinute(p82) -- Line: 307
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toMinute(u80.toMicrosecond(p82));
end;

function u80.toHour(p83) -- Line: 310
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toHour(u80.toMicrosecond(p83));
end;

function u80.toDay(p84) -- Line: 313
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toDay(u80.toMicrosecond(p84));
end;

function u80.toWeek(p85) -- Line: 316
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toWeek(u80.toMicrosecond(p85));
end;

function u80.toYear(p86) -- Line: 319
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toYear(u80.toMicrosecond(p86));
end;

function u80.toDecade(p87) -- Line: 322
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toDecade(u80.toMicrosecond(p87));
end;

function u80.toCentury(p88) -- Line: 325
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toCentury(u80.toMicrosecond(p88));
end;

function u80.toMillenia(p89) -- Line: 328
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toMillenia(u80.toMicrosecond(p89));
end;

function u80.toPicosecond(p90) -- Line: 331
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toPicosecond(u80.toMicrosecond(p90));
end;

function u80.toNanosecond(p91) -- Line: 334
    -- upvalues: u42 (copy), u80 (copy)
    return u42.toNanosecond(u80.toMicrosecond(p91));
end;

local u93 = {
    toSecond = function(p92) -- Line: 339, Name: toSecond
        return p92 * 60;
    end
};

function u93.toDay(p94) -- Line: 342
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toDay(u93.toSecond(p94));
end;

function u93.toHour(p95) -- Line: 345
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toHour(u93.toSecond(p95));
end;

function u93.toWeek(p96) -- Line: 348
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toWeek(u93.toSecond(p96));
end;

function u93.toYear(p97) -- Line: 351
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toYear(u93.toSecond(p97));
end;

function u93.toDecade(p98) -- Line: 354
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toDecade(u93.toSecond(p98));
end;

function u93.toCentury(p99) -- Line: 357
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toCentury(u93.toSecond(p99));
end;

function u93.toMillenia(p100) -- Line: 360
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toMillenia(u93.toSecond(p100));
end;

function u93.toMicrosecond(p101) -- Line: 363
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toMicrosecond(u93.toSecond(p101));
end;

function u93.toMillisecond(p102) -- Line: 366
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toMillisecond(u93.toSecond(p102));
end;

function u93.toPicosecond(p103) -- Line: 369
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toPicosecond(u93.toSecond(p103));
end;

function u93.toNanosecond(p104) -- Line: 372
    -- upvalues: u4 (copy), u93 (copy)
    return u4.toNanosecond(u93.toSecond(p104));
end;

local u106 = {
    toSecond = function(p105) -- Line: 377, Name: toSecond
        return p105 * 3600;
    end
};

function u106.toDay(p107) -- Line: 380
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toDay(u106.toSecond(p107));
end;

function u106.toMinute(p108) -- Line: 383
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toMinute(u106.toSecond(p108));
end;

function u106.toWeek(p109) -- Line: 386
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toWeek(u106.toSecond(p109));
end;

function u106.toYear(p110) -- Line: 389
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toYear(u106.toSecond(p110));
end;

function u106.toDecade(p111) -- Line: 392
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toDecade(u106.toSecond(p111));
end;

function u106.toCentury(p112) -- Line: 395
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toCentury(u106.toSecond(p112));
end;

function u106.toMillenia(p113) -- Line: 398
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toMillenia(u106.toSecond(p113));
end;

function u106.toMicrosecond(p114) -- Line: 401
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toMicrosecond(u106.toSecond(p114));
end;

function u106.toMillisecond(p115) -- Line: 404
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toMillisecond(u106.toSecond(p115));
end;

function u106.toPicosecond(p116) -- Line: 407
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toPicosecond(u106.toSecond(p116));
end;

function u106.toNanosecond(p117) -- Line: 410
    -- upvalues: u4 (copy), u106 (copy)
    return u4.toNanosecond(u106.toSecond(p117));
end;

local u119 = {
    toDay = function(p118) -- Line: 415, Name: toDay
        return p118 * 7;
    end
};

function u119.toSecond(p120) -- Line: 418
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toMinute(u119.toDay(p120));
end;

function u119.toMinute(p121) -- Line: 421
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toMinute(u119.toDay(p121));
end;

function u119.toHour(p122) -- Line: 424
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toHour(u119.toDay(p122));
end;

function u119.toYear(p123) -- Line: 427
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toYear(u119.toDay(p123));
end;

function u119.toDecade(p124) -- Line: 430
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toDecade(u119.toDay(p124));
end;

function u119.toCentury(p125) -- Line: 433
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toCentury(u119.toDay(p125));
end;

function u119.toMillenia(p126) -- Line: 436
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toMillenia(u119.toDay(p126));
end;

function u119.toMicrosecond(p127) -- Line: 439
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toMicrosecond(u119.toDay(p127));
end;

function u119.toMillisecond(p128) -- Line: 442
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toMillisecond(u119.toDay(p128));
end;

function u119.toPicosecond(p129) -- Line: 445
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toPicosecond(u119.toDay(p129));
end;

function u119.toNanosecond(p130) -- Line: 448
    -- upvalues: u15 (copy), u119 (copy)
    return u15.toNanosecond(u119.toDay(p130));
end;

local u132 = {
    toYear = function(p131) -- Line: 453, Name: toYear
        return p131 * 1000;
    end
};

function u132.toSecond(p133) -- Line: 456
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toSecond(u132.toYear(p133));
end;

function u132.toMinute(p134) -- Line: 459
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toMinute(u132.toYear(p134));
end;

function u132.toHour(p135) -- Line: 462
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toHour(u132.toYear(p135));
end;

function u132.toWeek(p136) -- Line: 465
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toWeek(u132.toYear(p136));
end;

function u132.toDecade(p137) -- Line: 468
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toDecade(u132.toYear(p137));
end;

function u132.toCentury(p138) -- Line: 471
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toCentury(u132.toYear(p138));
end;

function u132.toDay(p139) -- Line: 474
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toDay(u132.toYear(p139));
end;

function u132.toMicrosecond(p140) -- Line: 477
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toMicrosecond(u132.toYear(p140));
end;

function u132.toMillisecond(p141) -- Line: 480
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toMillisecond(u132.toYear(p141));
end;

function u132.toPicosecond(p142) -- Line: 483
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toPicosecond(u132.toYear(p142));
end;

function u132.toNanosecond(p143) -- Line: 486
    -- upvalues: u28 (copy), u132 (copy)
    return u28.toNanosecond(u132.toYear(p143));
end;

local u145 = {
    toYear = function(p144) -- Line: 491, Name: toYear
        return p144 * 10;
    end
};

function u145.toMillenia(p146) -- Line: 494
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toDecade(u145.toYear(p146));
end;

function u145.toSecond(p147) -- Line: 497
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toSecond(u145.toYear(p147));
end;

function u145.toMinute(p148) -- Line: 500
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toMinute(u145.toYear(p148));
end;

function u145.toHour(p149) -- Line: 503
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toHour(u145.toYear(p149));
end;

function u145.toWeek(p150) -- Line: 506
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toWeek(u145.toYear(p150));
end;

function u145.toCentury(p151) -- Line: 509
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toCentury(u145.toYear(p151));
end;

function u145.toDay(p152) -- Line: 512
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toDay(u145.toYear(p152));
end;

function u145.toMicrosecond(p153) -- Line: 515
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toMicrosecond(u145.toYear(p153));
end;

function u145.toMillisecond(p154) -- Line: 518
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toMillisecond(u145.toYear(p154));
end;

function u145.toPicosecond(p155) -- Line: 521
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toPicosecond(u145.toYear(p155));
end;

function u145.toNanosecond(p156) -- Line: 524
    -- upvalues: u28 (copy), u145 (copy)
    return u28.toNanosecond(u145.toYear(p156));
end;

local u158 = {
    toYear = function(p157) -- Line: 529, Name: toYear
        return p157 * 100;
    end
};

function u158.toMillenia(p159) -- Line: 532
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toMillenia(u158.toYear(p159));
end;

function u158.toSecond(p160) -- Line: 535
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toSecond(u158.toYear(p160));
end;

function u158.toMinute(p161) -- Line: 538
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toMinute(u158.toYear(p161));
end;

function u158.toHour(p162) -- Line: 541
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toHour(u158.toYear(p162));
end;

function u158.toWeek(p163) -- Line: 544
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toWeek(u158.toYear(p163));
end;

function u158.toDecade(p164) -- Line: 547
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toDecade(u158.toYear(p164));
end;

function u158.toDay(p165) -- Line: 550
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toDay(u158.toYear(p165));
end;

function u158.toMicrosecond(p166) -- Line: 553
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toMicrosecond(u158.toYear(p166));
end;

function u158.toMillisecond(p167) -- Line: 556
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toMillisecond(u158.toYear(p167));
end;

function u158.toPicosecond(p168) -- Line: 559
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toPicosecond(u158.toYear(p168));
end;

function u158.toNanosecond(p169) -- Line: 562
    -- upvalues: u28 (copy), u158 (copy)
    return u28.toNanosecond(u158.toYear(p169));
end;

return {
    Millenia = u132,
    Century = u158,
    Decade = u145,
    Year = u28,
    Week = u119,
    Day = u15,
    Hour = u106,
    Minute = u93,
    Second = u4,
    Millisecond = u80,
    Microsecond = u42,
    Nanosecond = u67,
    Picosecond = u55
};