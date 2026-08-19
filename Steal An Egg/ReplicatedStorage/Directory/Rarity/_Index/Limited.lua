-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Default = require(script.Parent.Parent.Private.BaseConfigs.Systems.FormatRarity.Default);
local Name = script.Name;
local v1 = ReplicatedStorage.Assets.UI.Rarity[Name];

return {
    RarityNumber = 9,
    DefaultRarityValue = "1 in 10,000",
    Announce = true,
    DisplayName = Name,
    ItemSlot = v1.ItemSlot,
    Gradient = v1.Gradient,
    Color = Color3.fromRGB(173, 79, 255),
    Message = Default("1 in 10,000")
};