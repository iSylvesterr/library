-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Private("Game.ConiferCone.SaplingDropEnabled", Asserts.Boolean, true);
local v2 = FastFlags.Private("Game.ConiferCone.PottedCanDrop", Asserts.Boolean, true);
local v3 = FastFlags.Private("Game.ConiferCone.TickInterval", Asserts.FinitePositive, 1);
local v4 = FastFlags.Private("Game.ConiferCone.BaseDropChancePerSecond", Asserts.Range(0, 1), 0.0015);
local v5 = FastFlags.Private("Game.ConiferCone.DropChanceDecayPerGeneration", Asserts.Range(0, 1), 0.2);
local v6 = FastFlags.Private("Game.ConiferCone.MaxSaplingsPerGeneration", Asserts.IntegerNonNegative, 3);
local v7 = FastFlags.Private("Game.ConiferCone.MaxGeneration", Asserts.IntegerPositive, 6);
local v8 = FastFlags.Private("Game.ConiferCone.SaplingMinSizeReduction", Asserts.Range(0, 1), 0.3);
local v9 = FastFlags.Private("Game.ConiferCone.SaplingMaxSizeReduction", Asserts.Range(0, 1), 0.7);
local v10 = FastFlags.Private("Game.ConiferCone.SaplingSizeReductionBias", Asserts.FinitePositive, 3);
local v11 = FastFlags.Private("Game.ConiferCone.SaplingDropRadius", Asserts.FinitePositive, 8);
local v12 = FastFlags.Private("Game.ConiferCone.SaplingMinPlantDistance", Asserts.FinitePositive, 2.5);
local v13 = FastFlags.Private("Game.ConiferCone.SaplingSpotAttempts", Asserts.IntegerPositive, 120);

return table.freeze({
    SaplingDropEnabled = v1,
    PottedCanDrop = v2,
    TickInterval = v3,
    BaseDropChancePerSecond = v4,
    DropChanceDecayPerGeneration = v5,
    MaxSaplingsPerGeneration = v6,
    MaxGeneration = v7,
    SaplingMinSizeReduction = v8,
    SaplingMaxSizeReduction = v9,
    SaplingSizeReductionBias = v10,
    SaplingDropRadius = v11,
    SaplingMinPlantDistance = v12,
    SaplingSpotAttempts = v13
});