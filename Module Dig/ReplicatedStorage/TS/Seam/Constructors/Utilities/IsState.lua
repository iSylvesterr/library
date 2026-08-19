-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = { "Spring", "Tween", "ComputedInstance", "RenderedInstance", "Value" };

function v1.__call(p3, p4) -- Line: 11
    -- upvalues: u2 (copy)
    if typeof(p4) ~= "table" then
        return false;
    end;

    if p4.__SEAM_OBJECT then
        return table.find(u2, (tostring(p4.__SEAM_OBJECT))) and true or false;
    end;

    return false;
end;

function v1.__index(p5, p6) -- Line: 27
    if p6 == "__SEAM_CAN_BE_SCOPED" then
        return false;
    end;

    return nil;
end;

return setmetatable({}, v1);