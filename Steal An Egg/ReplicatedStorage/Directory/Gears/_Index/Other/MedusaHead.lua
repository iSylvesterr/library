-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://112620664518048",
    MoneyCost = 5000000,
    ShopDropWeight = 6,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Turn enemies into stone.",
    Rarity = "Mythical",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name
}, {
    __index = Default
});