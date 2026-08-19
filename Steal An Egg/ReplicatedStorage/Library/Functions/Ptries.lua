-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = math.clamp(p1, 0, 1);
    assert(p2 >= 1);

    return 1 - (1 - v3) ^ p2;
end;