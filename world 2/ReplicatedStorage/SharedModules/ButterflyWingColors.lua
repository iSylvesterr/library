-- Decompiled with Potassium's decompiler.

local u1 = {
    {
        Weight = 0.7,
        Color = Color3.fromRGB(0, 170, 255)
    },
    {
        Weight = 0.25,
        Color = Color3.fromRGB(170, 85, 255)
    },
    {
        Weight = 0.04,
        Color = Color3.fromRGB(255, 200, 0)
    },
    {
        Weight = 0.01,
        Color = Color3.fromRGB(255, 0, 0)
    }
};
local u2 = {};

local function HashUID(p3) -- Line: 22
    local v4 = 5381;

    for i = 1, #p3 do
        local v5 = string.byte(p3, i);
        v4 = (v4 * 33 + v5) % 4294967296;
    end;

    return v4;
end;

function u2.GetColorForUID(p6) -- Line: 33
    -- upvalues: u1 (copy)
    local v7 = 5381;

    for i = 1, #p6 do
        local v8 = string.byte(p6, i);
        v7 = (v7 * 33 + v8) % 4294967296;
    end;

    local v9 = v7 / 4294967296;
    local v10 = 0;

    for _, v in u1 do
        v10 = v10 + v.Weight;

        if v9 < v10 then
            return v.Color;
        end;
    end;

    return u1[1].Color;
end;

function u2.ApplyToModel(p11, p12) -- Line: 49
    -- upvalues: u2 (copy)
    if type(p12) ~= "string" or p12 == "" then
        return;
    end;

    local v13 = u2.GetColorForUID(p12);

    for _, descendant in p11:GetDescendants() do
        if (descendant.Name == "WingLeftColor" or descendant.Name == "WingRightColor") and descendant:IsA("BasePart") then
            descendant.Color = v13;
        end;
    end;
end;

return table.freeze(u2);