-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RoundFigures = require(ReplicatedStorage.UserGenerated.Math.RoundFigures);
local StableExp10 = require(ReplicatedStorage.UserGenerated.Math.StableExp10);
local TrimmedNumberString = require(ReplicatedStorage.UserGenerated.Strings.TrimmedNumberString);
local u1 = { "", "k", "m", "b", "t", "q", "Qt", "Sx", "Sp", "o", "n", "d", "u", "Du", "Tr" };

return function(p2) -- Line: 66, Name: FormatAbbreviated
    -- upvalues: u1 (copy), StableExp10 (copy), RoundFigures (copy), TrimmedNumberString (copy)
    local v3 = type(p2) == "number";
    assert(v3);

    if p2 ~= p2 then
        return "NaN";
    end;

    if p2 == (1 / 0) then
        return "Infinity";
    end;

    if p2 == (-1 / 0) then
        return "-Infinity";
    end;

    local v4 = {};

    if p2 < 0 then
        table.insert(v4, "-");
        p2 = -p2;
    end;

    local v5 = math.floor(p2);

    if v5 >= 1000 then
        local v6 = math.log10(v5) / 3;
        local v7 = math.floor(v6) + 1;
        local v8 = math.clamp(v7, 1, #u1);
        local v9 = RoundFigures(StableExp10(v5, (v8 - 1) * -3), 3, nil, math.floor);
        table.insert(v4, TrimmedNumberString(v9));
        table.insert(v4, u1[v8]);
    else
        table.insert(v4, TrimmedNumberString(v5));
    end;

    return table.concat(v4);
end;