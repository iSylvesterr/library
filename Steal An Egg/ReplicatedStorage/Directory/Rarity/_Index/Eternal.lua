-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Default = require(script.Parent.Parent.Private.BaseConfigs.Systems.FormatRarity.Default);
local v1 = ReplicatedStorage.Assets.UI.Rarity[script.Name];

return {
    DisplayName = "Eternal",
    RarityNumber = 9,
    DefaultRarityValue = "1 in 100,000,000",
    Announce = false,
    ItemSlot = v1.ItemSlot,
    Gradient = v1.Gradient,
    Color = Color3.fromRGB(255, 30, 240),
    Message = Default("1 in 100,000,000")
};