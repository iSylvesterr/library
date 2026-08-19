-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 4
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3.BaseCost = p2.BaseCost or 100;
    v3.ScalingFactor = p2.ScalingFactor or 1.2;

    return v3;
end;

function u1.GetCost(p4, p5) -- Line: 11
    return p4.BaseCost * math.pow(p5, p4.ScalingFactor);
end;

return u1;