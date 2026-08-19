-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LocalPlayer = Players.LocalPlayer;
LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting"):Connect(function() -- Line: 18
    -- upvalues: LocalPlayer (copy), CharacterController (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        CharacterController.walk(false);
    end;
end);

local function IsCharacterAlive(p1) -- Line: 27
    local Character = p1.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local v2 = Character:FindFirstChildOfClass("Humanoid");

        if v2 and v2.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

return table.freeze({
    Name = "Walk",
    Group = "Default",
    Category = "Movement Keys",

    Callback = function(p3, p4) -- Line: 40, Name: onInput
        -- upvalues: LocalPlayer (copy), DataController (copy), CharacterController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v5;

        if Character and Character:IsDescendantOf(workspace) then
            local v6 = Character:FindFirstChildOfClass("Humanoid");
            v5 = v6 and v6.Health > 0 and true or false;
        else
            v5 = false;
        end;

        if not v5 then
            return;
        end;

        local v7 = DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Walk Mode");

        if ((not v7 or v7 == "") and "Hold" or v7) == "Toggle" then
            if p3 ~= Enum.UserInputState.Begin then
                return;
            end;

            local v8 = CharacterController.GetWalkState() or false;
            CharacterController.walk(not v8);

            return;
        end;

        if p3 == Enum.UserInputState.Begin then
            CharacterController.walk(true);

            return;
        end;

        if p3 ~= Enum.UserInputState.End then
            return;
        end;

        CharacterController.walk(false);
    end
});