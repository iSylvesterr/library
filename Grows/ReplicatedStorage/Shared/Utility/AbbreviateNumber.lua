-- Decompiled with Potassium's decompiler.

local u1 = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "De" };

return function(p2) -- Line: 6, Name: abbreviate
    -- upvalues: u1 (copy)
    local v3 = tonumber(p2) or 0;
    local v4 = v3 < 0;
    local v5 = math.abs(v3);

    if v5 < 1000 then
        local v6 = math.floor(v5 + 0.5);
        local v7 = tostring(v6);

        if v4 then
            v7 = "-" .. v7 or v7;
        end;

        return v7;
    end;

    local v8 = 0;

    while v5 >= 1000 and v8 < #u1 - 1 do
        v5 = v5 / 1000;
        v8 = v8 + 1;
    end;

    if v5 >= 999.995 and v8 < #u1 - 1 then
        v5 = v5 / 1000;
        v8 = v8 + 1;
    end;

    return (v4 and "-" or "") .. string.format("%.2f", v5):gsub("%.00$", "") .. u1[v8 + 1];
end;