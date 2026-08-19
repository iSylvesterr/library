-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Private("Game.AmberCranberry.RipeMutationChance", Asserts.Range(0, 1), 0.05);

return table.freeze({
    RipeMutationChance = v1
});