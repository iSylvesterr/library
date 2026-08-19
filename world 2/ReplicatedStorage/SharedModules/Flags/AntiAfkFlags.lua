-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.AntiAfk.Enabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.AntiAfk.IdleSeconds", Asserts.FinitePositive, 1140);

return table.freeze({
    Enabled = v1,
    IdleSeconds = v2
});