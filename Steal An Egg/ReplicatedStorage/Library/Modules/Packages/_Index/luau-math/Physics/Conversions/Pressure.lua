-- Decompiled with Potassium's decompiler.

local u7 = {
    toAtmosphere = function(p1) -- Line: 40, Name: toAtmosphere
        return p1 * 9.86923;
    end,

    toKilopascal = function(p2) -- Line: 43, Name: toKilopascal
        return p2 * 1000;
    end,

    toPascal = function(p3) -- Line: 46, Name: toPascal
        return p3 * 1000000;
    end,

    toBar = function(p4) -- Line: 49, Name: toBar
        return p4 * 10;
    end,

    toMillibar = function(p5) -- Line: 52, Name: toMillibar
        return p5 * 10000;
    end,

    toPoundsPerSquareInch = function(p6) -- Line: 55, Name: toPoundsPerSquareInch
        return p6 * 145.038;
    end
};
local u9 = {
    toMegapascal = function(p8) -- Line: 60, Name: toMegapascal
        return p8 / 1000;
    end
};

function u9.toAtmosphere(p10) -- Line: 63
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toAtmosphere(u9.toMegapascal(p10));
end;

function u9.toPascal(p11) -- Line: 66
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toPascal(u9.toMegapascal(p11));
end;

function u9.toBar(p12) -- Line: 69
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toBar(u9.toMegapascal(p12));
end;

function u9.toMillibar(p13) -- Line: 72
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toMillibar(u9.toMegapascal(p13));
end;

function u9.toPoundsPerSquareInch(p14) -- Line: 75
    -- upvalues: u7 (copy), u9 (copy)
    return u7.toPoundsPerSquareInch(u9.toMegapascal(p14));
end;

local u16 = {
    toMegapascal = function(p15) -- Line: 80, Name: toMegapascal
        return p15 / 1000000;
    end
};

function u16.toAtmosphere(p17) -- Line: 83
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toAtmosphere(u16.toMegapascal(p17));
end;

function u16.toPascal(p18) -- Line: 86
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toPascal(u16.toMegapascal(p18));
end;

function u16.toBar(p19) -- Line: 89
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toBar(u16.toMegapascal(p19));
end;

function u16.toMillibar(p20) -- Line: 92
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toMillibar(u16.toMegapascal(p20));
end;

function u16.toPoundsPerSquareInch(p21) -- Line: 95
    -- upvalues: u7 (copy), u16 (copy)
    return u7.toPoundsPerSquareInch(u16.toMegapascal(p21));
end;

local u23 = {
    toMegapascal = function(p22) -- Line: 100, Name: toMegapascal
        return p22 / 9.86923;
    end
};

function u23.toKilopascal(p24) -- Line: 103
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toAtmosphere(u23.toMegapascal(p24));
end;

function u23.toPascal(p25) -- Line: 106
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toPascal(u23.toMegapascal(p25));
end;

function u23.toBar(p26) -- Line: 109
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toBar(u23.toMegapascal(p26));
end;

function u23.toMillibar(p27) -- Line: 112
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toMillibar(u23.toMegapascal(p27));
end;

function u23.toPoundsPerSquareInch(p28) -- Line: 115
    -- upvalues: u7 (copy), u23 (copy)
    return u7.toPoundsPerSquareInch(u23.toMegapascal(p28));
end;

local u30 = {
    toMegapascal = function(p29) -- Line: 120, Name: toMegapascal
        return p29 / 10;
    end
};

function u30.toKilopascal(p31) -- Line: 123
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toAtmosphere(u30.toMegapascal(p31));
end;

function u30.toPascal(p32) -- Line: 126
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toPascal(u30.toMegapascal(p32));
end;

function u30.toAtmosphere(p33) -- Line: 129
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toAtmosphere(u30.toMegapascal(p33));
end;

function u30.toMillibar(p34) -- Line: 132
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toMillibar(u30.toMegapascal(p34));
end;

function u30.toPoundsPerSquareInch(p35) -- Line: 135
    -- upvalues: u7 (copy), u30 (copy)
    return u7.toPoundsPerSquareInch(u30.toMegapascal(p35));
end;

local u37 = {
    toMegapascal = function(p36) -- Line: 160, Name: toMegapascal
        return p36 / 145.038;
    end
};

function u37.toKilopascal(p38) -- Line: 163
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toAtmosphere(u37.toMegapascal(p38));
end;

function u37.toPascal(p39) -- Line: 166
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toPascal(u37.toMegapascal(p39));
end;

function u37.toAtmosphere(p40) -- Line: 169
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toAtmosphere(u37.toMegapascal(p40));
end;

function u37.toBar(p41) -- Line: 172
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toBar(u37.toMegapascal(p41));
end;

function u37.toMillibar(p42) -- Line: 175
    -- upvalues: u7 (copy), u37 (copy)
    return u7.toMillibar(u37.toMegapascal(p42));
end;

return {
    Megapascal = u7,
    Kilopascal = u9,
    Pascal = u16,
    Atmosphere = u23,
    Bar = u30,
    Millibar = {
        toMegapascal = function(p43) -- Line: 140, Name: toMegapascal
            return p43 / 10000;
        end,

        toKilopascal = function(p44) -- Line: 143, Name: toKilopascal
            -- upvalues: u7 (copy), u30 (copy)
            return u7.toAtmosphere(u30.toMegapascal(p44));
        end,

        toPascal = function(p45) -- Line: 146, Name: toPascal
            -- upvalues: u7 (copy), u30 (copy)
            return u7.toPascal(u30.toMegapascal(p45));
        end,

        toAtmosphere = function(p46) -- Line: 149, Name: toAtmosphere
            -- upvalues: u7 (copy), u30 (copy)
            return u7.toAtmosphere(u30.toMegapascal(p46));
        end,

        toBar = function(p47) -- Line: 152, Name: toBar
            -- upvalues: u7 (copy), u30 (copy)
            return u7.toBar(u30.toMegapascal(p47));
        end,

        toPoundsPerSquareInch = function(p48) -- Line: 155, Name: toPoundsPerSquareInch
            -- upvalues: u7 (copy), u30 (copy)
            return u7.toPoundsPerSquareInch(u30.toMegapascal(p48));
        end
    },
    PoundsPerSquareInch = u37
};