-- Decompiled with Potassium's decompiler.

local v1 = {};
local Tags = require(script.Parent.Parent.Parent.Modules.Symbol).new("Tags");

function v1.__call(p2, p3, p4) -- Line: 15
    for _, v in p4 do
        p3:AddTag(v);
    end;
end;

function v1.__index(p5, p6) -- Line: 21
    -- upvalues: Tags (copy)
    if p6 == "__SEAM_INDEX" then
        return Tags;
    end;

    if p6 == "__SEAM_CAN_BE_SCOPED" then
        return false;
    end;

    return nil;
end;

return setmetatable({}, v1);