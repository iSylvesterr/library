-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 20, Name: Keys
    local v2 = {};

    for i, _ in pairs(p1) do
        table.insert(v2, i);
    end;

    return v2;
end;