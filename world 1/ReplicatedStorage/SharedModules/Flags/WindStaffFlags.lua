-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Private("Game.Tools.WindStaff.FallTornadoDuration", Asserts.FinitePositive, 10);

return table.freeze({
    FallTornadoDuration = v1
});