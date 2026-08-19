-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Guild.LocalContestsEnabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.Guild.GardenRankBadgeMaxRank", Asserts.IntegerNonNegative, 99);

return table.freeze({
    LocalContestsEnabled = v1,
    GardenRankBadgeMaxRank = v2
});