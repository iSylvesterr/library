-- Decompiled with Potassium's decompiler.

require(script.Parent:WaitForChild("Node"));
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4) -- Line: 24
    -- upvalues: u1 (copy)
    local v5 = setmetatable({}, u1);
    v5.Node0 = p2;
    v5.Node1 = p3;
    v5.Weight = p4;

    return v5;
end;

function u1.HasNode(p6, p7) -- Line: 34
    return p7 == p6.Node0 and true or p7 == p6.Node1;
end;

return u1;