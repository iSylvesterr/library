-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Werewolf.Enabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.Werewolf.AfkIdleSeconds", Asserts.FinitePositive, 120);

return table.freeze({
    Enabled = v1,
    AfkIdleSeconds = v2
});