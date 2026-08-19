-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    while p2 ~= 0 do
        local v3 = p1 % p2;
        p1 = p2;
        p2 = v3;
    end;

    return p1;
end;