-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FormatOdds = require(ReplicatedStorage.UserGenerated.Strings.FormatOdds);
local FormatPercent = require(ReplicatedStorage.UserGenerated.Strings.FormatPercent);

return function(p1, p2) -- Line: 31, Name: FormatChance
    -- upvalues: FormatOdds (copy), FormatPercent (copy)
    local v3 = type(p1) == "number";
    assert(v3);
    local v4 = p2 == nil and true or type(p2) == "number";
    assert(v4);
    local v5 = math.clamp(p1, 0, 1);
    local v6 = math.clamp(p2 or v5, 0, 1);

    if v5 > 0 and (v6 <= 0.0002 and v5 <= 0.001) then
        return FormatOdds(v5);
    end;

    return FormatPercent(v5);
end;