-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://103235472197288",
    MoneyCost = 4400000,
    ShopDropWeight = 0.25,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "Slap",
    SlapPower = 80,
    Description = "Unleash a demonic slap that ragdolls victims with overwhelming force.",
    Rarity = "Prismatic",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name,
    ControllerData = {
        Player = {
            Duration = 1.03,
            Force = 35,
            BrainrotDamage = 40,
            MaxBrainrotTargets = 1
        },
        Brainrot = {
            Duration = 0.5,
            Force = 35,
            BrainrotDamage = 40,
            MaxBrainrotTargets = 1
        }
    }
}, {
    __index = Default
});