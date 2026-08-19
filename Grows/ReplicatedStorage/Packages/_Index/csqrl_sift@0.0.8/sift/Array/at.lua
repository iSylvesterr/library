-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 19, Name: at
    local v3 = #p1;

    if p2 < 1 then
        p2 = p2 + v3;
    end;

    return p1[p2];
end;