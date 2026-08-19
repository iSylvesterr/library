-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://131099804712161",
    MoneyCost = 0,
    ShopDropWeight = 0,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    ToolModel = "Bat",
    Description = "Fling players and steal their eggs!",
    Rarity = "Uncommon",
    Persistent = false,
    SinglePurchase = true,
    DisplayInShop = false,
    DisplayName = script.Name,
    BatControllerData = {
        Duration = 0.5,
        Force = 35,
        RangeBonus = 0
    }
}, {
    __index = Default
});