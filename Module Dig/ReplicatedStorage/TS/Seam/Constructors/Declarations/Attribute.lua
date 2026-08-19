-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
require(Modules.Types);
local Attribute = require(Modules.Symbol).new("Attribute");

function v1.__call(p2, u3) -- Line: 16
    -- upvalues: Attribute (copy)
    return setmetatable({}, {
        __call = function(p4, u5, u6) -- Line: 18, Name: __call
            -- upvalues: u3 (copy)
            if typeof(u6) ~= "table" or not u6.__SEAM_OBJECT then
                u5:SetAttribute(u3, u6);

                return;
            end;

            u6.Changed:Connect(function() -- Line: 23
                -- upvalues: u5 (copy), u3 (ref), u6 (copy)
                u5:SetAttribute(u3, u6.Value);
            end);
            u5:SetAttribute(u3, u6.Value);
        end,

        __index = function(p7, p8) -- Line: 36, Name: __index
            -- upvalues: Attribute (ref)
            if p8 == "__SEAM_INDEX" then
                return Attribute;
            end;

            return nil;
        end
    });
end;

function v1.__index(p9, p10) -- Line: 48
    if p10 == "__SEAM_CAN_BE_SCOPED" then
        return false;
    end;

    return nil;
end;

return setmetatable({}, v1);