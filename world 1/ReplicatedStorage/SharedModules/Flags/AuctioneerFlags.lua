-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Auctioneer.Enabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.Auctioneer.OpenEnabled", Asserts.Boolean, true);
local v3 = FastFlags.Replicated("Game.Auctioneer.PurchaseDebounceSeconds", Asserts.FiniteNonNegative, 0.2);
local v4 = FastFlags.Replicated("Game.Auctioneer.RobuxEnabled", Asserts.Boolean, true);
local v5 = FastFlags.Replicated("Game.Auctioneer.PurchaseCooldownSeconds", Asserts.FiniteNonNegative, 10);

return table.freeze({
    Enabled = v1,
    OpenEnabled = v2,
    PurchaseDebounceSeconds = v3,
    RobuxEnabled = v4,
    PurchaseCooldownSeconds = v5
});