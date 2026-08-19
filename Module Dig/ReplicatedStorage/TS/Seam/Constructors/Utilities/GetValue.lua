-- Decompiled with Potassium's decompiler.

local v1 = {};
local IsState = require(script.Parent.IsState);

function v1.__call(p2, p3) -- Line: 11
    -- upvalues: IsState (copy)
    if p3 == nil then
        return nil;
    end;

    if not IsState(p3) then
        return p3;
    end;

    if tostring(p3.__SEAM_OBJECT) == "Value" then
        return p3.ValueRaw;
    end;

    return p3.Value;
end;

function v1.__index(p4, p5) -- Line: 30
    if p5 == "__SEAM_CAN_BE_SCOPED" then
        return false;
    end;

    return nil;
end;

return setmetatable({}, v1);