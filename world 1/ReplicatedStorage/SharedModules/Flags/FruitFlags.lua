-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Fruit.MaxCollidableExtentStuds", Asserts.FinitePositive, 60);

return table.freeze({
    MaxCollidableExtentStuds = v1
});