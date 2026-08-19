-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FormatFiguresFloor = require(ReplicatedStorage.Library.Functions.FormatFiguresFloor);
local Commas = require(ReplicatedStorage.Library.Functions.Commas);
local NiceExp10 = require(ReplicatedStorage.Library.Functions.NiceExp10);
local u1 = { "", "k", "m", "b", "t", "q", "Qt", "Sx", "Sp", "o", "n", "d", "u", "Du", "Tr" };

return function(p2, p3, p4, p5) -- Line: 24
    -- upvalues: Commas (copy), u1 (copy), FormatFiguresFloor (copy), NiceExp10 (copy)
    if p2 ~= p2 then
        return "NaN";
    end;

    if p2 == (1 / 0) then
        return "Infinity";
    end;

    if p2 == (-1 / 0) then
        return "-Infinity";
    end;

    local v6 = p5 == nil and true or p5;
    local v7;

    if p2 < 0 then
        p2 = -p2;
        v7 = "-";
    else
        v7 = "";
    end;

    local v8 = math.floor(p2);

    if v8 < (p4 or 1000) then
        return v7 .. (v6 and Commas(v8) or tostring(v8));
    end;

    local v9 = math.log10(v8) / 3;
    local v10 = math.floor(v9) + 1;
    local v11 = math.clamp(v10, 1, #u1);

    return v7 .. FormatFiguresFloor(NiceExp10(v8, (v11 - 1) * -3), 3, nil, v6) .. u1[v11];
end;