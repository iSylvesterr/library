-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local logError = require(Parent.Logging.logError);

local function getProperty_unsafe(p1, p2) -- Line: 12
    return p1[p2];
end;

return function(u3) -- Line: 16, Name: OnEvent
    -- upvalues: getProperty_unsafe (copy), logError (copy)
    return {
        type = "SpecialKey",
        kind = "OnEvent",
        stage = "observer",

        apply = function(p4, p5, p6, p7) -- Line: 22, Name: apply
            -- upvalues: getProperty_unsafe (ref), u3 (copy), logError (ref)
            local success, result = pcall(getProperty_unsafe, p6, u3);

            if not success or typeof(result) ~= "RBXScriptSignal" then
                logError("cannotConnectEvent", nil, p6.ClassName, u3);

                return;
            end;

            if typeof(p5) == "function" then
                table.insert(p7, result:Connect(p5));

                return;
            end;

            logError("invalidEventHandler", nil, u3);
        end
    };
end;