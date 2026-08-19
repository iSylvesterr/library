-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 4
    local v3 = {};

    for _, v in ipairs(p1) do
        table.insert(v3, v);
    end;

    for _, v in ipairs(p2) do
        table.insert(v3, v);
    end;

    return v3;
end;