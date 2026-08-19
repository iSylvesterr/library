-- Decompiled with Potassium's decompiler.

return function(p1, ...) -- Line: 19, Name: removeIndices
    local v2 = #p1;
    local v3 = {};
    local v4 = {};

    for _, v in ipairs({ ... }) do
        if v < 1 then
            local v = v + v2;
        end;

        v3[v] = true;
    end;

    for i, v in ipairs(p1) do
        if not v3[i] then
            table.insert(v4, v);
        end;
    end;

    return v4;
end;