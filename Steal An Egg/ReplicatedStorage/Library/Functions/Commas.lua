-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = type(p1) == "number";
    assert(v2);

    if p1 ~= p1 then
        return "NaN";
    end;

    if p1 == (1 / 0) then
        return "Infinity";
    end;

    if p1 == (-1 / 0) then
        return "-Infinity";
    end;

    local v3;

    if p1 < 0 then
        p1 = -p1;
        v3 = "-";
    else
        v3 = "";
    end;

    local v4 = math.round(p1);
    local v5 = tostring(v4);
    local v6 = 1;
    local v7 = #v5 % 3;

    if v7 > 0 then
        v3 = v3 .. v5:sub(v6, v6 + v7 - 1);
        v6 = v6 + v7;
    end;

    while v6 <= #v5 do
        if v6 > 1 then
            v3 = v3 .. ",";
        end;

        v3 = v3 .. v5:sub(v6, v6 + 2);
        v6 = v6 + 3;
    end;

    return v3;
end;