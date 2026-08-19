-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 20, Name: shift
    local v3 = {};

    for i = type(p2) ~= "number" and 2 or p2 + 1, #p1 do
        table.insert(v3, p1[i]);
    end;

    return v3;
end;