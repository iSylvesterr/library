-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;

return table.freeze({
    Name = "Toggle Inventory Display",
    Group = "Gameplay",
    Category = "Movement Keys",

    Callback = function(p1, p2) -- Line: 15, Name: onInput
        -- upvalues: LocalPlayer (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
        end;
    end
});