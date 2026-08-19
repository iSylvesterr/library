-- Decompiled with Potassium's decompiler.

local v1 = {};
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ScriptContext = game:GetService("ScriptContext");

function v1.initClient() -- Line: 15
    -- upvalues: ScriptContext (copy), ReplicatedStorage (copy), GuiService (copy), UserInputService (copy)
    local Postie = require(script.Parent.GameAnalytics.Postie);
    ScriptContext.Error:Connect(function(p2, p3, u4) -- Line: 18
        -- upvalues: ReplicatedStorage (ref)
        if not u4 then
            return;
        end;

        local u5 = nil;
        local success, _ = pcall(function() -- Line: 24
            -- upvalues: u5 (ref), u4 (copy)
            u5 = u4:GetFullName();
        end);

        if not success then
            return;
        end;

        ReplicatedStorage.GameAnalyticsError:FireServer(p2, p3, u5);
    end);
    Postie.setCallback("getPlatform", function() -- Line: 35, Name: getPlatform
        -- upvalues: GuiService (ref), UserInputService (ref)
        return GuiService:IsTenFootInterface() and "Console" or (UserInputService.TouchEnabled and not UserInputService.MouseEnabled and "Mobile" or "Desktop");
    end);
end;

return v1;