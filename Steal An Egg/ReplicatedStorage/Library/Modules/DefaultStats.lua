-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local Schema = require(script.Types.Schema);
require(script.Types.Interface);
local Guards = require(ReplicatedStorage.Directory.Guards);
local v1 = {
    Money = 0,
    SpeedPower = TreadmillUtil.DEFAULT_BASE_SPEED_POWER,
    Inventory = {},
    EquippedAssets = {},
    GuardTutorialProgress = {
        Completed = false,
        CurrentStepId = nil
    },
    LastLogout = 0,
    PendingOfflineMoney = 0,
    PendingOfflineAnchorLogoutAt = 0,
    Gamepasses = {},
    Products = {},
    ClaimedCodes = {},
    ClaimedLikeMilestoneIds = {},
    StarterPackOfferExpires = 0,
    StarterPackOfferPending = false,
    StarterPackOfferFinished = false,
    Index = {},
    Rebirth = 0,
    AutoSellRarities = {},
    Settings = {
        SFX = true,
        Music = true,
        Trading = true,
        AFK = false,
        HideOtherPets = false,
        DisableVideos = false
    },
    LuckyBlockInventory = {},
    LatestTreadmillMediaIndex = 0,
    ClaimedGroupReward = false,
    DismissedGroupRewardPrompt = false,
    FreeGiftsStartedAt = 0,
    FreeGiftsTime = 0,
    FreeGiftsActiveStartedAt = 0,
    FreeGiftsClaimed = {},
    FusionSlots = {},
    FusionLocked = false,
    FusionEndsAt = nil,
    FusionDuration = 0,
    FusionReward = nil,
    VIPFusionSlots = {},
    VIPFusionLocked = false,
    VIPFusionEndsAt = nil,
    VIPFusionDuration = 0,
    VIPFusionReward = nil,
    PrivateFusionSlots = {},
    PrivateFusionLocked = false,
    PrivateFusionEndsAt = nil,
    PrivateFusionDuration = 0,
    PrivateFusionReward = nil,
    VIPOfferExpires = 0,
    VIPOfferStarted = false,
    MonetizationRobuxSpentTotal = 0,
    BaseUpgradeLevel = 0,
    TrailInventory = {},
    EquippedTrail = nil,
    VisitedGuardAreas = {
        [Guards.Directory.Forest._id] = true
    },
    StarterPackOfferPausedSeconds = 0,
    StarterPackOfferPlaytimeSeconds = 0,
    TreadmillMediaFeedState = {
        Seed = 0,
        CurrentIndex = 0,
        AlgorithmVersion = 3,
        HasSwappedRight = nil,
        ReleaseTrackingInitialized = false,
        FullFeedReleaseVersion = 0,
        CompletedReleaseVersion = 0,
        PendingReleaseVersion = 0,
        PendingCurrentMediaKey = nil,
        SeenPendingMediaKeys = {}
    },
    FreeGiftsLastResetDay = 0,
    SpeedBoostTierIndex = 0,
    BestRollDenominator = 0,
    IndexClaimedCategories = {},
    LikedTreadmillMedia = {},
    LikedCommentIds = {},
    CommentedTreadmillMedia = {},
    BestGuardRunDistance = 0,
    EggInventory = {},
    VisitedGears = {},
    GearInventory = {},
    GearAutoBuys = {},
    CurrentAreaEggClaims = {
        PeriodIndex = 0,
        Slots = {}
    },
    TemporarySpeedBoostRemainingSeconds = 0,
    TemporarySpeedBoostActiveStartedAt = 0,
    TreadmillUpgradeLevel = 1,
    HasPlacedFirstEgg = false,
    GuardSpeedWarningsSeen = {},
    PetPenCapacityGuidance = {
        Triggered = false,
        PetsTabAcknowledged = false,
        EquipBestAcknowledged = false
    },
    FusionEggReward = false,
    FusionInfoAcknowledged = false
};

if Constants.IS_STUDIO then
    assert(Schema(v1));
end;

return v1;