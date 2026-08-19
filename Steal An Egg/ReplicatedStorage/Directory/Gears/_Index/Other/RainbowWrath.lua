-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://108837517736733",
    MoneyCost = 10000000,
    ShopDropWeight = 3,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "It may shine like a rainbow, but it strikes like thunder.",
    Rarity = "Transcendent",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name
}, {
    __index = Default
});