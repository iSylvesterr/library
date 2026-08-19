-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9, Name: xtypeof
    local v2 = typeof(p1);

    if v2 == "table" and typeof(p1.type) == "string" then
        return p1.type;
    end;

    return v2;
end;