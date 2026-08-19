-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.GearShop.PriceOverrides", Asserts.Map(Asserts.String, Asserts.AnyOf(Asserts.FiniteNonNegative, Asserts.Equals(-1))), {});
local v2 = FastFlags.Replicated("Game.GearShop.EnabledOverrides", Asserts.Map(Asserts.String, Asserts.Boolean), {});

return table.freeze({
    PriceOverrides = v1,
    EnabledOverrides = v2
});