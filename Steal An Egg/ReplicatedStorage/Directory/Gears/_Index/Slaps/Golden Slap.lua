-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://73587459668895",
    MoneyCost = 15000,
    ShopDropWeight = 15,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "Slap",
    SlapPower = 35,
    Description = "Strike with gilded strength to send opponents flying in a long ragdoll.",
    Rarity = "Legendary",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name,
    ControllerData = {
        Player = {
            Duration = 0.85,
            Force = 25,
            BrainrotDamage = 14,
            MaxBrainrotTargets = 1
        },
        Brainrot = {
            Duration = 0.3,
            Force = 9,
            BrainrotDamage = 14,
            MaxBrainrotTargets = 1
        }
    }
}, {
    __index = Default
});