-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://96210110227945",
    MoneyCost = 10000,
    ShopDropWeight = 60,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Release bees to attack your opponent and invert their controls!",
    Rarity = "Legendary",
    DisplayInShop = false,
    Persistent = true,
    SinglePurchase = true,
    DisplayName = script.Name
}, {
    __index = Default
});