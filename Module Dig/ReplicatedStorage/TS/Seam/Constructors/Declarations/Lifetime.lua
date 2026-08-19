-- Decompiled with Potassium's decompiler.

local v1 = {};
local Debris = game:GetService("Debris");
local Lifetime = require(script.Parent.Parent.Parent.Modules.Symbol).new("Lifetime");

function v1.__call(p2, p3, p4) -- Line: 18
    -- upvalues: Debris (copy)
    Debris:AddItem(p3, p4);
end;

function v1.__index(p5, p6) -- Line: 25
    -- upvalues: Lifetime (copy)
    if p6 == "__SEAM_INDEX" then
        return Lifetime;
    end;

    if p6 == "__SEAM_CAN_BE_SCOPED" then
        return false;
    end;

    return nil;
end;

return setmetatable({}, v1);