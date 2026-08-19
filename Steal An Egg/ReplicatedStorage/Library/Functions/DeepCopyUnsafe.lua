-- Decompiled with Potassium's decompiler.

local function deepCopy(p1) -- Line: 1
    -- upvalues: deepCopy (copy)
    if type(p1) ~= "table" then
        return p1;
    end;

    local v2 = {};
    local v3 = #p1;

    if v3 > 0 then
        for i = 1, v3 do
            table.insert(v2, deepCopy(p1[i]));
        end;

        return v2;
    end;

    for i, v in next, p1 do
        v2[deepCopy(i)] = deepCopy(v);
    end;

    return v2;
end;

return deepCopy;