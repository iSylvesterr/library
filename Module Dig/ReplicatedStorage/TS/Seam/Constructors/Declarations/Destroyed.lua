-- Decompiled with Potassium's decompiler.

local v1 = {};
local Destroyed = require(script.Parent.Parent.Parent.Modules.Symbol).new("Destroyed");

function v1.__call(p2, p3, p4) -- Line: 15
    p3.Destroying:Once(p4);
end;

function v1.__index(p5, p6) -- Line: 19
    -- upvalues: Destroyed (copy)
    if p6 == "__SEAM_INDEX" then
        return Destroyed;
    end;

    if p6 == "__SEAM_CAN_BE_SCOPED" then
        return false;
    end;

    return nil;
end;

return setmetatable({}, v1);