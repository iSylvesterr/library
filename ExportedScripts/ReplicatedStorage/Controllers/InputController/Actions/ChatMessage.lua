-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
local u1 = nil;

return table.freeze({
    Name = "Chat Message",
    Group = "Default",
    Category = "Communication Options",

    Callback = function(p2, p3) -- Line: 15, Name: OnInput
        -- upvalues: u1 (ref), ReplicatedStorage (copy)
        if p2 ~= Enum.UserInputState.Begin then
            return;
        end;

        if not u1 then
            u1 = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Chat);
        end;

        u1.OpenChat(1);
    end
});