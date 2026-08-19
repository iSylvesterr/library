-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local AdminMessages = require(ReplicatedStorage.Library.Globals.Constants).NETWORK_MAP.AdminMessages;
Network.Fired(AdminMessages.SHOW_MESSAGE):Connect(function(p1, p2) -- Line: 9
    -- upvalues: Message (copy)
    Message.Top({
        ShowShadow = true,
        Message = p1,
        Time = p2,
        Color = Color3.new(1, 1, 1)
    });
end);