-- Decompiled with Potassium's decompiler.

local function deepEquals(p1, p2) -- Line: 1
    -- upvalues: deepEquals (copy)
    if p1 == p2 then
        return true;
    end;

    if type(p1) ~= "table" or type(p2) ~= "table" then
        return p1 ~= p1 and p2 ~= p2;
    end;

    if #p1 ~= #p2 then
        return false;
    end;

    for i, v in next, p1 do
        local v3 = p2[i];

        if v3 == nil or not deepEquals(v, v3) then
            return false;
        end;
    end;

    for i, v in next, p2 do
        local v4 = p1[i];

        if v4 == nil or not deepEquals(v, v4) then
            return false;
        end;
    end;

    return true;
end;

return deepEquals;