-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local logError = require(Parent.Logging.logError);

return function(u1) -- Line: 12, Name: OnChange
    -- upvalues: logError (copy)
    return {
        type = "SpecialKey",
        kind = "OnChange",
        stage = "observer",

        apply = function(p2, u3, u4, p5) -- Line: 18, Name: apply
            -- upvalues: u1 (copy), logError (ref)
            local success, result = pcall(u4.GetPropertyChangedSignal, u4, u1);

            if not success then
                logError("cannotConnectChange", nil, u4.ClassName, u1);

                return;
            end;

            if typeof(u3) == "function" then
                table.insert(p5, result:Connect(function() -- Line: 25
                    -- upvalues: u3 (copy), u4 (copy), u1 (ref)
                    u3(u4[u1]);
                end));

                return;
            end;

            logError("invalidChangeHandler", nil, u1);
        end
    };
end;