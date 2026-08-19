-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local u1 = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls();

local function IsCharacterAlive(p2) -- Line: 21
    local Character = p2.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local v3 = Character:FindFirstChildOfClass("Humanoid");

        if v3 and v3.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

return table.freeze({
    Name = "Move Left (Strafe)",
    Group = "Default",
    Category = "Movement Keys",

    Callback = function(p4, p5) -- Line: 34, Name: onInput
        -- upvalues: LocalPlayer (copy), u1 (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v6;

        if Character and Character:IsDescendantOf(workspace) then
            local v7 = Character:FindFirstChildOfClass("Humanoid");
            v6 = v7 and v7.Health > 0 and true or false;
        else
            v6 = false;
        end;

        if not v6 then
            return;
        end;

        local activeController = u1.activeController;

        if not activeController then
            return;
        end;

        if not activeController.UpdateMovement then
            return;
        end;

        activeController.leftValue = p4 == Enum.UserInputState.Begin and -1 or 0;
        activeController:UpdateMovement(p4);
    end
});