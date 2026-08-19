-- Decompiled with Potassium's decompiler.

local StarterGui = game:GetService("StarterGui");
local Window = require(script.Parent.CmdrInterface.Window);

return function(p1) -- Line: 4
    -- upvalues: StarterGui (copy), Window (copy)
    p1:HandleEvent("Message", function(p2) -- Line: 5
        -- upvalues: StarterGui (ref)
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = ("[Announcement] %s"):format(p2),
            Color = Color3.fromRGB(249, 217, 56)
        });
    end);
    p1:HandleEvent("AddLine", function(...) -- Line: 12
        -- upvalues: Window (ref)
        Window:AddLine(...);
    end);
end;