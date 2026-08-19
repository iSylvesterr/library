-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 17, Name: reverse
    local v2 = {};

    for i = #p1, 1, -1 do
        table.insert(v2, p1[i]);
    end;

    return v2;
end;