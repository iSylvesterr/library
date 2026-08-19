-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);

return {
    ReceiptInfo = t.interface({
        PurchaseId = t.union(t.string, t.number),
        PlayerId = t.optional(t.number),
        ProductId = t.optional(t.number),
        CurrencySpent = t.optional(t.number)
    }),

    ProductNameExists = function(p1) -- Line: 20
        error("unimplemented");
    end,

    DefaultConfig = t.interface({
        Callback = t.callback,
        ProductId = t.number,
        SinglePurchase = t.optional(t.boolean),
        ComputeItems = t.optional(t.boolean),
        DisplayName = t.optional(t.string),
        Icon = t.optional(t.string),
        Desc = t.optional(t.string),
        LockWhileProcessing = t.optional(t.boolean),
        DisableNotification = t.optional(t.boolean),
        ReservePrompt = t.optional(t.callback),
        CancelPrompt = t.optional(t.callback),
        ServerTest = t.optional(t.callback),
        ClientTest = t.optional(t.callback),
        AbilityUpgradeRarity = t.optional(t.string),
        StealRarity = t.optional(t.string),
        SpeedBoostTierIndex = t.optional(t.number),
        SpeedBoostMultiplier = t.optional(t.number),
        SpeedPowerReward = t.optional(t.number),
        TemporarySpeedBoostDurationSeconds = t.optional(t.number),
        TemporarySpeedBoostMultiplier = t.optional(t.number),
        TreadmillSpeedEquivalentDurationSeconds = t.optional(t.number),
        EggSkipGrowthMaxRemainingSeconds = t.optional(t.number),
        AssetProduct = t.optional(t.interface({
            AssetName = t.string,
            ShowcaseModelName = t.optional(t.string),
            AssetItemData = t.optional(AssetItem.AssetItemData)
        })),
        LimitedStock = t.optional(t.interface({
            StockId = t.string,
            InitialStock = t.number,
            RewardBundle = t.interface({
                KnifeSkin = t.optional(t.string),
                GunSkin = t.optional(t.string)
            }),
            DisplayInShop = t.optional(t.boolean),
            ShopFrameName = t.optional(t.string),
            ShowcaseModelName = t.optional(t.string)
        }))
    })
};