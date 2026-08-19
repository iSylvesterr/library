-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Private("Game.Honeysuckle.BoostMultiplier", Asserts.FinitePositive, 1.25);
local v2 = FastFlags.Private("Game.Honeysuckle.BoostDuration", Asserts.FinitePositive, 10);
local v3 = FastFlags.Private("Game.Honeysuckle.Cooldown", Asserts.FinitePositive, 60);

return table.freeze({
    BoostMultiplier = v1,
    BoostDuration = v2,
    Cooldown = v3
});