-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://73046090853025",
    MoneyCost = 100000,
    ShopDropWeight = 2,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Puts on cape. Shoots laser from eyes. Totally normal.",
    Rarity = "Transcendent",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name
}, {
    __index = Default
});