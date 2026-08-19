-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Private("Game.Weather.Eclipse.Duration", Asserts.FinitePositive, 150);
local v2 = FastFlags.Private("Game.Weather.Eclipse.BeamIntervalMin", Asserts.FinitePositive, 5);
local v3 = FastFlags.Private("Game.Weather.Eclipse.BeamIntervalMax", Asserts.FinitePositive, 20);
local v4 = FastFlags.Private("Game.Weather.Eclipse.BeamSpeed", Asserts.FinitePositive, 1000);

return table.freeze({
    Duration = v1,
    BeamIntervalMin = v2,
    BeamIntervalMax = v3,
    BeamSpeed = v4
});