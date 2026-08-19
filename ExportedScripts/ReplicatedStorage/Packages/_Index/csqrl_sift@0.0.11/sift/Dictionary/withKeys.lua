-- Decompiled with Potassium's decompiler.

return function(p1, ...) -- Line: 19, Name: withKeys
    local v2 = {};

    for _, v in ipairs({ ... }) do
        v2[v] = p1[v];
    end;

    return v2;
end;