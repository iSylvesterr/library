-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = 0;

    for _, v in pairs(p1) do
        v2 = v2 + v;
    end;

    return v2;
end;