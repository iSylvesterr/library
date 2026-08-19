-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 3
    if p1 < 0 then
        p1 = p1 + math.ceil(-p1 / 6.283185307179586) * 6.283185307179586;
    end;

    return p1 % 6.283185307179586;
end;