-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;

return table.freeze({
    Name = "Health Shot",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1, p2) -- Line: 16, Name: onInput
        -- upvalues: LocalPlayer (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
        end;
    end
});