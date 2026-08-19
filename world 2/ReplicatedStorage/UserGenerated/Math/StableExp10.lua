-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 25, Name: StableExp10
    local v3 = type(p1) == "number";
    assert(v3);
    local v4 = type(p2) == "number";
    assert(v4);

    if p2 == 0 then
        return p1;
    end;

    local v5 = `{string.format("%f", p1)}e{p2}`;

    return tonumber(v5) or p1 * 10 ^ p2;
end;