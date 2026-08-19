-- Decompiled with Potassium's decompiler.

return function(...) -- Line: 20, Name: intersection
    local v1 = select("#", ...);
    local v2 = select(1, ...);
    local v3 = {};

    for i, _ in pairs(v2) do
        local v4 = true;

        for i2 = 2, v1 do
            if select(i2, ...)[i] ~= true then
                v4 = false;
                break;
            end;
        end;

        if v4 then
            v3[i] = true;
        end;
    end;

    return v3;
end;