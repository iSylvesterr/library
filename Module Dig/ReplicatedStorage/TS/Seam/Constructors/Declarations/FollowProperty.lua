-- Decompiled with Potassium's decompiler.

local v1 = {};
local Modules = script.Parent.Parent.Parent.Modules;
require(Modules.Types);
local FollowProperty = require(Modules.Symbol).new("FollowProperty");

function v1.__call(p2, u3) -- Line: 16
    -- upvalues: FollowProperty (copy)
    return setmetatable({}, {
        __call = function(p4, u5, u6) -- Line: 18, Name: __call
            -- upvalues: u3 (copy)
            u5:GetPropertyChangedSignal(u3):Connect(function() -- Line: 21
                -- upvalues: u5 (copy), u3 (ref), u6 (copy)
                if u5[u3] ~= u6.Value then
                    u6.Value = u5[u3];
                end;

                u6.Value = u5[u3];
            end);
        end,

        __index = function(p7, p8) -- Line: 30, Name: __index
            -- upvalues: FollowProperty (ref)
            if p8 == "__SEAM_INDEX" then
                return FollowProperty;
            end;

            if p8 == "__SEAM_CAN_BE_SCOPED" then
                return false;
            end;

            return nil;
        end
    });
end;

return setmetatable({}, v1);