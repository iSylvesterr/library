-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.StarFruit.BeamCount", Asserts.IntegerPositive, 1);
local v2 = FastFlags.Replicated("Game.StarFruit.BeamDelayMin", Asserts.FinitePositive, 5);
local v3 = FastFlags.Replicated("Game.StarFruit.BeamDelayMax", Asserts.FinitePositive, 10);

return table.freeze({
    BeamCount = v1,
    BeamDelayMin = v2,
    BeamDelayMax = v3
});