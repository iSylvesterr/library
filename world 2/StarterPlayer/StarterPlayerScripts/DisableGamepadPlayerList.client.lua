-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local StarterGui = game:GetService("StarterGui");
local UserInputService = game:GetService("UserInputService");

local function IsConsole() -- Line: 15
    -- upvalues: GuiService (copy), UserInputService (copy)
    if GuiService:IsTenFootInterface() then
        return true;
    end;

    return UserInputService.GamepadEnabled and not (UserInputService.KeyboardEnabled or UserInputService.MouseEnabled) and not UserInputService.TouchEnabled;
end;

while true do
    local v1;

    if GuiService:IsTenFootInterface() then
        v1 = true;
    else
        v1 = UserInputService.GamepadEnabled and not (UserInputService.KeyboardEnabled or UserInputService.MouseEnabled) and not UserInputService.TouchEnabled;
    end;

    if v1 then
        pcall(function() -- Line: 27
            -- upvalues: StarterGui (copy)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
        end);
    end;

    task.wait(0.5);
end;