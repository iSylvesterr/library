-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.PetHunt.OpenEnabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.PetHunt.ShopEnabled", Asserts.Boolean, false);

return table.freeze({
    OpenEnabled = v1,
    ShopEnabled = v2
});