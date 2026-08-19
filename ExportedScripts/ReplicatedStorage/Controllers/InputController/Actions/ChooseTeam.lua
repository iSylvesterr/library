-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection);

return table.freeze({
    Name = "Choose Team",
    Group = "Default",
    Category = "UI Keys",

    Callback = function(p1, p2) -- Line: 19, Name: onInput
        -- upvalues: LocalPlayer (copy), TeamSelection (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        local v3 = LocalPlayer:GetAttribute("IsSpectating");
        local v4 = LocalPlayer:GetAttribute("Team");

        if v4 ~= "Counter-Terrorists" and v4 ~= "Terrorists" and v3 ~= true then
            return;
        end;

        if v3 then
            TeamSelection.openFrame();

            return;
        end;

        if not LocalPlayer.Character then
            return;
        end;

        TeamSelection.ToggleTeamSelection();
    end
});