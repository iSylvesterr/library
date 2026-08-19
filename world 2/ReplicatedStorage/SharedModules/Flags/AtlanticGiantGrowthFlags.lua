-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.AtlanticGiantGrowth.Coefficient", Asserts.FinitePositive, 0.0128);
local v2 = FastFlags.Replicated("Game.AtlanticGiantGrowth.Timescale", Asserts.FinitePositive, 1800);
local v3 = FastFlags.Replicated("Game.AtlanticGiantGrowth.Exponent", Asserts.FinitePositive, 2.55);
local v4 = FastFlags.Replicated("Game.AtlanticGiantGrowth.Enabled", Asserts.Boolean, true);
local v5 = FastFlags.Replicated("Game.AtlanticGiantGrowth.MaxMultiplier", Asserts.FinitePositive, 25);
local v6 = FastFlags.Replicated("Game.AtlanticGiantGrowth.VisualExponent", Asserts.FinitePositive, 0.548);

return table.freeze({
    Coefficient = v1,
    Timescale = v2,
    Exponent = v3,
    Enabled = v4,
    MaxMultiplier = v5,
    VisualExponent = v6
});