-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://103400414014905",
    MoneyCost = 50000,
    ShopDropWeight = 30,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "Slap",
    SlapPower = 65,
    Description = "A fully diamond powered strong slap.",
    Rarity = "Rare",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name,
    ControllerData = {
        Player = {
            Duration = 0.8,
            Force = 29,
            BrainrotDamage = 20,
            MaxBrainrotTargets = 1
        },
        Brainrot = {
            Duration = 0.2,
            Force = 10,
            BrainrotDamage = 20,
            MaxBrainrotTargets = 1
        }
    }
}, {
    __index = Default
});