-- Decompiled with Potassium's decompiler.

function DeepEqualsPure(p1, p2, p3)
    if type(p1) ~= "table" or type(p2) ~= "table" then
        return rawequal(p1, p2) and true or p1 ~= p1 and p2 ~= p2;
    end;

    local v4 = p3 or {};

    if v4[p1] or v4[p2] then
        return false;
    end;

    if rawequal(p1, p2) then
        return true;
    end;

    if rawlen(p1) ~= rawlen(p2) then
        return false;
    end;

    if getmetatable(p1) ~= getmetatable(p2) then
        return false;
    end;

    v4[p1] = true;
    v4[p2] = true;

    for i, v in next, p1 do
        local v5 = rawget(p2, i);

        if v5 == nil or not DeepEqualsPure(v, v5, v4) then
            return false;
        end;
    end;

    for i, _ in next, p2 do
        if rawget(p1, i) == nil then
            return false;
        end;
    end;

    v4[p1] = nil;
    v4[p2] = nil;

    return true;
end;

return DeepEqualsPure;