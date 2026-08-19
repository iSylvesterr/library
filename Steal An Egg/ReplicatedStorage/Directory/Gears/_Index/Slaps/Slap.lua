-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://111744314864127",
    MoneyCost = 500,
    ShopDropWeight = 30,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "Slap",
    SlapPower = 15,
    Description = "A trusty slap that ragdolls nearby players with a solid launch.",
    Rarity = "Rare",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name,
    ControllerData = {
        Player = {
            Duration = 0.8,
            Force = 25,
            BrainrotDamage = 12,
            MaxBrainrotTargets = 1
        },
        Brainrot = {
            Duration = 0.25,
            Force = 7,
            BrainrotDamage = 12,
            MaxBrainrotTargets = 1
        }
    }
}, {
    __index = Default
});