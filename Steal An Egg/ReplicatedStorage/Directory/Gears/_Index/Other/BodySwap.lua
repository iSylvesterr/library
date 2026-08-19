-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Types.Interface);
require(script.Parent.Parent.Parent.Types.ToolConfigs);
local Default = require(script.Parent.Parent.Parent.BaseConfigs.Default);
local v1 = {
    Icon = "rbxassetid://78673347",
    MoneyCost = 50000000,
    ShopDropWeight = 60,
    MinShopStockQuantity = 1,
    MaxShopStockQuantity = 1,
    ToolController = "None",
    Description = "Switch positions with the closest player in range!",
    Rarity = "Uncommon",
    Persistent = false,
    SinglePurchase = true,
    DisplayInShop = false,
    DisplayName = script.Name
};
local v2 = {
    MAX_RANGE = 35,
    COOLDOWN = 9,
    HIGHLIGHT_OUTLINE_TRANSPARENCY = 0.5,
    HIGHLIGHT_FILL_TRANSPARENCY = 0.7,
    SWAP_SFX_ID = "rbxassetid://0",
    SWAP_VFX_PATH = nil,
    SHOW_RANGE_INDICATOR = false,
    HIGHLIGHT_COLOR = Color3.new(1, 0, 0)
};
local v3 = table.clone(v1);
local v4 = setmetatable(v3, {
    __index = Default
});

for i, v in v2 do
    v4[i] = v;
end;

return v4;