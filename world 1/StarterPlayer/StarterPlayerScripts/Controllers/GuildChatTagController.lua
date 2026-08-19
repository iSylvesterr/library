-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
local GuildChatTag = require(script.GuildChatTag);

return {
    StartOrder = 5,

    Init = function(p1) -- Line: 10, Name: Init
        -- upvalues: GuildChatTag (copy)
        GuildChatTag.Install();
    end
};