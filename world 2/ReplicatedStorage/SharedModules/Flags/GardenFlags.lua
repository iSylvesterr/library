-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Garden.ExpansionPriceOverrides", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {});

return table.freeze({
    ExpansionPriceOverrides = v1
});