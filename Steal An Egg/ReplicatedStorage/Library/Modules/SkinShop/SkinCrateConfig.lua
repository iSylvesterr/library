-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SkinShopOptions = require(ReplicatedStorage.Directory.SkinShopOptions);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local IS_STUDIO = Constants.IS_STUDIO;
local v1 = game.PlaceId == Constants.TEST_PLACE_ID;
local v2 = v1 and 45 or 300;
local v3 = IS_STUDIO and 10 or 165;
local u4 = { SkinShopOptions.Directory["Basic Crate"]._id };
local u5 = {};
local _id = SkinShopOptions.Directory["Uncommon Crate"]._id;
local v6 = {
    MinStock = 1,
    TargetFill = 0.75,
    TargetSelloutTime = 300,
    MinCycleMultiplier = 0.85,
    MaxCycleMultiplier = 1.1,
    BetaTopRichestPercent = 0.75,
    BetaPriceMultiplier = 1,
    BetaMaxPrice = (1 / 0),
    OptionName = SkinShopOptions.Directory["Uncommon Crate"].DisplayName,
    Rarity = SkinShopOptions.Directory["Uncommon Crate"].Rarity._id,
    PackKey = SkinShopOptions.Directory["Uncommon Crate"].PackKey,
    SeedBasePrice = SkinShopOptions.Directory["Uncommon Crate"].Cost
};
local _ = Constants.IS_STUDIO;
v6.SpawnChance = 1;
v6.ScarcityRatio = Constants.IS_STUDIO and 1 or 0.75;
local v7 = math.floor(SkinShopOptions.Directory["Uncommon Crate"].Cost * 0.75);
v6.BetaMinPrice = math.max(1, v7);
u5[_id] = v6;
local _id2 = SkinShopOptions.Directory["Rare Crate"]._id;
local v8 = {
    MinStock = 1,
    TargetFill = 0.8,
    TargetSelloutTime = 270,
    MinCycleMultiplier = 0.88,
    MaxCycleMultiplier = 1.1,
    BetaTopRichestPercent = 0.6,
    BetaPriceMultiplier = 1,
    BetaMaxPrice = (1 / 0),
    OptionName = SkinShopOptions.Directory["Rare Crate"].DisplayName,
    Rarity = SkinShopOptions.Directory["Rare Crate"].Rarity._id,
    PackKey = SkinShopOptions.Directory["Rare Crate"].PackKey,
    SeedBasePrice = SkinShopOptions.Directory["Rare Crate"].Cost
};
local _ = Constants.IS_STUDIO;
v8.SpawnChance = 1;
v8.ScarcityRatio = Constants.IS_STUDIO and 1 or 0.6;
local v9 = math.floor(SkinShopOptions.Directory["Rare Crate"].Cost * 0.75);
v8.BetaMinPrice = math.max(1, v9);
u5[_id2] = v8;
local _id3 = SkinShopOptions.Directory["Epic Crate"]._id;
local v10 = {
    MinStock = 1,
    TargetFill = 0.85,
    TargetSelloutTime = 240,
    MinCycleMultiplier = 0.9,
    MaxCycleMultiplier = 1.12,
    BetaTopRichestPercent = 0.4,
    BetaPriceMultiplier = 1,
    BetaMaxPrice = (1 / 0),
    OptionName = SkinShopOptions.Directory["Epic Crate"].DisplayName,
    Rarity = SkinShopOptions.Directory["Epic Crate"].Rarity._id,
    PackKey = SkinShopOptions.Directory["Epic Crate"].PackKey,
    SeedBasePrice = SkinShopOptions.Directory["Epic Crate"].Cost
};
local _ = Constants.IS_STUDIO;
v10.SpawnChance = 1;
v10.ScarcityRatio = Constants.IS_STUDIO and 1 or 0.2;
local v11 = math.floor(SkinShopOptions.Directory["Epic Crate"].Cost * 0.75);
v10.BetaMinPrice = math.max(1, v11);
u5[_id3] = v10;
local _id4 = SkinShopOptions.Directory["Legendary Crate"]._id;
local v12 = {
    ScarcityRatio = 0.12,
    MinStock = 1,
    TargetFill = 0.9,
    TargetSelloutTime = 180,
    MinCycleMultiplier = 0.9,
    MaxCycleMultiplier = 1.12,
    BetaTopRichestPercent = 0.25,
    BetaPriceMultiplier = 1,
    BetaMaxPrice = (1 / 0),
    OptionName = SkinShopOptions.Directory["Legendary Crate"].DisplayName,
    Rarity = SkinShopOptions.Directory["Legendary Crate"].Rarity._id,
    PackKey = SkinShopOptions.Directory["Legendary Crate"].PackKey,
    SeedBasePrice = SkinShopOptions.Directory["Legendary Crate"].Cost
};
local _ = Constants.IS_STUDIO;
v12.SpawnChance = 1;
local v13 = math.floor(SkinShopOptions.Directory["Legendary Crate"].Cost * 0.75);
v12.BetaMinPrice = math.max(1, v13);
u5[_id4] = v12;
local _id5 = SkinShopOptions.Directory["Mythic Crate"]._id;
local v14 = {
    ScarcityRatio = 0.07,
    MinStock = 1,
    TargetFill = 0.92,
    TargetSelloutTime = 150,
    MinCycleMultiplier = 0.9,
    MaxCycleMultiplier = 1.12,
    BetaTopRichestPercent = 0.1,
    BetaPriceMultiplier = 1,
    BetaMaxPrice = (1 / 0),
    OptionName = SkinShopOptions.Directory["Mythic Crate"].DisplayName,
    Rarity = SkinShopOptions.Directory["Mythic Crate"].Rarity._id,
    PackKey = SkinShopOptions.Directory["Mythic Crate"].PackKey,
    SeedBasePrice = SkinShopOptions.Directory["Mythic Crate"].Cost
};
local _ = Constants.IS_STUDIO;
v14.SpawnChance = 1;
local v15 = math.floor(SkinShopOptions.Directory["Mythic Crate"].Cost * 0.75);
v14.BetaMinPrice = math.max(1, v15);
u5[_id5] = v14;
local _id6 = SkinShopOptions.Directory["Cosmic Crate"]._id;
local v16 = {
    ScarcityRatio = 0.04,
    MinStock = 1,
    TargetFill = 0.95,
    TargetSelloutTime = 120,
    MinCycleMultiplier = 0.92,
    MaxCycleMultiplier = 1.12,
    BetaTopRichestPercent = 0.05,
    BetaPriceMultiplier = 1,
    BetaMaxPrice = (1 / 0),
    OptionName = SkinShopOptions.Directory["Cosmic Crate"].DisplayName,
    Rarity = SkinShopOptions.Directory["Cosmic Crate"].Rarity._id,
    PackKey = SkinShopOptions.Directory["Cosmic Crate"].PackKey,
    SeedBasePrice = SkinShopOptions.Directory["Cosmic Crate"].Cost,
    SpawnChance = Constants.IS_STUDIO and 1 or 0.6000000000000001
};
local v17 = math.floor(SkinShopOptions.Directory["Cosmic Crate"].Cost * 0.75);
v16.BetaMinPrice = math.max(1, v17);
u5[_id6] = v16;
local _id7 = SkinShopOptions.Directory["Secret Crate"]._id;
local v18 = {
    ScarcityRatio = 0.02,
    MinStock = 1,
    TargetFill = 0.98,
    TargetSelloutTime = 90,
    MinCycleMultiplier = 0.95,
    MaxCycleMultiplier = 1.12,
    BetaTopRichestPercent = 0.02,
    BetaPriceMultiplier = 1,
    BetaMaxPrice = (1 / 0),
    OptionName = SkinShopOptions.Directory["Secret Crate"].DisplayName,
    Rarity = SkinShopOptions.Directory["Secret Crate"].Rarity._id,
    PackKey = SkinShopOptions.Directory["Secret Crate"].PackKey,
    SeedBasePrice = SkinShopOptions.Directory["Secret Crate"].Cost,
    SpawnChance = Constants.IS_STUDIO and 1 or 0.30000000000000004
};
local v19 = math.floor(SkinShopOptions.Directory["Secret Crate"].Cost * 0.75);
v18.BetaMinPrice = math.max(1, v19);
u5[_id7] = v18;
local _id8 = SkinShopOptions.Directory["Eternal Crate"]._id;
local v20 = {
    ScarcityRatio = 0.01,
    MinStock = 1,
    TargetFill = 1,
    TargetSelloutTime = 60,
    MinCycleMultiplier = 0.97,
    MaxCycleMultiplier = 1.1,
    BetaTopRichestPercent = 0.01,
    BetaPriceMultiplier = 1,
    BetaMaxPrice = (1 / 0),
    OptionName = SkinShopOptions.Directory["Eternal Crate"].DisplayName,
    Rarity = SkinShopOptions.Directory["Eternal Crate"].Rarity._id,
    PackKey = SkinShopOptions.Directory["Eternal Crate"].PackKey,
    SeedBasePrice = SkinShopOptions.Directory["Eternal Crate"].Cost,
    SpawnChance = Constants.IS_STUDIO and 1 or 0.09
};
local v21 = math.floor(SkinShopOptions.Directory["Eternal Crate"].Cost * 0.75);
v20.BetaMinPrice = math.max(1, v21);
u5[_id8] = v20;
local u22 = {};
local v23 = { "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal" };

for i, v in pairs(u5) do
    u22[v.Rarity] = i;
    local v24 = SkinShopOptions.Directory[i] ~= nil;
    local v25 = `Missing skin shop option {i}`;
    assert(v24, v25);
end;

return {
    BackendModeAttribute = "SkinCrateMarketMode",
    StudioFastTesting = IS_STUDIO,
    CompetitiveMarketMode = "PriceOnlyBeta",
    RefreshTime = v2,
    EligibilityRatio = 0.7,
    ReservationTTL = 8,
    ReservationRecordTTL = v2 + 120,
    PurchaseGuardTTL = v2 + 120,
    CompletionRecordTTL = v2 + 120,
    SummaryTTL = IS_STUDIO and 30 or 90,
    SummaryFreshness = IS_STUDIO and 10 or 60,
    SummaryHeartbeatMin = IS_STUDIO and 1 or 20,
    SummaryHeartbeatMax = IS_STUDIO and 2 or 30,
    BetaSummaryTTL = IS_STUDIO and 30 or v3 + 60,
    BetaSummaryFreshness = v3,
    BetaSummaryHeartbeatMin = 90,
    BetaSummaryHeartbeatMax = 120,
    BetaPriceRefreshMin = 120,
    BetaPriceRefreshMax = 180,
    BetaPriceStateTTL = 480,
    BetaStartupFallbackWindow = 60,
    BetaMinPlayersForComputedPrice = v1 and 3 or 2000,
    BindToCloseSummaryTTL = 5,
    CacheRefreshMin = IS_STUDIO and 1 or 10,
    CacheRefreshMax = IS_STUDIO and 2 or 20,
    CoordinatorLease = IS_STUDIO and 5 or 15,
    BetaPriceCoordinatorLease = 210,
    PlanningWaitSeconds = IS_STUDIO and 1 or 6,
    MinCoverageRatio = IS_STUDIO and 0 or 0.8,
    EmergencyCoverageRatio = IS_STUDIO and 0 or 0.2,
    StockPublishWindow = 0.35,
    RecoveryQueueInvisibility = 5,
    RecoveryQueueWaitTimeout = 0,
    RecoveryBatchSize = 10,
    RecoveryJobTTL = v2 + 120,
    GrantRepairGrace = 20,
    ReadOnlyFailureWindow = 10,
    ReadOnlyReasonThreshold = 3,
    ReadOnlyGlobalThreshold = 5,
    ReadOnlyCooldown = 8,
    RecoveryCleanPassesRequired = 2,
    LegacyOptions = u4,
    CompetitiveOptions = u5,
    CompetitiveRarities = v23,

    GetCompetitiveMarketMode = function() -- Line: 283, Name: GetCompetitiveMarketMode
        return "PriceOnlyBeta";
    end,

    IsFullMarket = function() -- Line: 287, Name: IsFullMarket
        return false;
    end,

    IsPriceOnlyBeta = function() -- Line: 291, Name: IsPriceOnlyBeta
        return true;
    end,

    IsCompetitiveDisabled = function() -- Line: 295, Name: IsCompetitiveDisabled
        return false;
    end,

    IsCompetitiveOption = function(p26) -- Line: 299, Name: IsCompetitiveOption
        -- upvalues: u5 (copy)
        return u5[p26] ~= nil;
    end,

    IsLegacyOption = function(p27) -- Line: 303, Name: IsLegacyOption
        -- upvalues: u4 (copy)
        return table.find(u4, p27) ~= nil;
    end,

    GetCompetitiveConfig = function(p28) -- Line: 307, Name: GetCompetitiveConfig
        -- upvalues: u5 (copy)
        return u5[p28];
    end,

    GetCompetitiveConfigByRarity = function(p29) -- Line: 311, Name: GetCompetitiveConfigByRarity
        -- upvalues: u22 (copy), u5 (copy)
        local v30 = u22[p29];

        if v30 == nil then
            return nil;
        end;

        return u5[v30];
    end,

    GetOptionNameFromRarity = function(p31) -- Line: 320, Name: GetOptionNameFromRarity
        -- upvalues: u22 (copy)
        return u22[p31];
    end,

    GetDefaultPrice = function(p32) -- Line: 324, Name: GetDefaultPrice
        -- upvalues: u5 (copy), SkinShopOptions (copy)
        local v33 = u5[p32];

        if v33 ~= nil then
            return v33.SeedBasePrice;
        end;

        local v34 = SkinShopOptions.Directory[p32];
        local v35 = `Unknown skin shop option {p32}`;
        assert(v34 ~= nil, v35);

        return v34.Cost;
    end
};