-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 20, Name: Unpack64
    if p1 >= 0 then
        return bit32.bor(p1 // 4294967296, 0), bit32.bor(p1, 0);
    end;

    local v2 = -1 - p1;

    return bit32.bnot(v2 // 4294967296), bit32.bnot(v2);
end;