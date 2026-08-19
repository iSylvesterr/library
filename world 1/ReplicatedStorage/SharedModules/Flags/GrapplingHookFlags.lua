-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.GrapplingHook.PullSpeed", Asserts.FinitePositive, 50);
local v2 = FastFlags.Replicated("Game.GrapplingHook.TipTravelSpeed", Asserts.FinitePositive, 50);
local v3 = FastFlags.Replicated("Game.GrapplingHook.ServerMaxDistance", Asserts.FinitePositive, 120);
local v4 = FastFlags.Replicated("Game.GrapplingHook.ClientMaxDistance", Asserts.FinitePositive, 100);
local v5 = FastFlags.Replicated("Game.GrapplingHook.ReleaseDistance", Asserts.FinitePositive, 8);
local v6 = FastFlags.Replicated("Game.GrapplingHook.Cooldown", Asserts.FinitePositive, 10);
local v7 = FastFlags.Replicated("Game.GrapplingHook.PullStartDelay", Asserts.FiniteNonNegative, 0.1);
local v8 = FastFlags.Replicated("Game.GrapplingHook.TimeoutBuffer", Asserts.FinitePositive, 1);
local v9 = FastFlags.Replicated("Game.GrapplingHook.StuckMinProgress", Asserts.FinitePositive, 2);
local v10 = FastFlags.Replicated("Game.GrapplingHook.StuckWindow", Asserts.FinitePositive, 0.35);
local v11 = FastFlags.Replicated("Game.GrapplingHook.ReplacesFreezeRayInShop", Asserts.Boolean, true);

return table.freeze({
    PullSpeed = v1,
    TipTravelSpeed = v2,
    ServerMaxDistance = v3,
    ClientMaxDistance = v4,
    ReleaseDistance = v5,
    Cooldown = v6,
    PullStartDelay = v7,
    TimeoutBuffer = v8,
    StuckMinProgress = v9,
    StuckWindow = v10,
    ReplacesFreezeRayInShop = v11
});