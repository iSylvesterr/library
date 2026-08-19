-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Default = require(script.Parent.Parent.Private.BaseConfigs.Systems.FormatRarity.Default);
local v1 = ReplicatedStorage.Assets.UI.Rarity[script.Name];

return {
    DisplayName = "Common",
    RarityNumber = 1,
    DefaultRarityValue = "1 in 2",
    Announce = false,
    ItemSlot = v1.ItemSlot,
    Gradient = v1.Gradient,
    Color = Color3.fromRGB(151, 151, 151),
    Message = Default("1 in 2")
};