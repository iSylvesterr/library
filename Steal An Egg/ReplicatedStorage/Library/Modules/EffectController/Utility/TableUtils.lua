-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.deepCopy(p2) -- Line: 3
    -- upvalues: u1 (copy)
    if typeof(p2) ~= "table" then
        return p2;
    end;

    local v3 = {};

    for i, v in pairs(p2) do
        v3[i] = u1.deepCopy(v);
    end;

    return v3;
end;

function u1.deepEquals(p4, p5) -- Line: 15
    -- upvalues: u1 (copy)
    if typeof(p4) ~= "table" or typeof(p5) ~= "table" then
        return p4 == p5;
    end;

    for i, v in pairs(p4) do
        if not u1.deepEquals(v, p5[i]) then
            return false;
        end;
    end;

    for i, v in pairs(p5) do
        if not u1.deepEquals(v, p4[i]) then
            return false;
        end;
    end;

    return true;
end;

function u1.getDictionaryLength(p6) -- Line: 33
    local v7 = 0;

    for _ in pairs(p6) do
        v7 = v7 + 1;
    end;

    return v7;
end;

return u1;