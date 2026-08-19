-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Parent.Types.Interface);
require(script.Parent.Parent.Parent.Types.ToolConfigs);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);
local v1 = {
    Icon = "rbxassetid://999316662",
    MoneyCost = 200000000,
    ShopDropWeight = 60,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Pull targets towards you with magnetic force",
    Rarity = "Uncommon",
    Persistent = false,
    SinglePurchase = true,
    DisplayInShop = false,
    DisplayName = script.Name
};
local v2 = {
    MAX_RANGE = 50,
    COOLDOWN = 10,
    PULL_DURATION = 3,
    PULL_FORCE = 50,
    PULL_SMOOTHNESS = 0.15,
    PULL_SPEED = 10,
    PULL_SFX_ID = "rbxassetid://0",
    SHOW_RANGE_INDICATOR = false,
    BEAM_TEMPLATE_PATH = ReplicatedStorage.Assets.ToolEffects.beamTrail,
    MAGNET_EFFECT_PATH = ReplicatedStorage.Assets.ToolEffects.MagnetEffect
};
local v3 = table.clone(v1);
local v4 = setmetatable(v3, {
    __index = Default
});

for i, v in v2 do
    v4[i] = v;
end;

return v4;