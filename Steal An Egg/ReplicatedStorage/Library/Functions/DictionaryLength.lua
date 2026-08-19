-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = 0;

    for _ in pairs(p1) do
        v2 = v2 + 1;
    end;

    return v2;
end;