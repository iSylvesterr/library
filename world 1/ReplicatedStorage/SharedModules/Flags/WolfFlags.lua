-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Private("Game.Pets.Wolf.MoonSpawnCountBySize", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Normal = 3,
    Big = 5,
    Huge = 8
});
local v2 = FastFlags.Private("Game.Pets.Wolf.MoonSpawnSpeciesWeights", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
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
local v3 = FastFlags.Private("Game.Pets.Wolf.MoonSpawnSpeciesWeightsFallHarvest", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Dog = 31.93,
    Hedgehog = 21.28,
    Turkey = 21.28,
    Squirrel = 12.77,
    Swan = 8.51,
    Wolf = 2.81,
    Fox = 1.4,
    ShadowDragon = 0.00395
});
local v4 = FastFlags.Private("Game.Pets.Wolf.MoonSpawnBigChance", Asserts.FiniteNonNegative, 0.005);
local v5 = FastFlags.Private("Game.Pets.Wolf.MoonSpawnHugeChance", Asserts.FiniteNonNegative, 0.00002);

return table.freeze({
    MoonSpawnCountBySize = v1,
    MoonSpawnSpeciesWeights = v2,
    MoonSpawnSpeciesWeightsFallHarvest = v3,
    MoonSpawnBigChance = v4,
    MoonSpawnHugeChance = v5
});