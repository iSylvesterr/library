-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.GuildChat.Enabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.GuildFeed.Enabled", Asserts.Boolean, true);
local v3 = FastFlags.Replicated("Game.GuildFeed.GiftingEnabled", Asserts.Boolean, true);
local v4 = FastFlags.Replicated("Game.GuildFeed.GiftingMaxGoal", Asserts.Integer, 10);

return table.freeze({
    ChatEnabled = v1,
    GuildFeedEnabled = v2,
    GiftingEnabled = v3,
    GiftingMaxGoal = v4
});