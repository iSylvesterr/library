-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 20, Name: FormatMultiplier
    local v3 = type(p1) == "number";
    assert(v3);
    local v4;

    if p2 == nil then
        v4 = true;
    elseif type(p2) == "number" and p2 >= 0 then
        v4 = math.floor(p2) == p2;
    else
        v4 = false;
    end;

    assert(v4);

    if p1 ~= p1 then
        return "NaN";
    end;

    if p1 == (1 / 0) then
        return "Infinity";
    end;

    if p1 == (-1 / 0) then
        return "-Infinity";
    end;

    local v5 = p2 or 2;

    if v5 > 0 then
        return string.format(`%0.{v5}f`, p1):gsub("(%d)%.?0+$", "%1");
    end;

    local v6 = math.round(p1);

    return tostring(v6);
end;