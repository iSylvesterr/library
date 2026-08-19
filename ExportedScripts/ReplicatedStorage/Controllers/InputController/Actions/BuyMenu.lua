-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu);

return table.freeze({
    Name = "Buy Menu",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1, p2) -- Line: 19, Name: onInput
        -- upvalues: LocalPlayer (copy), BuyMenu (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        local Character = LocalPlayer.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid");

            if Humanoid and Humanoid.Health > 0 then
                BuyMenu.toggleFrame();
            end;
        end;
    end
});