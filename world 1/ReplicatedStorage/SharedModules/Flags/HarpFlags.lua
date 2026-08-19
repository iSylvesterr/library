-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Private("Game.Tools.Harp.SpawnCount", Asserts.FiniteNonNegative, 5);
local v2 = FastFlags.Private("Game.Tools.Harp.SpawnSpeciesWeights", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Frog = 32.65,
    Bunny = 32.65,
    Owl = 19.59,
    Deer = 5.88,
    Robin = 3.92,
    Bee = 3.26,
    Unicorn = 0.643,
    Firefly = 0.543,
    GoldenDragonfly = 0.353,
    Bear = 0.204,
    BaldEagle = 0.204,
    Monkey = 0.0905,
    Raccoon = 0.0132
});
local v3 = FastFlags.Private("Game.Tools.Harp.SpawnSpeciesWeightsFallHarvest", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Dog = 31.93,
    Hedgehog = 21.28,
    Turkey = 21.28,
    Squirrel = 12.77,
    Swan = 8.51,
    Wolf = 2.81,
    Fox = 1.4,
    ShadowDragon = 0.00395
});
local v4 = FastFlags.Private("Game.Tools.Harp.SpawnBigChance", Asserts.FiniteNonNegative, 0.005);
local v5 = FastFlags.Private("Game.Tools.Harp.SpawnHugeChance", Asserts.FiniteNonNegative, 0.00002);

return table.freeze({
    SpawnCount = v1,
    SpawnSpeciesWeights = v2,
    SpawnSpeciesWeightsFallHarvest = v3,
    SpawnBigChance = v4,
    SpawnHugeChance = v5
});