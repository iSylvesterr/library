-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    for _, v in ipairs(p2) do
        table.insert(p1, v);
    end;

    return p1;
end;