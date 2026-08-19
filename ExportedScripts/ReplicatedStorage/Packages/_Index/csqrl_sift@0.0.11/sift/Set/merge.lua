-- Decompiled with Potassium's decompiler.

return function(...) -- Line: 20, Name: merge
    local v1 = {};

    for i = 1, select("#", ...) do
        local v2 = select(i, ...);

        if type(v2) == "table" then
            for i2, _ in pairs(v2) do
                v1[i2] = true;
            end;
        end;
    end;

    return v1;
end;