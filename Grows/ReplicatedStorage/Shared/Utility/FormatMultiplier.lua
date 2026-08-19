-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 4, Name: formatMultiplier
    local v2 = (tonumber(p1) or 0) * 100 + 0.5;
    local v3 = math.floor(v2) / 100;

    if v3 % 1 == 0 then
        return string.format("%d", v3);
    end;

    return string.format("%.2f", v3);
end;