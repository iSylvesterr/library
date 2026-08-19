-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Postie = require(script.Postie);
game:GetService("ScriptContext").Error:Connect(function(p1, p2, u3) -- Line: 11
    -- upvalues: ReplicatedStorage (copy)
    if not u3 then
        return;
    end;

    local u4 = nil;
    local success, _ = pcall(function() -- Line: 17
        -- upvalues: u4 (ref), u3 (copy)
        u4 = u3:GetFullName();
    end);

    if not success then
        return;
    end;

    ReplicatedStorage.GameAnalyticsError:FireServer(p1, p2, u4);
end);
Postie.setCallback("getPlatform", function() -- Line: 28, Name: getPlatform
    -- upvalues: GuiService (copy), UserInputService (copy)
    return GuiService:IsTenFootInterface() and "Console" or (UserInputService.TouchEnabled and not UserInputService.MouseEnabled and "Mobile" or "Desktop");
end);