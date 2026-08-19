-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RoundFigures = require(script.Parent.RoundFigures);
local Asserts = require(ReplicatedStorage.Library.Asserts);

function commasFull(p1)
    -- upvalues: Asserts (copy)
    Asserts.string(p1);
    local v2;

    if p1:sub(1, 1) == "-" then
        p1 = p1:sub(2);
        v2 = "-";
    else
        v2 = "";
    end;

    local v3 = 1;
    local v4 = #p1 % 3;

    if v4 > 0 then
        v2 = v2 .. p1:sub(v3, v3 + v4 - 1);
        v3 = v3 + v4;
    end;

    while v3 <= #p1 do
        if v3 > 1 then
            v2 = v2 .. ",";
        end;

        v2 = v2 .. p1:sub(v3, v3 + 2);
        v3 = v3 + 3;
    end;

    return v2;
end;

function formatFigures(p5, p6, p7)
    -- upvalues: Asserts (copy), RoundFigures (copy)
    Asserts.number(p5);
    Asserts.optional.number(p6);
    Asserts.optional.number(p7);

    if p5 ~= p5 then
        return "NaN";
    end;

    if p5 == (1 / 0) then
        return "Infinity";
    end;

    if p5 == (-1 / 0) then
        return "-Infinity";
    end;

    local v8 = RoundFigures(p5, p6, p7);
    local v9, v10 = string.format("%f", v8):match("([^%.]*)%.?(.*)");
    local v11 = commasFull(v9);

    if not v10 then
        return v11;
    end;

    local v12 = v10:gsub("0+$", "");

    if #v12 == 0 then
        return v11;
    end;

    return string.format("%s.%s", v11, v12);
end;

return formatFigures;