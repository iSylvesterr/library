-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.deepCopy(p2) -- Line: 17
    -- upvalues: u1 (copy)
    if not p2 then
        return {};
    end;

    local v3 = {};

    for i, v in pairs(p2) do
        if type(v) == "table" then
            v3[i] = u1.deepCopy(v);
        else
            v3[i] = v;
        end;
    end;

    return v3;
end;

function u1.IsEqual(p4, p5) -- Line: 39
    -- upvalues: u1 (copy)
    if type(p4) ~= "table" or type(p5) ~= "table" then
        return p4 == p5;
    end;

    if p4 == nil and p5 == nil then
        return true;
    end;

    if p4 == nil or p5 == nil then
        return false;
    end;

    for i, v in pairs(p4) do
        if not u1.IsEqual(p5[i], v) then
            return false;
        end;
    end;

    for i in pairs(p5) do
        if p4[i] == nil then
            return false;
        end;
    end;

    return true;
end;

return u1;