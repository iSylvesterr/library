-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
require(Modules.Types);
local FollowAttribute = require(Modules.Symbol).new("FollowAttribute");

function v1.__call(p2, u3) -- Line: 16
    -- upvalues: FollowAttribute (copy)
    return setmetatable({}, {
        __call = function(p4, u5, u6) -- Line: 18, Name: __call
            -- upvalues: u3 (copy)
            u5:GetAttributeChangedSignal(u3):Connect(function() -- Line: 21
                -- upvalues: u5 (copy), u3 (ref), u6 (copy)
                if u5:GetAttribute(u3) ~= u6.Value then
                    u6.Value = u5:GetAttribute(u3);
                end;

                u6.Value = u5:GetAttribute(u3);
            end);
        end,

        __index = function(p7, p8) -- Line: 30, Name: __index
            -- upvalues: FollowAttribute (ref)
            if p8 == "__SEAM_INDEX" then
                return FollowAttribute;
            end;

            if p8 == "__SEAM_CAN_BE_SCOPED" then
                return false;
            end;

            return nil;
        end
    });
end;

return setmetatable({}, v1);