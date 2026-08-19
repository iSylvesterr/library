-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Parent.Types.Interface);
require(script.Parent.Parent.Parent.Types.ToolConfigs);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);
local v1 = {
    Icon = "rbxassetid://65510059",
    MoneyCost = 250000000,
    ShopDropWeight = 60,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Create a powerful sound cone that continuously slaps and ragdolls targets",
    Rarity = "Uncommon",
    Persistent = false,
    SinglePurchase = true,
    DisplayInShop = false,
    DisplayName = script.Name
};
local v2 = {
    COOLDOWN = 14,
    MAX_RANGE = 20,
    CONE_ANGLE = 1.0471975511965976,
    EFFECT_DURATION = 4.5,
    DAMAGE = 2,
    SLAP_DURATION = 0.85,
    SLAP_FORCE = 40,
    TARGET_HIT_COOLDOWN = 0.5,
    SFX_ID = "rbxassetid://0",
    SHOW_RANGE_INDICATOR = false,
    VFX_PATH = ReplicatedStorage.Assets.ToolEffects.BeeToolEffect
};
local v3 = table.clone(v1);
local v4 = setmetatable(v3, {
    __index = Default
});

for i, v in v2 do
    v4[i] = v;
end;

return v4;