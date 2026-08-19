-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);

return table.freeze({
    Name = "Last Weapon Used",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1, p2) -- Line: 21, Name: onInput
        -- upvalues: LocalPlayer (copy), CaseSceneController (copy), InspectController (copy), InventoryController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        if CaseSceneController.IsActive() or InspectController.IsActive() then
            return;
        end;

        local v3 = InventoryController.getPreviousEquipped();

        if v3 then
            local _, v4, v5 = InventoryController.getInventoryItemFromLoadout(v3.Identifier);

            if v4 and v5 then
                InventoryController.equip(v4, v5);
            end;
        else
            local v6 = InventoryController.getCurrentInventory();
            local v7 = InventoryController.getCurrentEquipped();

            if v6 and v7 then
                local v8 = nil;
                local v9 = nil;

                for _, v in ipairs(v6) do
                    if #v._items > 0 then
                        for i, v2 in ipairs(v._items) do
                            if v2.Identifier ~= v7.Identifier then
                                v8 = v2.Slot;
                                v9 = i;
                                break;
                            end;
                        end;
                    end;
                end;

                if v8 and v9 then
                    InventoryController.equip(v8, v9);
                end;
            end;
        end;
    end
});