-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local LocalPlayer = Players.LocalPlayer;

return table.freeze({
    Name = "Jump",
    Group = "Gameplay",
    Category = "Movement Keys",

    Callback = function(p1, p2) -- Line: 19, Name: onInput
        -- upvalues: LocalPlayer (copy), CharacterController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 == Enum.UserInputState.Begin then
            CharacterController.jump();
        end;
    end
});