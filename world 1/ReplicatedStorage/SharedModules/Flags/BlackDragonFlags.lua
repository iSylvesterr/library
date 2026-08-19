-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.BlackDragon.EatChancePerSecond", Asserts.FiniteNonNegative, 0.035);
local v2 = FastFlags.Replicated("Game.BlackDragon.EatCooldownSeconds", Asserts.FiniteNonNegative, 8);
local v3 = FastFlags.Replicated("Game.BlackDragon.EatBigMultiplier", Asserts.FinitePositive, 1.25);
local v4 = FastFlags.Replicated("Game.BlackDragon.EatHugeMultiplier", Asserts.FinitePositive, 2);
local v5 = FastFlags.Replicated("Game.BlackDragon.EatRainbowMultiplier", Asserts.FinitePositive, 1.25);
local v6 = FastFlags.Replicated("Game.BlackDragon.FruitToLayEgg", Asserts.FinitePositive, 8);
local v7 = FastFlags.Replicated("Game.BlackDragon.PreferBestFruit", Asserts.Boolean, false);
local v8 = FastFlags.Replicated("Game.BlackDragon.CrossGardenEating.PreferBestFruit", Asserts.Boolean, true);
local v9 = FastFlags.Replicated("Game.BlackDragon.LayDelayMin", Asserts.FiniteNonNegative, 10);
local v10 = FastFlags.Replicated("Game.BlackDragon.LayDelayMax", Asserts.FiniteNonNegative, 30);
local v11 = FastFlags.Replicated("Game.BlackDragon.GroundIdleDuration", Asserts.FiniteNonNegative, 2);
local v12 = FastFlags.Replicated("Game.BlackDragon.PostLayTakeoffDelay", Asserts.FiniteNonNegative, 0.5);
local v13 = FastFlags.Replicated("Game.BlackDragon.EggDespawnSeconds", Asserts.FinitePositive, 180);
local v14 = FastFlags.Replicated("Game.BlackDragon.LaySoundVolume", Asserts.FiniteNonNegative, 3);
local v15 = FastFlags.Replicated("Game.BlackDragon.SpotAttempts", Asserts.FinitePositive, 50);
local v16 = FastFlags.Replicated("Game.BlackDragon.PlantAvoidRadius", Asserts.FinitePositive, 4);
local v17 = FastFlags.Replicated("Game.BlackDragon.CrossGardenEating.Enabled", Asserts.Boolean, true);

return table.freeze({
    EatChancePerSecond = v1,
    EatCooldownSeconds = v2,
    PreferBestFruit = v7,
    CrossGardenPreferBestFruit = v8,
    EatBigMultiplier = v3,
    EatHugeMultiplier = v4,
    EatRainbowMultiplier = v5,
    FruitToLayEgg = v6,
    LayDelayMin = v9,
    LayDelayMax = v10,
    GroundIdleDuration = v11,
    PostLayTakeoffDelay = v12,
    EggDespawnSeconds = v13,
    LaySoundVolume = v14,
    SpotAttempts = v15,
    PlantAvoidRadius = v16,
    CrossGardenEatingEnabled = v17
});