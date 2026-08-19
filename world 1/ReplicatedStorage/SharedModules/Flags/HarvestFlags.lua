-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Harvest.ClientCollectInterval", Asserts.FinitePositive, 0.025);
local v2 = FastFlags.Replicated("Game.Harvest.ClientCollectCooldown", Asserts.FinitePositive, 0.025);
local v3 = FastFlags.Replicated("Game.Harvest.ClientCollectRampStartInterval", Asserts.FinitePositive, 0.2);
local v4 = FastFlags.Replicated("Game.Harvest.ClientCollectRampEndInterval", Asserts.FinitePositive, 0.02);
local v5 = FastFlags.Replicated("Game.Harvest.ClientCollectRampDuration", Asserts.FiniteNonNegative, 3);

return table.freeze({
    ClientCollectInterval = v1,
    ClientCollectCooldown = v2,
    ClientCollectRampStartInterval = v3,
    ClientCollectRampEndInterval = v4,
    ClientCollectRampDuration = v5
});