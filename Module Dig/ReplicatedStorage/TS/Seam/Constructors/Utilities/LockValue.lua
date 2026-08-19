-- Decompiled with Potassium's decompiler.

local v1 = {};
require(script.Parent.Parent.States.Value);

function v1.__call(p2, p3) -- Line: 11
    if typeof(p3) ~= "table" or (not p3.__SEAM_OBJECT or tostring(p3.__SEAM_OBJECT) ~= "Value") then
        error("You can only lock a value state");
    end;

    p3.__LOCKED = true;
end;

function v1.__index(p4, p5) -- Line: 19
    if p5 == "__SEAM_CAN_BE_SCOPED" then
        return false;
    end;

    return nil;
end;

return setmetatable({}, v1);