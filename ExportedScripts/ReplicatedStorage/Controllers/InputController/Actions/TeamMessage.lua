-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;

return table.freeze({
    Name = "Team Message",
    Group = "Default",
    Category = "Communication Options",

    Callback = function(p2, p3) -- Line: 19, Name: OnInput
        -- upvalues: u1 (ref), ReplicatedStorage (copy), LocalPlayer (copy)
        if p2 ~= Enum.UserInputState.Begin then
            return;
        end;

        if not u1 then
            u1 = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat);
        end;

        local v4 = LocalPlayer:GetAttribute("Team");
        u1.OpenChat((not v4 or v4 == "Spectators") and 1 or 0);
    end
});