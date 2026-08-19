-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 20, Name: fromArray
    local v2 = table.create(#p1);

    for _, v in ipairs(p1) do
        v2[v] = true;
    end;

    return v2;
end;