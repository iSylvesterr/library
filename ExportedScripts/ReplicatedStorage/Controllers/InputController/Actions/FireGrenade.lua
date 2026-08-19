-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local EquipInventorySlot = require(ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot);
local u1 = table.freeze({
    Molotov = true,
    ["Incendiary Grenade"] = true
});

return table.freeze({
    Name = "Fire Grenade",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p2, p3) -- Line: 29, Name: onInput
        -- upvalues: LocalPlayer (copy), CaseSceneController (copy), InspectController (copy), EquipInventorySlot (copy), u1 (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p2 ~= Enum.UserInputState.Begin then
            return;
        end;

        if CaseSceneController.IsActive() or InspectController.IsActive() then
            return;
        end;

        EquipInventorySlot(4, function(p4) -- Line: 34
            -- upvalues: u1 (ref)
            return u1[p4.Name] == true;
        end);
    end
});