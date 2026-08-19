-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.PubTypes);

return function(p1) -- Line: 17, Name: updateAll
    local v2 = 0;
    local v3 = {};
    local v4 = {};
    local v5 = 1;
    local v6 = {};

    for i in p1.dependentSet do
        v2 = v2 + 1;
        v3[v2] = i;
        v4[i] = true;
    end;

    while v5 <= v2 do
        local v7 = v3[v5];
        local v8 = v6[v7];
        v6[v7] = v8 == nil and 1 or v8 + 1;

        if v7.dependentSet ~= nil then
            for i in v7.dependentSet do
                v2 = v2 + 1;
                v3[v2] = i;
            end;
        end;

        v5 = v5 + 1;
    end;

    local v9 = 1;

    while v9 <= v2 do
        local v10 = v3[v9];
        local v11 = v6[v10] - 1;
        v6[v10] = v11;

        if v11 == 0 and (v4[v10] and (v10:update() and v10.dependentSet ~= nil)) then
            for i in v10.dependentSet do
                v4[i] = true;
            end;
        end;

        v9 = v9 + 1;
    end;
end;