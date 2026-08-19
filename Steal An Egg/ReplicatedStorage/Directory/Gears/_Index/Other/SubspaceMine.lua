-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Parent.Types.Interface);
require(script.Parent.Parent.Parent.Types.ToolConfigs);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);
local v1 = {
    Icon = "http://www.roblox.com/asset/?id=11987521",
    MoneyCost = 500000000,
    ShopDropWeight = 45,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Place invisible traps that stun enemies",
    Rarity = "Rare",
    Persistent = false,
    SinglePurchase = true,
    DisplayInShop = false,
    DisplayName = script.Name
};
local v2 = {
    COOLDOWN = 14,
    MAX_ACTIVE_TRAPS = 1,
    MAX_PLACE_DISTANCE = 10,
    TRIGGER_RADIUS = 8,
    RAGDOLL_DURATION = 4.5,
    IMPULSE_FORCE = Vector3.new(0, 20, 0),
    DETECTION_INTERVAL = 0.1,
    FADE_DURATION = 3,
    IMPULSE_STRENGTH = 20,
    MOB_DAMAGE = 30,
    HIGHLIGHT_FADE_TIME = 0.5,
    TRIGGER_SFX_ID = "rbxassetid://0",
    IMPACT_VFX_ID = "rbxassetid://0",
    HIGHLIGHT_COLOR = Color3.fromRGB(128, 0, 128),
    TRAP_MODEL_PATH = ReplicatedStorage.Assets.ToolEffects.SubspaceTrap
};
v2.TRAP_COOLDOWN_SECONDS = v2.COOLDOWN;
local v3 = table.clone(v1);
local v4 = setmetatable(v3, {
    __index = Default
});

for i, v in v2 do
    v4[i] = v;
end;

return v4;