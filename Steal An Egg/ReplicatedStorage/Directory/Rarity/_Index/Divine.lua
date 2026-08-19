-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Default = require(script.Parent.Parent.Private.BaseConfigs.Systems.FormatRarity.Default);
local Name = script.Name;
local v1 = ReplicatedStorage.Assets.UI.Rarity[Name];

return {
    RarityNumber = 10,
    DefaultRarityValue = "1 in 1,000,000,000",
    Announce = true,
    DisplayName = Name,
    ItemSlot = v1.ItemSlot,
    Gradient = v1.Gradient,
    Color = Color3.fromRGB(251, 255, 0),
    Message = Default("1 in 1,000,000,000")
};