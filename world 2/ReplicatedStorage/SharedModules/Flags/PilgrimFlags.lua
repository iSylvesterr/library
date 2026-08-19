-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Pilgrim.Enabled", Asserts.Boolean, true);
local v2 = FastFlags.Private("Game.Pilgrim.QuestsPerDay", Asserts.IntegerPositive, 5);
local v3 = FastFlags.Private("Game.Pilgrim.RewardCornucopiaName", Asserts.String, "Cornucopia");
local v4 = FastFlags.Private("Game.Pilgrim.RewardCornucopiaAmount", Asserts.IntegerPositive, 1);
local v5 = FastFlags.Private("Game.Pilgrim.ResetUtcOffsetHours", Asserts.Finite, -5);

return table.freeze({
    Enabled = v1,
    QuestsPerDay = v2,
    RewardCornucopiaName = v3,
    RewardCornucopiaAmount = v4,
    ResetUtcOffsetHours = v5
});