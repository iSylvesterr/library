-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = {};

    for _, v in pairs(p1) do
        table.insert(v2, v);
    end;

    return v2;
end;