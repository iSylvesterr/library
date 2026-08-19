-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
local Symbol = require(Modules.Symbol);
local CreateDeepTraceback = require(Modules.CreateDeepTraceback);
require(script.Parent.Parent.Memory.Scope);
local New = Symbol.new("New");

function v1.__call(p2, p3, p4, p5) -- Line: 17
    -- upvalues: CreateDeepTraceback (copy)
    local v6 = nil;

    if typeof(p3) == "Instance" then
        v6 = p3;
    elseif typeof(p3) == "string" then
        v6 = Instance.new(p3);
    elseif typeof(p3) == "table" and p3.__SEAM_COMPONENT then
        v6 = nil;
    else
        error((`Invalid class type! Expected string or instance, got {typeof(p3)}: {CreateDeepTraceback()}`));
    end;

    if not v6 then
        return p3(p5, p4);
    end;

    for i, v in p4 do
        if typeof(i) == "table" then
            if i.__SEAM_INDEX then
                i(v6, v);
            else
                error((`Object hydration recieved invalid index type! Expected Seam object or string, got table ({v6:GetFullName()}); {CreateDeepTraceback()}`));
            end;
        elseif typeof(v) == "table" then
            if v.__SEAM_OBJECT then
                v(v6, i);
            else
                error((`Invalid property type! Expected Seam object or string, got table: {CreateDeepTraceback()}`));
            end;
        elseif typeof(i) == "number" then
            error((`Error when applying property to object, index is a number; {CreateDeepTraceback()}`));
        else
            v6[i] = v;
        end;
    end;

    return v6;
end;

function v1.__index(p7, p8) -- Line: 65
    -- upvalues: New (copy)
    if p8 == "__SEAM_OBJECT" then
        return New;
    end;

    return p8 == "__SEAM_CAN_BE_SCOPED" and true or nil;
end;

return setmetatable({}, v1);