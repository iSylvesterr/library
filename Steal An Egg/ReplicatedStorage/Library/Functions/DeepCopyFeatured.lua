-- Decompiled with Potassium's decompiler.

local function DeepCopy(p1, p2, p3, p4, p5, p6) -- Line: 1
    -- upvalues: DeepCopy (copy)
    if typeof(p1) ~= "table" then
        return p1;
    end;

    local v7 = p5 or {};
    local v8 = v7[p1];

    if v8 then
        return v8;
    end;

    local v9 = typeof(p2) == "table" and p2 and p2 or {};
    v7[p1] = v9;

    for i, v in p1 do
        if typeof(p4) ~= "table" or not (p3 and p4[i]) then
            if typeof(v) == "table" and not p3 then
                v9[i] = DeepCopy(v, nil, p3, p4, v7, true);
            else
                v9[i] = v;
            end;
        end;
    end;

    local v10 = getmetatable(p1);

    if typeof(v10) == "table" then
        setmetatable(v9, v10);
    end;

    if not p6 then
        table.clear(v7);
    end;

    return v9;
end;

return DeepCopy;