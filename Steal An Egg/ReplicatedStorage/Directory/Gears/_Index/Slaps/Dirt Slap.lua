-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);

return setmetatable({
    Icon = "rbxassetid://126416331206871",
    MoneyCost = 2500,
    ShopDropWeight = 100,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "Slap",
    SlapPower = 25,
    Description = "A heavy clod of dirt that splatters opponents, leaving them stunned and covered in grime.",
    Rarity = "Common",
    Persistent = false,
    SinglePurchase = true,
    DisplayName = script.Name,
    ControllerData = {
        Player = {
            Duration = 0.78,
            Force = 24,
            BrainrotDamage = 11,
            MaxBrainrotTargets = 1
        },
        Brainrot = {
            Duration = 0.2,
            Force = 4,
            BrainrotDamage = 11,
            MaxBrainrotTargets = 1
        }
    }
}, {
    __index = Default
});