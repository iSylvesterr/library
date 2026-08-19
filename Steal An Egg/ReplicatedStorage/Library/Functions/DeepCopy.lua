-- Decompiled with Potassium's decompiler.

local function DeepCopy(p1, p2) -- Line: 1
    -- upvalues: DeepCopy (copy)
    if typeof(p1) ~= "table" then
        return p1;
    end;

    local v3 = p2 or {};
    local v4 = v3[p1];

    if v4 then
        return v4;
    end;

    local v5 = {};
    v3[p1] = v5;
    local v6 = #p1;

    if v6 > 0 then
        for i = 1, v6 do
            table.insert(v5, DeepCopy(p1[i], v3));
        end;
    else
        for i, v in next, p1 do
            v5[DeepCopy(i, v3)] = DeepCopy(v, v3);
        end;
    end;

    local v7 = getmetatable(p1);

    if v7 then
        setmetatable(v5, DeepCopy(v7, v3));
    end;

    return v5;
end;

return DeepCopy;