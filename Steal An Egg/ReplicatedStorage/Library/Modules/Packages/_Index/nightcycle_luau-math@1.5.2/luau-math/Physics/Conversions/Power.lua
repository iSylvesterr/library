-- Decompiled with Potassium's decompiler.

local u7 = {
    toWatt = function(p1) -- Line: 40, Name: toWatt
        return p1 * 1000;
    end,

    toMegawatt = function(p2) -- Line: 43, Name: toMegawatt
        return p2 * 0.001;
    end,

    toGigawatt = function(p3) -- Line: 46, Name: toGigawatt
        return p3 * 1e-6;
    end,

    toHorsepower = function(p4) -- Line: 49, Name: toHorsepower
        return p4 * 0.7457;
    end,

    toFootPoundsPerMinute = function(p5) -- Line: 52, Name: toFootPoundsPerMinute
        return p5 * 43478.260869565216;
    end,

    toKilogramMetersPerSecond = function(p6) -- Line: 55, Name: toKilogramMetersPerSecond
        return p6 * 0.0098;
    end
};
local u9 = {
    toKilowatt = function(p8) -- Line: 60, Name: toKilowatt
        return p8 / 1000;
    end
};

function u9.toMegawatt(p10) -- Line: 63
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toMegawatt(u9.toKilowatt(p10));
end;

function u9.toGigawatt(p11) -- Line: 66
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toGigawatt(u9.toKilowatt(p11));
end;

function u9.toHorsepower(p12) -- Line: 69
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toHorsepower(u9.toKilowatt(p12));
end;

function u9.toFootPoundsPerMinute(p13) -- Line: 72
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toFootPoundsPerMinute(u9.toKilowatt(p13));
end;

function u9.toKilogramMetersPerSecond(p14) -- Line: 75
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toKilogramMetersPerSecond(u9.toKilowatt(p14));
end;

local u16 = {
    toKilowatt = function(p15) -- Line: 80, Name: toKilowatt
        return p15 / 0.001;
    end
};

function u16.toWatt(p17) -- Line: 83
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toMegawatt(u16.toKilowatt(p17));
end;

function u16.toGigawatt(p18) -- Line: 86
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toGigawatt(u16.toKilowatt(p18));
end;

function u16.toHorsepower(p19) -- Line: 89
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toHorsepower(u16.toKilowatt(p19));
end;

function u16.toFootPoundsPerMinute(p20) -- Line: 92
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toFootPoundsPerMinute(u16.toKilowatt(p20));
end;

function u16.toKilogramMetersPerSecond(p21) -- Line: 95
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toKilogramMetersPerSecond(u16.toKilowatt(p21));
end;

local u23 = {
    toKilowatt = function(p22) -- Line: 100, Name: toKilowatt
        return p22 / 1e-6;
    end
};

function u23.toWatt(p24) -- Line: 103
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toMegawatt(u23.toKilowatt(p24));
end;

function u23.toMegawatt(p25) -- Line: 106
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toMegawatt(u23.toKilowatt(p25));
end;

function u23.toHorsepower(p26) -- Line: 109
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toHorsepower(u23.toKilowatt(p26));
end;

function u23.toFootPoundsPerMinute(p27) -- Line: 112
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toFootPoundsPerMinute(u23.toKilowatt(p27));
end;

function u23.toKilogramMetersPerSecond(p28) -- Line: 115
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toKilogramMetersPerSecond(u23.toKilowatt(p28));
end;

local u30 = {
    toKilowatt = function(p29) -- Line: 120, Name: toKilowatt
        return p29 / 1e-6;
    end
};

function u30.toWatt(p31) -- Line: 123
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toMegawatt(u30.toKilowatt(p31));
end;

function u30.toMegawatt(p32) -- Line: 126
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toMegawatt(u30.toKilowatt(p32));
end;

function u30.toGigawatt(p33) -- Line: 129
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toGigawatt(u30.toKilowatt(p33));
end;

function u30.toFootPoundsPerMinute(p34) -- Line: 132
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toFootPoundsPerMinute(u30.toKilowatt(p34));
end;

function u30.toKilogramMetersPerSecond(p35) -- Line: 135
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toKilogramMetersPerSecond(u30.toKilowatt(p35));
end;

local u37 = {
    toKilowatt = function(p36) -- Line: 140, Name: toKilowatt
        return p36 / 1e-6;
    end
};

function u37.toWatt(p38) -- Line: 143
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toMegawatt(u37.toKilowatt(p38));
end;

function u37.toMegawatt(p39) -- Line: 146
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toMegawatt(u37.toKilowatt(p39));
end;

function u37.toGigawatt(p40) -- Line: 149
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toGigawatt(u37.toKilowatt(p40));
end;

function u37.toHorsepower(p41) -- Line: 152
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toHorsepower(u37.toKilowatt(p41));
end;

function u37.toKilogramMetersPerSecond(p42) -- Line: 155
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toKilogramMetersPerSecond(u37.toKilowatt(p42));
end;

return {
    Kilowatt = u7,
    Watt = u9,
    Megawatt = u16,
    Gigawatt = u23,
    Horsepower = u30,
    FootPoundsPerMinute = u37
};