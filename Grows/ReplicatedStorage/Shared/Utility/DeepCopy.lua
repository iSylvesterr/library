-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 3
    local v2 = {};
    local v3 = {};
    local v4 = {};

    for i, v in p1 do
        v2[#v2 + 1] = { v3, i, v };
    end;

    while #v2 > 0 do
        local v5 = v2[#v2];
        local v6 = v5[1];
        local v7 = v5[2];
        local v8 = v5[3];
        v2[#v2] = nil;

        if typeof(v8) == "table" then
            if v4[v8] then
                v6[v7] = v4[v8];
            else
                local v9 = {};
                v4[v8] = v9;
                v6[v7] = v9;

                for i, v in v8 do
                    v2[#v2 + 1] = { v9, i, v };
                end;
            end;
        else
            v6[v7] = v8;
        end;
    end;

    return v3;
end;