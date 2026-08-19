-- Decompiled with Potassium's decompiler.

local u1 = { "k", "m", "b", "t", "q", "Qt", "Sx", "Sp", "o", "n", "d", "u", "Du", "Tr" };

return function(p2, p3, p4) -- Line: 38, Name: FormatAbbreviated
    -- upvalues: u1 (copy)
    local v5 = type(p2) == "number";
    assert(v5);
    local v6 = p3 == nil and true or type(p3) == "number";
    assert(v6);
    local v7 = p4 == nil and true or type(p4) == "number";
    assert(v7);

    if p2 ~= p2 then
        return "NaN";
    end;

    if p2 == (1 / 0) then
        return "Infinity";
    end;

    if p2 == (-1 / 0) then
        return "-Infinity";
    end;

    local v8 = p3 or 3;
    local v9 = math.abs(p2);
    local v10 = math.pow(10, -#u1 * 3);
    local v11 = math.max(v9, v10);
    local v12 = math.log10(v11);
    local v13 = math.ceil(v12);
    local v14 = 10 ^ (math.min(v13, #u1 * 3 + v8) - (p4 or 0) - v8);
    local v15 = math.round(v11 / v14) * v14;
    local v16 = math.max(v15, 1);
    local v17 = math.log10(v16) / 3;
    local v18 = math.floor(v17);
    local v19 = math.min(v18, #u1);
    local v20 = v15 * math.sign(p2) / 10 ^ (v19 * 3);
    local v21 = string.format("%f", v20):gsub("%.?0+$", "");

    if v19 >= 1 then
        return v21 .. u1[v19];
    end;

    return v21;
end;