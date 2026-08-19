-- Decompiled with Potassium's decompiler.

local FloorFigures = require(script.Parent.FloorFigures);

local function insertCommas(p1) -- Line: 3
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

function FormatFiguresFloor(p5, p6, p7, p8)
    -- upvalues: FloorFigures (copy), insertCommas (copy)
    if p5 ~= p5 then
        return "NaN";
    end;

    if p5 == (1 / 0) then
        return "Infinity";
    end;

    if p5 == (-1 / 0) then
        return "-Infinity";
    end;

    local v9 = FloorFigures(p5, p6, p7);
    local v10, v11 = string.format("%f", v9):match("([^%.]*)%.?(.*)");

    if p8 then
        v10 = insertCommas(v10);
    end;

    if not v11 then
        return v10;
    end;

    local v12 = v11:gsub("0+$", "");

    if #v12 == 0 then
        return v10;
    end;

    return ("%s.%s"):format(v10, v12);
end;

return FormatFiguresFloor;