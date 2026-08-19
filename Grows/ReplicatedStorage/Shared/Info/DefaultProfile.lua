-- Decompiled with Potassium's decompiler.

local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);
require(game.ReplicatedStorage.Shared.Info.GlobalVars);
require(game.ReplicatedStorage.Shared.Info.Constants);

return {
    LogInTimes = 0,
    LoggedInDuration = 0,
    LastLoggedIn = 0,
    Banned = false,
    BannedUntil = 0,
    Settings = {
        MusicMute = false,
        PerformanceMode = false,
        MusicVolume = 0.5,
        SoundVolume = 0.5,
        Keybinds = {
            Hotbar = {},
            ExitAll = Enum.KeyCode.E.Name,
            Sprint = Enum.KeyCode.LeftShift.Name,
            ShiftLock = Enum.KeyCode.LeftControl.Name,
            Inventory = Enum.KeyCode.Backquote.Name
        },
        MobileOffset = {
            Hotbar = {},
            Buttons = {}
        }
    },
    Currency = {
        [CustomEnum.CURRENCIES.COINS] = 10,
        [CustomEnum.CURRENCIES.TICKETS] = 0
    },
    DailyQuests = {
        LastResetTime = 0,
        Quests = {
            DuelFriend = {
                Progress = 0,
                MaxProgress = 1,
                Claimed = false,
                Reward = 500
            },
            Play5Times = {
                Progress = 0,
                MaxProgress = 5,
                Claimed = false,
                Reward = 300
            }
        }
    },
    Bundles = {},
    SpecialOwedGiven = {},
    Analytics = {
        EnteredRaidFirstTime = false,
        RejoinedLobbyFirstTime = false,
        JoinedGameTracked = false
    },
    FunnelSteps = {
        ONBOARDING = {}
    },
    ClaimedCodes = {},
    Stats = {
        General = {
            Deaths = 0,
            TimePlayed = {
                Seconds = 0,
                Minutes = 0,
                Hours = 0,
                Days = 0
            }
        }
    },
    Gamepasses = {},
    Purchases = {},
    VipRewardTimeStamp = 0,
    Index = {
        SeedsLevel = 1,
        FruitsLevel = 1,
        PetsLevel = 1,
        Seeds = {},
        Fruits = {},
        Pets = {}
    },
    Inventory = {
        Hotbar = {},
        Storage = {}
    },
    PlotTrees = {},
    PlotDecor = {},
    PlotEggs = {},
    PlotPets = {},
    PlotFinds = {},
    Worms = {},
    Compost = 0,
    PetSlots = 3,
    EggSlots = 3,
    Planters = {},
    UnlockedPlanters = { 1 },
    MarketClaims = {
        epoch = 0,
        version = 0,
        rows = {},
        escrow = {},
        pending = {}
    },
    OpenedFarmersMarket = false,
    OpenedFurnitureShop = false,
    OpenedPetShop = false,
    UsedCompost = false,
    SeedBeamHints = {
        Pine = false,
        Apple = false
    },
    ClaimedGroupReward = false,
    ReceivedR2Tickets = false,
    SelectedFence = "DefaultFence",
    OpenedCustomizeFence = false,
    PlotLikes = 0,
    LikedPlots = {},
    StarterPackOfferStart = 0,
    StarterPackOfferRemaining = 0,
    StarterPackSessionStart = 0,
    StarterPackPurchased = false,
    TutorialStep = 0,
    TutorialLightning = false,
    TutorialPlantCount = 0,
    TutorialFruitPending = false,
    UngrownTreeTipCount = 0,
    FarmLevel = 1,
    ShredProgress = 0,
    TotalWood = 0,
    Rebirth = 0
};