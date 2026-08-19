-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://125486072175077",
    MoneyCost = 200000,
    ShopDropWeight = 30,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "Slap",
    SlapPower = 40,
    Description = "Radiate power with a vivid slap that ragdolls enemies for an extended time.",
    Rarity = "Rare",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name,
    ControllerData = {
        Player = {
            Duration = 0.83,
            Force = 32,
            BrainrotDamage = 17,
            MaxBrainrotTargets = 1
        },
        Brainrot = {
            Duration = 0.33,
            Force = 11,
            BrainrotDamage = 17,
            MaxBrainrotTargets = 1
        }
    }
}, {
    __index = Default
});