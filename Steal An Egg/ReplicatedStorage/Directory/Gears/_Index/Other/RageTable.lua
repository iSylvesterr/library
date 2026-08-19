-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://95102385555032",
    MoneyCost = 25000,
    ShopDropWeight = 45,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Throw a table to fling players.",
    Rarity = "Rare",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name
}, {
    __index = Default
});