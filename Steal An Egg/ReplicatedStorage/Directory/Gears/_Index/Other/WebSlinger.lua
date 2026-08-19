-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://114256711462971",
    MoneyCost = 2000000,
    ShopDropWeight = 10,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Pull enemies and trap them close to you! Use this in many ways to your advantage..",
    Rarity = "Divine",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name
}, {
    __index = Default
});