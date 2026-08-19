-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = {
    GEAR_NAME = "Bull Horn",
    ATTRIBUTE = "BullHorn",
    RANGE = 25,
    VALIDATION_MULT = 1.2,
    MAX_TARGETS = 40,
    KNOCKBACK_FORCE = 50,
    KNOCKBACK_UP_FORCE = 24.5,
    KNOCKBACK_DURATION = 0.35,
    RAGDOLL_DURATION = 1.5,
    CooldownSeconds = FastFlags.Replicated("Game.BullHorn.CooldownSeconds", Asserts.FinitePositive, 120)
};

return table.freeze(v1);