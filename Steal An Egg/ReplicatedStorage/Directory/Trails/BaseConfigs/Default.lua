-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);

return {
    Price = 0,
    ProductId = nil,
    Icon = "",
    SpeedMultiplier = 1,
    DisplayInShop = true,
    DisplayName = "",
    Rarity = require(ReplicatedStorage.Directory.Rarity).Rarities.Common
};