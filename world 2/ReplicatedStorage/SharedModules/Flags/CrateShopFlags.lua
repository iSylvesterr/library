-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.CrateShop.OpenEnabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.CrateShop.PriceOverrides", Asserts.Map(Asserts.String, Asserts.AnyOf(Asserts.FiniteNonNegative, Asserts.Equals(-1))), {});
local v3 = FastFlags.Replicated("Game.CrateShop.EnabledOverrides", Asserts.Map(Asserts.String, Asserts.Boolean), {});
local v4 = FastFlags.Replicated("Game.CrateShop.LimitedEndTimes", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Fourth Of July Crate"] = 1783720800
});

return table.freeze({
    OpenEnabled = v1,
    PriceOverrides = v2,
    EnabledOverrides = v3,
    LimitedEndTimes = v4
});