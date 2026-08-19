-- Decompiled with Potassium's decompiler.

local u7 = {
    toKilojoule = function(p1) -- Line: 39, Name: toKilojoule
        return p1 * 0.001;
    end,

    toMegajoule = function(p2) -- Line: 42, Name: toMegajoule
        return p2 * 1e-6;
    end,

    toCalorie = function(p3) -- Line: 45, Name: toCalorie
        return p3 * 2.39006e-7;
    end,

    toKilocalorie = function(p4) -- Line: 48, Name: toKilocalorie
        return p4 * 0.000239006;
    end,

    toBritishThermalUnit = function(p5) -- Line: 51, Name: toBritishThermalUnit
        return p5 * 0.000947817;
    end,

    toGigajoule = function(p6) -- Line: 54, Name: toGigajoule
        return p6 * 9.999999999999999e-10;
    end
};
local u9 = {
    toJoule = function(p8) -- Line: 59, Name: toJoule
        return p8 / 0.001;
    end
};

function u9.toMegajoule(p10) -- Line: 62
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toMegajoule(u9.toJoule(p10));
end;

function u9.toCalorie(p11) -- Line: 65
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toCalorie(u9.toJoule(p11));
end;

function u9.toKilocalorie(p12) -- Line: 68
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toKilocalorie(u9.toJoule(p12));
end;

function u9.toBritishThermalUnit(p13) -- Line: 71
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toBritishThermalUnit(u9.toJoule(p13));
end;

function u9.toGigajoule(p14) -- Line: 74
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toGigajoule(u9.toJoule(p14));
end;

local u16 = {
    toJoule = function(p15) -- Line: 79, Name: toJoule
        return p15 / 0.001;
    end
};

function u16.toKilojoule(p17) -- Line: 82
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toKilojoule(u16.toJoule(p17));
end;

function u16.toCalorie(p18) -- Line: 85
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toCalorie(u16.toJoule(p18));
end;

function u16.toKilocalorie(p19) -- Line: 88
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toKilocalorie(u16.toJoule(p19));
end;

function u16.toBritishThermalUnit(p20) -- Line: 91
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toBritishThermalUnit(u16.toJoule(p20));
end;

function u16.toGigajoule(p21) -- Line: 94
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toGigajoule(u16.toJoule(p21));
end;

local u23 = {
    toJoule = function(p22) -- Line: 99, Name: toJoule
        return p22 / 2.39006e-7;
    end
};

function u23.toKilojoule(p24) -- Line: 102
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toKilojoule(u23.toJoule(p24));
end;

function u23.toMegajoule(p25) -- Line: 105
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toMegajoule(u23.toJoule(p25));
end;

function u23.toKilocalorie(p26) -- Line: 108
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toKilocalorie(u23.toJoule(p26));
end;

function u23.toBritishThermalUnit(p27) -- Line: 111
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toBritishThermalUnit(u23.toJoule(p27));
end;

function u23.toGigajoule(p28) -- Line: 114
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toGigajoule(u23.toJoule(p28));
end;

local u30 = {
    toJoule = function(p29) -- Line: 119, Name: toJoule
        return p29 / 2.39006e-7;
    end
};

function u30.toKilojoule(p31) -- Line: 122
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toKilojoule(u30.toJoule(p31));
end;

function u30.toMegajoule(p32) -- Line: 125
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toMegajoule(u30.toJoule(p32));
end;

function u30.toCalorie(p33) -- Line: 128
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toCalorie(u30.toJoule(p33));
end;

function u30.toBritishThermalUnit(p34) -- Line: 131
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toBritishThermalUnit(u30.toJoule(p34));
end;

function u30.toGigajoule(p35) -- Line: 134
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toGigajoule(u30.toJoule(p35));
end;

local u37 = {
    toJoule = function(p36) -- Line: 139, Name: toJoule
        return p36 / 0.000947817;
    end
};

function u37.toKilojoule(p38) -- Line: 142
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toKilojoule(u37.toJoule(p38));
end;

function u37.toMegajoule(p39) -- Line: 145
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toMegajoule(u37.toJoule(p39));
end;

function u37.toKilocalorie(p40) -- Line: 148
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toKilocalorie(u37.toJoule(p40));
end;

function u37.toCalorie(p41) -- Line: 151
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toCalorie(u37.toJoule(p41));
end;

function u37.toGigajoule(p42) -- Line: 154
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toGigajoule(u37.toJoule(p42));
end;

local u44 = {
    toJoule = function(p43) -- Line: 159, Name: toJoule
        return p43 / 9.999999999999999e-10;
    end
};

function u44.toKilojoule(p45) -- Line: 162
    -- upvalues: u7 (copy), u44 (copy)
    return u7.toKilojoule(u44.toJoule(p45));
end;

function u44.toMegajoule(p46) -- Line: 165
    -- upvalues: u7 (copy), u44 (copy)
    return u7.toMegajoule(u44.toJoule(p46));
end;

function u44.toKilocalorie(p47) -- Line: 168
    -- upvalues: u7 (copy), u44 (copy)
    return u7.toKilocalorie(u44.toJoule(p47));
end;

function u44.toCalorie(p48) -- Line: 171
    -- upvalues: u7 (copy), u44 (copy)
    return u7.toCalorie(u44.toJoule(p48));
end;

function u44.toBritishThermalUnit(p49) -- Line: 174
    -- upvalues: u7 (copy), u44 (copy)
    return u7.toBritishThermalUnit(u44.toJoule(p49));
end;

return {
    Joule = u7,
    Kilojoule = u9,
    Megajoule = u16,
    Calorie = u23,
    Kilocalorie = u30,
    BritishThermalUnit = u37,
    Gigajoule = u44
};