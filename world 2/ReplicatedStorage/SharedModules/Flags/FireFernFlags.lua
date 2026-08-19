-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.FireFern.Radius", Asserts.FinitePositive, 20);
local v2 = FastFlags.Replicated("Game.FireFern.RadiusMax", Asserts.FinitePositive, 30);
local v3 = FastFlags.Replicated("Game.FireFern.Damage", Asserts.FinitePositive, 2.5);
local v4 = FastFlags.Replicated("Game.FireFern.Tick", Asserts.FinitePositive, 1);
local v5 = FastFlags.Replicated("Game.FireFern.Vertical", Asserts.FinitePositive, 15);
local v6 = FastFlags.Replicated("Game.FireFern.Cooldown", Asserts.FiniteNonNegative, 1);
local v7 = FastFlags.Replicated("Game.FireFern.RingInterval", Asserts.FinitePositive, 0.6);
local v8 = FastFlags.Replicated("Game.FireFern.BurnDuration", Asserts.FinitePositive, 5);

return table.freeze({
    FireFernRadius = v1,
    FireFernRadiusMax = v2,
    FireFernDamage = v3,
    FireFernTick = v4,
    FireFernVertical = v5,
    FireFernCooldown = v6,
    FireFernRingInterval = v7,
    FireFernBurnDuration = v8
});