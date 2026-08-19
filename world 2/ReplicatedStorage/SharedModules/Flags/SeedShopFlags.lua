-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.SeedShop.PriceOverrides", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {});
local v2 = FastFlags.Replicated("Game.SeedShop.EnabledOverrides", Asserts.Map(Asserts.String, Asserts.Boolean), {});
local v3 = FastFlags.Replicated("Game.SeedShop.LimitedEndTimes", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Rocket Pop"] = 1783720800
});

return table.freeze({
    PriceOverrides = v1,
    EnabledOverrides = v2,
    LimitedEndTimes = v3
});