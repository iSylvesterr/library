-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = #p1;
    local v4 = table.clone(p1);

    for i, v in ipairs(v4) do
        v4[i] = table.clone(v);
    end;

    local v5 = table.clone(p2);

    for i = 1, v3 - 1 do
        local v6 = i;

        for i2 = i + 1, v3 do
            if math.abs(v4[i2][i]) > math.abs(v4[v6][i]) then
                v6 = i2;
            end;
        end;

        if i ~= v6 then
            local v7 = v4[i];
            v4[i] = v4[v6];
            v4[v6] = v7;
            local v8 = v5[i];
            v5[i] = v5[v6];
            v5[v6] = v8;
        end;

        for i2 = i + 1, v3 do
            local v9 = v4[i2][i] / v4[i][i];
            v5[i2] = v5[i2] - v9 * v5[i];

            for i3 = i, v3 do
                local v10 = v4[i2];
                v10[i3] = v10[i3] - v9 * v4[i][i3];
            end;
        end;
    end;

    local v11 = table.create(v3, 0);

    for i = v3, 1, -1 do
        v11[i] = v5[i];

        for i2 = i + 1, v3 do
            v11[i] = v11[i] - v4[i][i2] * v11[i2];
        end;

        v11[i] = v11[i] / v4[i][i];
    end;

    return v11;
end;