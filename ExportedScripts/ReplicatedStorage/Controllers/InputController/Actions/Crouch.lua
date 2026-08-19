-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting"):Connect(function() -- Line: 17
    -- upvalues: LocalPlayer (copy), CharacterController (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        CharacterController.crouch(false);
    end;
end);

return table.freeze({
    Name = "Crouch",
    Group = "Gameplay",
    Category = "Movement Keys",

    Callback = function(p1, p2) -- Line: 26, Name: onInput
        -- upvalues: LocalPlayer (copy), CharacterController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 == Enum.UserInputState.Begin then
            CharacterController.crouch(true);

            return;
        end;

        if p1 ~= Enum.UserInputState.End then
            return;
        end;

        CharacterController.crouch(false);
    end
});