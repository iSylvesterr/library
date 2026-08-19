-- Decompiled with Potassium's decompiler.

local u1 = { "k", "m", "b", "t", "q", "Qt", "Sx" };

return function(p2, p3, p4) -- Line: 11
    -- upvalues: u1 (copy)
    local v5 = p3 or 3;
    local v6 = math.abs(p2);
    local v7 = math.pow(10, -#u1 * 3);
    local v8 = math.max(v6, v7);
    local v9 = math.log10(v8);
    local v10 = math.ceil(v9);
    local v11 = 10 ^ (math.min(v10, #u1 * 3 + v5) - (p4 or 0) - v5);
    local v12 = math.round(v8 / v11) * v11;
    local v13 = math.max(v12, 1);
    local v14 = math.log10(v13) / 3;
    local v15 = math.floor(v14);
    local v16 = math.min(v15, #u1);
    local v17 = v12 * math.sign(p2) / 10 ^ (v16 * 3);
    local v18 = string.format("%f", v17):gsub("%.?0+$", "");

    if v16 >= 1 then
        return v18 .. u1[v16];
    end;

    return v18;
end;