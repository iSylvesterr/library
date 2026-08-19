-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Default = require(script.Parent.Parent.Private.BaseConfigs.Systems.FormatRarity.Default);
local Name = script.Name;
local v1 = ReplicatedStorage.Assets.UI.Rarity[Name];

return {
    RarityNumber = 4,
    DefaultRarityValue = "1 in 10",
    Announce = false,
    DisplayName = Name,
    ItemSlot = v1.ItemSlot,
    Gradient = v1.Gradient,
    Color = Color3.fromRGB(196, 2, 255),
    Message = Default("1 in 10")
};