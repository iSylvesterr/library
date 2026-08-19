-- Decompiled with Potassium's decompiler.

local Interface = require(script.Parent.Parent.Types.Interface);

return function(p1) -- Line: 11
    -- upvalues: Interface (copy)
    local v2, v3 = Interface.IndexBatConfigOptions(p1);
    assert(v2, v3);

    return {
        MoneyCost = 0,
        ShopDropWeight = 0,
        MinShopStockQuantity = 1,
        MaxShopStockQuantity = 1,
        ToolController = "None",
        Persistent = true,
        SinglePurchase = true,
        DisplayInShop = false,
        Icon = p1.Icon,
        DisplayName = p1.DisplayName,
        ToolModel = p1.DisplayName,
        Description = `Complete the {p1.DisplayName} area index to equip this bat!`,
        Rarity = p1.Rarity,
        IndexBatTier = p1.IndexBatTier,
        BatControllerData = {
            Duration = p1.Duration,
            Force = p1.Force,
            RangeBonus = (p1.IndexBatTier - 1) * 1.875
        }
    };
end;