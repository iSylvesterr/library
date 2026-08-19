-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local logError = require(Parent.Logging.logError);
local xtypeof = require(Parent.Utility.xtypeof);

return function(u1) -- Line: 13, Name: Out
    -- upvalues: logError (copy), xtypeof (copy)
    return {
        type = "SpecialKey",
        kind = "Out",
        stage = "observer",

        apply = function(p2, u3, u4, p5) -- Line: 19, Name: apply
            -- upvalues: u1 (copy), logError (ref), xtypeof (ref)
            local success, result = pcall(u4.GetPropertyChangedSignal, u4, u1);

            if not success then
                logError("invalidOutProperty", nil, u4.ClassName, u1);

                return;
            end;

            if xtypeof(u3) ~= "State" or u3.kind ~= "Value" then
                logError("invalidOutType");

                return;
            end;

            u3:set(u4[u1]);
            table.insert(p5, result:Connect(function() -- Line: 29
                -- upvalues: u3 (copy), u4 (copy), u1 (ref)
                u3:set(u4[u1]);
            end));
            table.insert(p5, function() -- Line: 33
                -- upvalues: u3 (copy)
                u3:set(nil);
            end);
        end
    };
end;