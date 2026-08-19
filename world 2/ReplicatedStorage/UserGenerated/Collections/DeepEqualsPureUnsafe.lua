-- Decompiled with Potassium's decompiler.

function DeepEqualsPureUnsafe(p1, p2)
    if rawequal(p1, p2) then
        return true;
    end;

    if type(p1) ~= "table" or type(p2) ~= "table" then
        return p1 ~= p1 and p2 ~= p2;
    end;

    if rawlen(p1) ~= rawlen(p2) then
        return false;
    end;

    if getmetatable(p1) ~= getmetatable(p2) then
        return false;
    end;

    for i, v in next, p1 do
        local v3 = rawget(p2, i);

        if v3 == nil or not DeepEqualsPureUnsafe(v, v3) then
            return false;
        end;
    end;

    for i, _ in next, p2 do
        if rawget(p1, i) == nil then
            return false;
        end;
    end;

    return true;
end;

return DeepEqualsPureUnsafe;