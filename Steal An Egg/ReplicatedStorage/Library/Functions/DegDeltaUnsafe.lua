-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = p1 - p2;

    if v3 > 180 then
        return v3 - 360;
    end;

    if v3 < -180 then
        return v3 + 360;
    end;

    return v3;
end;