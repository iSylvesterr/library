-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = {};

    for i, v in pairs(p1) do
        if p2(v) then
            v3[i] = v;
        end;
    end;

    return v3;
end;