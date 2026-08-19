-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 14, Name: springCoefficients
    if p1 == 0 or p3 == 0 then
        return 1, 0, 0, 1;
    end;

    if p2 > 1 then
        local v4 = p1 * p3;
        local v5 = math.sqrt(p2 ^ 2 - 1);
        local v6 = -0.5 / v5;
        local v7 = -v5 - p2;
        local v8 = 1 / v7;
        local v9 = math.exp(v4 * v7);
        local v10 = math.exp(v4 * v8);

        return (v10 * v7 - v9 * v8) * v6, (v9 - v10) * v6 / p3, (v10 - v9) * v6 * p3, (v9 * v7 - v10 * v8) * v6;
    end;

    if p2 == 1 then
        local v11 = p1 * p3;
        local v12 = math.exp(-v11);

        return v12 * (v11 + 1), v12 * p1, v12 * (-v11 * p3), v12 * (1 - v11);
    end;

    local v13 = p1 * p3;
    local v14 = math.sqrt(1 - p2 ^ 2);
    local v15 = v14 * v13;
    local v16 = math.exp(-v13 * p2);
    local v17 = v16 * math.sin(v15);
    local v18 = v16 * math.cos(v15);
    local v19 = v17 * (1 / v14);
    local v20 = v19 * p2;

    return v20 + v18, v19, -(v20 * p2 + v17 * v14), v18 - v20;
end;