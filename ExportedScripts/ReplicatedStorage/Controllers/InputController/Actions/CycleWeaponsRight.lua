-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local EquipSlotRight = require(ReplicatedStorage.Components.Common.UserInput.EquipSlotRight);
local HintController = require(ReplicatedStorage.Controllers.HintController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Leaderboard = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard);

return table.freeze({
    Name = "Cycle Weapons Right",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1, p2) -- Line: 26, Name: onInput
        -- upvalues: LocalPlayer (copy), MenuState (copy), CaseSceneController (copy), InspectController (copy), Leaderboard (copy), EquipSlotRight (copy), HintController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") or p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        if MenuState.GetCurrentScreen() or (CaseSceneController.IsActive() or (InspectController.IsActive() or Leaderboard.IsRightClickUnlockActive() and p2.UserInputType == Enum.UserInputType.MouseWheel)) then
            return;
        end;

        EquipSlotRight();
        HintController:clearHint("Reload");
    end
});