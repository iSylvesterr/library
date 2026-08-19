-- Decompiled with Potassium's decompiler.

local u5 = {
    toKilometersPerHour = function(p1) -- Line: 31, Name: toKilometersPerHour
        return p1 * 3.6;
    end,

    toMilesPerHour = function(p2) -- Line: 34, Name: toMilesPerHour
        return p2 * 2.23694;
    end,

    toFeetPerSecond = function(p3) -- Line: 37, Name: toFeetPerSecond
        return p3 * 3.28084;
    end,

    toKnot = function(p4) -- Line: 40, Name: toKnot
        return p4 * 1.94384;
    end
};
local u7 = {
    toMetersPerSecond = function(p6) -- Line: 45, Name: toMetersPerSecond
        return p6 / 3.6;
    end
};

function u7.toMilesPerHour(p8) -- Line: 48
    -- upvalues: u5 (copy), u7 (copy)
    return u5.toMilesPerHour(u7.toMetersPerSecond(p8));
end;

function u7.toFeetPerSecond(p9) -- Line: 51
    -- upvalues: u5 (copy), u7 (copy)
    return u5.toFeetPerSecond(u7.toMetersPerSecond(p9));
end;

function u7.toKnot(p10) -- Line: 54
    -- upvalues: u5 (copy), u7 (copy)
    return u5.toKnot(u7.toMetersPerSecond(p10));
end;

local u12 = {
    toMetersPerSecond = function(p11) -- Line: 59, Name: toMetersPerSecond
        return p11 / 2.23694;
    end
};

function u12.toKilometersPerHour(p13) -- Line: 62
    -- upvalues: u5 (copy), u12 (copy)
    return u5.toKilometersPerHour(u12.toMetersPerSecond(p13));
end;

function u12.toFeetPerSecond(p14) -- Line: 65
    -- upvalues: u5 (copy), u12 (copy)
    return u5.toFeetPerSecond(u12.toMetersPerSecond(p14));
end;

function u12.toKnot(p15) -- Line: 68
    -- upvalues: u5 (copy), u12 (copy)
    return u5.toKnot(u12.toMetersPerSecond(p15));
end;

local u17 = {
    toMetersPerSecond = function(p16) -- Line: 73, Name: toMetersPerSecond
        return p16 / 3.28084;
    end
};

function u17.toKilometersPerHour(p18) -- Line: 76
    -- upvalues: u5 (copy), u17 (copy)
    return u5.toKilometersPerHour(u17.toMetersPerSecond(p18));
end;

function u17.toMilesPerHour(p19) -- Line: 79
    -- upvalues: u5 (copy), u17 (copy)
    return u5.toMilesPerHour(u17.toMetersPerSecond(p19));
end;

function u17.toKnot(p20) -- Line: 82
    -- upvalues: u5 (copy), u17 (copy)
    return u5.toKnot(u17.toMetersPerSecond(p20));
end;

return {
    MetersPerSecond = u5,
    KilometersPerHour = u7,
    MilesPerHour = u12,
    FeetPerSecond = u17,
    Knot = {
        toMetersPerSecond = function(p21) -- Line: 87, Name: toMetersPerSecond
            return p21 / 1.94384;
        end,

        toKilometersPerHour = function(p22) -- Line: 90, Name: toKilometersPerHour
            -- upvalues: u5 (copy), u17 (copy)
            return u5.toKilometersPerHour(u17.toMetersPerSecond(p22));
        end,

        toMilesPerHour = function(p23) -- Line: 93, Name: toMilesPerHour
            -- upvalues: u5 (copy), u17 (copy)
            return u5.toMilesPerHour(u17.toMetersPerSecond(p23));
        end,

        toFeetPerSecond = function(p24) -- Line: 96, Name: toFeetPerSecond
            -- upvalues: u5 (copy), u17 (copy)
            return u5.toFeetPerSecond(u17.toMetersPerSecond(p24));
        end
    }
};