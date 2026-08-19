-- Decompiled with Potassium's decompiler.

local u1 = typeof;

return function(p2) -- Line: 5, Name: typeof
    -- upvalues: u1 (copy)
    local v3 = u1(p2);

    if v3 ~= "table" then
        return v3;
    end;

    local v4 = getmetatable(p2);

    if u1(v4) ~= "table" then
        return v3;
    end;

    local __type = v4.__type;

    if __type == nil then
        return v3;
    end;

    return __type;
end;