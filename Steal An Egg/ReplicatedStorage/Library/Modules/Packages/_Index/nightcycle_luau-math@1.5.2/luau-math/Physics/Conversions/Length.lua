-- Decompiled with Potassium's decompiler.

local u2 = {
    toKilometer = function(p1) -- Line: 78, Name: toKilometer
        return p1 / 1000;
    end
};

function u2.toAstronomicalUnit(p3) -- Line: 81
    -- upvalues: u2 (copy)
    return u2.toKilometer(p3) / 149597870.7;
end;

function u2.toLightYear(p4) -- Line: 84
    -- upvalues: u2 (copy)
    return u2.toAstronomicalUnit(p4) / 63241.1;
end;

function u2.toLightSecond(p5) -- Line: 87
    -- upvalues: u2 (copy)
    return u2.toKilometer(p5) / 299792.6369041473;
end;

function u2.toLeague(p6) -- Line: 90
    return p6 / 5556;
end;

function u2.toMile(p7) -- Line: 93
    -- upvalues: u2 (copy)
    return u2.toKilometer(p7) / 1.60934;
end;

function u2.toFeet(p8) -- Line: 96
    return p8 * 3.28;
end;

function u2.toCentimeter(p9) -- Line: 99
    return p9 * 100;
end;

function u2.toMillimeter(p10) -- Line: 102
    return p10 * 1000;
end;

function u2.toMicrometer(p11) -- Line: 105
    -- upvalues: u2 (copy)
    return u2.toMillimeter(p11) * 1000;
end;

function u2.toNanometer(p12) -- Line: 108
    -- upvalues: u2 (copy)
    return u2.toNanometer(p12) * 1000;
end;

function u2.toPicometer(p13) -- Line: 111
    -- upvalues: u2 (copy)
    return u2.toNanometer(p13) * 1000;
end;

function u2.toPlanck(p14) -- Line: 114
    -- upvalues: u2 (copy)
    return u2.toPicometer(p14) * 1.6000000000000002e-23;
end;

local u16 = {
    toMeter = function(p15) -- Line: 119, Name: toMeter
        return p15 * 1000;
    end
};

function u16.toAstronomicalUnit(p17) -- Line: 122
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toAstronomicalUnit(u16.toMeter(p17));
end;

function u16.toLightYear(p18) -- Line: 125
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toLightYear(u16.toMeter(p18));
end;

function u16.toLightSecond(p19) -- Line: 128
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toLightSecond(u16.toMeter(p19));
end;

function u16.toLeague(p20) -- Line: 131
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toLeague(u16.toMeter(p20));
end;

function u16.toMile(p21) -- Line: 134
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toMile(u16.toMeter(p21));
end;

function u16.toFeet(p22) -- Line: 137
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toFeet(u16.toMeter(p22));
end;

function u16.toCentimeter(p23) -- Line: 140
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toCentimeter(u16.toMeter(p23));
end;

function u16.toMillimeter(p24) -- Line: 143
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toMillimeter(u16.toMeter(p24));
end;

function u16.toMicrometer(p25) -- Line: 146
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toMicrometer(u16.toMeter(p25));
end;

function u16.toNanometer(p26) -- Line: 149
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toNanometer(u16.toMeter(p26));
end;

function u16.toPicometer(p27) -- Line: 152
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toPicometer(u16.toMeter(p27));
end;

function u16.toPlanck(p28) -- Line: 155
    -- upvalues: u2 (copy), u16 (copy)
    return u2.toPlanck(u16.toMeter(p28));
end;

local u30 = {
    toKilometer = function(p29) -- Line: 160, Name: toKilometer
        return p29 * 149597870.7;
    end
};

function u30.toMeter(p31) -- Line: 163
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toMeter(u30.toKilometer(p31));
end;

function u30.toLightYear(p32) -- Line: 166
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toLightYear(u30.toKilometer(p32));
end;

function u30.toLightSecond(p33) -- Line: 169
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toLightSecond(u30.toKilometer(p33));
end;

function u30.toLeague(p34) -- Line: 172
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toLeague(u30.toKilometer(p34));
end;

function u30.toMile(p35) -- Line: 175
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toMile(u30.toKilometer(p35));
end;

function u30.toFeet(p36) -- Line: 178
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toFeet(u30.toKilometer(p36));
end;

function u30.toCentimeter(p37) -- Line: 181
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toCentimeter(u30.toKilometer(p37));
end;

function u30.toMillimeter(p38) -- Line: 184
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toMillimeter(u30.toKilometer(p38));
end;

function u30.toMicrometer(p39) -- Line: 187
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toMicrometer(u30.toKilometer(p39));
end;

function u30.toNanometer(p40) -- Line: 190
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toNanometer(u30.toKilometer(p40));
end;

function u30.toPicometer(p41) -- Line: 193
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toPicometer(u30.toKilometer(p41));
end;

function u30.toPlanck(p42) -- Line: 196
    -- upvalues: u16 (copy), u30 (copy)
    return u16.toPlanck(u30.toKilometer(p42));
end;

local u44 = {
    toKilometer = function(p43) -- Line: 201, Name: toKilometer
        -- upvalues: u30 (copy)
        return u30.toKilometer(p43 * 63241.1);
    end
};

function u44.toMeter(p45) -- Line: 204
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toMeter(u44.toKilometer(p45));
end;

function u44.toAstronomicalUnit(p46) -- Line: 207
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toAstronomicalUnit(u44.toKilometer(p46));
end;

function u44.toLightSecond(p47) -- Line: 210
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toLightSecond(u44.toKilometer(p47));
end;

function u44.toLeague(p48) -- Line: 213
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toLeague(u44.toKilometer(p48));
end;

function u44.toMile(p49) -- Line: 216
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toMile(u44.toKilometer(p49));
end;

function u44.toFeet(p50) -- Line: 219
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toFeet(u44.toKilometer(p50));
end;

function u44.toCentimeter(p51) -- Line: 222
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toCentimeter(u44.toKilometer(p51));
end;

function u44.toMillimeter(p52) -- Line: 225
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toMillimeter(u44.toKilometer(p52));
end;

function u44.toMicrometer(p53) -- Line: 228
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toMicrometer(u44.toKilometer(p53));
end;

function u44.toNanometer(p54) -- Line: 231
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toNanometer(u44.toKilometer(p54));
end;

function u44.toPicometer(p55) -- Line: 234
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toPicometer(u44.toKilometer(p55));
end;

function u44.toPlanck(p56) -- Line: 237
    -- upvalues: u16 (copy), u44 (copy)
    return u16.toPlanck(u44.toKilometer(p56));
end;

local u58 = {
    toKilometer = function(p57) -- Line: 242, Name: toKilometer
        return p57 * 299792.6369041473;
    end
};

function u58.toMeter(p59) -- Line: 245
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toMeter(u58.toKilometer(p59));
end;

function u58.toAstronomicalUnit(p60) -- Line: 248
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toAstronomicalUnit(u58.toKilometer(p60));
end;

function u58.toLightYear(p61) -- Line: 251
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toLightYear(u58.toKilometer(p61));
end;

function u58.toLeague(p62) -- Line: 254
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toLeague(u58.toKilometer(p62));
end;

function u58.toMile(p63) -- Line: 257
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toMile(u58.toKilometer(p63));
end;

function u58.toFeet(p64) -- Line: 260
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toFeet(u58.toKilometer(p64));
end;

function u58.toCentimeter(p65) -- Line: 263
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toCentimeter(u58.toKilometer(p65));
end;

function u58.toMillimeter(p66) -- Line: 266
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toMillimeter(u58.toKilometer(p66));
end;

function u58.toMicrometer(p67) -- Line: 269
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toMicrometer(u58.toKilometer(p67));
end;

function u58.toNanometer(p68) -- Line: 272
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toNanometer(u58.toKilometer(p68));
end;

function u58.toPicometer(p69) -- Line: 275
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toPicometer(u58.toKilometer(p69));
end;

function u58.toPlanck(p70) -- Line: 278
    -- upvalues: u16 (copy), u58 (copy)
    return u16.toPlanck(u58.toKilometer(p70));
end;

local u72 = {
    toMeter = function(p71) -- Line: 283, Name: toMeter
        return p71 * 5556;
    end
};

function u72.toKilometer(p73) -- Line: 286
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toKilometer(u72.toMeter(p73));
end;

function u72.toAstronomicalUnit(p74) -- Line: 289
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toAstronomicalUnit(u72.toMeter(p74));
end;

function u72.toLightYear(p75) -- Line: 292
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toLightYear(u72.toMeter(p75));
end;

function u72.toLightSecond(p76) -- Line: 295
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toLightSecond(u72.toMeter(p76));
end;

function u72.toMile(p77) -- Line: 298
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toMile(u72.toMeter(p77));
end;

function u72.toFeet(p78) -- Line: 301
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toFeet(u72.toMeter(p78));
end;

function u72.toCentimeter(p79) -- Line: 304
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toCentimeter(u72.toMeter(p79));
end;

function u72.toMillimeter(p80) -- Line: 307
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toMillimeter(u72.toMeter(p80));
end;

function u72.toMicrometer(p81) -- Line: 310
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toMicrometer(u72.toMeter(p81));
end;

function u72.toNanometer(p82) -- Line: 313
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toNanometer(u72.toMeter(p82));
end;

function u72.toPicometer(p83) -- Line: 316
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toPicometer(u72.toMeter(p83));
end;

function u72.toPlanck(p84) -- Line: 319
    -- upvalues: u2 (copy), u72 (copy)
    return u2.toPlanck(u72.toMeter(p84));
end;

local u86 = {
    toKilometer = function(p85) -- Line: 324, Name: toKilometer
        return p85 * 1.60934;
    end
};

function u86.toMeter(p87) -- Line: 327
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toMeter(u86.toKilometer(p87));
end;

function u86.toAstronomicalUnit(p88) -- Line: 330
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toAstronomicalUnit(u86.toKilometer(p88));
end;

function u86.toLightYear(p89) -- Line: 333
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toLightYear(u86.toKilometer(p89));
end;

function u86.toLightSecond(p90) -- Line: 336
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toLightSecond(u86.toKilometer(p90));
end;

function u86.toLeague(p91) -- Line: 339
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toLeague(u86.toKilometer(p91));
end;

function u86.toFeet(p92) -- Line: 342
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toFeet(u86.toKilometer(p92));
end;

function u86.toCentimeter(p93) -- Line: 345
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toCentimeter(u86.toKilometer(p93));
end;

function u86.toMillimeter(p94) -- Line: 348
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toMillimeter(u86.toKilometer(p94));
end;

function u86.toMicrometer(p95) -- Line: 351
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toMicrometer(u86.toKilometer(p95));
end;

function u86.toNanometer(p96) -- Line: 354
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toNanometer(u86.toKilometer(p96));
end;

function u86.toPicometer(p97) -- Line: 357
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toPicometer(u86.toKilometer(p97));
end;

function u86.toPlanck(p98) -- Line: 360
    -- upvalues: u16 (copy), u86 (copy)
    return u16.toPlanck(u86.toKilometer(p98));
end;

local u100 = {
    toMeter = function(p99) -- Line: 365, Name: toMeter
        return p99 / 3.28;
    end
};

function u100.toKilometer(p101) -- Line: 368
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toKilometer(u100.toMeter(p101));
end;

function u100.toAstronomicalUnit(p102) -- Line: 371
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toAstronomicalUnit(u100.toMeter(p102));
end;

function u100.toLightYear(p103) -- Line: 374
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toLightYear(u100.toMeter(p103));
end;

function u100.toLightSecond(p104) -- Line: 377
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toLightSecond(u100.toMeter(p104));
end;

function u100.toLeague(p105) -- Line: 380
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toLeague(u100.toMeter(p105));
end;

function u100.toMile(p106) -- Line: 383
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toMile(u100.toMeter(p106));
end;

function u100.toCentimeter(p107) -- Line: 386
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toCentimeter(u100.toMeter(p107));
end;

function u100.toMillimeter(p108) -- Line: 389
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toMillimeter(u100.toMeter(p108));
end;

function u100.toMicrometer(p109) -- Line: 392
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toMicrometer(u100.toMeter(p109));
end;

function u100.toNanometer(p110) -- Line: 395
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toNanometer(u100.toMeter(p110));
end;

function u100.toPicometer(p111) -- Line: 398
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toPicometer(u100.toMeter(p111));
end;

function u100.toPlanck(p112) -- Line: 401
    -- upvalues: u2 (copy), u100 (copy)
    return u2.toPlanck(u100.toMeter(p112));
end;

local u114 = {
    toMeter = function(p113) -- Line: 406, Name: toMeter
        return p113 / 100;
    end
};

function u114.toKilometer(p115) -- Line: 409
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toKilometer(u114.toMeter(p115));
end;

function u114.toAstronomicalUnit(p116) -- Line: 412
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toAstronomicalUnit(u114.toMeter(p116));
end;

function u114.toLightYear(p117) -- Line: 415
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toLightYear(u114.toMeter(p117));
end;

function u114.toLightSecond(p118) -- Line: 418
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toLightSecond(u114.toMeter(p118));
end;

function u114.toLeague(p119) -- Line: 421
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toLeague(u114.toMeter(p119));
end;

function u114.toMile(p120) -- Line: 424
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toMile(u114.toMeter(p120));
end;

function u114.toFeet(p121) -- Line: 427
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toFeet(u114.toMeter(p121));
end;

function u114.toMillimeter(p122) -- Line: 430
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toMillimeter(u114.toMeter(p122));
end;

function u114.toMicrometer(p123) -- Line: 433
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toMicrometer(u114.toMeter(p123));
end;

function u114.toNanometer(p124) -- Line: 436
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toNanometer(u114.toMeter(p124));
end;

function u114.toPicometer(p125) -- Line: 439
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toPicometer(u114.toMeter(p125));
end;

function u114.toPlanck(p126) -- Line: 442
    -- upvalues: u2 (copy), u114 (copy)
    return u2.toPlanck(u114.toMeter(p126));
end;

local u128 = {
    toMeter = function(p127) -- Line: 447, Name: toMeter
        -- upvalues: u114 (copy)
        return u114.toMeter(p127 / 1000);
    end
};

function u128.toKilometer(p129) -- Line: 450
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toKilometer(u128.toMeter(p129));
end;

function u128.toAstronomicalUnit(p130) -- Line: 453
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toAstronomicalUnit(u128.toMeter(p130));
end;

function u128.toLightYear(p131) -- Line: 456
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toLightYear(u128.toMeter(p131));
end;

function u128.toLightSecond(p132) -- Line: 459
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toLightSecond(u128.toMeter(p132));
end;

function u128.toLeague(p133) -- Line: 462
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toLeague(u128.toMeter(p133));
end;

function u128.toMile(p134) -- Line: 465
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toMile(u128.toMeter(p134));
end;

function u128.toFeet(p135) -- Line: 468
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toFeet(u128.toMeter(p135));
end;

function u128.toCentimeter(p136) -- Line: 471
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toCentimeter(u128.toMeter(p136));
end;

function u128.toMicrometer(p137) -- Line: 474
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toMicrometer(u128.toMeter(p137));
end;

function u128.toNanometer(p138) -- Line: 477
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toNanometer(u128.toMeter(p138));
end;

function u128.toPicometer(p139) -- Line: 480
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toPicometer(u128.toMeter(p139));
end;

function u128.toPlanck(p140) -- Line: 483
    -- upvalues: u2 (copy), u128 (copy)
    return u2.toPlanck(u128.toMeter(p140));
end;

local u142 = {
    toMillimeter = function(p141) -- Line: 488, Name: toMillimeter
        return p141 / 1000;
    end
};

function u142.toMeter(p143) -- Line: 491
    -- upvalues: u128 (copy), u142 (copy)
    return u128.toMeter(u142.toMillimeter(p143));
end;

function u142.toKilometer(p144) -- Line: 494
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toKilometer(u142.toMeter(p144));
end;

function u142.toAstronomicalUnit(p145) -- Line: 497
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toAstronomicalUnit(u142.toMeter(p145));
end;

function u142.toLightYear(p146) -- Line: 500
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toLightYear(u142.toMeter(p146));
end;

function u142.toLightSecond(p147) -- Line: 503
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toLightSecond(u142.toMeter(p147));
end;

function u142.toLeague(p148) -- Line: 506
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toLeague(u142.toMeter(p148));
end;

function u142.toMile(p149) -- Line: 509
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toMile(u142.toMeter(p149));
end;

function u142.toFeet(p150) -- Line: 512
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toFeet(u142.toMeter(p150));
end;

function u142.toCentimeter(p151) -- Line: 515
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toCentimeter(u142.toMeter(p151));
end;

function u142.toNanometer(p152) -- Line: 518
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toNanometer(u142.toMeter(p152));
end;

function u142.toPicometer(p153) -- Line: 521
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toPicometer(u142.toMeter(p153));
end;

function u142.toPlanck(p154) -- Line: 524
    -- upvalues: u2 (copy), u142 (copy)
    return u2.toPlanck(u142.toMeter(p154));
end;

local u156 = {
    toMicrometer = function(p155) -- Line: 529, Name: toMicrometer
        return p155 / 1000;
    end
};

function u156.toMeter(p157) -- Line: 532
    -- upvalues: u128 (copy), u156 (copy)
    return u128.toMeter(u156.toMicrometer(p157));
end;

function u156.toKilometer(p158) -- Line: 535
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toKilometer(u156.toMeter(p158));
end;

function u156.toAstronomicalUnit(p159) -- Line: 538
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toAstronomicalUnit(u156.toMeter(p159));
end;

function u156.toLightYear(p160) -- Line: 541
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toLightYear(u156.toMeter(p160));
end;

function u156.toLightSecond(p161) -- Line: 544
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toLightSecond(u156.toMeter(p161));
end;

function u156.toLeague(p162) -- Line: 547
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toLeague(u156.toMeter(p162));
end;

function u156.toMile(p163) -- Line: 550
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toMile(u156.toMeter(p163));
end;

function u156.toFeet(p164) -- Line: 553
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toFeet(u156.toMeter(p164));
end;

function u156.toCentimeter(p165) -- Line: 556
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toCentimeter(u156.toMeter(p165));
end;

function u156.toMillimeter(p166) -- Line: 559
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toMillimeter(u156.toMeter(p166));
end;

function u156.toPicometer(p167) -- Line: 562
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toPicometer(u156.toMeter(p167));
end;

function u156.toPlanck(p168) -- Line: 565
    -- upvalues: u2 (copy), u156 (copy)
    return u2.toPlanck(u156.toMeter(p168));
end;

local u170 = {
    toNanometer = function(p169) -- Line: 570, Name: toNanometer
        return p169 / 1000;
    end
};

function u170.toMeter(p171) -- Line: 573
    -- upvalues: u128 (copy), u170 (copy)
    return u128.toMeter(u170.toMicrometer(p171));
end;

function u170.toKilometer(p172) -- Line: 576
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toKilometer(u170.toMeter(p172));
end;

function u170.toAstronomicalUnit(p173) -- Line: 579
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toAstronomicalUnit(u170.toMeter(p173));
end;

function u170.toLightYear(p174) -- Line: 582
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toLightYear(u170.toMeter(p174));
end;

function u170.toLightSecond(p175) -- Line: 585
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toLightSecond(u170.toMeter(p175));
end;

function u170.toLeague(p176) -- Line: 588
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toLeague(u170.toMeter(p176));
end;

function u170.toMile(p177) -- Line: 591
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toMile(u170.toMeter(p177));
end;

function u170.toFeet(p178) -- Line: 594
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toFeet(u170.toMeter(p178));
end;

function u170.toCentimeter(p179) -- Line: 597
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toCentimeter(u170.toMeter(p179));
end;

function u170.toMillimeter(p180) -- Line: 600
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toMillimeter(u170.toMeter(p180));
end;

function u170.toMicrometer(p181) -- Line: 603
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toMicrometer(u170.toMeter(p181));
end;

function u170.toPicometer(p182) -- Line: 606
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toPicometer(u170.toMeter(p182));
end;

function u170.toPlanck(p183) -- Line: 609
    -- upvalues: u2 (copy), u170 (copy)
    return u2.toPlanck(u170.toMeter(p183));
end;

local u185 = {
    toPicometer = function(p184) -- Line: 614, Name: toPicometer
        return p184 / 1.6000000000000002e-23;
    end
};

function u185.toMeter(p186) -- Line: 617
    -- upvalues: u128 (copy), u185 (copy)
    return u128.toMeter(u185.toMicrometer(p186));
end;

function u185.toKilometer(p187) -- Line: 620
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toKilometer(u185.toMeter(p187));
end;

function u185.toAstronomicalUnit(p188) -- Line: 623
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toAstronomicalUnit(u185.toMeter(p188));
end;

function u185.toLightYear(p189) -- Line: 626
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toLightYear(u185.toMeter(p189));
end;

function u185.toLightSecond(p190) -- Line: 629
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toLightSecond(u185.toMeter(p190));
end;

function u185.toLeague(p191) -- Line: 632
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toLeague(u185.toMeter(p191));
end;

function u185.toMile(p192) -- Line: 635
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toMile(u185.toMeter(p192));
end;

function u185.toFeet(p193) -- Line: 638
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toFeet(u185.toMeter(p193));
end;

function u185.toCentimeter(p194) -- Line: 641
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toCentimeter(u185.toMeter(p194));
end;

function u185.toMillimeter(p195) -- Line: 644
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toMillimeter(u185.toMeter(p195));
end;

function u185.toMicrometer(p196) -- Line: 647
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toMicrometer(u185.toMeter(p196));
end;

function u185.toNanometer(p197) -- Line: 650
    -- upvalues: u2 (copy), u185 (copy)
    return u2.toNanometer(u185.toMeter(p197));
end;

return {
    Meter = u2,
    Kilometer = u16,
    AstronomicalUnit = u30,
    LightYear = u44,
    LightSecond = u58,
    League = u72,
    Mile = u86,
    Feet = u100,
    Centimeter = u114,
    Millimeter = u128,
    Micrometer = u142,
    Nanometer = u156,
    Picometer = u170,
    Planck = u185
};