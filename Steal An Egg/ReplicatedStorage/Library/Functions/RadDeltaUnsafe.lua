-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = p1 - p2;

    if v3 > 3.141592653589793 then
        return v3 - 6.283185307179586;
    end;

    if v3 < -3.141592653589793 then
        v3 = v3 + 6.283185307179586;
    end;

    return v3;
end;