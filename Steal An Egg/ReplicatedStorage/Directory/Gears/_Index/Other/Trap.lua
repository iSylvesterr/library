-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://98146157051289",
    MoneyCost = 1000,
    ShopDropWeight = 100,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 3,
    ToolController = "None",
    Description = "Place traps that freeze thieves for 7 seconds (3 Max)",
    Rarity = "Common",
    Persistent = false,
    SinglePurchase = false,
    MaxActiveDeployments = 3,
    ActiveDeploymentAttribute = "ActiveTrapCount",
    DisplayName = script.Name
}, {
    __index = Default
});