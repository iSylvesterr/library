-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = 1 / (1 + 0.5 * p1);
    local v3 = v2 * math.exp(-p1 * p1 - 1.26551223 + v2 * (1.00002368 + v2 * (0.37409196 + v2 * (0.09678418 + v2 * (-0.18628806 + v2 * (0.27886807 + v2 * (-1.13520398 + v2 * (1.48851587 + v2 * (-0.82215223 + v2 * 0.17087277)))))))));

    if p1 >= 0 then
        return v3;
    end;

    return 2 - v3;
end;