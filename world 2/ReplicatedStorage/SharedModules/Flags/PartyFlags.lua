-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.AdminParty.Enabled", Asserts.Boolean, false);
local v2 = FastFlags.Replicated("Game.AdminParty.StartAtUnix", Asserts.FiniteNonNegative, 0);
local v3 = FastFlags.Replicated("Game.AdminParty.ConfettiOnPoints", Asserts.Boolean, true);
local v4 = FastFlags.Replicated("Game.AdminParty.HatFlyOnPoints", Asserts.Boolean, true);
local v5 = FastFlags.Replicated("Game.AdminParty.RevealOnTick", Asserts.Boolean, true);

return table.freeze({
    Enabled = v1,
    StartAtUnix = v2,
    ConfettiOnPoints = v3,
    HatFlyOnPoints = v4,
    RevealOnTick = v5
});