-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = 0;

    for i = 1, #p1 do
        local v3 = bit32.lshift(v2, 8);
        v2 = bit32.bor(v3, string.byte(p1, i));
    end;

    return v2;
end;