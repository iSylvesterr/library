-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local LocalPlayer = Players.LocalPlayer;
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);

return table.freeze({
    Name = "Main Menu",
    Group = "Default",
    Category = "UI Keys",

    Callback = function(p1, p2) -- Line: 22, Name: onInput
        -- upvalues: LocalPlayer (copy), CloseButtonRegistry (copy), Top (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p2.KeyCode == Enum.KeyCode.ButtonB and (CloseButtonRegistry.CloseFrame() or CloseButtonRegistry.IsDoublePressed()) then
            return;
        end;

        local v3 = LocalPlayer:GetAttribute("IsSpectating");
        local v4 = LocalPlayer:GetAttribute("Team");

        if v4 ~= "Counter-Terrorists" and v4 ~= "Terrorists" and v3 ~= true then
            return;
        end;

        if p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        Top.ToggleMenu();
    end
});