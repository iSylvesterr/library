-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local ItemRain = require(ReplicatedStorage.Library.Client.RewardFeedback.ItemRain);
local Item = require(ReplicatedStorage.Library.Client.NotificationCmds.Item);
local SpeedPowerItem = require(ReplicatedStorage.Library.Items.SpeedPowerItem);

return {
    Show = function(p1) -- Line: 22, Name: Show
        -- upvalues: Asserts (copy), SpeedPowerItem (copy), ItemRain (copy), Item (copy)
        Asserts.number(p1);
        assert(p1 > 0, "Expected positive speed reward amount");
        local v2 = SpeedPowerItem():SetAmount((math.round(p1)));
        ItemRain.Play("rbxassetid://99458650446228");
        Item.Bottom({
            Item = v2
        });
    end
};