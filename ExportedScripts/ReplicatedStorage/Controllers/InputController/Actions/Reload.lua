-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local HintController = require(ReplicatedStorage.Controllers.HintController);

return table.freeze({
    Name = "Reload",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1, p2) -- Line: 20, Name: onInput
        -- upvalues: LocalPlayer (copy), InventoryController (copy), HintController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        local v3 = InventoryController.getCurrentEquipped();

        if not v3 then
            return;
        end;

        v3:reload();
        HintController:clearHint("Reload");
    end
});