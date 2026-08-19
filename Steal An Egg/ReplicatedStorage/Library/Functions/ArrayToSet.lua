-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = {};

    for _, v in ipairs(p1) do
        v2[v] = true;
    end;

    return v2;
end;