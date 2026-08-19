-- Decompiled with Potassium's decompiler.

local function DeepEquals(p1, p2, p3) -- Line: 1
    -- upvalues: DeepEquals (copy)
    if p1 == p2 then
        return true;
    end;

    if type(p1) ~= "table" or type(p2) ~= "table" then
        return false;
    end;

    local v4 = p3 or {};
    v4[p1] = v4[p1] or {};

    if v4[p1][p2] then
        return true;
    end;

    v4[p2] = v4[p2] or {};

    if v4[p2][p1] then
        return true;
    end;

    v4[p1][p2] = true;
    v4[p2][p1] = true;
    local v5 = getmetatable(p1);

    if v5 and v5.__eq then
        return p1 == p2;
    end;

    local v6 = getmetatable(p2);

    if v6 and v6.__eq then
        return p1 == p2;
    end;

    if #p1 ~= #p2 then
        return false;
    end;

    for i, v in pairs(p1) do
        local v7 = p2[i];

        if v7 == nil or not DeepEquals(v, v7, v4) then
            return false;
        end;
    end;

    for i, v in pairs(p2) do
        local v8 = p1[i];

        if v8 == nil or not DeepEquals(v, v8, v4) then
            return false;
        end;
    end;

    return true;
end;

return DeepEquals;