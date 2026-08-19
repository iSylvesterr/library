-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Default = require(script.Parent.Parent.Private.BaseConfigs.Systems.FormatRarity.Default);
local Name = script.Name;
local v1 = ReplicatedStorage.Assets.UI.Rarity[Name];

return {
    RarityNumber = 6,
    DefaultRarityValue = "1 in 100,000,000",
    Announce = false,
    DisplayName = Name,
    ItemSlot = v1.ItemSlot,
    Gradient = v1.Gradient,
    Color = Color3.fromRGB(240, 35, 172),
    Message = Default("1 in 100,000,000")
};