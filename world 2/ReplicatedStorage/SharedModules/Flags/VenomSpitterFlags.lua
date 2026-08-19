-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.VenomSpitter.SpitTravelSpeed", Asserts.FinitePositive, 80);
local v2 = FastFlags.Replicated("Game.VenomSpitter.SpitInterval", Asserts.FinitePositive, 3);
local v3 = FastFlags.Replicated("Game.VenomSpitter.SpitDamage", Asserts.FinitePositive, 30);
local v4 = FastFlags.Replicated("Game.VenomSpitter.SpitBurnDuration", Asserts.FinitePositive, 10);
local v5 = FastFlags.Replicated("Game.VenomSpitter.SpitBurnTicks", Asserts.IntegerPositive, 10);

return table.freeze({
    SpitTravelSpeed = v1,
    SpitInterval = v2,
    SpitDamage = v3,
    SpitBurnDuration = v4,
    SpitBurnTicks = v5
});