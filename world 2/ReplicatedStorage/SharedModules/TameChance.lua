-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {
    Common = 2,
    Uncommon = 0.5,
    Rare = 0.2,
    Epic = 0.05,
    Legendary = 0.01,
    Mythic = 0.004,
    Super = 0.001,
    Secret = 0.0002
};

function v1.GetMultiplier(p3) -- Line: 17
    -- upvalues: u2 (copy)
    return u2[p3] or 0;
end;

function v1.GetMaxProgress() -- Line: 21
    return 100;
end;

function v1.ComputeProgress(p4, p5) -- Line: 29
    -- upvalues: u2 (copy)
    local v6 = u2[p4];

    if not v6 then
        return 0;
    end;

    if type(p5) ~= "number" or p5 <= 0 then
        return 0;
    end;

    local v7 = p5 * v6;

    return v7 < 0.25 and 0.25 or v7;
end;

local function formatTrimmed(p8) -- Line: 40
    local v9 = math.floor(p8 * 100 + 0.5) / 100;

    if v9 == math.floor(v9) then
        return string.format("%d", (math.floor(v9)));
    end;

    local v10 = string.format("%.2f", v9);

    return string.gsub(v10, "0$", "");
end;

function v1.FormatPercent(p11) -- Line: 52
    -- upvalues: formatTrimmed (copy)
    local v12 = (type(p11) ~= "number" or p11 < 0) and 0 or p11;

    return formatTrimmed(v12 > 100 and 100 or v12) .. "% Tamed";
end;

function v1.FormatGain(p13) -- Line: 59
    -- upvalues: formatTrimmed (copy)
    return (type(p13) ~= "number" or p13 <= 0) and "+0% Tamed!" or "+" .. formatTrimmed(p13) .. "% Tamed!";
end;

return v1;