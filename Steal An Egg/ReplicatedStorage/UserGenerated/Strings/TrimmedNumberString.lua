-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 20, Name: TrimmedNumberString
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

    local v3 = string.format("%f", p1);
    local v4, v5 = string.match(v3, "^([^%.]*)%.?(.*)$");
    assert(v4);

    if not v5 then
        return v4;
    end;

    local v6 = string.gsub(v5, "0+$", "");

    if #v6 == 0 then
        return v4;
    end;

    return `{v4}.{v6}`;
end;