-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
require(ReplicatedStorage.Controllers.InventoryController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot);

return table.freeze({
    Name = "Cycle Grenades",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1, p2) -- Line: 24, Name: onInput
        -- upvalues: LocalPlayer (copy), CaseSceneController (copy), InspectController (copy), EquipInventorySlot (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        if CaseSceneController.IsActive() or InspectController.IsActive() then
            return;
        end;

        EquipInventorySlot(4);
    end
});