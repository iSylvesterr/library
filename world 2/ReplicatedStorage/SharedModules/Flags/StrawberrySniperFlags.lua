-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.StrawberrySniper.AimAssistPixelRadius", Asserts.FiniteNonNegative, 71);

return table.freeze({
    AimAssistPixelRadius = v1
});