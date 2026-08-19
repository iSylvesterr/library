-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Library.Player);
require(ReplicatedStorage.Library.Types.GUI);
local Signal = require(ReplicatedStorage.Library.Signal);
local u1 = RunService:IsStudio() and 30 or 99999999;
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui", u1);
local u2 = nil;
local u3 = nil;
u3 = {
    BaseUpgradeTransitionGui = function() -- Line: 60, Name: BaseUpgradeTransitionGui
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BaseUpgradeTransitionGui", u1);
    end,

    PlayerGui = function() -- Line: 63, Name: PlayerGui
        -- upvalues: PlayerGui (copy)
        return PlayerGui;
    end,

    TreadmillScreenSideButtons = function() -- Line: 66, Name: TreadmillScreenSideButtons
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TreadmillScreenSideButtons", u1);
    end,

    TreadmillScreenComments = function() -- Line: 69, Name: TreadmillScreenComments
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TreadmillScreenComments", u1);
    end,

    TreadmillScreenFriendLikes = function() -- Line: 72, Name: TreadmillScreenFriendLikes
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TreadmillScreenFriendLikes", u1);
    end,

    StealDnaMessage = function() -- Line: 75, Name: StealDnaMessage
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("StealDnaMessage", u1);
    end,

    TreadmillVideoSurfaceGui = function() -- Line: 78, Name: TreadmillVideoSurfaceGui
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TreadmillVideoSurfaceGui", u1);
    end,

    StaticTreadmillImageSurfaceGui = function() -- Line: 81, Name: StaticTreadmillImageSurfaceGui
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("StaticTreadmillImageSurfaceGui", u1);
    end,

    BonusScreen = function() -- Line: 84, Name: BonusScreen
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BonusScreen", u1);
    end,

    BonusScreenVignette = function() -- Line: 87, Name: BonusScreenVignette
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BonusScreenVignette", u1);
    end,

    BottomUI = function() -- Line: 90, Name: BottomUI
        -- upvalues: PlayerGui (copy), u1 (copy)
        local BottomUI = PlayerGui:WaitForChild("BottomUI", u1);
        local v4 = BottomUI:IsA("ScreenGui");
        assert(v4, "PlayerGui.BottomUI must be a ScreenGui");
        local BottomFrame = BottomUI.BottomFrame;
        local v5 = BottomFrame:IsA("Frame");
        assert(v5, "PlayerGui.BottomUI.BottomFrame must be a Frame");
        local Holder = BottomFrame.Holder;
        local v6 = Holder:IsA("Frame");
        assert(v6, "PlayerGui.BottomUI.BottomFrame.Holder must be a Frame");
        local List = Holder.List;
        local v7 = List:IsA("Frame");
        assert(v7, "PlayerGui.BottomUI.BottomFrame.Holder.List must be a Frame");
        local Luck = List.Luck;
        local v8 = Luck:IsA("Frame");
        assert(v8, "PlayerGui.BottomUI.BottomFrame.Holder.List.Luck must be a Frame");
        local Button = Luck.Button;
        local v9 = Button:IsA("ImageButton");
        assert(v9, "BottomUI Luck.Button must be an ImageButton");
        local Content = Button.Content;
        local v10 = Content:IsA("Frame");
        assert(v10, "BottomUI Luck.Button.Content must be a Frame");
        local Value = Content.Value;
        local v11 = Value:IsA("Frame");
        assert(v11, "BottomUI Luck.Button.Content.Value must be a Frame");
        local v12 = Value.TextLabel:IsA("TextLabel");
        assert(v12, "BottomUI Luck value must be a TextLabel");
        local x2Luck = List.x2Luck;
        local v13 = x2Luck:IsA("Frame");
        assert(v13, "BottomUI x2Luck must be a Frame");
        local v14 = x2Luck.Icon:IsA("ImageButton");
        assert(v14, "BottomUI x2Luck.Icon must be an ImageButton");
        local v15 = x2Luck.Timer:IsA("TextLabel");
        assert(v15, "BottomUI x2Luck.Timer must be a TextLabel");
        local x2Growth = List.x2Growth;
        local v16 = x2Growth:IsA("Frame");
        assert(v16, "BottomUI x2Growth must be a Frame");
        local v17 = x2Growth.Icon:IsA("ImageButton");
        assert(v17, "BottomUI x2Growth.Icon must be an ImageButton");
        local v18 = x2Growth.Timer:IsA("TextLabel");
        assert(v18, "BottomUI x2Growth.Timer must be a TextLabel");

        return BottomUI;
    end,

    Damage = function() -- Line: 120, Name: Damage
        -- upvalues: PlayerGui (copy), u1 (copy)
        local Damage = PlayerGui:WaitForChild("Damage", u1);
        local v19 = Damage:IsA("ScreenGui");
        assert(v19, "PlayerGui.Damage must be a ScreenGui");
        local v20 = Damage:WaitForChild("ImageLabel", u1):IsA("ImageLabel");
        assert(v20, "PlayerGui.Damage.ImageLabel must be an ImageLabel");

        return Damage;
    end,

    OfflineMoneyInPlot = function() -- Line: 129, Name: OfflineMoneyInPlot
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("OfflineMoneyInPlot", u1);
    end,

    PuzzleUI = function() -- Line: 132, Name: PuzzleUI
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("PuzzleUI", u1);
    end,

    FuseMachine = function() -- Line: 135, Name: FuseMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("FuseMachine", u1);
    end,

    VIPSkinFuseMachine = function() -- Line: 138, Name: VIPSkinFuseMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("VIPSkinFuseMachine", u1);
    end,

    VIPBrainrotFuseMachine = function() -- Line: 141, Name: VIPBrainrotFuseMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("VIPBrainrotFuseMachine", u1);
    end,

    WeatherSchedules = function() -- Line: 144, Name: WeatherSchedules
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("WeatherSchedules", u1);
    end,

    SkinFuseMachine = function() -- Line: 147, Name: SkinFuseMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("SkinFuseMachine", u1);
    end,

    BrainrotFuseMachine = function() -- Line: 150, Name: BrainrotFuseMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BrainrotFuseMachine", u1);
    end,

    PrivateBrainrotFuseMachine = function() -- Line: 153, Name: PrivateBrainrotFuseMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("PrivateBrainrotFuseMachine", u1);
    end,

    AbilityShop = function() -- Line: 156, Name: AbilityShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("AbilityShop", u1);
    end,

    SkinShop = function() -- Line: 159, Name: SkinShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("SkinShop", u1);
    end,

    BlackMarket = function() -- Line: 162, Name: BlackMarket
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BlackMarket", u1);
    end,

    StealEffectVignette = function() -- Line: 165, Name: StealEffectVignette
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Vignette", u1);
    end,

    ScaryText = function() -- Line: 168, Name: ScaryText
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ScaryText", u1);
    end,

    AutoSell = function() -- Line: 171, Name: AutoSell
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("AutoSell", u1);
    end,

    EggInventory = function() -- Line: 174, Name: EggInventory
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("EggInventory", u1);
    end,

    AssetEggShop = function() -- Line: 177, Name: AssetEggShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("AssetEggShop", u1);
    end,

    AssetEggData = function() -- Line: 180, Name: AssetEggData
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("AssetEggData", u1);
    end,

    AssetHoverData = function() -- Line: 183, Name: AssetHoverData
        -- upvalues: PlayerGui (copy), u1 (copy)
        local AssetHoverData = PlayerGui:WaitForChild("AssetHoverData", u1);
        local v21 = AssetHoverData:IsA("ScreenGui");
        assert(v21, "PlayerGui.AssetHoverData must be a ScreenGui.");

        return AssetHoverData;
    end,

    ActiveAssetHover_UI = function() -- Line: 188, Name: ActiveAssetHover_UI
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ActiveAssetHover_UI", u1);
    end,

    AreaGui = function() -- Line: 191, Name: AreaGui
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("AreaGui", u1);
    end,

    BrainrotOddsHoverData = function() -- Line: 194, Name: BrainrotOddsHoverData
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BrainrotOddsHoverData", u1);
    end,

    BloodNightShop = function() -- Line: 197, Name: BloodNightShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BloodNightShop", u1);
    end,

    Index = function() -- Line: 200, Name: Index
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Index", u1);
    end,

    BloodlutCurrency_UI = function() -- Line: 203, Name: BloodlutCurrency_UI
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BloodlutCurrency_UI", u1);
    end,

    Backpack = function() -- Line: 206, Name: Backpack
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BackpackGui", u1);
    end,

    DropHeldEgg = function() -- Line: 209, Name: DropHeldEgg
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("DropHeldEgg", u1);
    end,

    Money = function() -- Line: 212, Name: Money
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Money", u1);
    end,

    OfflineMoney = function() -- Line: 215, Name: OfflineMoney
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("OfflineCashOnly", u1);
    end,

    OfflineCashOnly = function() -- Line: 218, Name: OfflineCashOnly
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("OfflineCashOnly", u1);
    end,

    OfflineCashAndAssetLevelGrew = function() -- Line: 221, Name: OfflineCashAndAssetLevelGrew
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("OfflineCashAndAssetLevelGrew", u1);
    end,

    TeleportUI = function() -- Line: 224, Name: TeleportUI
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TeleportUI", u1);
    end,

    LuckyFoodShop = function() -- Line: 227, Name: LuckyFoodShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("LuckyFoodShop", u1);
    end,

    TrailShop = function() -- Line: 230, Name: TrailShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TrailShop", u1);
    end,

    TreadmillScreenButtonSwapLeft = function() -- Line: 233, Name: TreadmillScreenButtonSwapLeft
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TreadmillScreenButtonSwapLeft", u1);
    end,

    TreadmillScreenButtonSwapRight = function() -- Line: 236, Name: TreadmillScreenButtonSwapRight
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TreadmillScreenButtonSwapRight", u1);
    end,

    TreadmillScreenButtonShare = function() -- Line: 239, Name: TreadmillScreenButtonShare
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TreadmillScreenButtonShare", u1);
    end,

    SwordShop = function() -- Line: 242, Name: SwordShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("SwordShop", u1);
    end,

    Odds_UI = function() -- Line: 245, Name: Odds_UI
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Odds_UI", u1);
    end,

    RunButton = function() -- Line: 248, Name: RunButton
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("RunButton", u1);
    end,

    RunButtonButton = function() -- Line: 251, Name: RunButtonButton
        -- upvalues: u3 (ref), u1 (copy)
        return u3.RunButton():WaitForChild("Button", u1);
    end,

    RunCharge = function() -- Line: 254, Name: RunCharge
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("RunCharge", u1);
    end,

    RunChargeBaseLuck = function() -- Line: 257, Name: RunChargeBaseLuck
        -- upvalues: u3 (ref), u1 (copy)
        return u3.RunCharge():WaitForChild("Main", u1):WaitForChild("Frame", u1):WaitForChild("Top", u1):WaitForChild("BaseLuck", u1);
    end,

    RunChargeTopScale = function() -- Line: 264, Name: RunChargeTopScale
        -- upvalues: u3 (ref), u1 (copy)
        return u3.RunCharge():WaitForChild("Main", u1):WaitForChild("Frame", u1):WaitForChild("Top", u1):WaitForChild("UIScale", u1);
    end,

    RunChargeBar = function() -- Line: 271, Name: RunChargeBar
        -- upvalues: u3 (ref), u1 (copy)
        return u3.RunCharge():WaitForChild("Main", u1):WaitForChild("CanvasGroup", u1):WaitForChild("Bar", u1);
    end,

    ChargeResultEffects = function() -- Line: 277, Name: ChargeResultEffects
        -- upvalues: u3 (ref)
        return u3.RunCharge().Main;
    end,

    ChargeResultEffectsFrame = function() -- Line: 280, Name: ChargeResultEffectsFrame
        -- upvalues: u3 (ref)
        return u3.ChargeResultEffects().ChargeResultEffects;
    end,

    ChargeResultEffectsBad = function() -- Line: 283, Name: ChargeResultEffectsBad
        -- upvalues: u3 (ref)
        return u3.ChargeResultEffectsFrame().Bad;
    end,

    ChargeResultEffectsGood = function() -- Line: 286, Name: ChargeResultEffectsGood
        -- upvalues: u3 (ref)
        return u3.ChargeResultEffectsFrame().Good;
    end,

    ChargeResultEffectsGreat = function() -- Line: 289, Name: ChargeResultEffectsGreat
        -- upvalues: u3 (ref)
        return u3.ChargeResultEffectsFrame().Great;
    end,

    ChargeResultEffectsExcellent = function() -- Line: 292, Name: ChargeResultEffectsExcellent
        -- upvalues: u3 (ref)
        return u3.ChargeResultEffectsFrame().Excellent;
    end,

    ChargeResultEffectsPerfect = function() -- Line: 295, Name: ChargeResultEffectsPerfect
        -- upvalues: u3 (ref)
        return u3.ChargeResultEffectsFrame().Perfect;
    end,

    ChargeResultEffectsBadScale = function() -- Line: 298, Name: ChargeResultEffectsBadScale
        -- upvalues: u2 (ref), u3 (ref)
        return u2(u3.ChargeResultEffectsBad());
    end,

    ChargeResultEffectsGoodScale = function() -- Line: 301, Name: ChargeResultEffectsGoodScale
        -- upvalues: u2 (ref), u3 (ref)
        return u2(u3.ChargeResultEffectsGood());
    end,

    ChargeResultEffectsGreatScale = function() -- Line: 304, Name: ChargeResultEffectsGreatScale
        -- upvalues: u2 (ref), u3 (ref)
        return u2(u3.ChargeResultEffectsGreat());
    end,

    ChargeResultEffectsExcellentScale = function() -- Line: 307, Name: ChargeResultEffectsExcellentScale
        -- upvalues: u2 (ref), u3 (ref)
        return u2(u3.ChargeResultEffectsExcellent());
    end,

    ChargeResultEffectsPerfectScale = function() -- Line: 310, Name: ChargeResultEffectsPerfectScale
        -- upvalues: u2 (ref), u3 (ref)
        return u2(u3.ChargeResultEffectsPerfect());
    end,

    MutationPotionsShop = function() -- Line: 313, Name: MutationPotionsShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("MutationPotionsShop", u1);
    end,

    GearShop = function() -- Line: 316, Name: GearShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GearShop", u1);
    end,

    ConfirmPetEggPurchase = function() -- Line: 319, Name: ConfirmPetEggPurchase
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ConfirmPetEggPurchase", u1);
    end,

    PetEggShop = function() -- Line: 322, Name: PetEggShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("PetEggShop", u1);
    end,

    ActivePetUI = function() -- Line: 325, Name: ActivePetUI
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ActivePetUI", u1);
    end,

    PetList = function() -- Line: 328, Name: PetList
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("PetList", u1);
    end,

    PetUI = function() -- Line: 331, Name: PetUI
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("PetUI", u1);
    end,

    FriendBoost = function() -- Line: 334, Name: FriendBoost
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("FriendBoost", u1);
    end,

    FirstTimeClimbTower = function() -- Line: 337, Name: FirstTimeClimbTower
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("FirstTimeClimbTower", u1);
    end,

    FirstTimeProgressTower = function() -- Line: 340, Name: FirstTimeProgressTower
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("FirstTimeProgressTower", u1);
    end,

    SpeedGainAnimation = function() -- Line: 343, Name: SpeedGainAnimation
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("SpeedGainAnimation", u1);
    end,

    BatchScaledUIs = function() -- Line: 346, Name: BatchScaledUIs
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BatchScaledUIs", u1);
    end,

    Achievements = function() -- Line: 349, Name: Achievements
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Achievements", u1);
    end,

    BattlePass = function() -- Line: 352, Name: BattlePass
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BattlePass", u1);
    end,

    BoothOtherPlayer = function() -- Line: 355, Name: BoothOtherPlayer
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BoothOtherPlayer", u1);
    end,

    BoothPrompt = function() -- Line: 358, Name: BoothPrompt
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BoothPrompt", u1);
    end,

    NpcQuestsList = function() -- Line: 361, Name: NpcQuestsList
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("NpcQuestsList", u1);
    end,

    Box = function() -- Line: 364, Name: Box
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Box", u1);
    end,

    Codes = function() -- Line: 367, Name: Codes
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Codes", u1);
    end,

    GroupReward = function() -- Line: 370, Name: GroupReward
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GroupReward", u1);
    end,

    DropBrainrot = function() -- Line: 373, Name: DropBrainrot
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("DropBrainrot", u1);
    end,

    DropBrainrotForTutorial = function() -- Line: 376, Name: DropBrainrotForTutorial
        -- upvalues: PlayerGui (copy), u1 (copy)
        local v22 = PlayerGui:WaitForChild("DropBrainrot", u1):Clone();
        v22.Name = "DropBrainrotForTutorial";
        v22.Parent = PlayerGui;

        return v22;
    end,

    Changelog = function() -- Line: 382, Name: Changelog
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Changelog", u1);
    end,

    Enchants = function() -- Line: 385, Name: Enchants
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Enchants", u1);
    end,

    ExclusiveShopItems = function() -- Line: 388, Name: ExclusiveShopItems
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ExclusiveShopItems", u1);
    end,

    GenerateRewards = function() -- Line: 391, Name: GenerateRewards
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GenerateRewards", u1);
    end,

    GlobalEvents = function() -- Line: 394, Name: GlobalEvents
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GlobalEvents", u1);
    end,

    GoalsSide = function() -- Line: 397, Name: GoalsSide
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GoalsSide", u1);
    end,

    Guilds = function() -- Line: 400, Name: Guilds
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Guilds", u1);
    end,

    HatchSettings = function() -- Line: 403, Name: HatchSettings
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("HatchSettings", u1);
    end,

    HypeTickets = function() -- Line: 406, Name: HypeTickets
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("HypeTickets", u1);
    end,

    Inventory = function() -- Line: 409, Name: Inventory
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Inventory", u1);
    end,

    InviteFriends = function() -- Line: 412, Name: InviteFriends
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("InviteFriends", u1);
    end,

    LootMessage = function() -- Line: 415, Name: LootMessage
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("LootMessage", u1);
    end,

    Main = function() -- Line: 418, Name: Main
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Main", u1);
    end,

    MainBottomRight = function() -- Line: 421, Name: MainBottomRight
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Main", u1):WaitForChild("BottomRight", u1);
    end,

    MainLeft = function() -- Line: 424, Name: MainLeft
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("MainLeft", u1);
    end,

    MainMobile = function() -- Line: 427, Name: MainMobile
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("MainMobile", u1);
    end,

    Mastery = function() -- Line: 430, Name: Mastery
        -- upvalues: u3 (ref), u1 (copy)
        return u3.BatchScaledUIs():WaitForChild("Mastery", u1);
    end,

    MasteryPerk = function() -- Line: 433, Name: MasteryPerk
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("MasteryPerk", u1);
    end,

    Message = function() -- Line: 436, Name: Message
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Message", u1);
    end,

    NewGift = function() -- Line: 439, Name: NewGift
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("NewGift", u1);
    end,

    Notifications = function() -- Line: 442, Name: Notifications
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Notifications", u1);
    end,

    ProgressBars = function() -- Line: 445, Name: ProgressBars
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ProgressBars", u1);
    end,

    RaidSummary = function() -- Line: 448, Name: RaidSummary
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("RaidSummary", u1);
    end,

    Rank = function() -- Line: 451, Name: Rank
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Rank", u1);
    end,

    RankUp = function() -- Line: 454, Name: RankUp
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("RankUp", u1);
    end,

    Rebirth = function() -- Line: 457, Name: Rebirth
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Rebirth", u1);
    end,

    Revive = function() -- Line: 460, Name: Revive
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Revive", u1);
    end,

    BrainrotSpinnyWheel = function() -- Line: 463, Name: BrainrotSpinnyWheel
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("BrainrotSpinnyWheel", u1);
    end,

    RebirthDetails = function() -- Line: 466, Name: RebirthDetails
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("RebirthDetails", u1);
    end,

    TycoonRebirthDetails = function() -- Line: 469, Name: TycoonRebirthDetails
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TycoonRebirthDetails", u1);
    end,

    Settings = function() -- Line: 472, Name: Settings
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Settings", u1);
    end,

    ShinyBonus = function() -- Line: 475, Name: ShinyBonus
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ShinyBonus", u1);
    end,

    Starter = function() -- Line: 478, Name: Starter
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Starter", u1);
    end,

    StarterpackDeal = function() -- Line: 481, Name: StarterpackDeal
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("StarterpackDeal", u1);
    end,

    LimitedStarterPackOffer = function() -- Line: 484, Name: LimitedStarterPackOffer
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("LimitedStarterPackOffer", u1);
    end,

    TeleportMap = function() -- Line: 487, Name: TeleportMap
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TeleportMap", u1);
    end,

    TradeHistory = function() -- Line: 490, Name: TradeHistory
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TradeHistory", u1);
    end,

    TradeMessage = function() -- Line: 493, Name: TradeMessage
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TradeMessage", u1);
    end,

    TradePlayerList = function() -- Line: 496, Name: TradePlayerList
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TradePlayerList", u1);
    end,

    TradePlazaChoice = function() -- Line: 499, Name: TradePlazaChoice
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TradePlazaChoice", u1);
    end,

    TradeWindow = function() -- Line: 502, Name: TradeWindow
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TradeWindow", u1);
    end,

    TradingTerminalLoading = function() -- Line: 505, Name: TradingTerminalLoading
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TradingTerminalLoading", u1);
    end,

    Transition = function() -- Line: 508, Name: Transition
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Transition", u1);
    end,

    Tutorial = function() -- Line: 511, Name: Tutorial
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Tutorial", u1);
    end,

    TutorialInstructions = function() -- Line: 514, Name: TutorialInstructions
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TutorialInstructions", u1);
    end,

    TutorialTapScreen = function() -- Line: 517, Name: TutorialTapScreen
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TutorialTapScreen", u1);
    end,

    Ultimates = function() -- Line: 520, Name: Ultimates
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Ultimates", u1);
    end,

    DigsiteMerchant = function() -- Line: 523, Name: DigsiteMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("DigsiteMerchant", u1);
    end,

    FishingGame = function() -- Line: 526, Name: FishingGame
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("FishingGame", u1);
    end,

    Digsite = function() -- Line: 529, Name: Digsite
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("Digsite", u1);
    end,

    FishingMerchant = function() -- Line: 532, Name: FishingMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("FishingMerchant", u1);
    end,

    RaceTimer = function() -- Line: 535, Name: RaceTimer
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("RaceTimer", u1);
    end,

    ObbyTimer = function() -- Line: 538, Name: ObbyTimer
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("ObbyTimer", u1);
    end,

    ChestRush = function() -- Line: 541, Name: ChestRush
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("ChestRush", u1);
    end,

    FlowerMerchant = function() -- Line: 544, Name: FlowerMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("FlowerMerchant", u1);
    end,

    Minecart = function() -- Line: 547, Name: Minecart
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("Minecart", u1);
    end,

    AdvancedDigsiteMerchant = function() -- Line: 550, Name: AdvancedDigsiteMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("AdvancedDigsiteMerchant", u1);
    end,

    AdvancedFishingMerchant = function() -- Line: 553, Name: AdvancedFishingMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("AdvancedFishingMerchant", u1);
    end,

    ChestRaid = function() -- Line: 556, Name: ChestRaid
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("ChestRaid", u1);
    end,

    ClawMachine = function() -- Line: 559, Name: ClawMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_INSTANCES", u1):WaitForChild("ClawMachine", u1);
    end,

    EggSlotsMachine = function() -- Line: 562, Name: EggSlotsMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("EggSlotsMachine", u1);
    end,

    EquipSlotsMachine = function() -- Line: 565, Name: EquipSlotsMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("EquipSlotsMachine", u1);
    end,

    GoldMachine = function() -- Line: 568, Name: GoldMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("GoldMachine", u1);
    end,

    DinoTycoonHugeChanceMachine = function() -- Line: 571, Name: DinoTycoonHugeChanceMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("DinoTycoonHugeChanceMachine", u1);
    end,

    TreehouseMerchant = function() -- Line: 575, Name: TreehouseMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("TreehouseMerchant", u1);
    end,

    TransferMachine = function() -- Line: 578, Name: TransferMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("TransferMachine", u1);
    end,

    RainbowMachine = function() -- Line: 581, Name: RainbowMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("RainbowMachine", u1);
    end,

    TravelingMerchant = function() -- Line: 584, Name: TravelingMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("TravelingMerchant", u1);
    end,

    UpgradeEnchantsMachineSingular = function() -- Line: 587, Name: UpgradeEnchantsMachineSingular
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("UpgradeEnchantsMachineSingular", u1);
    end,

    UpgradePotionsMachineSingular = function() -- Line: 591, Name: UpgradePotionsMachineSingular
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("UpgradePotionsMachineSingular", u1);
    end,

    PetIndexMachine = function() -- Line: 595, Name: PetIndexMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("PetIndexMachine", u1);
    end,

    SpinnyWheel = function() -- Line: 598, Name: SpinnyWheel
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("SpinnyWheel", u1);
    end,

    XPPotionMachine = function() -- Line: 601, Name: XPPotionMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("XPPotionMachine", u1);
    end,

    DiceCraftingMachine = function() -- Line: 604, Name: DiceCraftingMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("DiceCraftingMachine", u1);
    end,

    CraftPotionsMachine = function() -- Line: 607, Name: CraftPotionsMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("CraftPotionsMachine", u1);
    end,

    PowerUpIndex = function() -- Line: 610, Name: PowerUpIndex
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("PowerUpIndex", u1);
    end,

    Auction = function() -- Line: 613, Name: Auction
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("Auction", u1);
    end,

    UpgradeFruitsMachine = function() -- Line: 616, Name: UpgradeFruitsMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("UpgradeFruitsMachine", u1);
    end,

    UpgradeFruitsSelectorMachine = function() -- Line: 619, Name: UpgradeFruitsSelectorMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("UpgradeFruitsSelectorMachine", u1);
    end,

    UpgradeFruitsShinyMachine = function() -- Line: 623, Name: UpgradeFruitsShinyMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("UpgradeFruitsShinyMachine", u1);
    end,

    DaycareMachine = function() -- Line: 626, Name: DaycareMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("DaycareMachine", u1);
    end,

    EnchantsSelectorMachine = function() -- Line: 629, Name: EnchantsSelectorMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("EnchantsSelectorMachine", u1);
    end,

    HugeMachine = function() -- Line: 632, Name: HugeMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("HugeMachine", u1);
    end,

    MailboxMachine = function() -- Line: 635, Name: MailboxMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("MailboxMachine", u1);
    end,

    TradingTerminal = function() -- Line: 638, Name: TradingTerminal
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("TradingTerminal", u1);
    end,

    ReverseMerchant = function() -- Line: 641, Name: ReverseMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("ReverseMerchant", u1);
    end,

    MagicMachine = function() -- Line: 644, Name: MagicMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("MagicMachine", u1);
    end,

    Merchant = function() -- Line: 647, Name: Merchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("Merchant", u1);
    end,

    DailyQuestMachine = function() -- Line: 650, Name: DailyQuestMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("DailyQuestMachine", u1);
    end,

    SuperMachine = function() -- Line: 653, Name: SuperMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("SuperMachine", u1);
    end,

    ItemCreatorMachine = function() -- Line: 656, Name: ItemCreatorMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("ItemCreatorMachine", u1);
    end,

    UpgradePotionsMachineBulk = function() -- Line: 659, Name: UpgradePotionsMachineBulk
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("UpgradePotionsMachineBulk", u1);
    end,

    UpgradeEnchantsMachineBulk = function() -- Line: 662, Name: UpgradeEnchantsMachineBulk
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("UpgradeEnchantsMachineBulk", u1);
    end,

    ForgeMachineSelect = function() -- Line: 666, Name: ForgeMachineSelect
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("ForgeMachineSelect", u1);
    end,

    ForgeMachine = function() -- Line: 669, Name: ForgeMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("ForgeMachine", u1);
    end,

    ExclusiveDaycareMachine = function() -- Line: 672, Name: ExclusiveDaycareMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("ExclusiveDaycareMachine", u1);
    end,

    EmpowerEnchantsMachine = function() -- Line: 675, Name: EmpowerEnchantsMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("EmpowerEnchantsMachine", u1);
    end,

    EnchantEssenceMachine = function() -- Line: 678, Name: EnchantEssenceMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("EnchantEssenceMachine", u1);
    end,

    SummerGiftMachine = function() -- Line: 681, Name: SummerGiftMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("SummerGiftMachine", u1);
    end,

    ActionMenu = function() -- Line: 684, Name: ActionMenu
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("ActionMenu", u1);
    end,

    StarGrab = function() -- Line: 687, Name: StarGrab
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("StarGrab", u1);
    end,

    Alert = function() -- Line: 690, Name: Alert
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("Alert", u1);
    end,

    BuyMultiple = function() -- Line: 693, Name: BuyMultiple
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("BuyMultiple", u1);
    end,

    Debris = function() -- Line: 696, Name: Debris
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("Debris", u1);
    end,

    FFlags = function() -- Line: 699, Name: FFlags
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("FFlags", u1);
    end,

    FreeGifts = function() -- Line: 702, Name: FreeGifts
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("FreeGifts", u1);
    end,

    TextInput = function() -- Line: 705, Name: TextInput
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("TextInput", u1);
    end,

    Loading = function() -- Line: 708, Name: Loading
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("Loading", u1);
    end,

    RebirthFlash = function() -- Line: 711, Name: RebirthFlash
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("RebirthFlash", u1);
    end,

    Tool = function() -- Line: 714, Name: Tool
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("Tool", u1);
    end,

    Instancing = function() -- Line: 717, Name: Instancing
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("Instancing", u1);
    end,

    TycoonTeleport = function() -- Line: 720, Name: TycoonTeleport
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("TycoonTeleport", u1);
    end,

    BoxCustomize = function() -- Line: 723, Name: BoxCustomize
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("BoxCustomize", u1);
    end,

    ChatFilters = function() -- Line: 726, Name: ChatFilters
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("ChatFilters", u1);
    end,

    AdminCommands = function() -- Line: 729, Name: AdminCommands
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Admin Commands", u1);
    end,

    AdminPanelItem = function() -- Line: 732, Name: AdminPanelItem
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("AdminPanelItem", u1);
    end,

    AdminInventory = function() -- Line: 735, Name: AdminInventory
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Admin Inventory", u1);
    end,

    RngUpgradeMachine = function() -- Line: 738, Name: RngUpgradeMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("RngUpgradeMachine", u1);
    end,

    RngEventPetMerchant = function() -- Line: 741, Name: RngEventPetMerchant
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("RngEventPetMerchant", u1);
    end,

    RngUI = function() -- Line: 744, Name: RngUI
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("RngUI", u1);
    end,

    Debug = function() -- Line: 747, Name: Debug
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Debug", u1);
    end,

    ModeratorUtil = function() -- Line: 750, Name: ModeratorUtil
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Moderator Util", u1);
    end,

    PlayerProfile = function() -- Line: 753, Name: PlayerProfile
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("PlayerProfile", u1);
    end,

    Keybinds = function() -- Line: 756, Name: Keybinds
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Keybinds", u1);
    end,

    BoostExchangeMachine = function() -- Line: 759, Name: BoostExchangeMachine
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MACHINES", u1):WaitForChild("BoostExchangeMachine", u1);
    end,

    RaffleSelector = function() -- Line: 762, Name: RaffleSelector
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("RaffleSelector", u1);
    end,

    InventorySelect = function() -- Line: 765, Name: InventorySelect
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("InventorySelect", u1);
    end,

    DarkBg = function() -- Line: 768, Name: DarkBg
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("DarkBg", u1);
    end,

    Core = function() -- Line: 771, Name: Core
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Core", u1);
    end,

    HotBar = function() -- Line: 774, Name: HotBar
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("HotBar", u1);
    end,

    SideButtons = function() -- Line: 777, Name: SideButtons
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Elements", u1);
    end,

    SideButtonTools = function() -- Line: 780, Name: SideButtonTools
        -- upvalues: u3 (ref)
        return u3.SideButtons().Left.Tools;
    end,

    PlayerList = function() -- Line: 783, Name: PlayerList
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("PlayerList", u1);
    end,

    Shop = function() -- Line: 786, Name: Shop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Shop", u1);
    end,

    TreadmillSpeedShop = function() -- Line: 789, Name: TreadmillSpeedShop
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TreadmillSpeedShop", u1);
    end,

    ServerLuck = function() -- Line: 792, Name: ServerLuck
        -- upvalues: u3 (ref), u1 (copy)
        return u3.Shop():WaitForChild("Frame", u1):WaitForChild("Main", u1):WaitForChild("ScrollingFrame", u1):WaitForChild("ServerLuck", u1):WaitForChild("Main", u1);
    end,

    Teleport = function() -- Line: 800, Name: Teleport
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Teleport", u1);
    end,

    OnScreenPrompts = function() -- Line: 803, Name: OnScreenPrompts
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Prompts", u1);
    end,

    StarsHolder = function() -- Line: 806, Name: StarsHolder
        -- upvalues: u3 (ref)
        return u3.Core().Kernel.Header.Right.Tokens.Stars.Kernel;
    end,

    DiamondsHolder = function() -- Line: 809, Name: DiamondsHolder
        -- upvalues: u3 (ref)
        return u3.Core().Kernel.Header.Right.Tokens.Diamonds.Kernel;
    end,

    HeaderItems = function() -- Line: 812, Name: HeaderItems
        -- upvalues: u3 (ref)
        return u3.Core().Kernel.Header;
    end,

    MasteryButton = function() -- Line: 815, Name: MasteryButton
        -- upvalues: u3 (ref)
        return u3.SideButtonTools().Mastery.Button;
    end,

    TopBarItems = function() -- Line: 818, Name: TopBarItems
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TopBarItems", u1);
    end,

    TopBarStandard = function() -- Line: 821, Name: TopBarStandard
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("TopbarStandard", u1);
    end,

    StreamingScreen = function() -- Line: 824, Name: StreamingScreen
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Streaming", u1);
    end,

    Goal = function() -- Line: 827, Name: Goal
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Goal", u1);
    end,

    ArrowHolder = function() -- Line: 830, Name: ArrowHolder
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ArrowHolder", u1);
    end,

    WorldCutscenes = function() -- Line: 833, Name: WorldCutscenes
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("_MISC", u1):WaitForChild("WorldCutscenes", u1);
    end,

    EdgeGlow = function() -- Line: 836, Name: EdgeGlow
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("EdgeGlow", u1);
    end,

    OfflineLogs = function() -- Line: 840, Name: OfflineLogs
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("OfflineLogs", u1);
    end,

    LeaveLuckyBlocksView = function() -- Line: 843, Name: LeaveLuckyBlocksView
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("LeaveLuckyBlocksView", u1);
    end,

    Radio = function() -- Line: 846, Name: Radio
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Radio", u1);
    end,

    FirstTimePanel = function() -- Line: 849, Name: FirstTimePanel
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("FirstTimePanel", u1);
    end,

    GameStatus = function() -- Line: 852, Name: GameStatus
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GameStatus", u1);
    end,

    GameResetTimer = function() -- Line: 855, Name: GameResetTimer
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GameResetTimer", u1);
    end,

    Fade = function() -- Line: 858, Name: Fade
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("Fade", u1);
    end,

    FadeFrame = function() -- Line: 861, Name: FadeFrame
        -- upvalues: u3 (ref)
        return u3.Fade().Fade;
    end,

    GiftNotification = function() -- Line: 864, Name: GiftNotification
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GiftNotification", u1);
    end,

    GetMoreSpeedOnHit = function() -- Line: 867, Name: GetMoreSpeedOnHit
        -- upvalues: PlayerGui (copy), u1 (copy)
        local GetMoreSpeedOnHit = PlayerGui:WaitForChild("GetMoreSpeedOnHit", u1);
        local v23 = GetMoreSpeedOnHit:IsA("ScreenGui");
        assert(v23, "PlayerGui.GetMoreSpeedOnHit must be a ScreenGui");

        return GetMoreSpeedOnHit;
    end,

    GrowingEggList = function() -- Line: 872, Name: GrowingEggList
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("GrowingEggList", u1);
    end,

    ResetStartTimer = function() -- Line: 875, Name: ResetStartTimer
        -- upvalues: PlayerGui (copy), u1 (copy)
        return PlayerGui:WaitForChild("ResetStartTimer", u1);
    end,

    ResetStartTimerLabel = function() -- Line: 878, Name: ResetStartTimerLabel
        -- upvalues: u3 (ref)
        return u3.ResetStartTimer().Frame.TextLabel;
    end,

    ResetStartTimerLabelScale = function() -- Line: 881, Name: ResetStartTimerLabelScale
        -- upvalues: u2 (ref), u3 (ref)
        return u2(u3.ResetStartTimerLabel());
    end
};
local v24 = table.clone(u3);
local v27 = setmetatable(v24, {
    __index = function(p25, p26) -- Line: 887, Name: __index
        error("Missing GUI: " .. tostring(p26));
    end
});
table.freeze(v27);
local u28 = {};
local u29 = nil;
local v30 = {};

u2 = function(p31) -- Line: 902, Name: getOrCreateUIScale
    local v32 = p31:FindFirstChildOfClass("UIScale");

    if v32 then
        return v32;
    end;

    local UIScale = Instance.new("UIScale");
    UIScale.Scale = 0;
    UIScale.Parent = p31;

    return UIScale;
end;

function v30.ToggleMouseLock(p33) -- Line: 918
    -- upvalues: u29 (ref), PlayerGui (copy)
    local v34 = p33 or false;

    if not u29 then
        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "LockMouse";
        ScreenGui.Parent = PlayerGui;
        local TextButton = Instance.new("TextButton");
        TextButton.Visible = false;
        TextButton.BackgroundTransparency = 1;
        TextButton.Text = "";
        TextButton.BorderSizePixel = 0;
        TextButton.Size = UDim2.fromOffset(1, 1);
        TextButton.Parent = ScreenGui;
        u29 = TextButton;
    end;

    u29.Modal = v34;
    u29.Visible = v34;
end;

local u35 = {};

function v30.ButtonActivated(u36, u37) -- Line: 940
    -- upvalues: u35 (copy), Signal (copy)
    if u35[u36] then
        u35[u36].Signal:Disconnect();
        u35[u36].Default:Disconnect();
    end;

    u35[u36] = {
        Default = u36.Activated:Connect(u37),
        Signal = Signal.Fired("Console: Pressed Button"):Connect(function(p38) -- Line: 947
            -- upvalues: u36 (copy), Signal (ref), u37 (copy)
            if u36 == p38 then
                local u39 = nil;
                u39 = Signal.Fired("Console: Released Button"):Connect(function(p40) -- Line: 950
                    -- upvalues: u36 (ref), u37 (ref), u39 (ref)
                    if u36 == p40 then
                        u37();
                    end;

                    u39:Disconnect();
                end);
            end;
        end)
    };

    return u35[u36];
end;

function v30.ToggleCursor(p41) -- Line: 962
    -- upvalues: UserInputService (copy)
    UserInputService.MouseIconEnabled = p41 or false;
end;

function v30.Get(p42) -- Line: 966
    -- upvalues: u28 (copy), u3 (ref)
    if u28[p42] then
        return u28[p42];
    end;

    local v43 = u3[p42];
    local v44 = v43 and v43();

    if v44 then
        u28[p42] = v44;

        return v44;
    end;

    error("Missing UI: " .. p42);
end;

return setmetatable(v30, {
    __index = v27
});