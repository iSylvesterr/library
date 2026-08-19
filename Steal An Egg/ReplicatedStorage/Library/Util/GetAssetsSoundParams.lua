-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 8
    if not p1 or p1 <= 0 then
        return 1, 1;
    end;

    local v2 = math.clamp(p1, 50, 480);
    local v3 = (math.log(v2) - 3.912023005428146) / 2.2617630984737906;

    return v3 * 0.5 + 2.5, v2 >= 80 and v2 <= 110 and 1 or 2 - v3 * 1.5;
end;