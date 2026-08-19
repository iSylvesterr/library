-- Decompiled with Potassium's decompiler.

function Por(p1, p2)
    local v3 = math.clamp(p1, 0, 1);
    local v4 = math.clamp(p2, 0, 1);

    return v3 + v4 - v3 * v4;
end;

return Por;