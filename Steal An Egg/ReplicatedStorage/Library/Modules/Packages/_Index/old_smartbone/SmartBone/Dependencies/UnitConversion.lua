-- Decompiled with Potassium's decompiler.

local u1 = {
    Conversions = {
        Kilometer = 280.0336040324839,
        Hektometer = 28.00336040324839,
        Decameter = 2.800336040324839,
        Meter = 0.2800336040324839,
        Decimeter = 0.02800336040324839,
        Centimeter = 0.002800336040324839,
        Millimeter = 0.0002800336040324839,
        Miles = 4850.975973116774,
        Yards = 2.7562363483618033,
        Feet = 0.9187454494539344,
        Inches = 0.07656212078782787
    }
};

function u1.Convert(p2, p3) -- Line: 22
    -- upvalues: u1 (copy)
    local v4;

    if u1.Conversions[p3] == nil then
        v4 = false;
    else
        v4 = p2 * u1.Conversions[p3];
    end;

    return v4;
end;

function u1.ConvertInverse(p5, p6) -- Line: 26
    -- upvalues: u1 (copy)
    local v7;

    if u1.Conversions[p6] == nil then
        v7 = false;
    else
        v7 = u1.Conversions[p6] / p5;
    end;

    return v7;
end;

function u1.ConvertRounded(p8, p9) -- Line: 30
    -- upvalues: u1 (copy)
    local v10;

    if u1.Conversions[p9] == nil then
        v10 = false;
    else
        v10 = math.floor(p8 * u1.Conversions[p9]);
    end;

    return v10;
end;

return u1;