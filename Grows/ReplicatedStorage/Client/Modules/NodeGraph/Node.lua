-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 18
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3.Data = p2;

    return v3;
end;

function u1.Destroy(p4) -- Line: 26
    p4.Data = nil;
end;

return u1;