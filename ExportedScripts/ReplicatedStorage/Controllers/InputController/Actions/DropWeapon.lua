-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Router = require(ReplicatedStorage.Database.Security.Router);

return table.freeze({
    Name = "Drop Weapon",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1, p2) -- Line: 29, Name: onInput
        -- upvalues: LocalPlayer (copy), SpectateController (copy), InventoryController (copy), Skins (copy), Rarities (copy), Router (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        if SpectateController.IsLocalPlayerDead() then
            return;
        end;

        local v3 = InventoryController.getCurrentEquipped();

        if not v3 then
            return;
        end;

        local v4 = Skins.GetSkinInformation(v3.Name, v3.Skin);

        if v4 then
            local v5 = Rarities[v4.rarity];
            local v6 = math.floor(v5.Color.R * 255);
            local v7 = math.floor(v5.Color.G * 255);
            local v8 = math.floor(v5.Color.B * 255);

            if v3:drop() then
                Router.broadcastRouter("CreateNotification", "Item Dropped", `You dropped your <font color = "rgb({v6}, {v7}, {v8})"><b>{v3.Name:find("Zeus") and "Taser" or v3.Name} | {v3.Skin}</b></font>`, 2);
            end;
        end;
    end
});